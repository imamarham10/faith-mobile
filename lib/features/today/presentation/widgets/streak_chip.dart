import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../domain/practice_day.dart';
import '../controllers/today_dashboard_controller.dart';

/// The streak, in the header.
///
/// Renders **nothing** until a streak is actually known — while the read is
/// in flight, if it fails, and when the user has no run going. A zero and an
/// unknown are different things and neither is worth a chip; a `🔥 0` in the
/// header of a religious-practice app is a daily reminder of failure, which
/// is the opposite of what this is for.
///
/// Not tappable. The design makes this chip the entry point to Circle, but
/// Circle is Phase 3 and `/circle` is not a registered route — pushing an
/// unregistered route throws, and pointing it somewhere else would be worse
/// than inert.
class StreakChip extends ConsumerWidget {
  const StreakChip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streak = ref.watch(todayDashboardProvider).valueOrNull?.streak;
    if (streak == null || streak.days <= 0) return const SizedBox.shrink();
    return _Chip(streak: streak);
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.streak});

  final PracticeStreak streak;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.extension<FaithThemeExtension>()!.palette;
    final label = '${streak.days}${streak.isFloor ? '+' : ''}';

    return Semantics(
      label:
          '${streak.isFloor ? 'At least ' : ''}${streak.days} '
          'day${streak.days == 1 ? '' : 's'} in a row',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          // Recolours per faith from the tokens alone — marigold under
          // Hindu, amber under Islam — with no duplicated asset.
          color: palette.secondary,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(color: palette.outline, width: 2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.local_fire_department,
              size: 16,
              color: palette.ink,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: palette.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
