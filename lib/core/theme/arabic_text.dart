import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../preferences/arabic_script.dart';

/// The script the user is reading in, with the pre-load default applied.
///
/// Exposed separately from [arabicTextStyleOf] because the preference picks
/// a *text* as well as a face: a caller that renders a verse needs the
/// script itself to hand to `arabicTextForScript`, and reading it twice
/// through two helpers would let the two drift apart for a frame.
ArabicScript activeArabicScript(WidgetRef ref) =>
    ref.watch(arabicScriptControllerProvider).valueOrNull ??
    ArabicScript.indoPak;

/// Returns the [TextStyle] for the active Arabic script preference.
///
/// Watches [arabicScriptControllerProvider] so changing the preference in
/// settings live-updates every Arabic surface in the app.
TextStyle arabicTextStyleOf(
  WidgetRef ref, {
  double? fontSize,
  double? height,
  Color? color,
  FontWeight? fontWeight,
}) => arabicTextStyle(
  activeArabicScript(ref),
  fontSize: fontSize,
  height: height,
  color: color,
  fontWeight: fontWeight,
);

/// The leading each script wants, as a multiple of font size.
///
/// Arabic line height is set by the marks, not the letters, and the three
/// scripts carry different amounts of them: Indo-Pak stacks an explicit
/// sukun over long vowels and hangs waqf marks above the line, Uthmani adds
/// superscript alef and the small high markers over silent letters, and
/// plain Naskh carries the fewest. A single number for all three either
/// clips the dense ones or airs out the sparse one.
double arabicLineHeight(ArabicScript script) => switch (script) {
  ArabicScript.indoPak => 2.0,
  ArabicScript.uthmani => 2.15,
  ArabicScript.naskh => 1.9,
};

/// Pure helper — builds the [TextStyle] for an explicit script. Useful when
/// the caller already has the script in hand (e.g. inside the settings
/// preview row).
///
/// ## Why each face
///
/// The face is chosen for the *encoding* it will be handed, not for taste.
/// A font drawn for one orthography rendering another is how the Indo-Pak
/// preference spent its first life looking almost-right and being wrong.
///
/// * **Indo-Pak → Scheherazade New.** SIL's Arabic family, drawn with the
///   South Asian Qur'anic conventions in its coverage: dotless ya, the
///   small high marks, and the `ؕ`-family waqf signs (U+0615 …) that the
///   Indo-Pak text is full of and that most Arabic UI faces simply lack.
/// * **Uthmani → Amiri Quran.** Amiri's Qur'anic cut, drawn against the
///   King Fahd Complex text: alef-wasla, the small high rounded zero, the
///   superscript alef all sit where that text expects them.
/// * **Naskh → Noto Naskh Arabic.** A plain modern Naskh for the plain
///   modern spelling; broad coverage and the least ornament of the three.
///
/// When a script's own text is unavailable the caller falls back to
/// `textArabic` but **keeps this face** — a per-verse typeface swap as data
/// trickles in would flicker, and all three faces cover the Uthmani-family
/// marks that `textArabic` carries.
TextStyle arabicTextStyle(
  ArabicScript script, {
  double? fontSize,
  double? height,
  Color? color,
  FontWeight? fontWeight,
}) {
  final resolvedHeight = height ?? arabicLineHeight(script);
  final base = switch (script) {
    ArabicScript.indoPak => GoogleFonts.scheherazadeNew(
      fontSize: fontSize,
      height: resolvedHeight,
      color: color,
      fontWeight: fontWeight,
    ),
    ArabicScript.uthmani => GoogleFonts.amiriQuran(
      fontSize: fontSize,
      height: resolvedHeight,
      color: color,
      fontWeight: fontWeight,
    ),
    ArabicScript.naskh => GoogleFonts.notoNaskhArabic(
      fontSize: fontSize,
      height: resolvedHeight,
      color: color,
      fontWeight: fontWeight,
    ),
  };

  // Splits the extra leading above and below the glyphs instead of hanging
  // all of it below, which is Flutter's default and which crops the marks
  // sitting above the *first* line — superscript alef and maddah, exactly
  // the ones Qur'anic text is made of. Applied after the fact because the
  // GoogleFonts builders take no such argument.
  return base.copyWith(leadingDistribution: TextLeadingDistribution.even);
}
