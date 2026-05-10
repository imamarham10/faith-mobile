import 'dart:async';
import 'dart:developer' as developer;

import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/audio_state.dart';

part 'audio_controller.g.dart';

/// Available playback speeds, in cycle order. Tap the speed pill in the mini
/// player to cycle. 1× sits in the middle so a single tap from default lands
/// on the first noticeable change.
const List<double> kPlaybackSpeeds = [1.0, 1.25, 1.5, 1.75, 2.0, 0.75];

/// Base URL for the recitation source. Each ayah's audio is loaded as
/// `$kRecitationBaseUrl/$surah/$ayah.mp3` (zero-padded surah, three-digit
/// ayah). Swap this constant when a backend recitation source is wired.
///
/// Provider used: Mishary Rashid Alafasy via everyayah.com — a well-known,
/// CORS-friendly mirror commonly used by Quran apps.
// TODO: replace with real recitation source from backend when available.
const String kRecitationBaseUrl = 'https://everyayah.com/data/Alafasy_128kbps';

/// Builds the recitation URL for a specific ayah.
String recitationUrl({required int surah, required int ayah}) {
  final s = surah.toString().padLeft(3, '0');
  final a = ayah.toString().padLeft(3, '0');
  return '$kRecitationBaseUrl/$s$a.mp3';
}

/// Shared `AudioPlayer` for the Quran feature.
///
/// Plays one ayah at a time; auto-advances to the next ayah on completion.
@Riverpod(keepAlive: true)
class AudioController extends _$AudioController {
  AudioPlayer? _player;
  StreamSubscription<PlayerState>? _stateSub;

  @override
  AudioState build() {
    ref.onDispose(() async {
      await _stateSub?.cancel();
      await _player?.dispose();
    });
    _ensurePlayer();
    return const AudioState();
  }

  AudioPlayer _ensurePlayer() {
    if (_player != null) return _player!;
    final player = AudioPlayer();
    _stateSub = player.playerStateStream.listen((s) {
      state = state.copyWith(
        isPlaying: s.playing,
        isBuffering:
            s.processingState == ProcessingState.loading ||
            s.processingState == ProcessingState.buffering,
      );
      if (s.processingState == ProcessingState.completed) {
        unawaited(_onAyahFinished());
      }
    });
    _player = player;
    return player;
  }

  /// Auto-advance handler — fires when an ayah's audio reaches the end.
  Future<void> _onAyahFinished() async {
    final s = state.currentSurah;
    final a = state.currentAyah;
    final tv = state.totalVerses;
    final sn = state.surahName;
    if (s == null || a == null || tv == null || sn == null) return;
    if (a >= tv) {
      // End of surah — settle into stopped state, keep mini-player visible.
      state = state.copyWith(isPlaying: false, isBuffering: false);
      return;
    }
    await playAyah(
      surahId: s,
      verseNumber: a + 1,
      surahName: sn,
      totalVerses: tv,
    );
  }

  /// Loads + plays the given ayah. Replaces any current track.
  Future<void> playAyah({
    required int surahId,
    required int verseNumber,
    required String surahName,
    required int totalVerses,
  }) async {
    final player = _ensurePlayer();
    final url = recitationUrl(surah: surahId, ayah: verseNumber);
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
      await player.setUrl(url);
      await player.setSpeed(state.speed);
      await player.play();
    } on Object catch (e, st) {
      developer.log('playAyah failed', error: e, stackTrace: st);
      state = state.copyWith(
        isPlaying: false,
        isBuffering: false,
        errorMessage: 'Could not play this verse. Try again.',
      );
    }
  }

  Future<void> pause() async {
    await _player?.pause();
  }

  Future<void> resume() async {
    await _player?.play();
  }

  Future<void> stop() async {
    await _player?.stop();
    state = const AudioState();
  }

  /// Plays the next ayah within the same surah; no-op if at the end.
  Future<void> next() async {
    final s = state.currentSurah;
    final a = state.currentAyah;
    final tv = state.totalVerses;
    final sn = state.surahName;
    if (s == null || a == null || tv == null || sn == null) return;
    if (a >= tv) return;
    await playAyah(
      surahId: s,
      verseNumber: a + 1,
      surahName: sn,
      totalVerses: tv,
    );
  }

  Future<void> previous() async {
    final s = state.currentSurah;
    final a = state.currentAyah;
    final tv = state.totalVerses;
    final sn = state.surahName;
    if (s == null || a == null || a <= 1 || tv == null || sn == null) return;
    await playAyah(
      surahId: s,
      verseNumber: a - 1,
      surahName: sn,
      totalVerses: tv,
    );
  }

  /// Sets the playback speed and persists it in state so subsequent ayahs
  /// pick it up automatically.
  Future<void> setSpeed(double speed) async {
    state = state.copyWith(speed: speed);
    await _player?.setSpeed(speed);
  }

  /// Cycles to the next preset in [kPlaybackSpeeds].
  Future<void> cycleSpeed() async {
    final current = state.speed;
    final idx = kPlaybackSpeeds.indexWhere(
      (s) => (s - current).abs() < 0.001,
    );
    final next = kPlaybackSpeeds[(idx + 1) % kPlaybackSpeeds.length];
    await setSpeed(next);
  }
}
