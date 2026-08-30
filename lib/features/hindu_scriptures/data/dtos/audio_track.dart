import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_track.freezed.dart';
part 'audio_track.g.dart';

/// One narration option for a chapter — `GET /texts/:slug/chapters/:n/audio`
/// returns a list of these. Unlike the Quran module (which hits a
/// hardcoded third-party mp3 host with no reciter choice), the Hindu
/// scriptures backend has a real narration endpoint with multiple
/// reciters/languages per chapter.
@freezed
abstract class AudioTrack with _$AudioTrack {
  const factory AudioTrack({
    required String reciterSlug,
    required String name,
    required String language,
    String? credit,
    required String url,
    @Default(false) bool isPremium,
  }) = _AudioTrack;

  factory AudioTrack.fromJson(Map<String, dynamic> json) =>
      _$AudioTrackFromJson(json);
}
