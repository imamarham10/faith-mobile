import 'arabic_script.dart';

/// Picks which of a verse's Arabic strings to render for [script].
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
}) => switch (script) {
  ArabicScript.indoPak => _firstPresent(textIndopak, textArabic),
  ArabicScript.uthmani => _firstPresent(textUthmani, textArabic),
  // `textArabic` is the text every Arabic surface in the app has always
  // rendered, and the one the Naskh face was chosen against.
  ArabicScript.naskh => textArabic,
};

String _firstPresent(String? preferred, String fallback) =>
    (preferred != null && preferred.trim().isNotEmpty) ? preferred : fallback;
