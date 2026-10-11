import 'dart:developer' as developer;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/audio/playback_audio_handler.dart';
import '../../../../core/audio/playback_audio_service.dart';
import '../../../../core/audio/recitation_media.dart';
import '../../domain/audio_state.dart';

// Re-exported from their new home in `core/audio` so existing imports of
// `recitationUrl` / `kRecitationBaseUrl` from this library keep resolving.
export '../../../../core/audio/recitation_media.dart'
    show kRecitationBaseUrl, recitationUrl;

part 'audio_controller.g.dart';

/// Available playback speeds, in cycle order. Tap the speed pill in the mini
/// player to cycle. 1× sits in the middle so a single tap from default lands
/// on the first noticeable change.
const List<double> kPlaybackSpeeds = [1.0, 1.25, 1.5, 1.75, 2.0, 0.75];

/// UI-facing state for the Quran recitation player.
///
/// Playback itself lives in [PlaybackAudioHandler], inside an
/// `audio_service` foreground service, so recitation survives the screen
/// going off. This controller owns only the state the reader renders, and
/// forwards intent to the handler.
///
/// That handler is shared with Hindu chapter narration — one process, one
/// `AudioService.init()`, one player — so starting a surah takes the player
/// from a Gita chapter and vice versa. The hand-over arrives here as
/// [PlaybackCallbacks.onDisplaced].
///
/// The handler is created on the first [playAyah] — never at build time, so
/// opening the reader costs nothing and the launch path is untouched.
@Riverpod(keepAlive: true)
class AudioController extends _$AudioController {
  PlaybackAudioHandler? _handler;

  @override
  AudioState build() => const AudioState();

  /// What this controller wants to hear about while it owns the player.
  ///
  /// Handed over on every load rather than assigned to the handler once:
  /// the handler keeps one callback set, belonging to whichever vertical is
  /// playing, so these are installed at load time and dropped the moment
  /// narration takes the player.
  PlaybackCallbacks get _callbacks => PlaybackCallbacks(
    onPlayerState: ({required playing, required buffering}) =>
        state = state.copyWith(isPlaying: playing, isBuffering: buffering),
    // Auto-advance and lock-screen skips both move the queue; the reader
    // follows from here rather than from a completion callback. The handler
    // counts queue positions from zero, ayahs run from one.
    onIndexChanged: (index) {
      final name = state.surahName;
      final surah = state.currentSurah;
      if (name == null || surah == null) return;
      final ayah = index + 1;
      state = state.copyWith(currentAyah: ayah, title: '$name · $surah:$ayah');
    },
    // A stop from the notification or lock screen has to clear in-app state
    // too, or the mini player lingers over a track that no longer exists.
    onStopped: () => state = const AudioState(),
    // End of surah is not a dismissal: the service is released, but the
    // reader keeps its mini player so the listener can replay from here.
    onCompleted: () =>
        state = state.copyWith(isPlaying: false, isBuffering: false),
    // A verse that fails to load partway through the surah never passes
    // through playAyah's try/catch, so the message has to arrive here or the
    // player sits silent with nothing explaining why.
    onError: (Object e) => state = state.copyWith(
      isPlaying: false,
      isBuffering: false,
      errorMessage: 'Could not play this verse. Try again.',
    ),
    // Hindu narration took the player. Nothing is playing here any more and
    // nothing will, so the mini player comes down rather than freezing
    // mid-surah over audio the listener can no longer hear.
    onDisplaced: () => state = const AudioState(),
  );

  /// The handler is never disposed from here. It belongs to
  /// [AudioPlaybackService], whose lifetime is the process:
  /// `AudioService.init()` runs once and the instance is cached forever, so
  /// disposing it from a provider would leave every later `ensureStarted()`
  /// handing back a dead player with no way to re-init.
  Future<PlaybackAudioHandler> _ensureHandler() async =>
      _handler ??= await AudioPlaybackService.instance.ensureStarted();

  /// Loads + plays the given ayah, queueing the rest of the surah behind it.
  ///
  /// Signature is load-bearing for callers across the Quran feature; new
  /// inputs should arrive as optional named parameters.
  Future<void> playAyah({
    required int surahId,
    required int verseNumber,
    required String surahName,
    required int totalVerses,
  }) async {
    state = state.copyWith(
      currentSurah: surahId,
      currentAyah: verseNumber,
      totalVerses: totalVerses,
      surahName: surahName,
      title: '$surahName · $surahId:$verseNumber',
      errorMessage: null,
      isBuffering: true,
    );
    try {
      final handler = await _ensureHandler();
      await handler.loadQueue(
        owner: PlaybackOwner.quranRecitation,
        callbacks: _callbacks,
        contentKey: surahId,
        items: recitationQueue(
          surahId: surahId,
          surahName: surahName,
          totalVerses: totalVerses,
        ),
        initialIndex: verseNumber - 1,
        speed: state.speed,
      );
    } on Object catch (e, st) {
      developer.log('playAyah failed', error: e, stackTrace: st);
      state = state.copyWith(
        isPlaying: false,
        isBuffering: false,
        errorMessage: 'Could not play this verse. Try again.',
      );
    }
  }

  Future<void> pause() async => _handler?.pause();

  /// Resumes, or reloads: if the surah played through to its end the handler
  /// released the player, and if narration has taken the player over since
  /// there is nothing of ours left on it either.
  Future<void> resume() async {
    final handler = _handler;
    final surah = state.currentSurah;
    final ayah = state.currentAyah;
    final name = state.surahName;
    final total = state.totalVerses;
    if (handler == null ||
        handler.isIdle ||
        handler.owner != PlaybackOwner.quranRecitation) {
      if (surah == null || ayah == null || name == null || total == null) {
        return;
      }
      await playAyah(
        surahId: surah,
        verseNumber: ayah,
        surahName: name,
        totalVerses: total,
      );
      return;
    }
    await handler.play();
  }

  /// Ends playback: releases the foreground service and removes the media
  /// notification. [PlaybackCallbacks.onStopped] resets this state.
  Future<void> stop() async {
    final handler = _handler;
    if (handler == null) {
      state = const AudioState();
      return;
    }
    await handler.stop();
  }

  /// Plays the next ayah within the same surah; no-op if at the end.
  Future<void> next() async {
    final a = state.currentAyah;
    final tv = state.totalVerses;
    if (a == null || tv == null || a >= tv) return;
    await _handler?.skipToNext();
  }

  Future<void> previous() async {
    final a = state.currentAyah;
    if (a == null || a <= 1) return;
    await _handler?.skipToPrevious();
  }

  /// Sets the playback speed and persists it in state so subsequent ayahs
  /// pick it up automatically.
  Future<void> setSpeed(double speed) async {
    state = state.copyWith(speed: speed);
    await _handler?.setSpeed(speed);
  }

  /// Cycles to the next preset in [kPlaybackSpeeds].
  Future<void> cycleSpeed() async {
    final current = state.speed;
    final idx = kPlaybackSpeeds.indexWhere((s) => (s - current).abs() < 0.001);
    final next = kPlaybackSpeeds[(idx + 1) % kPlaybackSpeeds.length];
    await setSpeed(next);
  }
}
