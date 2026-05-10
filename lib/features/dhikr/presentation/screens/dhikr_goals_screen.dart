import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/gap.dart';
import '../../data/dtos/dhikr_goal.dart';
import '../../data/dtos/dhikr_phrase.dart';
import '../controllers/dhikr_counters_controller.dart';
import '../controllers/dhikr_goals_controller.dart';

/// Dhikr goals — track running totals against a target over a period.
class DhikrGoalsScreen extends ConsumerWidget {
  const DhikrGoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final async = ref.watch(dhikrGoalsControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Goals')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openNewGoalSheet(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('New goal'),
      ),
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () =>
              ref.read(dhikrGoalsControllerProvider.notifier).refresh(),
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
                      Text('Goals', style: theme.textTheme.headlineMedium),
                      const Gap(4),
                      Text(
                        'Set targets, then return as you remember.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              async.when(
                loading: () => const _ShimmerSliver(),
                error: (e, _) => SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenEdge,
                    ),
                    child: _ErrorBlock(
                      message: e.toString(),
                      onRetry: () => ref
                          .read(dhikrGoalsControllerProvider.notifier)
                          .refresh(),
                    ),
                  ),
                ),
                data: (goals) {
                  if (goals.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.screenEdge,
                        ),
                        child: _EmptyGoals(
                          onCreate: () => _openNewGoalSheet(context, ref),
                        ),
                      ),
                    );
                  }
                  return SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screenEdge,
                      0,
                      AppSpacing.screenEdge,
                      96,
                    ),
                    sliver: SliverList.separated(
                      itemBuilder: (_, i) => _GoalTile(goal: goals[i]),
                      separatorBuilder: (_, __) => const Gap(10),
                      itemCount: goals.length,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openNewGoalSheet(BuildContext context, WidgetRef ref) async {
    HapticFeedback.lightImpact();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (_) => const _NewGoalSheet(),
    );
  }
}

class _GoalTile extends StatelessWidget {
  const _GoalTile({required this.goal});

  final DhikrGoal goal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final progress = goal.targetCount > 0
        ? (goal.currentCount / goal.targetCount).clamp(0.0, 1.0).toDouble()
        : 0.0;

    final phraseLabel = goal.phraseEnglish ?? goal.phraseArabic ?? 'Dhikr goal';
    final endLabel = goal.endDate != null
        ? 'until ${DateFormat.MMMd().format(goal.endDate!)}'
        : null;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: cs.outline),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(phraseLabel, style: theme.textTheme.titleMedium),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: cs.primaryContainer.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  border: Border.all(color: cs.outline),
                ),
                child: Text(
                  goal.period.label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: cs.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const Gap(12),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: cs.outline.withValues(alpha: 0.3),
              valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
            ),
          ),
          const Gap(8),
          Row(
            children: [
              Text(
                '${goal.currentCount} / ${goal.targetCount}',
                style: theme.textTheme.bodySmall,
              ),
              const Spacer(),
              if (endLabel != null)
                Text(endLabel, style: theme.textTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}

class _NewGoalSheet extends ConsumerStatefulWidget {
  const _NewGoalSheet();

  @override
  ConsumerState<_NewGoalSheet> createState() => _NewGoalSheetState();
}

class _NewGoalSheetState extends ConsumerState<_NewGoalSheet> {
  final _targetController = TextEditingController(text: '100');
  DhikrPhrase? _phrase;
  DhikrGoalPeriod _period = DhikrGoalPeriod.daily;
  bool _busy = false;

  @override
  void dispose() {
    _targetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dictionary =
        ref.watch(dhikrDictionaryProvider).valueOrNull ?? const <DhikrPhrase>[];
    final viewInsets = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screenEdge,
        0,
        AppSpacing.screenEdge,
        AppSpacing.lg + viewInsets,
      ),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Gap(4),
            Text('New goal', style: theme.textTheme.headlineMedium),
            const Gap(4),
            Text(
              'Pick a phrase, target, and period.',
              style: theme.textTheme.bodyMedium,
            ),
            const Gap(20),
            Text('Phrase', style: theme.textTheme.labelMedium),
            const Gap(8),
            if (dictionary.isEmpty)
              Text('Loading…', style: theme.textTheme.bodyMedium)
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final p in dictionary)
                    ChoiceChip(
                      label: Text(p.phraseTransliteration),
                      selected: _phrase?.id == p.id,
                      onSelected: (_) {
                        HapticFeedback.selectionClick();
                        setState(() {
                          _phrase = p;
                          _targetController.text = p.recommendedCount
                              .toString();
                        });
                      },
                    ),
                ],
              ),
            const Gap(16),
            Text('Period', style: theme.textTheme.labelMedium),
            const Gap(8),
            SegmentedButton<DhikrGoalPeriod>(
              segments: const [
                ButtonSegment(
                  value: DhikrGoalPeriod.daily,
                  label: Text('Daily'),
                ),
                ButtonSegment(
                  value: DhikrGoalPeriod.weekly,
                  label: Text('Weekly'),
                ),
                ButtonSegment(
                  value: DhikrGoalPeriod.monthly,
                  label: Text('Monthly'),
                ),
              ],
              selected: {_period},
              onSelectionChanged: (s) {
                HapticFeedback.selectionClick();
                setState(() => _period = s.first);
              },
            ),
            const Gap(16),
            Text('Target', style: theme.textTheme.labelMedium),
            const Gap(8),
            TextField(
              controller: _targetController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(hintText: '100'),
            ),
            const Gap(20),
            Row(
              children: [
                TextButton(
                  onPressed: _busy ? null : () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const Spacer(),
                FilledButton(
                  onPressed: _phrase == null || _busy ? null : _submit,
                  child: _busy
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Create'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final phrase = _phrase;
    if (phrase == null) return;
    final target = int.tryParse(_targetController.text.trim()) ?? 0;
    if (target <= 0) return;

    setState(() => _busy = true);
    final created = await ref
        .read(dhikrGoalsControllerProvider.notifier)
        .create(
          phrase: phrase.phraseTransliteration,
          targetCount: target,
          period: _period,
        );
    if (!mounted) return;
    if (created != null) {
      await HapticFeedback.mediumImpact();
      if (mounted) Navigator.of(context).pop();
    } else {
      setState(() => _busy = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not create goal. Try again.')),
      );
    }
  }
}

class _EmptyGoals extends StatelessWidget {
  const _EmptyGoals({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: cs.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.flag_outlined, size: 28, color: cs.primary),
          const Gap(12),
          Text('No goals yet', style: theme.textTheme.titleLarge),
          const Gap(4),
          Text(
            'Set a daily or weekly target to give your dhikr a quiet rhythm.',
            style: theme.textTheme.bodyMedium,
          ),
          const Gap(16),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
            onPressed: onCreate,
            icon: const Icon(Icons.add),
            label: const Text('New goal'),
          ),
        ],
      ),
    );
  }
}

class _ShimmerSliver extends StatelessWidget {
  const _ShimmerSliver();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
      sliver: SliverList.list(
        children: [
          for (var i = 0; i < 3; i++) ...[
            Shimmer.fromColors(
              baseColor: cs.surface,
              highlightColor: cs.outline.withValues(alpha: 0.4),
              child: Container(
                height: 110,
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

class _ErrorBlock extends StatelessWidget {
  const _ErrorBlock({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Couldn\'t load goals', style: theme.textTheme.titleMedium),
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
    );
  }
}
