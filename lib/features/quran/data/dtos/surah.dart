import 'package:freezed_annotation/freezed_annotation.dart';

part 'surah.freezed.dart';
part 'surah.g.dart';

/// A surah summary returned by `GET /api/v1/islam/quran/surahs`.
///
/// The Quran has 114 surahs. Each carries an Arabic name, an English name,
/// transliteration, the place of revelation (Meccan/Medinan), and a verse
/// count.
@freezed
abstract class Surah with _$Surah {
  const factory Surah({
    required int id,
    required String nameArabic,
    required String nameEnglish,
    required String nameTransliteration,
    required String revelationPlace,
    required int verseCount,
  }) = _Surah;

  factory Surah.fromJson(Map<String, dynamic> json) => _$SurahFromJson(json);
}
