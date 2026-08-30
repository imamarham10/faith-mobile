import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Text style for Devanagari (Sanskrit) scripture text. Unlike Arabic's
/// multi-script preference (`arabic_text.dart`), there's no analogous
/// Settings option in scope for Hindu scripture rendering, so this is a
/// single fixed style rather than a `WidgetRef`-dependent lookup.
TextStyle sanskritTextStyle({
  double? fontSize,
  double? height,
  Color? color,
  FontWeight? fontWeight,
}) {
  return GoogleFonts.tiroDevanagariSanskrit(
    fontSize: fontSize,
    height: height,
    color: color,
    fontWeight: fontWeight,
  );
}
