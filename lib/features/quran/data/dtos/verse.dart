import 'package:freezed_annotation/freezed_annotation.dart';

import 'translation.dart';

part 'verse.freezed.dart';
part 'verse.g.dart';

/// A single verse (ayah). Returned inside `Surah` detail payloads.
@freezed
abstract class Verse with _$Verse {
  const factory Verse({
    required String id,
    required int surahId,
    required int verseNumber,
    required String textArabic,
    String? textSimple,
    @Default(<Translation>[]) List<Translation> translations,
  }) = _Verse;

  factory Verse.fromJson(Map<String, dynamic> json) => _$VerseFromJson(json);
}

/// A surah with all its verses — returned by `GET /api/v1/islam/quran/surah/:id`.
@freezed
abstract class SurahDetail with _$SurahDetail {
  const factory SurahDetail({
    required int id,
    required String nameArabic,
    required String nameEnglish,
    @Default(<Verse>[]) List<Verse> verses,
  }) = _SurahDetail;

  factory SurahDetail.fromJson(Map<String, dynamic> json) =>
      _$SurahDetailFromJson(json);
}
