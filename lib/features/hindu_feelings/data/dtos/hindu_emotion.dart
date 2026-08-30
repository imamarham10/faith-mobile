import 'package:freezed_annotation/freezed_annotation.dart';

import 'hindu_remedy.dart';

part 'hindu_emotion.freezed.dart';
part 'hindu_emotion.g.dart';

/// A user-selectable mood, returned by `GET /api/v1/hindu/feelings`.
///
/// Unlike Islam's `Emotion` (which needs a `kDefaultMoods` client fallback
/// because the backend list can be empty), this backend is fully seeded —
/// 10 real emotions, each carrying a Hindi name alongside the English one.
@freezed
abstract class HinduEmotion with _$HinduEmotion {
  const factory HinduEmotion({
    required String id,
    required String slug,
    required String nameEnglish,
    String? nameHindi,
    String? icon,
    @Default(0) int remedyCount,
  }) = _HinduEmotion;

  factory HinduEmotion.fromJson(Map<String, dynamic> json) =>
      _$HinduEmotionFromJson(json);
}

/// Detail returned by `GET /api/v1/hindu/feelings/:slug` — an emotion with
/// its attached remedies (each a Gita verse plus a short reflective note).
/// Built manually in the repository (like Islam's `EmotionDetail`), not via
/// this class's own `fromJson` — `remedies` needs `HinduRemedy.parse`'s
/// tolerant, nested-map parsing, not a straight `List<HinduRemedy>` decode.
@freezed
abstract class HinduEmotionDetail with _$HinduEmotionDetail {
  const factory HinduEmotionDetail({
    required String slug,
    required String nameEnglish,
    String? nameHindi,
    String? icon,
    @Default(<HinduRemedy>[]) List<HinduRemedy> remedies,
  }) = _HinduEmotionDetail;
}
