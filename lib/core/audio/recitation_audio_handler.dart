import 'dart:async';
import 'dart:developer' as developer;

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';

import 'recitation_media.dart';

/// Audio-focus and lifecycle owner for Qur'an recitation.
///
/// This exists so playback runs inside a real `mediaPlayback` foreground
/// service. Without one Android treats the app as cached the moment it
/// leaves the foreground — measured at `oom_score_adj` 900 with audio
/// actively playing — and an OEM memory cleaner culls the process mid-surah.
/// A foreground service with a live `MediaSession` is the only thing that
/// tells the platform "media is playing, do not kill this".
///
/// Used directly rather than through `just_audio_background`, which replaces
/// `JustAudioPlatform.instance` process-wide and then rejects the second
/// `AudioPlayer` in the app (Hindu chapter narration owns the other one).
class RecitationAudioHandler extends BaseAudioHandler with SeekHandler {
  RecitationAudioHandler(this._player);

  final AudioPlayer _player;

  /// The surah currently queued, so a replay of the same surah seeks rather
  /// than rebuilding the playlist.
  int? _loadedSurah;

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
  /// notification behind for a surah nobody is listening to. The idle state
  /// pushed by [_release] is final; nothing after it may clobber it.
  bool _releasing = false;

  /// Fires when the listener ends playback deliberately — the stop button in
  /// the app or in the notification. The Riverpod controller clears its state
  /// here so the mini player does not linger over a dead track.
  void Function()? onStopped;

  /// Fires when the surah plays through to its last ayah. Distinct from
  /// [onStopped]: the service is released either way, but reaching the end of
  /// Al-Ahzab is not the same gesture as dismissing the player, and the
  /// reader keeps its mini player so the listener can replay or move on.
  void Function()? onCompleted;

  /// Fires when playback fails after the first ayah — a dropped connection
  /// four verses into a surah is the common case, not the edge case. Only
  /// the initial load throws out of [load]; everything later surfaces here.
  void Function(Object error)? onError;

  /// Fires with the 1-based ayah number whenever the queue advances, so
  /// in-app state follows auto-advance and lock-screen skips alike.
  void Function(int ayah)? onAyahChanged;

  AudioPlayer get player => _player;

  /// Wires the player's streams into the media session. Called once, by
  /// [RecitationAudioService], immediately after construction.
  Future<void> start() async {
    final session = await AudioSession.instance;
    // `speech()` marks the stream as spoken word, which is what recitation
    // is: it keeps the system from applying music-oriented processing and
    // sets the right usage for in-car and accessibility routing.
    //
    // `androidWillPauseWhenDucked` makes the platform deliver a transient
    // *pause* instead of a duck request. Ducked recitation is unintelligible
    // — half-volume Qur'an under a notification chime serves nobody — so a
    // clean pause-and-resume is the respectful behaviour.
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
    _subs.add(
      _player.currentIndexStream.listen((index) {
        if (index == null) return;
        final q = queue.value;
        if (index < 0 || index >= q.length) return;
        mediaItem.add(q[index]);
        onAyahChanged?.call(index + 1);
      }),
    );
    // A surah that plays to its end should release the service, not sit
    // foregrounded on a finished queue.
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
    developer.log('recitation playback error', error: e, stackTrace: st);
    playbackState.add(
      playbackState.value.copyWith(
        processingState: AudioProcessingState.error,
        playing: false,
      ),
    );
    onError?.call(e);
  }

  /// Queues [surahId] and starts at [verseNumber].
  Future<void> load({
    required int surahId,
    required int verseNumber,
    required String surahName,
    required int totalVerses,
    required double speed,
  }) async {
    _releasing = false;
    final index = (verseNumber - 1).clamp(0, totalVerses - 1);
    if (_loadedSurah == surahId && queue.value.length == totalVerses) {
      // Same surah already queued — a seek keeps the foreground service and
      // the media session alive across the jump.
      await _player.seek(Duration.zero, index: index);
      await _player.setSpeed(speed);
      await _player.play();
      return;
    }

    final items = recitationQueue(
      surahId: surahId,
      surahName: surahName,
      totalVerses: totalVerses,
    );
    queue.add(items);
    mediaItem.add(items[index]);
    _loadedSurah = surahId;

    await _player.setAudioSource(
      ConcatenatingAudioSource(
        children: [
          for (final item in items) AudioSource.uri(Uri.parse(item.id)),
        ],
      ),
      initialIndex: index,
    );
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
    onStopped?.call();
    // Deliberately no `super.stop()`. `BaseAudioHandler.stop` exists only to
    // push an idle `playbackState`, which [_release] has already done.
    // Pushing a second one re-enters `AudioService`'s state observer *after*
    // it has torn the service down, and that re-posts the media notification
    // for a surah nobody is playing.
  }

  /// End of the surah. Releases the service exactly as [stop] does — a
  /// finished queue has no business holding a foreground service — but tells
  /// the reader it finished rather than that it was dismissed.
  Future<void> _finish() async {
    await _release();
    onCompleted?.call();
  }

  Future<void> _release() async {
    _releasing = true;
    _pausedByInterruption = false;
    _loadedSurah = null;
    await _player.stop();
    queue.add(const []);
    mediaItem.add(null);
    // `idle` is what tells audio_service to leave the foreground and pull the
    // notification: it stops the service on the *transition* into idle, so
    // this must be the last state this handler emits for the track.
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
    playbackState.add(
      playbackState.value.copyWith(
        // Previous / play-pause / next are the controls that make sense for
        // verse-by-verse recitation; stop is what releases the service.
        controls: [
          MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.skipToNext,
          MediaControl.stop,
        ],
        systemActions: const {MediaAction.seek},
        androidCompactActionIndices: const [0, 1, 2],
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
