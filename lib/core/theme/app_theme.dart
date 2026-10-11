import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    final onPrimaryColor = _onColorFor(palette.primary);
    final onSecondaryColor = _onColorFor(palette.secondary);
    final onErrorColor = _onColorFor(palette.error);

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: palette.primary,
      onPrimary: onPrimaryColor,
      primaryContainer: palette.primary.withValues(alpha: 0.16),
      onPrimaryContainer: palette.ink,
      secondary: palette.secondary,
      onSecondary: onSecondaryColor,
      secondaryContainer: palette.secondary.withValues(alpha: 0.16),
      onSecondaryContainer: palette.ink,
      tertiary: palette.secondary,
      onTertiary: onSecondaryColor,
      error: palette.error,
      onError: onErrorColor,
      surface: palette.surface,
      onSurface: palette.ink,
      onSurfaceVariant: palette.inkMuted,
      surfaceContainerLowest: palette.surface,
      surfaceContainerLow: palette.surfaceCard,
      surfaceContainer: palette.surfaceCard,
      surfaceContainerHigh: palette.surfaceCard,
      surfaceContainerHighest: palette.surfaceCard,
      outline: palette.outline,
      outlineVariant: palette.outline.withValues(alpha: 0.4),
      shadow: palette.shadow,
      scrim: Colors.black.withValues(alpha: 0.4),
      inverseSurface: palette.ink,
      onInverseSurface: palette.surface,
      // TODO: fails WCAG contrast vs inverseSurface in dark mode (~1.7-2.1:1,
      // needs 3:1). Zero live impact today (no SnackBarAction exists yet) —
      // must be fixed before anyone adds one.
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
        systemOverlayStyle: systemOverlayStyleFor(brightness),
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
          foregroundColor: onPrimaryColor,
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: textTheme.titleMedium,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _onColorFor(palette.surface),
          textStyle: textTheme.labelLarge,
        ),
      ),
    );
  }

  static double _contrastRatio(Color a, Color b) {
    final l1 = a.computeLuminance() + 0.05;
    final l2 = b.computeLuminance() + 0.05;
    return l1 > l2 ? l1 / l2 : l2 / l1;
  }

  /// Picks whichever of near-black or white has higher WCAG contrast against
  /// [background] — the "poppy" palette's saturated colors don't reliably
  /// pair with one fixed choice the way a muted palette would.
  static Color _onColorFor(Color background) {
    const darkText = Color(0xFF1A1A1A);
    const lightText = Colors.white;
    return _contrastRatio(darkText, background) >=
            _contrastRatio(lightText, background)
        ? darkText
        : lightText;
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
      headlineLarge: baloo.headlineLarge?.copyWith(
        fontSize: 26,
        fontWeight: FontWeight.w600,
        color: ink,
      ),
      headlineMedium: baloo.headlineMedium?.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: ink,
      ),
      headlineSmall: baloo.headlineSmall?.copyWith(
        fontSize: 20,
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
      titleSmall: nunito.titleSmall?.copyWith(
        fontSize: 14,
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

/// The one status-bar/navigation-bar style for a given theme brightness.
///
/// ## Why this exists in exactly one place
///
/// The status bar was visibly flickering — most obviously around the battery
/// icon — whenever the app moved between screens, and its icons were washed
/// out to the point of being unreadable on the cream ground.
///
/// Both came from the same gap. `main()` set only
/// `statusBarColor: Colors.transparent` and named **no icon brightness**, and
/// `AppBarTheme` set no `systemOverlayStyle` at all. So:
///
/// * The 51 screens with an `AppBar` got Flutter's fallback, which derives a
///   style from the app bar's own background and publishes it through an
///   `AnnotatedRegion`.
/// * The five built on [PageMasthead] — Today, Qur'an, Hadiths, Practice and
///   the Hindu scripture/stories homes — have no `AppBar`, so they published
///   nothing and fell back to the global style with its unspecified icon
///   colour.
///
/// Moving between the two kinds, and during the route transition where both
/// are briefly in the tree, the platform overlay style changed back and forth.
/// That is the flicker. A `StatefulShellRoute.indexedStack` keeps all five
/// branches alive at once, which gives the competing regions every chance to
/// swap.
///
/// Naming the style here, and applying it both to `AppBarTheme` and at the app
/// root, means every screen publishes the *same* value — so there is nothing
/// left to flicker between. Do not set a second overlay style anywhere else;
/// re-introducing a competing one brings the flicker straight back.
SystemUiOverlayStyle systemOverlayStyleFor(Brightness brightness) {
  final isLight = brightness == Brightness.light;
  return SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
    // Android reads these two: the *icons* must contrast with the page
    // behind them, so a light page needs dark icons.
    statusBarIconBrightness: isLight ? Brightness.dark : Brightness.light,
    systemNavigationBarIconBrightness: isLight
        ? Brightness.dark
        : Brightness.light,
    // iOS reads this one, and its meaning is inverted: it names the
    // brightness of the *background*, not of the icons. Getting these two
    // the same way round is the usual way this is shipped broken.
    statusBarBrightness: brightness,
  );
}
