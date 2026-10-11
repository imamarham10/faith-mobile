import 'dart:async';
import 'dart:developer' as developer;

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';

/// The notification's buttons, and which of them the collapsed media
/// notification shows.
///
/// Previous / next are meaningful for a verse-by-verse surah and dead
/// buttons for a single-file chapter narration, so the control set follows
/// the queue — and the compact indices, which point *into* that list, have
/// to follow with it. A compact index past the end of the control list is a
/// crash on some OEM shells, which is why this pairing is one function and
/// not two expressions.
({List<MediaControl> controls, List<int> compactIndices}) playbackControls({
  required bool playing,
  required bool multiTrack,
}) => (
  controls: [
    if (multiTrack) MediaControl.skipToPrevious,
    if (playing) MediaControl.pause else MediaControl.play,
    if (multiTrack) MediaControl.skipToNext,
    MediaControl.stop,
  ],
  compactIndices: multiTrack ? const [0, 1, 2] : const [0, 1],
);

/// Which vertical currently owns the one player.
///
/// `audio_service` allows exactly one `AudioService.init()` per process, so
/// there is one handler, one `AudioPlayer` and one media session for the
/// whole app. That is what makes Qur'an recitation and Hindu chapter
/// narration mutually exclusive by construction rather than by convention —
/// but it also means the handler has to know whose track it is holding, so
/// the vertical that just lost the player can take its mini player down.
enum PlaybackOwner { quranRecitation, scriptureNarration }

/// What the owning controller wants to hear about.
///
/// Passed in on every [PlaybackAudioHandler.loadQueue] rather than assigned
/// field-by-field: both controllers attach to the *same* handler instance,
/// and piecemeal assignment let whichever ran last silently clobber the
/// other's callbacks while the loser kept rendering a live mini player over
/// a track it no longer owned.
class PlaybackCallbacks {
  const PlaybackCallbacks({
    this.onPlayerState,
    this.onIndexChanged,
    this.onStopped,
    this.onCompleted,
    this.onError,
    this.onDisplaced,
  });

  /// Playing / buffering, straight from the player.
  final void Function({required bool playing, required bool buffering})?
  onPlayerState;

  /// Zero-based index into the queue this owner loaded. Fires on
  /// auto-advance and on lock-screen skips alike.
  final void Function(int index)? onIndexChanged;

  /// The listener ended playback deliberately — the stop button in the app
  /// or in the notification.
  final void Function()? onStopped;

  /// The queue played through to its end. Distinct from [onStopped]: the
  /// service is released either way, but reaching the last ayah of a surah
  /// is not the same gesture as dismissing the player, and the reader keeps
  /// its mini player so the listener can replay or move on.
  final void Function()? onCompleted;

  /// Playback failed after the load succeeded — a dropped connection four
  /// verses in is the common case, not the edge case.
  final void Function(Object error)? onError;

  /// The *other* vertical took the player. Nothing is playing for this owner
  /// any more and nothing will: clear the state behind the mini player.
  final void Function()? onDisplaced;
}

/// Audio-focus and lifecycle owner for every long-form playback in the app:
/// Qur'an recitation and Hindu scripture narration both.
///
/// This exists so playback runs inside a real `mediaPlayback` foreground
/// service. Without one Android treats the app as cached the moment it
/// leaves the foreground — measured at `oom_score_adj` 900 with audio
/// actively playing — and an OEM memory cleaner culls the process mid-surah.
/// A foreground service with a live `MediaSession` is the only thing that
/// tells the platform "media is playing, do not kill this".
///
/// Deliberately content-agnostic: it is handed a list of [MediaItem]s whose
/// ids are playable URLs and knows nothing about ayahs or chapters. The two
/// verticals build their own queues ([recitation_media.dart] and
/// [narration_media.dart]) and translate indices back at their own edge.
///
/// Used directly rather than through `just_audio_background`, which replaces
/// `JustAudioPlatform.instance` process-wide and then rejects any second
/// `AudioPlayer` in the app.
class PlaybackAudioHandler extends BaseAudioHandler with SeekHandler {
  PlaybackAudioHandler(this._player);

  final AudioPlayer _player;

  /// Whose track is loaded. Null before the first load and after a stop.
  PlaybackOwner? _owner;

  PlaybackCallbacks _callbacks = const PlaybackCallbacks();

  /// Identifies what [_owner] has queued, so replaying the same thing seeks
  /// rather than rebuilding the playlist.
  Object? _loadedKey;

  /// True while playback is suspended by something outside the app (a call,
  /// another media app taking transient focus). Distinguishes "resume when
  /// the interruption ends" from a pause the listener chose.
  bool _pausedByInterruption = false;

  final List<StreamSubscription<Object?>> _subs = [];

