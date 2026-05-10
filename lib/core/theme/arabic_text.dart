import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../preferences/arabic_script.dart';

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
}) {
  final script =
      ref.watch(arabicScriptControllerProvider).valueOrNull ??
      ArabicScript.indoPak;
  return arabicTextStyle(
    script,
    fontSize: fontSize,
    height: height,
    color: color,
    fontWeight: fontWeight,
  );
}

/// Pure helper — builds the [TextStyle] for an explicit script. Useful when
/// the caller already has the script in hand (e.g. inside the settings
/// preview row).
TextStyle arabicTextStyle(
  ArabicScript script, {
  double? fontSize,
  double? height,
  Color? color,
  FontWeight? fontWeight,
}) {
  switch (script) {
    case ArabicScript.indoPak:
      return GoogleFonts.scheherazadeNew(
        fontSize: fontSize,
        height: height,
        color: color,
        fontWeight: fontWeight,
      );
    case ArabicScript.uthmani:
      return GoogleFonts.amiriQuran(
        fontSize: fontSize,
        height: height,
        color: color,
        fontWeight: fontWeight,
      );
    case ArabicScript.naskh:
      return GoogleFonts.notoNaskhArabic(
        fontSize: fontSize,
        height: height,
        color: color,
        fontWeight: fontWeight,
      );
  }
}
