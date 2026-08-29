import 'package:flutter/material.dart';

import 'faith_id.dart';
import 'faith_palette.dart';

/// Carries faith-aware tokens that don't fit [ColorScheme]/[TextTheme]:
/// which faith is active (so widgets can branch content/mascot without a
/// separate Riverpod read), the full [FaithPalette] (for shadow/pressed
/// states the default ColorScheme doesn't model), and shared motion timings.
///
/// Access via `Theme.of(context).extension<FaithThemeExtension>()!`.
class FaithThemeExtension extends ThemeExtension<FaithThemeExtension> {
  const FaithThemeExtension({
    required this.faithId,
    required this.palette,
    required this.cardOutlineWidth,
    required this.pressDuration,
    required this.pressOffset,
  });

  final FaithId faithId;
  final FaithPalette palette;
  final double cardOutlineWidth;
  final Duration pressDuration;
  final double pressOffset;

  factory FaithThemeExtension.of(FaithId faithId, FaithPalette palette) =>
      FaithThemeExtension(
        faithId: faithId,
        palette: palette,
        cardOutlineWidth: 2.5,
        pressDuration: const Duration(milliseconds: 100),
        pressOffset: 4,
      );

  @override
  FaithThemeExtension copyWith({
    FaithId? faithId,
    FaithPalette? palette,
    double? cardOutlineWidth,
    Duration? pressDuration,
    double? pressOffset,
  }) => FaithThemeExtension(
    faithId: faithId ?? this.faithId,
    palette: palette ?? this.palette,
    cardOutlineWidth: cardOutlineWidth ?? this.cardOutlineWidth,
    pressDuration: pressDuration ?? this.pressDuration,
    pressOffset: pressOffset ?? this.pressOffset,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FaithThemeExtension &&
          runtimeType == other.runtimeType &&
          faithId == other.faithId &&
          palette == other.palette &&
          cardOutlineWidth == other.cardOutlineWidth &&
          pressDuration == other.pressDuration &&
          pressOffset == other.pressOffset;

  @override
  int get hashCode => Object.hash(
    faithId,
    palette,
    cardOutlineWidth,
    pressDuration,
    pressOffset,
  );

  @override
  FaithThemeExtension lerp(
    covariant ThemeExtension<FaithThemeExtension>? other,
    double t,
  ) {
    if (other is! FaithThemeExtension) return this;
    // faithId/palette are a hard identity switch, not a gradient — snap at
    // the midpoint rather than trying to blend two religions' colors.
    return t < 0.5 ? this : other;
  }
}
