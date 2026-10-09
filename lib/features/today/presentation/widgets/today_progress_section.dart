import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/poppy_button.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../../../shared/widgets/poppy_skeleton.dart';
import '../../domain/today_dashboard.dart';
import '../controllers/today_dashboard_controller.dart';
import 'goal_card.dart';
import 'practice_checklist.dart';
import 'stat_tile_row.dart';
import 'week_strip.dart';

/// The habit loop, made visible: week strip, today's goal, the checklist of
/// acts that complete it, and the stat tiles.
///
/// Built **once** for both faiths. Everything faith-specific — five prayers
/// or three sandhya, dhikr or japa, which route a row deep-links to — comes
/// through [TodayDashboard] from the controller, and every colour comes from
/// the active [FaithPalette] via the theme. There is no Islam copy of this
/// widget and no Hindu one, which is what keeps the two from drifting.
class TodayProgressSection extends ConsumerWidget {
  const TodayProgressSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(todayDashboardProvider);
    return async.when(
      loading: () => const _Skeleton(),
      error: (_, __) => _ErrorCard(
        onRetry: () {
          HapticFeedback.heavyImpact();
          ref.invalidate(todayDashboardProvider);
        },
      ),
      data: (dashboard) => _Content(dashboard: dashboard),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.dashboard});

  final TodayDashboard dashboard;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WeekStrip(week: dashboard.week),
        const Gap(AppSpacing.xl),
        PoppyCard(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: GoalCard(goal: dashboard.goal),
        ),
        const Gap(AppSpacing.md),
        PracticeChecklist(items: dashboard.checklist),
        const Gap(AppSpacing.xl),
        StatTileRow(stats: dashboard.stats, streak: dashboard.streak),
      ],
    );
  }
}

class _Skeleton extends StatelessWidget {
  const _Skeleton();

  @override
  Widget build(BuildContext context) {
    // Roughly the silhouette of the loaded section — strip, goal card,
    // checklist, tiles — so nothing jumps when the numbers arrive.
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PoppySkeleton(height: 44, radius: AppRadius.pill),
        Gap(AppSpacing.xl),
        PoppySkeleton(height: 120),
        Gap(AppSpacing.md),
        PoppySkeleton(height: 64, radius: AppRadius.lg),
        Gap(AppSpacing.xl),
        PoppySkeleton(height: 84, radius: AppRadius.lg),
      ],
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PoppyCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.cloud_off_outlined,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const Gap(AppSpacing.sm),
          Text(
            "Couldn't load your progress.",
            style: theme.textTheme.bodyLarge,
          ),
          const Gap(AppSpacing.md),
          PoppyButton(label: 'Try again', onPressed: onRetry),
        ],
      ),
    );
  }
}
