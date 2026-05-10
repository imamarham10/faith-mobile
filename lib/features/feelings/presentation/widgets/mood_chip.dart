import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_radius.dart';

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
    final fg = selected ? cs.secondary : cs.onSurface;
    final border = selected ? cs.secondary.withValues(alpha: 0.5) : cs.outline;
    final bg = selected
        ? cs.secondaryContainer.withValues(alpha: 0.6)
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
