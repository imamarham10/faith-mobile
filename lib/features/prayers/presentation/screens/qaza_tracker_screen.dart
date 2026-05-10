import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/section_label.dart';
import '../../data/dtos/prayer_stats.dart';
import '../controllers/prayer_log_controller.dart';

/// Qaza counts at a glance. Each prayer row supports incrementing (which
/// `POST`s a `qada` log to the backend).
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
        Container(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [cs.surface, cs.primaryContainer.withValues(alpha: 0.5)],
            ),
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(color: cs.outline),
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
              onIncrement: () async {
                HapticFeedback.mediumImpact();
                try {
                  await ref
                      .read(prayerStatsControllerProvider.notifier)
                      .incrementQada(p.key);
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Couldn\'t update: $e')),
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _QazaRow extends StatelessWidget {
  const _QazaRow({
    required this.label,
    required this.count,
    required this.onIncrement,
  });

  final String label;
  final int count;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.base,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Row(
        children: [
          Expanded(child: Text(label, style: theme.textTheme.titleMedium)),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            transitionBuilder: (child, anim) =>
                FadeTransition(opacity: anim, child: child),
            child: Text(
              '$count',
              key: ValueKey<int>(count),
              style: theme.textTheme.displaySmall?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          const Gap.h(AppSpacing.base),
          _IconCircleButton(
            icon: Icons.add,
            tooltip: 'Add one qaḍāʾ',
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
  final VoidCallback onPressed;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Tooltip(
      message: tooltip,
      child: SizedBox(
        width: 44,
        height: 44,
        child: Material(
          color: theme.colorScheme.primaryContainer,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onPressed,
            child: Icon(icon, color: theme.colorScheme.primary, size: 22),
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
        Center(
          child: FilledButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              onRetry();
            },
            child: const Text('Try again'),
          ),
        ),
      ],
    );
  }
}
