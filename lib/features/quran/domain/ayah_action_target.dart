import '../data/dtos/juz.dart';
import '../data/dtos/verse.dart';

/// Everything the per-verse actions — play, bookmark, share, tafsir — need
/// to know about the verse they are acting on.
///
/// It exists because those actions are now offered from three places (the
/// scrolling reader's action sheet, the juz reader's action bar, the
/// surah verse reader's action bar) over **two unrelated DTOs**: [Verse],
/// which carries a `List<Translation>` for the translation picker, and
/// [JuzVerse], which carries one already-resolved `translation` string and
/// names its own surah. Neither is a superset of the other, and the sheet
/// used to take the first of them — which is precisely why the juz reader
/// could not reuse it.
///
/// So the sheet takes this instead, and the two DTOs map in at the edges.
class AyahActionTarget {
  const AyahActionTarget({
    required this.surahId,
    required this.surahName,
    required this.verseNumber,
    required this.textArabic,
    this.translation,
    this.totalVerses,
  });

  /// From a surah payload's verse. [surahName] and [totalVerses] come from
  /// the enclosing `SurahDetail`, which the verse itself does not carry.
  factory AyahActionTarget.fromVerse(
    Verse verse, {
    required int surahId,
    required String surahName,
    required int totalVerses,
  }) => AyahActionTarget(
    surahId: surahId,
    surahName: surahName,
    verseNumber: verse.verseNumber,
    textArabic: verse.textArabic,
    translation: verse.translations.isNotEmpty
        ? verse.translations.first.text
        : null,
    totalVerses: totalVerses,
  );

  /// From a juz payload's verse, which names its own surah.
  ///
  /// [totalVerses] has to be supplied from the 114-surah index — the juz
  /// payload never says how long a surah is — and is genuinely unknown if
  /// that index has not loaded. See the field.
  factory AyahActionTarget.fromJuzVerse(JuzVerse verse, {int? totalVerses}) =>
      AyahActionTarget(
        surahId: verse.surahId,
        surahName: verse.surahName,
        verseNumber: verse.verseNumber,
        textArabic: verse.textArabic,
        translation: verse.translation,
        totalVerses: totalVerses,
      );

  final int surahId;
  final String surahName;
  final int verseNumber;

  /// The payload's Arabic. Deliberately **not** script-resolved: this is
  /// what gets bookmarked and shared, and a bookmark should hold the verse
  /// rather than a snapshot of the reader's current orthography setting.
  final String textArabic;

  final String? translation;

  /// How many verses the surah has — the point at which continuous
  /// recitation stops advancing.
  ///
  /// Null when the surah index has not loaded (only reachable by deep link
  /// straight into a reader). Playback then stops after this verse rather
  /// than running past the end of the surah; see `AyahActions.play`.
  final int? totalVerses;

  /// "Al-Baqarah · 2:255" — the one label every action surface uses.
  String get label => '$surahName · $surahId:$verseNumber';

  /// "— Al-Baqarah 2:255", for the share card's footer.
  String get attribution => '— $surahName $surahId:$verseNumber';
}
