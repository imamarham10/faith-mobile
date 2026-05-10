import 'package:freezed_annotation/freezed_annotation.dart';

part 'remedy.freezed.dart';
part 'remedy.g.dart';

/// A spiritual remedy (verse / dua / hadith) attached to an [Emotion].
///
/// Backend payload (per APIs.md) uses `arabicText`, `translation`,
/// `transliteration`, `source`. We additionally tolerate camelCase and
/// snake_case by parsing in [Remedy.parse].
@freezed
abstract class Remedy with _$Remedy {
  const factory Remedy({
    required String id,

    /// `verse` | `dua` | `hadith`. `null` when the API doesn't classify.
    String? kind,
    required String arabicText,
    String? transliteration,
    required String translation,
    String? source,
  }) = _Remedy;

  factory Remedy.fromJson(Map<String, dynamic> json) => _$RemedyFromJson(json);

  /// Tolerant parser — accepts the canonical shape plus a few aliases.
  static Remedy parse(Map<String, dynamic> json) {
    String? str(String key) {
      final v = json[key];
      return v is String ? v : null;
    }

    final id = str('id') ?? str('_id') ?? str('uuid') ?? '';
    final arabic = str('arabicText') ?? str('textAr') ?? str('arabic') ?? '';
    final translation =
        str('translation') ?? str('translationEn') ?? str('text') ?? '';
    final translit = str('transliteration') ?? str('translit');
    final source = str('source') ?? str('reference');
    final kind = str('kind') ?? str('type');

    return Remedy(
      id: id,
      kind: kind,
      arabicText: arabic,
      transliteration: translit,
      translation: translation,
      source: source,
    );
  }
}

/// Detail returned by `GET /api/v1/islam/feelings/:slug`.
@freezed
abstract class EmotionDetail with _$EmotionDetail {
  const factory EmotionDetail({
    required String slug,
    required String name,
    String? icon,
    String? description,
    @Default(<Remedy>[]) List<Remedy> remedies,
  }) = _EmotionDetail;

  factory EmotionDetail.fromJson(Map<String, dynamic> json) =>
      _$EmotionDetailFromJson(json);
}
