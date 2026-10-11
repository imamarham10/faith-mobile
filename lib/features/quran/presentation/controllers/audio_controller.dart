import 'dart:async';
import 'dart:developer' as developer;

import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/audio/recitation_audio_handler.dart';
import '../../../../core/audio/recitation_audio_service.dart';
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
/// Playback itself lives in [RecitationAudioHandler], inside an
/// `audio_service` foreground service, so recitation survives the screen
/// going off. This controller owns only the state the reader renders, and
/// forwards intent to the handler.
///
/// The handler is created on the first [playAyah] — never at build time, so
/// opening the reader costs nothing and the launch path is untouched.
@Riverpod(keepAlive: true)
class AudioController extends _$AudioController {
  RecitationAudioHandler? _handler;
  StreamSubscription<PlayerState>? _stateSub;

  @override
  AudioState build() {
    ref.onDispose(() async {
      await _stateSub?.cancel();
      await _handler?.dispose();
    });
    return const AudioState();
  }

  Future<RecitationAudioHandler> _ensureHandler() async {
    final existing = _handler;
    if (existing != null) return existing;

    final handler = await RecitationAudioService.instance.ensureStarted();

    // A stop from the notification or lock screen has to clear in-app state
    // too, or the mini player lingers over a track that no longer exists.
    handler.onStopped = () => state = const AudioState();
    // Auto-advance and lock-screen skips both move the queue; the reader
    // follows from here rather than from a completion callback.
    handler.onAyahChanged = (ayah) {
      final name = state.surahName;
      final surah = state.currentSurah;
      if (name == null || surah == null) return;
      state = state.copyWith(
        currentAyah: ayah,
        title: '$name · $surah:$ayah',
      );
    };
    _stateSub = handler.player.playerStateStream.listen((s) {
      state = state.copyWith(
        isPlaying: s.playing,
        isBuffering:
            s.processingState == ProcessingState.loading ||
            s.processingState == ProcessingState.buffering,
      );
    });

    _handler = handler;
    return handler;
  }

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
      await handler.load(
        surahId: surahId,
        verseNumber: verseNumber,
        surahName: surahName,
        totalVerses: totalVerses,
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

  Future<void> resume() async => _handler?.play();

  /// Ends playback: releases the foreground service and removes the media
  /// notification. [RecitationAudioHandler.onStopped] resets this state.
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
