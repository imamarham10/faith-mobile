import 'package:freezed_annotation/freezed_annotation.dart';

part 'emotion.freezed.dart';
part 'emotion.g.dart';

/// A user-selectable mood, returned by `GET /api/v1/islam/feelings`.
@freezed
abstract class Emotion with _$Emotion {
  const factory Emotion({
    required String id,
    required String name,
    required String slug,
    String? icon,
    String? description,
  }) = _Emotion;

  factory Emotion.fromJson(Map<String, dynamic> json) =>
      _$EmotionFromJson(json);
}
