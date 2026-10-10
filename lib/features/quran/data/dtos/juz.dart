import 'package:freezed_annotation/freezed_annotation.dart';

part 'juz.freezed.dart';
part 'juz.g.dart';

/// One end of a juz, as returned inside `GET /api/v1/islam/quran/juz`.
///
/// A juz does not line up with surah boundaries — juz 1 ends mid-Baqarah at
/// 2:141 — so both ends carry their own surah as well as a verse number.
@freezed
abstract class JuzBoundary with _$JuzBoundary {
  const factory JuzBoundary({
    required int surahId,
    required String surahName,
    required int verseNumber,
  }) = _JuzBoundary;

  factory JuzBoundary.fromJson(Map<String, dynamic> json) =>
      _$JuzBoundaryFromJson(json);
}

/// A juz in the chooser: `GET /api/v1/islam/quran/juz` returns exactly 30 of
/// these, ascending.
///
/// [surahIds] is every surah the juz touches, in order, so the list row can
/// name its range without a second call.
@freezed
abstract class JuzSummary with _$JuzSummary {
  const factory JuzSummary({
    required int number,
    required JuzBoundary start,
    required JuzBoundary end,
    required int verseCount,
    @Default(<int>[]) List<int> surahIds,
  }) = _JuzSummary;

  factory JuzSummary.fromJson(Map<String, dynamic> json) =>
      _$JuzSummaryFromJson(json);
}

/// One verse inside a juz page.
///
/// Deliberately **not** the existing [Verse] DTO. Two fields differ in kind,
/// not just in name: `translation` here is a single resolved string (the
/// server has already picked one by `translationId`), where [Verse] carries
/// a `List<Translation>` for the reader's translation picker; and a juz
/// verse must say which surah it belongs to, which a verse nested inside a
/// surah payload never has to.
///
/// [indexInJuz] is 1-based across the **whole juz**, not the page. It is the
/// only thing the reader navigates by: position within the surah
/// ([verseNumber]) resets at every surah boundary, and a juz crosses up to
/// 37 of them.
///
/// [textUthmani] and [textIndopak] are the same verse in the other two
/// orthographies, and the reader picks between all three by the user's
/// script preference (`arabicTextForScript`). They are not styling: the
/// characters differ — Uthmani's `ٱلَّتِى كَانُوا۟` against Indo-Pak's
/// `الَّتِیْ كَانُوۡا` — and no font bridges that.
///
/// [textIndopak] is nullable and *is* null today: it is an additive field
/// and arrives only once the backend seed has run, and may stay null for
/// individual verses after. The reader falls back to [textArabic] rather
/// than showing an empty verse.
///
/// [translation] is nullable and genuinely arrives null: the juz endpoints
/// are public, so premium editions are filtered out server-side and a
/// request for one resolves to a verse with no translation rather than an
/// error. The reader renders the Arabic alone in that case.
@freezed
abstract class JuzVerse with _$JuzVerse {
  const factory JuzVerse({
    required String id,
    required int surahId,
    required String surahName,
    required int verseNumber,
    required int indexInJuz,
    required String textArabic,
    String? textUthmani,
    String? textIndopak,
    String? translation,
  }) = _JuzVerse;

  factory JuzVerse.fromJson(Map<String, dynamic> json) =>
      _$JuzVerseFromJson(json);
}

/// One server-side page of a juz: `GET /api/v1/islam/quran/juz/:number`.
///
/// [verseCount] is the whole juz's length, not the page's — the reader needs
/// it for "N verses left" and to know where forward navigation stops.
@freezed
abstract class JuzPage with _$JuzPage {
  const factory JuzPage({
    required int number,
    required int verseCount,
    required int page,
    required int limit,
    required int totalPages,
    @Default(<JuzVerse>[]) List<JuzVerse> verses,
  }) = _JuzPage;

  factory JuzPage.fromJson(Map<String, dynamic> json) =>
      _$JuzPageFromJson(json);
}
