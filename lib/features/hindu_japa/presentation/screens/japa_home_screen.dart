import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/poppy_button.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../../../shared/widgets/poppy_skeleton.dart';
import '../../../../shared/widgets/section_label.dart';
import '../../../../shared/widgets/stat_chip.dart';
import '../../data/dtos/japa_counter.dart';
import '../../data/dtos/japa_phrase.dart';
import '../controllers/japa_counters_controller.dart';
import '../controllers/japa_stats_controller.dart';
import '../widgets/japa_counter_tile.dart';
import '../widgets/mantra_picker.dart';
import 'new_counter_sheet.dart';

/// Japa home — your counters, suggested mantras, streaks, and links to
/// Goals + History. Mirrors `DhikrHomeScreen` structurally.
class JapaHomeScreen extends ConsumerWidget {
  const JapaHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final countersAsync = ref.watch(japaCountersControllerProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            HapticFeedback.lightImpact();
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/practice');
            }
          },
        ),
        title: const Text('Japa'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openNewSheet(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('New'),
      ),
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () =>
              ref.read(japaCountersControllerProvider.notifier).refresh(),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenEdge,
                  AppSpacing.sm,
                  AppSpacing.screenEdge,
                  AppSpacing.lg,
                ),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tend your japa', style: theme.textTheme.headlineMedium),
                      const SizedBox(height: 4),
                      Text(
                        'Counters, goals, and quiet returns.',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const Gap(AppSpacing.base),
                      const _StatsRow(),
                    ],
                  ),
                ),
              ),
              countersAsync.when(
                loading: () => const _LoadingSliver(),
                error: (e, _) => _ErrorSliver(
                  message: e.toString(),
                  onRetry: () => ref
                      .read(japaCountersControllerProvider.notifier)
                      .refresh(),
                ),
                data: (counters) => _ContentSlivers(
                  counters: counters,
                  onOpenNew: () => _openNewSheet(context, ref),
                ),
              ),
              const SliverToBoxAdapter(child: Gap(96)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openNewSheet(BuildContext context, WidgetRef ref) async {
    HapticFeedback.lightImpact();
    final phrase = await showModalBottomSheet<JapaPhrase>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (_) => const NewCounterSheet(),
    );
    if (phrase == null) return;
    try {
      final created = await ref
          .read(japaCountersControllerProvider.notifier)
          .createFromPhrase(phrase);
      await HapticFeedback.mediumImpact();
      if (!context.mounted) return;
      context.push('/practice/japa/counter/${created.id}');
    } on Object catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Couldn\'t add counter: $e')));
    }
  }
}

class _StatsRow extends ConsumerWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(japaStatsProvider);
    return async.when(
      data: (stats) {
        if (stats.totalCount == 0) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(top: AppSpacing.sm),
          child: Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              StatChip(
                value: '${stats.currentStreak}',
                label: 'day streak',
                icon: Icons.local_fire_department_outlined,
              ),
              StatChip(
                value: '${stats.totalCount}',
                label: 'total',
                icon: Icons.all_inclusive,
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _ContentSlivers extends ConsumerWidget {
  const _ContentSlivers({required this.counters, required this.onOpenNew});

  final List<JapaCounter> counters;
  final VoidCallback onOpenNew;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final suggested = ref.watch(suggestedJapaPhrasesProvider);

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
      sliver: SliverList.list(
        children: [
          if (counters.isEmpty)
            _EmptyCounters(onCreate: onOpenNew)
          else ...[
            const SectionLabel('Your counters'),
            const Gap(12),
            for (final c in counters) ...[
              JapaCounterTile(
                counter: c,
                onTap: () => context.push('/practice/japa/counter/${c.id}'),
              ),
              const Gap(10),
            ],
          ],
          const Gap(12),
          if (suggested.isNotEmpty) ...[
            const SectionLabel('Suggested'),
            const Gap(12),
            for (final p in suggested.take(5)) ...[
              MantraPicker(phrase: p, onTap: () => _quickAdd(context, ref, p)),
              const Gap(8),
            ],
          ],
          const Gap(28),
          Row(
            children: [
              Expanded(
                child: _SecondaryButton(
                  icon: Icons.flag_outlined,
                  label: 'Goals',
                  onTap: () => context.push('/practice/japa/goals'),
                ),
              ),
              const Gap(12),
              Expanded(
                child: _SecondaryButton(
                  icon: Icons.history,
                  label: 'History',
                  onTap: () => context.push('/practice/japa/history'),
                ),
              ),
            ],
          ),
          const Gap(24),
          Center(
            child: Text(
              '"Repetition of the divine name purifies the mind."',
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _quickAdd(
    BuildContext context,
    WidgetRef ref,
    JapaPhrase phrase,
  ) async {
    HapticFeedback.lightImpact();
    try {
      final created = await ref
          .read(japaCountersControllerProvider.notifier)
          .createFromPhrase(phrase);
      await HapticFeedback.mediumImpact();
      if (!context.mounted) return;
      context.push('/practice/japa/counter/${created.id}');
    } on Object catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Couldn\'t add counter: $e')));
    }
  }
}

class _EmptyCounters extends StatelessWidget {
  const _EmptyCounters({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return PoppyCard(
      radius: AppRadius.lg,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.self_improvement, size: 28, color: cs.primary),
          const Gap(12),
          Text('Begin a japa', style: theme.textTheme.titleLarge),
          const Gap(4),
          Text(
            'Create your first counter from a known mantra or your own.',
            style: theme.textTheme.bodyMedium,
          ),
          const Gap(16),
          PoppyButton(label: 'New counter', icon: Icons.add, onPressed: onCreate),
        ],
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return PoppyCard(
      radius: AppRadius.md,
      padding: const EdgeInsets.symmetric(vertical: 18),
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Column(
        children: [
          Icon(icon, size: 22, color: cs.onSurface),
          const Gap(6),
          Text(label, style: theme.textTheme.labelLarge),
        ],
      ),
    );
  }
}

class _LoadingSliver extends StatelessWidget {
  const _LoadingSliver();

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
      sliver: SliverList.list(
        children: [
          for (var i = 0; i < 3; i++) ...[
            const PoppySkeleton(height: 100, radius: AppRadius.lg),
            const Gap(10),
          ],
        ],
      ),
    );
  }
}

class _ErrorSliver extends StatelessWidget {
  const _ErrorSliver({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
      sliver: SliverToBoxAdapter(
        child: PoppyCard(
          radius: AppRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Couldn\'t load your counters',
                style: theme.textTheme.titleMedium,
              ),
              const Gap(6),
              Text(message, style: theme.textTheme.bodySmall),
              const Gap(12),
              PoppyButton(label: 'Try again', onPressed: onRetry),
            ],
          ),
        ),
      ),
    );
  }
}
