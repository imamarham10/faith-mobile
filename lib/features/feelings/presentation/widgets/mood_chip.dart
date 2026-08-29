import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/faith_theme_extension.dart';

/// A pill-shaped, tappable mood label.
///
/// Used in the bottom-sheet chooser, the result-screen badge, and history
/// rows. The `selected` state shifts colour to gold so a chosen mood feels
/// warm rather than active-blue.
class MoodChip extends StatelessWidget {
  const MoodChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.compact = false,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final palette = theme.extension<FaithThemeExtension>()!.palette;
    final fg = selected ? palette.accentText : cs.onSurface;
    final border = selected ? cs.secondary.withValues(alpha: 0.5) : cs.outline;
    // Note: `cs.secondaryContainer` is itself `secondary` at 16% alpha — an
    // earlier version of this chip called `.withValues(alpha: 0.6)` on that
    // ALREADY-translucent color, which overwrites (not multiplies) alpha
    // channels, silently jumping the fill from a 16% tint to a bold 60% one
    // and leaving `accentText` too low-contrast against it. Compute the tint
    // directly off `palette.secondary` instead, at an alpha verified to keep
    // `accentText` ≥4.5:1 for both faiths (0.20 → 4.66:1 hindu, the tighter
    // of the two — see the palette's accentText doc comment for the method).
    final bg = selected
        ? palette.secondary.withValues(alpha: 0.20)
        : Colors.transparent;

    final hPad = compact ? 14.0 : 20.0;
    final vPad = compact ? 8.0 : 12.0;

    final content = Container(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: border),
      ),
      child: Text(
        label,
        style:
            (compact ? theme.textTheme.labelLarge : theme.textTheme.titleMedium)
                ?.copyWith(color: fg),
      ),
    );

    if (onTap == null) return content;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        onTap: () {
          HapticFeedback.selectionClick();
          onTap!();
        },
        child: content,
      ),
    );
  }
}
