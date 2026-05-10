import 'package:freezed_annotation/freezed_annotation.dart';

part 'divine_name.freezed.dart';
part 'divine_name.g.dart';

/// Shared DTO for both the 99 Names of Allah and the 99 Names of Muhammad ﷺ.
///
/// Mirrors the backend response shape of `GET /api/v1/islam/names/allah` and
/// `GET /api/v1/islam/names/muhammad`:
///
/// ```json
/// {
///   "id": 1,
///   "nameArabic": "الرحمن",
///   "nameTranslit": "Ar-Rahman",
///   "nameEnglish": "The Most Gracious",
///   "meaning": "The Most Gracious",
///   "description": "The Most Gracious",
///   "audioUrl": null
/// }
/// ```
@freezed
abstract class DivineName with _$DivineName {
  const factory DivineName({
    required int id,
    required String nameArabic,
    required String nameTranslit,
    required String nameEnglish,
    String? meaning,
    String? description,
    String? audioUrl,
  }) = _DivineName;

  factory DivineName.fromJson(Map<String, dynamic> json) =>
      _$DivineNameFromJson(json);
}
