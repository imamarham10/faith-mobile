import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_state.freezed.dart';

/// Immutable snapshot of the recitation player.
///
/// Owned by `AudioController`. The reader observes [isPlaying] / [currentSurah]
/// / [currentAyah] to drive the mini-player UI.
@freezed
abstract class AudioState with _$AudioState {
  const factory AudioState({
    @Default(false) bool isPlaying,
    @Default(false) bool isBuffering,
    int? currentSurah,
    int? currentAyah,
    int? totalVerses,
    String? surahName,
    String? title,
    String? errorMessage,
    @Default(1.0) double speed,
  }) = _AudioState;

  const AudioState._();

  /// Convenience: is anything currently loaded into the player?
  bool get hasTrack => currentSurah != null && currentAyah != null;
}
