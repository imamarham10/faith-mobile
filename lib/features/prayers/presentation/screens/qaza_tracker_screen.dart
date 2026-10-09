import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/poppy_button.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../../../shared/widgets/section_label.dart';
import '../../../../shared/widgets/stat_chip.dart';
import '../../data/dtos/prayer_stats.dart';
import '../controllers/prayer_log_controller.dart';

/// Qaza counts at a glance. Each prayer row can be adjusted in both
/// directions, which `POST`s to the standalone `/qada/increment` and
/// `/qada/decrement` tallies — never a `qada` prayer log, which would upsert
/// over today's row for that prayer.
///
/// Both directions matter. A counter that only climbs makes a mis-tap
/// permanent, and a debt the user cannot clear is a reason to stop opening
/// the screen.
class QazaTrackerScreen extends ConsumerWidget {
  const QazaTrackerScreen({super.key});

  static const _prayers = <({String key, String label})>[
    (key: 'fajr', label: 'Fajr'),
    (key: 'dhuhr', label: 'Dhuhr'),
    (key: 'asr', label: 'ʿAṣr'),
    (key: 'maghrib', label: 'Maghrib'),
    (key: 'isha', label: 'ʿIshā'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final statsAsync = ref.watch(prayerStatsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () {
            HapticFeedback.lightImpact();
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/today/prayers');
            }
          },
        ),
        title: Text('Qaḍāʾ', style: theme.textTheme.titleLarge),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(prayerStatsControllerProvider);
          await ref.read(prayerStatsControllerProvider.future);
        },
        child: statsAsync.when(
          loading: () => const _LoadingShimmer(),
          error: (e, _) => _ErrorView(
            message: e.toString(),
            onRetry: () => ref.invalidate(prayerStatsControllerProvider),
          ),
          data: (stats) => _Content(stats: stats, prayers: _prayers),
        ),
      ),
    );
  }
}

class _Content extends ConsumerWidget {
  const _Content({required this.stats, required this.prayers});

  final PrayerStats stats;
  final List<({String key, String label})> prayers;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return ListView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenEdge,
        AppSpacing.lg,
        AppSpacing.screenEdge,
        AppSpacing.xxl,
      ),
      children: [
        PoppyCard(
          radius: AppRadius.xl,
          color: cs.primaryContainer,
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total qaḍāʾ',
                style: theme.textTheme.labelSmall?.copyWith(color: cs.primary),
              ),
              const Gap(AppSpacing.sm),
              Text('${stats.totalQaza}', style: theme.textTheme.displayLarge),
              const Gap(AppSpacing.xs),
              Text(
                stats.totalQaza == 0
                    ? 'You\'re caught up. May Allah keep it that way.'
                    : 'Each one is a chance to return.',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        const Gap(AppSpacing.xl),
        const SectionLabel('By prayer'),
        const Gap(AppSpacing.md),
        ...prayers.map(
          (p) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: _QazaRow(
              label: p.label,
              count: stats.countFor(p.key),
              onIncrement: () => _adjust(
                context,
                ref,
                (c) => c.incrementQada(p.key),
                impact: HapticFeedback.mediumImpact,
              ),
              // Null disables the control, which is the client half of the
              // below-zero guard. The server clamps at zero regardless
              // (`prayers.service.ts`: `Math.max(0, count + by)`), so this
              // is an affordance, not the enforcement — it just stops a
              // guaranteed no-op round-trip and stops the button lying
              // about what it will do.
              onDecrement: stats.countFor(p.key) == 0
                  ? null
                  : () => _adjust(
                      context,
                      ref,
                      (c) => c.decrementQada(p.key),
                      impact: HapticFeedback.lightImpact,
                    ),
            ),
          ),
        ),
      ],
    );
  }

  /// Runs one tally adjustment, reporting failure in place.
  ///
  /// The controller restores the previous tally and rethrows, so the row the
  /// user was looking at stays on screen and only the snackbar changes.
  Future<void> _adjust(
    BuildContext context,
    WidgetRef ref,
    Future<void> Function(PrayerStatsController) call, {
    required void Function() impact,
  }) async {
    impact();
    try {
      await call(ref.read(prayerStatsControllerProvider.notifier));
    } catch (e) {
      if (!context.mounted) return;
      HapticFeedback.heavyImpact();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Couldn\'t update: $e')));
    }
  }
}

class _QazaRow extends StatelessWidget {
  const _QazaRow({
    required this.label,
    required this.count,
    required this.onIncrement,
    required this.onDecrement,
  });

  final String label;
  final int count;
  final VoidCallback onIncrement;

  /// `null` when the count is already zero — there is nothing to undo.
  final VoidCallback? onDecrement;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PoppyCard(
      radius: AppRadius.md,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.base,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Expanded(child: Text(label, style: theme.textTheme.titleMedium)),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            transitionBuilder: (child, anim) =>
                FadeTransition(opacity: anim, child: child),
            child: StatChip(
              key: ValueKey<int>(count),
              value: '$count',
              label: 'missed',
            ),
          ),
          const Gap.h(AppSpacing.base),
          _IconCircleButton(
            icon: Icons.remove,
            tooltip: count == 0
                ? 'No $label qaḍāʾ to remove'
                : 'Remove one $label qaḍāʾ',
            onPressed: onDecrement,
          ),
          const Gap.h(AppSpacing.sm),
          _IconCircleButton(
            icon: Icons.add,
            tooltip: 'Add one $label qaḍāʾ',
            onPressed: onIncrement,
          ),
        ],
      ),
    );
  }
}

class _IconCircleButton extends StatelessWidget {
  const _IconCircleButton({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
  });

  final IconData icon;

  /// `null` renders the button disabled rather than removing it, so the row
  /// does not reflow every time a count crosses zero.
  final VoidCallback? onPressed;

  final String tooltip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final enabled = onPressed != null;
    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        enabled: enabled,
        label: tooltip,
        child: SizedBox(
          // 44pt is the minimum comfortable tap target, and the two buttons
          // sit side by side — shrinking either would put them inside each
          // other's slop.
          width: 44,
          height: 44,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            opacity: enabled ? 1 : 0.38,
            child: Material(
              color: cs.primaryContainer,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onPressed,
                child: Icon(icon, color: cs.primary, size: 22),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoadingShimmer extends StatelessWidget {
  const _LoadingShimmer();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final base = theme.colorScheme.outline.withValues(alpha: 0.4);
    final highlight = theme.colorScheme.surface;
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenEdge,
        AppSpacing.lg,
        AppSpacing.screenEdge,
        AppSpacing.xxl,
      ),
      children: [
        Shimmer.fromColors(
          baseColor: base,
          highlightColor: highlight,
          child: Container(
            height: 160,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
          ),
        ),
        const Gap(AppSpacing.xl),
        for (var i = 0; i < 5; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Shimmer.fromColors(
              baseColor: base,
              highlightColor: highlight,
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
      children: [
        const Gap(120),
        Icon(
          Icons.cloud_off_outlined,
          size: 56,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const Gap(AppSpacing.base),
        Text(
          'Couldn\'t load qaḍāʾ stats',
          style: theme.textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const Gap(AppSpacing.xs),
        Text(
          message,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium,
        ),
        const Gap(AppSpacing.lg),
        PoppyButton(
          label: 'Try again',
          onPressed: () {
            HapticFeedback.lightImpact();
            onRetry();
          },
        ),
      ],
    );
  }
}
