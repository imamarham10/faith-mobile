import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../domain/today_dashboard.dart';

/// The day's acts, ticked. Five prayers under Islam, three sandhya under
/// Hindu.
///
/// Nothing here is self-reported: every cell deep-links to the screen that
/// actually completes the act and logs it, which is why a tap navigates
/// rather than toggling.
class PracticeChecklist extends StatelessWidget {
  const PracticeChecklist({super.key, required this.items});

  final List<ChecklistItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return PoppyCard(
      radius: AppRadius.lg,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.md,
      ),
      onTap: () {
        HapticFeedback.lightImpact();
        context.push(items.first.route);
      },
      child: Row(
        children: [
          for (final item in items) Expanded(child: _Cell(item: item)),
        ],
      ),
    );
  }
}

/// Stacked, not inline.
///
/// At 320px the card has ~264 logical pixels of content width; five inline
/// `✓ Maghrib` cells cannot fit there, and making the row scroll would hide
/// state the whole point of this strip is to show. Stacking the glyph above
/// a small label fits five cells in 52px each with room to spare.
class _Cell extends StatelessWidget {
  const _Cell({required this.item});

  final ChecklistItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.extension<FaithThemeExtension>()!.palette;
    final done = item.done;

    return Semantics(
      label: '${item.label}, ${done ? 'logged' : 'not yet logged'}',
      excludeSemantics: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            done ? Icons.check_circle : Icons.circle_outlined,
            size: 22,
            color: done ? palette.primary : palette.inkMuted,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            item.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelSmall?.copyWith(
              color: done ? palette.ink : palette.inkMuted,
              fontWeight: done ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
