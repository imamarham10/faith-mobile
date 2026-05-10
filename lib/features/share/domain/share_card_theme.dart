import 'package:flutter/material.dart';

/// Soothing theme presets for share cards. All four are deliberately calm —
/// no high-contrast brand looks. Add more by appending to [kShareCardThemes].
class ShareCardTheme {
  const ShareCardTheme({
    required this.id,
    required this.label,
    required this.gradientStart,
    required this.gradientEnd,
    required this.textPrimary,
    required this.textSecondary,
    required this.accent,
    required this.brightness,
  });

  final String id;
  final String label;

  /// Top-left gradient stop.
  final Color gradientStart;

  /// Bottom-right gradient stop.
  final Color gradientEnd;

  /// Body text and main typography.
  final Color textPrimary;

  /// Eyebrow / attribution / muted UI.
  final Color textSecondary;

  /// Hairline divider + small ornaments.
  final Color accent;

  /// Drives status-bar tone for the preview screen so app chrome reads.
  final Brightness brightness;
}

/// Sage — moss green to soft mint. Muted, library-quiet.
const _sage = ShareCardTheme(
  id: 'sage',
  label: 'Sage',
  gradientStart: Color(0xFFE8EFE3),
  gradientEnd: Color(0xFFB8C9B5),
  textPrimary: Color(0xFF2C3A2C),
  textSecondary: Color(0xFF5C6E5C),
  accent: Color(0xFF7A8E73),
  brightness: Brightness.light,
);

/// Parchment — warm cream with deep brown ink. Reads like an old manuscript.
const _parchment = ShareCardTheme(
  id: 'parchment',
  label: 'Parchment',
  gradientStart: Color(0xFFF7EFDD),
  gradientEnd: Color(0xFFE8D9B8),
  textPrimary: Color(0xFF3B2A18),
  textSecondary: Color(0xFF6B563F),
  accent: Color(0xFFB08B5C),
  brightness: Brightness.light,
);

/// Dawn — soft peach to lavender. Hopeful, morning.
const _dawn = ShareCardTheme(
  id: 'dawn',
  label: 'Dawn',
  gradientStart: Color(0xFFFFE7DA),
  gradientEnd: Color(0xFFD9CDF0),
  textPrimary: Color(0xFF2A2C4A),
  textSecondary: Color(0xFF5C5E80),
  accent: Color(0xFFB089C9),
  brightness: Brightness.light,
);

/// Midnight — deep navy to muted indigo with soft gold. For evening reads.
const _midnight = ShareCardTheme(
  id: 'midnight',
  label: 'Midnight',
  gradientStart: Color(0xFF101A2C),
  gradientEnd: Color(0xFF1F2A45),
  textPrimary: Color(0xFFE9E2C6),
  textSecondary: Color(0xFF9A9580),
  accent: Color(0xFFC9A95F),
  brightness: Brightness.dark,
);

const List<ShareCardTheme> kShareCardThemes = [
  _sage,
  _parchment,
  _dawn,
  _midnight,
];

ShareCardTheme shareCardThemeById(String id) =>
    kShareCardThemes.firstWhere((t) => t.id == id, orElse: () => _sage);