  /// Set while [_release] is tearing playback down.
  ///
  /// `audio_service` removes the media notification only when the *last*
  /// `playbackState` it saw is `idle`. Stopping the player emits more
  /// playback events, and letting [_broadcast] run on them overwrites that
  /// idle with the player's lingering `completed`, leaving an ongoing
  /// notification behind for a track nobody is listening to. The idle state
  /// pushed by [_release] is final; nothing after it may clobber it.
  bool _releasing = false;

  /// Set across the audio-source swap inside [loadQueue].
  ///
  /// The queue is replaced before the new source is set, so the old source's
  /// final index events would otherwise be read against the new queue and
  /// report an index the listener never asked for.
  bool _swapping = false;

  PlaybackOwner? get owner => _owner;

  /// Nothing loaded — a replay has to rebuild the source rather than resume.
  bool get isIdle => _player.processingState == ProcessingState.idle;

  /// Wires the player's streams into the media session. Called once, by
  /// [AudioPlaybackService], immediately after construction.
  Future<void> start() async {
    final session = await AudioSession.instance;
    // `speech()` marks the stream as spoken word, which is what both
    // recitation and chapter narration are: it keeps the system from
    // applying music-oriented processing and sets the right usage for
    // in-car and accessibility routing.
    //
    // `androidWillPauseWhenDucked` makes the platform deliver a transient
    // *pause* instead of a duck request. Ducked recitation is unintelligible
    // — half-volume scripture under a notification chime serves nobody — so
    // a clean pause-and-resume is the respectful behaviour.
    await session.configure(
      const AudioSessionConfiguration.speech().copyWith(
        androidWillPauseWhenDucked: true,
      ),
    );

    _subs.add(session.interruptionEventStream.listen(_onInterruption));
    // Headphones pulled out: pause, and never auto-resume. Audio suddenly
    // leaving the earpiece for a room full of people is the one failure the
    // listener cannot undo.
    _subs.add(
      session.becomingNoisyEventStream.listen((_) {
        _pausedByInterruption = false;
        unawaited(pause());
      }),
    );

    _subs.add(
      _player.playbackEventStream.listen(_broadcast, onError: _onPlaybackError),
    );
    // The owning controller's playing/buffering flags come from here rather
    // than from each controller subscribing to the player itself: two live
    // subscriptions would have meant Gita narration driving the Qur'an mini
    // player's spinner.
    _subs.add(
      _player.playerStateStream.listen(
        (s) => _callbacks.onPlayerState?.call(
          playing: s.playing,
          buffering:
              s.processingState == ProcessingState.loading ||
              s.processingState == ProcessingState.buffering,
        ),
        // The same failure arrives on `playbackEventStream`, which reports
        // it through `onError` already; this one only needs to not escape to
        // the zone.
        onError: (Object e, StackTrace st) =>
            developer.log('player state stream error', error: e, stackTrace: st),
      ),
    );
    _subs.add(
      _player.currentIndexStream.listen((index) {
        if (index == null || _swapping) return;
        final q = queue.value;
        if (index < 0 || index >= q.length) return;
        mediaItem.add(q[index]);
        _callbacks.onIndexChanged?.call(index);
      }),
    );
    // A queue that plays to its end should release the service, not sit
    // foregrounded on a finished playlist.
    _subs.add(
      _player.processingStateStream.listen((s) {
        if (s == ProcessingState.completed && !_releasing) {
          unawaited(_finish());
        }
      }),
    );
  }

  void _onInterruption(AudioInterruptionEvent event) {
    if (event.begin) {
      switch (event.type) {
        case AudioInterruptionType.duck:
          // Only reachable if the platform ignores androidWillPauseWhenDucked.
          unawaited(_player.setVolume(0.3));
        case AudioInterruptionType.pause:
        case AudioInterruptionType.unknown:
          _pausedByInterruption = _player.playing;
          unawaited(pause());
      }
      return;
    }
    switch (event.type) {
      case AudioInterruptionType.duck:
        unawaited(_player.setVolume(1));
      case AudioInterruptionType.pause:
        // Transient loss ended (the call hung up) — pick up where we left off.
        if (_pausedByInterruption) unawaited(play());
        _pausedByInterruption = false;
      case AudioInterruptionType.unknown:
        // Permanent loss: another app owns audio now. Staying paused is
        // correct — resuming would fight it.
        _pausedByInterruption = false;
    }
  }

  void _onPlaybackError(Object e, StackTrace st) {
    developer.log('playback error', error: e, stackTrace: st);
    playbackState.add(
      playbackState.value.copyWith(
        processingState: AudioProcessingState.error,
        playing: false,
      ),
    );
    _callbacks.onError?.call(e);
  }

