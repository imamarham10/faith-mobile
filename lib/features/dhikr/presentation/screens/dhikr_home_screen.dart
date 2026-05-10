import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/section_label.dart';
import '../../data/dtos/dhikr_counter.dart';
import '../../data/dtos/dhikr_phrase.dart';
import '../controllers/dhikr_counters_controller.dart';
import '../widgets/dhikr_counter_tile.dart';
import '../widgets/dictionary_picker.dart';
import 'new_counter_sheet.dart';

/// Dhikr home — your counters, suggested phrases, and links to Goals + History.
class DhikrHomeScreen extends ConsumerWidget {
  const DhikrHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final countersAsync = ref.watch(dhikrCountersControllerProvider);

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
        title: const Text('Dhikr'),
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
              ref.read(dhikrCountersControllerProvider.notifier).refresh(),
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
                      Text(
                        'Tend your dhikr',
                        style: theme.textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Counters, goals, and quiet returns.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              countersAsync.when(
                loading: () => const _LoadingSliver(),
                error: (e, _) => _ErrorSliver(
                  message: e.toString(),
                  onRetry: () => ref
                      .read(dhikrCountersControllerProvider.notifier)
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
    final phrase = await showModalBottomSheet<DhikrPhrase>(
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
          .read(dhikrCountersControllerProvider.notifier)
          .createFromPhrase(phrase);
      await HapticFeedback.mediumImpact();
      if (!context.mounted) return;
      context.push('/practice/dhikr/counter/${created.id}');
    } on Object catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Couldn\'t add counter: $e')),
      );
    }
  }
}

class _ContentSlivers extends ConsumerWidget {
  const _ContentSlivers({required this.counters, required this.onOpenNew});

  final List<DhikrCounter> counters;
  final VoidCallback onOpenNew;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final suggested = ref.watch(suggestedPhrasesProvider);

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
              DhikrCounterTile(
                counter: c,
                onTap: () => context.push('/practice/dhikr/counter/${c.id}'),
              ),
              const Gap(10),
            ],
          ],
          const Gap(12),
          if (suggested.isNotEmpty) ...[
            const SectionLabel('Suggested'),
            const Gap(12),
            for (final p in suggested.take(5)) ...[
              DictionaryPicker(
                phrase: p,
                onTap: () => _quickAdd(context, ref, p),
              ),
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
                  onTap: () => context.push('/practice/dhikr/goals'),
                ),
              ),
              const Gap(12),
              Expanded(
                child: _SecondaryButton(
                  icon: Icons.history,
                  label: 'History',
                  onTap: () => context.push('/practice/dhikr/history'),
                ),
              ),
            ],
          ),
          const Gap(24),
          Center(
            child: Text(
              '“The remembrance of Allah is greatest.”',
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
    DhikrPhrase phrase,
  ) async {
    HapticFeedback.lightImpact();
    try {
      final created = await ref
          .read(dhikrCountersControllerProvider.notifier)
          .createFromPhrase(phrase);
      await HapticFeedback.mediumImpact();
      if (!context.mounted) return;
      context.push('/practice/dhikr/counter/${created.id}');
    } on Object catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Couldn\'t add counter: $e')),
      );
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
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xl,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: cs.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.fingerprint, size: 28, color: cs.primary),
          const Gap(12),
          Text('Begin a remembrance', style: theme.textTheme.titleLarge),
          const Gap(4),
          Text(
            'Create your first counter from a known phrase or your own.',
            style: theme.textTheme.bodyMedium,
          ),
          const Gap(16),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
            onPressed: onCreate,
            icon: const Icon(Icons.add),
            label: const Text('New counter'),
          ),
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
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.md),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: cs.outline),
          ),
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Column(
            children: [
              Icon(icon, size: 22, color: cs.onSurface),
              const Gap(6),
              Text(label, style: theme.textTheme.labelLarge),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadingSliver extends StatelessWidget {
  const _LoadingSliver();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
      sliver: SliverList.list(
        children: [
          for (var i = 0; i < 3; i++) ...[
            Shimmer.fromColors(
              baseColor: cs.surface,
              highlightColor: cs.outline.withValues(alpha: 0.4),
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: cs.outline),
                  color: cs.surface,
                ),
              ),
            ),
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
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: theme.colorScheme.outline),
          ),
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
              TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
