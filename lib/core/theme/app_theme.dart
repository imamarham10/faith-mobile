import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Builds the Material 3 light and dark themes for Faith.
///
/// The display/headline scale uses Fraunces (a soulful serif), and body/labels
/// use Inter for clean utility text.
class AppTheme {
  const AppTheme._();

  static ThemeData light() => _build(
    brightness: Brightness.light,
    scaffoldBg: AppColors.parchment,
    surface: AppColors.parchmentRaised,
    onSurface: AppColors.ink,
    onSurfaceMuted: AppColors.inkMuted,
    onSurfaceSubtle: AppColors.inkSubtle,
    primary: AppColors.sage,
    onPrimary: AppColors.parchmentRaised,
    primaryContainer: AppColors.sageSoft,
    secondary: AppColors.gold,
    onSecondary: AppColors.parchmentRaised,
    secondaryContainer: AppColors.goldSoft,
    outline: AppColors.line,
    navIndicator: AppColors.sageSoft,
  );

  static ThemeData dark() => _build(
    brightness: Brightness.dark,
    scaffoldBg: AppColors.night,
    surface: AppColors.nightSurface,
    onSurface: AppColors.moonlight,
    onSurfaceMuted: AppColors.moonMuted,
    onSurfaceSubtle: AppColors.moonSubtle,
    primary: AppColors.sageNight,
    onPrimary: AppColors.night,
    primaryContainer: AppColors.sageNightSoft,
    secondary: AppColors.goldNight,
    onSecondary: AppColors.night,
    secondaryContainer: AppColors.goldNightSoft,
    outline: AppColors.nightLine,
    navIndicator: AppColors.nightSurfaceHigh,
  );

  static ThemeData _build({
    required Brightness brightness,
    required Color scaffoldBg,
    required Color surface,
    required Color onSurface,
    required Color onSurfaceMuted,
    required Color onSurfaceSubtle,
    required Color primary,
    required Color onPrimary,
    required Color primaryContainer,
    required Color secondary,
    required Color onSecondary,
    required Color secondaryContainer,
    required Color outline,
    required Color navIndicator,
  }) {
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onSurface,
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: onSurface,
      tertiary: secondary,
      onTertiary: onSecondary,
      error: const Color(0xFFB3261E),
      onError: const Color(0xFFFFFFFF),
      surface: surface,
      onSurface: onSurface,
      onSurfaceVariant: onSurfaceMuted,
      outline: outline,
      outlineVariant: outline,
      shadow: Colors.black.withValues(alpha: 0.08),
      scrim: Colors.black.withValues(alpha: 0.4),
      inverseSurface: onSurface,
      onInverseSurface: surface,
      inversePrimary: primary,
    );

    final textTheme = _buildTextTheme(onSurface, onSurfaceMuted);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBg,
      canvasColor: scaffoldBg,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      hoverColor: primary.withValues(alpha: 0.04),
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBg,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: false,
        foregroundColor: onSurface,
        titleTextStyle: textTheme.titleLarge,
        iconTheme: IconThemeData(color: onSurface),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 68,
        elevation: 0,
        backgroundColor: scaffoldBg,
        surfaceTintColor: Colors.transparent,
        indicatorColor: navIndicator,
        labelTextStyle: WidgetStatePropertyAll(textTheme.labelSmall),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: onSurface, size: 24);
          }
          return IconThemeData(color: onSurfaceMuted, size: 24);
        }),
      ),
      dividerTheme: DividerThemeData(color: outline, thickness: 1, space: 1),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        hintStyle: textTheme.bodyLarge?.copyWith(color: onSurfaceSubtle),
        labelStyle: textTheme.bodyMedium?.copyWith(color: onSurfaceMuted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.error, width: 1.5),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: textTheme.titleMedium,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: textTheme.labelLarge,
        ),
      ),
    );
  }

  static TextTheme _buildTextTheme(Color onSurface, Color onSurfaceMuted) {
    final fraunces = GoogleFonts.frauncesTextTheme();
    final inter = GoogleFonts.interTextTheme();

    return TextTheme(
      displayLarge: fraunces.displayLarge?.copyWith(
        fontSize: 56,
        fontWeight: FontWeight.w300,
        letterSpacing: -2,
        height: 1.0,
        color: onSurface,
      ),
      displayMedium: fraunces.displayMedium?.copyWith(
        fontSize: 40,
        fontWeight: FontWeight.w400,
        letterSpacing: -1,
        height: 1.05,
        color: onSurface,
      ),
      displaySmall: fraunces.displaySmall?.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.5,
        color: onSurface,
      ),
      headlineMedium: fraunces.headlineMedium?.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
        color: onSurface,
      ),
      titleLarge: inter.titleLarge?.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: onSurface,
      ),
      titleMedium: inter.titleMedium?.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: onSurface,
      ),
      bodyLarge: inter.bodyLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.55,
        color: onSurface,
      ),
      bodyMedium: inter.bodyMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: onSurfaceMuted,
      ),
      bodySmall: inter.bodySmall?.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.45,
        color: onSurfaceMuted,
      ),
      labelLarge: inter.labelLarge?.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
        color: onSurface,
      ),
      labelMedium: inter.labelMedium?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.6,
        color: onSurfaceMuted,
      ),
      labelSmall: inter.labelSmall?.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
        color: onSurfaceMuted,
      ),
    );
  }
}
