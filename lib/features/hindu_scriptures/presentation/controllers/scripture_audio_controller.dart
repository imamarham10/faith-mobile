import 'dart:async';
import 'dart:developer' as developer;

import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_client.dart';
import '../../data/dtos/audio_track.dart';
import '../../data/hindu_scriptures_repository.dart';
import '../../domain/scripture_audio_state.dart';

part 'scripture_audio_controller.g.dart';

/// Playback speeds, same cycle as the Quran module's mini player.
const List<double> kScripturePlaybackSpeeds = [1.0, 1.25, 1.5, 1.75, 2.0, 0.75];

/// Shared `AudioPlayer` for chapter narration.
///
/// Unlike Quran's `AudioController` (hardcoded third-party mp3 host with
/// no reciter choice), this hits the real backend narration endpoint and
/// lets the user switch between available reciter/language tracks.
@Riverpod(keepAlive: true)
class ScriptureAudioController extends _$ScriptureAudioController {
  AudioPlayer? _player;
  StreamSubscription<PlayerState>? _stateSub;

  @override
  ScriptureAudioState build() {
    ref.onDispose(() async {
      await _stateSub?.cancel();
      await _player?.dispose();
    });
    _ensurePlayer();
    return const ScriptureAudioState();
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
        state = state.copyWith(isPlaying: false, isBuffering: false);
      }
    });
    _player = player;
    return player;
  }

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
    final player = _ensurePlayer();
    state = state.copyWith(currentTrack: track, isBuffering: true);
    try {
      await player.setUrl(_resolveUrl(track.url));
      await player.setSpeed(state.speed);
      await player.play();
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

  /// Some tracks (this backend's own narrations) are served as host-relative
  /// paths (e.g. `/audio/gita/hi/ch01.mp3`) rather than absolute URLs —
  /// unlike Quran's audio, which is always a hardcoded absolute third-party
  /// URL. `just_audio.setUrl` requires an absolute URI, so a relative path
  /// must be resolved to one or playback fails outright.
  ///
  /// These particular relative paths are NOT served by the API host —
  /// confirmed live: `unified-faith-service.vercel.app/audio/...` 404s.
  /// They're served by the web app's own static assets instead
  /// (`www.siraat.website/audio/...` 200s), so resolve against
  /// [kWebBaseUrl], not [kApiBaseUrl].
  String _resolveUrl(String url) {
    final uri = Uri.parse(url);
    if (uri.hasScheme) return url;
    return Uri.parse(kWebBaseUrl).resolveUri(uri).toString();
  }

  Future<void> pause() async => _player?.pause();

  Future<void> resume() async => _player?.play();

  Future<void> stop() async {
    await _player?.stop();
    state = const ScriptureAudioState();
  }

  Future<void> setSpeed(double speed) async {
    state = state.copyWith(speed: speed);
    await _player?.setSpeed(speed);
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
