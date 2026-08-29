import 'package:flutter/material.dart';

import '../../core/theme/faith_theme_extension.dart';

/// Wraps a Material glyph in a colored circular badge with a thick outline
/// — gives stock iconography a "poppy" read without custom icon authoring.
///
/// [foreground] defaults to the palette's brand-colored primary on the
/// default tinted badge (see the accepted contrast limitation noted below).
/// If a caller supplies a custom, opaque [background] but leaves
/// [foreground] unset, the glyph color auto-corrects to whichever of the
/// brand color or a high-contrast neutral (near-black / white) actually
/// reads legibly against that background, instead of blindly defaulting to
/// [FaithPalette.primary] — which, on a `background: palette.primary` badge,
/// would make the icon disappear entirely.
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
    // Default state (tinted badge + brand-colored glyph) measures ~2.1-2.4:1
    // contrast in light mode — below WCAG 1.4.11's 3:1 non-text guideline —
    // because the tint and glyph share the same hue. Accepted as a minor,
    // non-blocking limitation: shape/silhouette reads via hue+chroma
    // separation, and every current usage pairs the icon with adjacent text.
    final resolvedBackground = background ?? palette.primary.withValues(alpha: 0.16);
    final resolvedForeground = foreground ??
        (background != null
            ? _bestContrastColor(palette.primary, resolvedBackground)
            : palette.primary);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: resolvedBackground,
        shape: BoxShape.circle,
        border: Border.all(color: palette.outline, width: 2),
      ),
      alignment: Alignment.center,
      child: Icon(
        icon,
        size: size * 0.5,
        color: resolvedForeground,
      ),
    );
  }

  /// Keeps [candidate] (the brand color) if it already contrasts acceptably
  /// against [background]; otherwise falls back to whichever of near-black
  /// or white contrasts best. Mirrors `AppTheme._onColorFor`'s WCAG
  /// luminance-ratio approach, using the 3.0 non-text threshold (WCAG
  /// 1.4.11) rather than the 4.5 text threshold, since this is an icon glyph.
  static Color _bestContrastColor(Color candidate, Color background) {
    const darkText = Color(0xFF1A1A1A);
    const lightText = Colors.white;
    double contrast(Color a, Color b) {
      final l1 = a.computeLuminance() + 0.05;
      final l2 = b.computeLuminance() + 0.05;
      return l1 > l2 ? l1 / l2 : l2 / l1;
    }

    if (contrast(candidate, background) >= 3.0) return candidate;
    return contrast(darkText, background) >= contrast(lightText, background)
        ? darkText
        : lightText;
  }
}
