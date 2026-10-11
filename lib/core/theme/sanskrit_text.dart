import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// The leading Devanagari scripture wants, as a multiple of font size.
///
/// Devanagari sets its line height from what hangs off the śirorekhā, not
/// from the letters on it: mātrās, anusvāra and candrabindu stack above the
/// headline, and the vertical conjuncts Sanskrit is full of (क्त्र, द्ध,
/// ङ्क्ष) hang well below the baseline. At Latin leading the two collide
/// between lines and the lower halves of conjuncts clip — the same failure
/// Arabic had with its marks, and the reason `arabicLineHeight` exists.
///
/// One number rather than Arabic's three because, unlike the Qur'an, there
/// is no orthography preference here: every Hindu text renders in the one
/// face below.
const double sanskritLineHeight = 1.9;

/// Text style for Devanagari (Sanskrit) scripture text. Unlike Arabic's
/// multi-script preference (`arabic_text.dart`), there's no analogous
/// Settings option in scope for Hindu scripture rendering, so this is a
/// single fixed style rather than a `WidgetRef`-dependent lookup.
///
/// [height] is deliberately **not** defaulted to [sanskritLineHeight]: most
/// call sites here are single-line chips, tiles and headings, where airing
/// out the line box pushes the row past its height for no gain. The readers
/// — where lines sit above and below one another — pass it explicitly.
TextStyle sanskritTextStyle({
  double? fontSize,
  double? height,
  Color? color,
  FontWeight? fontWeight,
}) {
  final base = GoogleFonts.tiroDevanagariSanskrit(
    fontSize: fontSize,
    height: height,
    color: color,
    fontWeight: fontWeight,
  );

  // Splits whatever extra leading there is above and below the glyphs
  // instead of hanging all of it below, which is Flutter's default and
  // which crops what sits above the *first* line — the mātrās and anusvāra
  // every Sanskrit verse opens with. Applied after the fact because the
  // GoogleFonts builders take no such argument; the same treatment, and for
  // the same reason, as `arabicTextStyle`.
  return base.copyWith(leadingDistribution: TextLeadingDistribution.even);
}
