import 'package:flutter/material.dart';

import 'faith_id.dart';

/// Flat token bag for one faith + brightness. Only `primary`/`primaryPressed`
/// /`secondary`/`secondaryPressed`/`mascotAccent` vary by faith — neutrals
/// (surface/ink/outline/shadow) are shared so both faiths read as siblings.
///
/// `secondary` is deliberately bold/saturated — it's tuned as a FILL color
/// (buttons, chips, badge backgrounds) where a computed contrasting "on"
/// color sits on top of it. It fails WCAG AA (~1.5:1) when read directly as
/// TEXT color on `surface`/`surfaceCard` — a distinct use case that this
/// same bold value was incorrectly pressed into across ~20 call sites app-
/// wide (found 2026-08-29: verse references, day-number labels, section
/// headers, etc. — all unreadable in light mode). Use `accentText` instead
/// for that case: same hue/saturation as `secondary`, lightness reduced
/// until it clears WCAG AA against `surface` (light mode only needs this —
/// dark mode's `secondary` already has 11.8-13.1:1 against dark surfaces,
/// so `accentText` just equals `secondary` there).
class FaithPalette {
  const FaithPalette({
    required this.primary,
    required this.primaryPressed,
    required this.secondary,
    required this.secondaryPressed,
    required this.accentText,
    required this.mascotAccent,
    required this.surface,
    required this.surfaceCard,
    required this.ink,
    required this.inkMuted,
    required this.outline,
    required this.shadow,
    required this.error,
  });

  final Color primary;
  final Color primaryPressed;
  final Color secondary;
  final Color secondaryPressed;
  final Color accentText;
  final Color mascotAccent;
  final Color surface;
  final Color surfaceCard;
  final Color ink;
  final Color inkMuted;
  final Color outline;
  final Color shadow;
  final Color error;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FaithPalette &&
          runtimeType == other.runtimeType &&
          primary == other.primary &&
          primaryPressed == other.primaryPressed &&
          secondary == other.secondary &&
          secondaryPressed == other.secondaryPressed &&
          accentText == other.accentText &&
          mascotAccent == other.mascotAccent &&
          surface == other.surface &&
          surfaceCard == other.surfaceCard &&
          ink == other.ink &&
          inkMuted == other.inkMuted &&
          outline == other.outline &&
          shadow == other.shadow &&
          error == other.error;

  @override
  int get hashCode => Object.hash(
    primary,
    primaryPressed,
    secondary,
    secondaryPressed,
    accentText,
    mascotAccent,
    surface,
    surfaceCard,
    ink,
    inkMuted,
    outline,
    shadow,
    error,
  );

  static FaithPalette of(FaithId faith, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return switch (faith) {
      FaithId.islam => isDark ? _islamDark : _islamLight,
      FaithId.hindu => isDark ? _hinduDark : _hinduLight,
    };
  }

  // Shared neutrals
  static const _surfaceLight = Color(0xFFFFF9F0);
  static const _surfaceCardLight = Color(0xFFFFFFFF);
  static const _inkLight = Color(0xFF1A1A1A);
  static const _inkMutedLight = Color(0xFF6B6A66);
  static const _outlineLight = Color(0xFF1A1A1A);
  static const _shadowLight = Color(0xFF1A1A1A);

  static const _surfaceDark = Color(0xFF151515);
  static const _surfaceCardDark = Color(0xFF1F1F1F);
  static const _inkDark = Color(0xFFF5F5F0);
  static const _inkMutedDark = Color(0xFFA8A8A2);
  static const _outlineDark = Color(0xFF3A3A3A);
  static const _shadowDark = Color(0xFF0A0A0A);
  static const _errorShared = Color(0xFFFF4B4B);

  static const _islamLight = FaithPalette(
    primary: Color(0xFF00B87A),
    primaryPressed: Color(0xFF00935F),
    secondary: Color(0xFFFFC93C),
    secondaryPressed: Color(0xFFE0AC1F),
    accentText: Color(0xFF876200), // 5.3:1 vs surface — same hue as secondary
    mascotAccent: Color(0xFFFFC93C),
    surface: _surfaceLight,
    surfaceCard: _surfaceCardLight,
    ink: _inkLight,
    inkMuted: _inkMutedLight,
    outline: _outlineLight,
    shadow: _shadowLight,
    error: _errorShared,
  );

  static const _islamDark = FaithPalette(
    primary: Color(0xFF1BD696),
    primaryPressed: Color(0xFF14A876),
    secondary: Color(0xFFFFD666),
    secondaryPressed: Color(0xFFE0B93E),
    accentText: Color(0xFFFFD666), // already 11.8-13.1:1 vs dark surfaces
    mascotAccent: Color(0xFFFFD666),
    surface: _surfaceDark,
    surfaceCard: _surfaceCardDark,
    ink: _inkDark,
    inkMuted: _inkMutedDark,
    outline: _outlineDark,
    shadow: _shadowDark,
    error: _errorShared,
  );

  static const _hinduLight = FaithPalette(
    primary: Color(0xFFFF6B3D),
    primaryPressed: Color(0xFFE0532A),
    secondary: Color(0xFFFFB000),
    secondaryPressed: Color(0xFFD99400),
    accentText: Color(0xFF8C6100), // 5.25:1 vs surface — same hue as secondary
    mascotAccent: Color(0xFFFFD23F),
    surface: _surfaceLight,
    surfaceCard: _surfaceCardLight,
    ink: _inkLight,
    inkMuted: _inkMutedLight,
    outline: _outlineLight,
    shadow: _shadowLight,
    error: _errorShared,
  );

  static const _hinduDark = FaithPalette(
    primary: Color(0xFFFF8A5C),
    primaryPressed: Color(0xFFE06C3D),
    secondary: Color(0xFFFFC94D),
    secondaryPressed: Color(0xFFE0AA2E),
    accentText: Color(0xFFFFC94D), // already 11.9:1 vs dark surfaces
    mascotAccent: Color(0xFFFFD23F),
    surface: _surfaceDark,
    surfaceCard: _surfaceCardDark,
    ink: _inkDark,
    inkMuted: _inkMutedDark,
    outline: _outlineDark,
    shadow: _shadowDark,
    error: _errorShared,
  );
}
