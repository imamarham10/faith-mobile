import 'package:freezed_annotation/freezed_annotation.dart';

import '../data/dtos/audio_track.dart';

part 'scripture_audio_state.freezed.dart';

/// Immutable snapshot of the chapter-narration player.
///
/// Unlike the Quran module (per-ayah clips, auto-advancing through a
/// surah), Hindu scripture audio is per-*chapter* narration — one or more
/// reciter/language tracks per chapter, not segmented by verse. There is
/// no "next verse" auto-advance concept here.
@freezed
abstract class ScriptureAudioState with _$ScriptureAudioState {
  const factory ScriptureAudioState({
    @Default(false) bool isPlaying,
    @Default(false) bool isBuffering,
    String? currentTextSlug,
    int? currentChapterNumber,
    String? chapterTitle,
    AudioTrack? currentTrack,
    @Default(<AudioTrack>[]) List<AudioTrack> availableTracks,
    String? errorMessage,
    @Default(1.0) double speed,
  }) = _ScriptureAudioState;

  const ScriptureAudioState._();

  /// Convenience: is anything currently loaded into the player?
  bool get hasTrack => currentTextSlug != null && currentChapterNumber != null;
}
