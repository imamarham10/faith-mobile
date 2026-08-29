import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/theme/faith_theme_extension.dart';

/// Loading-state placeholder matching [PoppyCard]'s exact shape: same
/// default border radius (24), same thick outline (`cardOutlineWidth`/
/// `palette.outline`), but with a `Shimmer.fromColors` fill instead of a
/// flat color.
///
/// Replaces the hand-rolled `Container(decoration: BoxDecoration(...))`
/// skeletons that used to be duplicated (and drifted from each other) across
/// Today's cards — e.g. one had a border, the other didn't, both hardcoded
/// their own radius. Callers pass [height] (and, for hero cards like
/// `PrayerCountdownCard`, a non-default [radius]) to match the real
/// [PoppyCard] they're standing in for.
///
/// The outline is painted by the *outer* box, with the shimmering fill
/// clipped and inset by [FaithThemeExtension.cardOutlineWidth] so the border
/// itself reads as a solid ring rather than shimmering along with the fill.
class PoppySkeleton extends StatelessWidget {
  const PoppySkeleton({
    super.key,
    required this.height,
    this.radius = 24, // PoppyCard's own default.
    this.padding,
  });

  final double height;
  final double radius;

  /// Optional outer inset, for callers that need this skeleton to occupy
  /// the same footprint as a [PoppyCard] that has external spacing around
  /// it (rather than sizing [height] to include that spacing themselves).
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<FaithThemeExtension>()!;
    final palette = ext.palette;
    final innerRadius = (radius - ext.cardOutlineWidth).clamp(0.0, radius);

    final skeleton = Container(
      height: height,
      padding: EdgeInsets.all(ext.cardOutlineWidth),
      decoration: BoxDecoration(
        color: palette.surfaceCard,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: palette.outline, width: ext.cardOutlineWidth),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(innerRadius),
        child: Shimmer.fromColors(
          baseColor: palette.surfaceCard,
          highlightColor: palette.outline.withValues(alpha: 0.15),
          child: Container(color: palette.surfaceCard),
        ),
      ),
    );

    return padding == null ? skeleton : Padding(padding: padding!, child: skeleton);
  }
}
