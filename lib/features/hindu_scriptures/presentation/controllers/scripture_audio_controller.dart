import 'dart:developer' as developer;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/audio/narration_media.dart';
import '../../../../core/audio/playback_audio_handler.dart';
import '../../../../core/audio/playback_audio_service.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/dtos/audio_track.dart';
import '../../data/hindu_scriptures_repository.dart';
import '../../domain/scripture_audio_state.dart';

part 'scripture_audio_controller.g.dart';

/// Playback speeds, same cycle as the Quran module's mini player.
const List<double> kScripturePlaybackSpeeds = [1.0, 1.25, 1.5, 1.75, 2.0, 0.75];

/// UI-facing state for the chapter-narration player.
///
/// A chapter narration is minutes of audio, so playback runs where Qur'an
/// recitation runs: inside [PlaybackAudioHandler], in a real `mediaPlayback`
/// foreground service. A raw `AudioPlayer` here left the process in the
/// cached bucket (`oom_score_adj` 900 with narration audibly playing) and
/// OEM memory cleaners killed it mid-chapter.
///
/// `audio_service` allows exactly one `AudioService.init()` per process, so
/// that handler is shared with the Quran module rather than duplicated —
/// which is also what makes the two mutually exclusive: starting a chapter
/// takes the one player from recitation, and [PlaybackCallbacks.onDisplaced]
/// takes the other vertical's mini player down.
///
/// Unlike Quran's `AudioController` (hardcoded third-party mp3 host with
/// no reciter choice), this hits the real backend narration endpoint and
/// lets the user switch between available reciter/language tracks.
@Riverpod(keepAlive: true)
class ScriptureAudioController extends _$ScriptureAudioController {
  PlaybackAudioHandler? _handler;

  @override
  ScriptureAudioState build() => const ScriptureAudioState();

  /// What this controller wants to hear about while it owns the player.
  ///
  /// Handed over on every load rather than assigned to the handler once:
  /// the handler keeps one callback set, belonging to whichever vertical is
  /// playing, so these are installed at load time and dropped the moment
  /// recitation takes the player.
  PlaybackCallbacks get _callbacks => PlaybackCallbacks(
    onPlayerState: ({required playing, required buffering}) =>
        state = state.copyWith(isPlaying: playing, isBuffering: buffering),
    // A stop from the notification or lock screen has to clear in-app state
    // too, or the mini player lingers over a track that no longer exists.
    onStopped: () => state = const ScriptureAudioState(),
    // Reaching the end of the chapter releases the service but is not a
    // dismissal: the mini player stays so the listener can replay or pick a
    // different reciter.
    onCompleted: () =>
        state = state.copyWith(isPlaying: false, isBuffering: false),
    // A chapter that drops its connection partway through never passes back
    // through _play's try/catch, so the message has to arrive here.
    onError: (Object e) => state = state.copyWith(
      isPlaying: false,
      isBuffering: false,
      errorMessage: 'Could not play this narration. Try again.',
    ),
    // Qur'an recitation took the player.
    onDisplaced: () => state = const ScriptureAudioState(),
    // No onIndexChanged: narration is per-chapter, a queue of one, so there
    // is no position in a playlist for the reader to follow.
  );

  /// The handler is never disposed from here — it belongs to
  /// [AudioPlaybackService] and its lifetime is the process. It is also only
  /// created on the first play, so opening the chapter reader neither binds
  /// a media session nor pays for one on a cold start that never plays.
  Future<PlaybackAudioHandler> _ensureHandler() async =>
      _handler ??= await AudioPlaybackService.instance.ensureStarted();

  /// Fetches available narrations for a chapter and plays the first
  /// non-premium track (falling back to the first track if all are
  /// premium — the detail screen still gates premium content, this just
  /// picks a sensible default rather than leaving the player empty).
  Future<void> playChapter({
    required String textSlug,
    required int chapterNumber,
    required String chapterTitle,
  }) async {
    state = state.copyWith(
      currentTextSlug: textSlug,
      currentChapterNumber: chapterNumber,
      chapterTitle: chapterTitle,
      errorMessage: null,
      isBuffering: true,
    );
    try {
      final repo = ref.read(hinduScripturesRepositoryProvider);
      final tracks = await repo.getChapterAudio(textSlug, chapterNumber);
      if (tracks.isEmpty) {
        state = state.copyWith(
          isBuffering: false,
          errorMessage: 'No narration available for this chapter.',
        );
        return;
      }
      final defaultTrack = tracks.firstWhere(
        (t) => !t.isPremium,
        orElse: () => tracks.first,
      );
      state = state.copyWith(availableTracks: tracks);
      await _play(defaultTrack);
    } on Object catch (e, st) {
      developer.log('playChapter failed', error: e, stackTrace: st);
      state = state.copyWith(
        isBuffering: false,
        errorMessage: 'Could not load narration. Try again.',
      );
    }
  }

  Future<void> _play(AudioTrack track) async {
    final slug = state.currentTextSlug;
    final chapter = state.currentChapterNumber;
    if (slug == null || chapter == null) return;
    state = state.copyWith(
      currentTrack: track,
      isBuffering: true,
      errorMessage: null,
    );
    try {
      final url = narrationUrl(track.url, webBaseUrl: kWebBaseUrl);
      final handler = await _ensureHandler();
      await handler.loadQueue(
        owner: PlaybackOwner.scriptureNarration,
        callbacks: _callbacks,
        // The track url, not the chapter: switching reciter mid-chapter has
        // to rebuild the source rather than seek within the old one. That
        // swap keeps the session and the foreground service standing, so it
        // costs a buffer, not a notification flicker.
        contentKey: url,
        items: [
          narrationMediaItem(
            url: url,
            textSlug: slug,
            chapterNumber: chapter,
            chapterTitle: state.chapterTitle ?? 'Chapter $chapter',
            reciterName: track.name,
          ),
        ],
        initialIndex: 0,
        speed: state.speed,
      );
    } on Object catch (e, st) {
      developer.log('audio play failed', error: e, stackTrace: st);
      state = state.copyWith(
        isPlaying: false,
        isBuffering: false,
        errorMessage: 'Could not play this narration. Try again.',
      );
    }
  }

  /// Switches to a different reciter/language track for the same chapter.
  Future<void> switchTrack(AudioTrack track) async {
    await _play(track);
  }

  Future<void> pause() async => _handler?.pause();

  /// Resumes, or reloads: the handler releases the player at the end of a
  /// chapter, and recitation may have taken it over since.
  Future<void> resume() async {
    final handler = _handler;
    final track = state.currentTrack;
    if (handler == null ||
        handler.isIdle ||
        handler.owner != PlaybackOwner.scriptureNarration) {
      if (track == null) return;
      await _play(track);
      return;
    }
    await handler.play();
  }

  /// Ends playback: releases the foreground service and removes the media
  /// notification. [PlaybackCallbacks.onStopped] resets this state.
  Future<void> stop() async {
    final handler = _handler;
    if (handler == null) {
      state = const ScriptureAudioState();
      return;
    }
    await handler.stop();
  }

  Future<void> setSpeed(double speed) async {
    state = state.copyWith(speed: speed);
    await _handler?.setSpeed(speed);
  }

  Future<void> cycleSpeed() async {
    final current = state.speed;
    final idx = kScripturePlaybackSpeeds.indexWhere(
      (s) => (s - current).abs() < 0.001,
    );
    final next =
        kScripturePlaybackSpeeds[(idx + 1) % kScripturePlaybackSpeeds.length];
    await setSpeed(next);
  }
}
