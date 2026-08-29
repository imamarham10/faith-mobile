import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'faith_id.dart';
import 'faith_palette.dart';
import 'faith_theme_extension.dart';

/// Builds the Material 3 light and dark themes for the active faith.
///
/// Typography: Baloo 2 for display/headline (chunky, rounded, "poppy"),
/// Nunito for body/labels (readable at small sizes, still rounded/friendly).
class AppTheme {
  const AppTheme._();

  static ThemeData light(FaithId faith) =>
      _build(faith: faith, brightness: Brightness.light);

  static ThemeData dark(FaithId faith) =>
      _build(faith: faith, brightness: Brightness.dark);

  static ThemeData _build({
    required FaithId faith,
    required Brightness brightness,
  }) {
    final palette = FaithPalette.of(faith, brightness);
    final onPrimary = brightness == Brightness.dark
        ? const Color(0xFF0A0A0A)
        : const Color(0xFFFFFFFF);

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: palette.primary,
      onPrimary: onPrimary,
      primaryContainer: palette.primary.withValues(alpha: 0.16),
      onPrimaryContainer: palette.ink,
      secondary: palette.secondary,
      onSecondary: onPrimary,
      secondaryContainer: palette.secondary.withValues(alpha: 0.16),
      onSecondaryContainer: palette.ink,
      tertiary: palette.secondary,
      onTertiary: onPrimary,
      error: palette.error,
      onError: Colors.white,
      surface: palette.surface,
      onSurface: palette.ink,
      onSurfaceVariant: palette.inkMuted,
      outline: palette.outline,
      outlineVariant: palette.outline.withValues(alpha: 0.4),
      shadow: palette.shadow,
      scrim: Colors.black.withValues(alpha: 0.4),
      inverseSurface: palette.ink,
      onInverseSurface: palette.surface,
      inversePrimary: palette.primary,
    );

    final textTheme = _buildTextTheme(palette.ink, palette.inkMuted);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: palette.surface,
      canvasColor: palette.surface,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      hoverColor: palette.primary.withValues(alpha: 0.04),
      extensions: [FaithThemeExtension.of(faith, palette)],
      appBarTheme: AppBarTheme(
        backgroundColor: palette.surface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: false,
        foregroundColor: palette.ink,
        titleTextStyle: textTheme.titleLarge,
        iconTheme: IconThemeData(color: palette.ink),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 68,
        elevation: 0,
        backgroundColor: palette.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: palette.primary.withValues(alpha: 0.16),
        labelTextStyle: WidgetStatePropertyAll(textTheme.labelSmall),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: palette.primary, size: 26);
          }
          return IconThemeData(color: palette.inkMuted, size: 24);
        }),
      ),
      dividerTheme: DividerThemeData(
        color: palette.outline,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.surfaceCard,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        hintStyle: textTheme.bodyLarge?.copyWith(color: palette.inkMuted),
        labelStyle: textTheme.bodyMedium?.copyWith(color: palette.inkMuted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: palette.outline, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: palette.outline, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: palette.primary, width: 2.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.error, width: 2.5),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: palette.primary,
          foregroundColor: onPrimary,
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: textTheme.titleMedium,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: palette.primary,
          textStyle: textTheme.labelLarge,
        ),
      ),
    );
  }

  static TextTheme _buildTextTheme(Color ink, Color inkMuted) {
    final baloo = GoogleFonts.baloo2TextTheme();
    final nunito = GoogleFonts.nunitoTextTheme();

    return TextTheme(
      displayLarge: baloo.displayLarge?.copyWith(
        fontSize: 52,
        fontWeight: FontWeight.w700,
        letterSpacing: -1,
        height: 1.05,
        color: ink,
      ),
      displayMedium: baloo.displayMedium?.copyWith(
        fontSize: 38,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.08,
        color: ink,
      ),
      displaySmall: baloo.displaySmall?.copyWith(
        fontSize: 30,
        fontWeight: FontWeight.w600,
        color: ink,
      ),
      headlineMedium: baloo.headlineMedium?.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: ink,
      ),
      titleLarge: nunito.titleLarge?.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w800,
        color: ink,
      ),
      titleMedium: nunito.titleMedium?.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: ink,
      ),
      bodyLarge: nunito.bodyLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.5,
        color: ink,
      ),
      bodyMedium: nunito.bodyMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.45,
        color: inkMuted,
      ),
      bodySmall: nunito.bodySmall?.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: inkMuted,
      ),
      labelLarge: nunito.labelLarge?.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
        color: ink,
      ),
      labelMedium: nunito.labelMedium?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.4,
        color: inkMuted,
      ),
      labelSmall: nunito.labelSmall?.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.8,
        color: inkMuted,
      ),
    );
  }
}
