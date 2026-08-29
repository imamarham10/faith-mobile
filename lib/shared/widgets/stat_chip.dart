import 'package:flutter/material.dart';

import '../../core/theme/faith_theme_extension.dart';

/// Pill-shaped stat display — prayer/japa streaks, dhikr counts, reading
/// progress. Bold numeral first, small label second.
class StatChip extends StatelessWidget {
  const StatChip({
    super.key,
    required this.value,
    required this.label,
    this.icon,
  });

  final String value;
  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<FaithThemeExtension>()!;
    final palette = ext.palette;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: palette.secondary.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: palette.outline, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: palette.ink),
            const SizedBox(width: 6),
          ],
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 4),
          Text(label, style: theme.textTheme.labelMedium),
        ],
      ),
    );
  }
}