  /// Queues [items] for [owner] and starts at [initialIndex].
  ///
  /// [contentKey] identifies what is being queued *within* that owner (a
  /// surah id, a narration track url); re-loading the same key seeks instead
  /// of rebuilding, which keeps the foreground service and media session
  /// alive across the jump.
  ///
  /// A load from the other vertical takes the player over. It deliberately
  /// does **not** release first: replacing the audio source leaves the
  /// session and the foreground service standing, where an idle transition
  /// in between would flicker the notification and reopen the window in
  /// which the process is unprotected. The displaced owner is told through
  /// [PlaybackCallbacks.onDisplaced] so its mini player comes down.
  Future<void> loadQueue({
    required PlaybackOwner owner,
    required PlaybackCallbacks callbacks,
    required Object contentKey,
    required List<MediaItem> items,
    required int initialIndex,
    required double speed,
  }) async {
    assert(items.isNotEmpty, 'loadQueue needs at least one item');
    _releasing = false;
    final index = initialIndex.clamp(0, items.length - 1);

    final previousOwner = _owner;
    final displaced = previousOwner != null && previousOwner != owner
        ? _callbacks
        : null;
    _owner = owner;
    _callbacks = callbacks;
    if (displaced != null) {
      _loadedKey = null;
      displaced.onDisplaced?.call();
    }

    if (_loadedKey == contentKey && queue.value.length == items.length) {
      await _player.seek(Duration.zero, index: index);
      await _player.setSpeed(speed);
      await _player.play();
      return;
    }

    queue.add(items);
    mediaItem.add(items[index]);
    _loadedKey = contentKey;

    _swapping = true;
    try {
      await _player.setAudioSource(
        ConcatenatingAudioSource(
          children: [
            for (final item in items) AudioSource.uri(Uri.parse(item.id)),
          ],
        ),
        initialIndex: index,
      );
    } finally {
      _swapping = false;
    }
    _callbacks.onIndexChanged?.call(index);
    await _player.setSpeed(speed);
    await _player.play();
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> skipToNext() => _player.seekToNext();

  @override
  Future<void> skipToPrevious() => _player.seekToPrevious();

  @override
  Future<void> skipToQueueItem(int index) async {
    if (index < 0 || index >= queue.value.length) return;
    await _player.seek(Duration.zero, index: index);
  }

  @override
  Future<void> setSpeed(double speed) => _player.setSpeed(speed);

  @override
  Future<void> stop() async {
    await _release();
    final displaced = _callbacks;
    // A deliberate stop surrenders the player: the next load from either
    // vertical starts clean rather than counting as a takeover.
    _owner = null;
    _callbacks = const PlaybackCallbacks();
    displaced.onStopped?.call();
    // Deliberately no `super.stop()`. `BaseAudioHandler.stop` exists only to
    // push an idle `playbackState`, which [_release] has already done.
    // Pushing a second one re-enters `AudioService`'s state observer *after*
    // it has torn the service down, and that re-posts the media notification
    // for a track nobody is playing.
  }

  /// End of the queue. Releases the service exactly as [stop] does — a
  /// finished queue has no business holding a foreground service — but tells
  /// the reader it finished rather than that it was dismissed.
  ///
  /// Ownership is *kept*: the mini player stays up for a replay, so the
  /// other vertical starting playback still has to displace it.
  Future<void> _finish() async {
    await _release();
    _callbacks.onCompleted?.call();
  }

  Future<void> _release() async {
    _releasing = true;
    _pausedByInterruption = false;
    _loadedKey = null;
    await _player.stop();
    // Deliberately no `queue.add([])` / `mediaItem.add(null)` here.
    // `audio_service` drains `queue`, `mediaItem` and `playbackState` in
    // three independent `await for` loops, so a queue cleared here can reach
    // the platform *after* the service has stopped and rebuild the
    // notification it had just cancelled. Teardown therefore emits exactly
    // one thing — the idle state below. [loadQueue] replaces the queue
    // anyway, and a stale queue behind an inactive session is invisible.
    //
    // `idle` is what tells audio_service to leave the foreground and pull the
    // notification: it stops the service on the *transition* into idle, so
    // this must be the last thing this handler emits for the track.
    playbackState.add(
      playbackState.value.copyWith(
        processingState: AudioProcessingState.idle,
        playing: false,
        updatePosition: Duration.zero,
      ),
    );
  }

  Future<void> dispose() async {
    for (final s in _subs) {
      await s.cancel();
    }
    _subs.clear();
    await _player.dispose();
  }

  void _broadcast(PlaybackEvent event) {
    if (_releasing) return;
    final playing = _player.playing;
    final buttons = playbackControls(
      playing: playing,
      multiTrack: queue.value.length > 1,
    );
    playbackState.add(
      playbackState.value.copyWith(
        controls: buttons.controls,
        systemActions: const {MediaAction.seek},
        androidCompactActionIndices: buttons.compactIndices,
        processingState: _processingState,
        playing: playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
        queueIndex: event.currentIndex,
      ),
    );
  }

  AudioProcessingState get _processingState => switch (_player.processingState) {
    ProcessingState.idle => AudioProcessingState.idle,
    ProcessingState.loading => AudioProcessingState.loading,
    ProcessingState.buffering => AudioProcessingState.buffering,
    ProcessingState.ready => AudioProcessingState.ready,
    ProcessingState.completed => AudioProcessingState.completed,
  };
}
