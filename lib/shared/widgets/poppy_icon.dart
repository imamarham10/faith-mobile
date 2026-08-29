import 'package:flutter/material.dart';

import '../../core/theme/faith_theme_extension.dart';

/// Wraps a Material glyph in a colored circular badge with a thick outline
/// — gives stock iconography a "poppy" read without custom icon authoring.
class PoppyIcon extends StatelessWidget {
  const PoppyIcon({
    super.key,
    required this.icon,
    this.size = 44,
    this.background,
    this.foreground,
  });

  final IconData icon;
  final double size;
  final Color? background;
  final Color? foreground;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).extension<FaithThemeExtension>()!.palette;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background ?? palette.primary.withValues(alpha: 0.16),
        shape: BoxShape.circle,
        border: Border.all(color: palette.outline, width: 2),
      ),
      alignment: Alignment.center,
      child: Icon(
        icon,
        size: size * 0.5,
        color: foreground ?? palette.primary,
      ),
    );
  }
}
