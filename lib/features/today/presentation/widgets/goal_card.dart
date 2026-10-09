import 'package:flutter/material.dart';

import '../../../../core/theme/app_motion.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../../../shared/widgets/gap.dart';
import '../../domain/today_dashboard.dart';

/// "Today's goal — 1 / 5 prayers", with a bar.
///
/// The number carries a real unit, never a synthetic currency. Points exist
/// in the design only so a cross-activity leaderboard is possible; they are
/// never what a user is shown.
class GoalCard extends StatelessWidget {
  const GoalCard({super.key, required this.goal});

  final GoalProgress goal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.extension<FaithThemeExtension>()!.palette;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                "TODAY'S GOAL",
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            if (goal.isComplete)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, size: 16, color: palette.primary),
                  const Gap.h(AppSpacing.xs),
                  Text(
                    'Complete',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: palette.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
          ],
        ),
        const Gap(AppSpacing.sm),
        // RichText so the count reads as one phrase to a screen reader
        // instead of three separate nodes.
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '${goal.done}',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: goal.done > 0 ? palette.ink : palette.inkMuted,
                ),
              ),
              TextSpan(
                text: ' / ${goal.target} ${goal.unit}',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: palette.inkMuted,
                ),
              ),
            ],
          ),
        ),
        const Gap(AppSpacing.md),
        _GoalBar(fraction: goal.fraction),
      ],
    );
  }
}

class _GoalBar extends StatelessWidget {
  const _GoalBar({required this.fraction});

  final double fraction;

  static const double _height = 12;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<FaithThemeExtension>()!;
    final palette = ext.palette;

    return Semantics(
      value: '${(fraction * 100).round()}%',
      child: Container(
        height: _height,
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(color: palette.outline, width: 2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          child: Align(
            alignment: Alignment.centerLeft,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return TweenAnimationBuilder<double>(
                  tween: Tween<double>(end: fraction),
                  duration: AppMotion.cardSpringBack,
                  curve: AppMotion.enterCurve,
                  builder: (context, value, _) => Container(
                    width: constraints.maxWidth * value,
                    color: palette.primary,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
