import 'arabic_script.dart';

/// Picks which of a verse's Arabic strings to render for [script], and
/// returns it ready to draw (see [_renderable]).
///
/// The three scripts are **encodings**, not typefaces, and the difference is
/// in the characters themselves. 2:142 is the standing example:
///
/// * Uthmani — `ٱلسُّفَهَآءُ … ٱلَّتِى كَانُوا۟` — alef-wasla, dotless final
///   ya, the small high rounded zero over a silent waw.
/// * Indo-Pak — `السُّفَهَآءُ … الَّتِیْ كَانُوۡا` — plain alef-lam, explicit
///   sukun on long vowels, `ؕ` (U+0615) for the waqf marks.
///
/// No font bridges that, which is why this function exists: before it, the
/// preference swapped [TextStyle.fontFamily] and left the Unicode alone, so
/// "Indo-Pak" rendered Uthmani text in a South Asian typeface.
///
/// ## Falling back
///
/// [textIndopak] is additive and nullable — it is null for every verse until
/// the backend seed lands, and may stay null for some verses after. A verse
/// is never worth withholding over its orthography, so an absent (or
/// blank — a seed that half-ran leaves empty strings, not nulls) variant
/// falls through to [textArabic], which every payload carries and which is
/// itself Uthmani-family. The reader shows the verse; only the spelling is
/// degraded.
String arabicTextForScript(
  ArabicScript script, {
  required String textArabic,
  String? textIndopak,
  String? textUthmani,
}) => _renderable(switch (script) {
  ArabicScript.indoPak => _firstPresent(textIndopak, textArabic),
  ArabicScript.uthmani => _firstPresent(textUthmani, textArabic),
  // `textArabic` is the text every Arabic surface in the app has always
  // rendered, and the one the Naskh face was chosen against.
  ArabicScript.naskh => textArabic,
});

String _firstPresent(String? preferred, String fallback) =>
    (preferred != null && preferred.trim().isNotEmpty) ? preferred : fallback;

/// Characters borrowed from the Unicode **Private Use Area**, which mean
/// nothing outside the one font they were drawn for.
///
/// The Indo-Pak text carries about 1,383 of them across the corpus — a
/// handful of waqf signs at U+E003, U+E004, U+E01A–E01F, U+E021 and U+E022
/// that the IndoPak print tradition uses and Unicode never encoded. 7:29
/// has two.
final _privateUse = RegExp(r'[\uE000-\uF8FF]');

/// Runs of horizontal space left behind once a mark between two of them is
/// gone. The corpus spaces its waqf marks with U+2002 EN SPACE.
final _orphanedSpace = RegExp(r'[ \u2002\u2003]{2,}');

/// Drops what no font the app can draw with would render.
///
/// All three faces — Scheherazade New, Amiri Quran, Noto Naskh Arabic —
/// map **zero** of those codepoints (checked against their cmaps), and the
/// app bundles no font of its own, so rendering the text verbatim would put
/// a tofu box at every one of those 1,383 places in the mushaf.
///
/// This is a deliberate trade and worth naming as one: **a missing waqf
/// mark is a loss of recitation guidance**, not of the Qur'anic text, and
/// it is the lesser loss against boxes scattered through scripture. The
/// marks come back the day a real Indo-Pak face that maps the range is
/// bundled (Al Qalam Quran, Noorehuda, PDMS Saleem Quran — each needs its
/// licence checked for redistribution in a paid app); on that day this
/// filter is deleted, not amended.
///
/// Nothing else in the string is touched. The text is **not** NFC-
/// normalised here or anywhere in the client — 5,703 of 6,236 verses change
/// under NFC, and in 1,242 of them it composes alef + maddah into U+0622,
/// characters the mushaf does not have. The RLM, ZWSP and U+FEFF threaded
/// through verse text are shaping and direction controls, not noise, and a
/// mid-string U+FEFF is not a BOM.
String _renderable(String text) => text
    .replaceAll(_privateUse, '')
    .replaceAll(_orphanedSpace, ' ')
    .trim();
