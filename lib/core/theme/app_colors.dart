import 'package:flutter/material.dart';

/// Brand color tokens.
///
/// Light palette evokes an illuminated manuscript;
/// dark palette evokes pre-dawn / night reading.
class AppColors {
  const AppColors._();

  // Light — illuminated manuscript
  static const parchment = Color(0xFFFAF7F2);
  static const parchmentRaised = Color(0xFFFFFDF8);
  static const ink = Color(0xFF1C1B17);
  static const inkMuted = Color(0xFF6B6A63);
  static const inkSubtle = Color(0xFFA09E96);
  static const sage = Color(0xFF5C7457);
  static const sageSoft = Color(0xFFE8EDE5);
  static const gold = Color(0xFFB89968);
  static const goldSoft = Color(0xFFF3EBD9);
  static const line = Color(0xFFE8E2D6);

  // Dark — pre-dawn / night reading
  static const night = Color(0xFF0B0B0C);
  static const nightSurface = Color(0xFF161617);
  static const nightSurfaceHigh = Color(0xFF1F1F21);
  static const nightLine = Color(0xFF26262A);
  static const moonlight = Color(0xFFEFEAE0);
  static const moonMuted = Color(0xFF8A8780);
  static const moonSubtle = Color(0xFF54534D);
  static const sageNight = Color(0xFF7A8E73);
  static const goldNight = Color(0xFFD4B47A);

  // Soft accent surfaces used by tinted cards.
  static const sageNightSoft = Color(0xFF1C2620);
  static const goldNightSoft = Color(0xFF2A2418);
}
