import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/section_label.dart';
import '../../data/dtos/dhikr_history_entry.dart';
import '../controllers/dhikr_history_controller.dart';

/// Quiet vertical timeline grouped by day.
class DhikrHistoryScreen extends ConsumerWidget {
  const DhikrHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final async = ref.watch(dhikrHistoryGroupedProvider());

    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(dhikrHistoryGroupedProvider);
            await ref.read(dhikrHistoryGroupedProvider().future);
          },
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
                      Text('History', style: theme.textTheme.headlineMedium),
                      const Gap(4),
                      Text(
                        'A trace of your remembrance.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              async.when(
                loading: () => const _Shimmer(),
                error: (e, _) => SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenEdge,
                    ),
                    child: _ErrorBlock(message: e.toString()),
                  ),
                ),
                data: (grouped) {
                  if (grouped.isEmpty) {
                    return const SliverToBoxAdapter(child: _Empty());
                  }
                  final entries = grouped.entries.toList(growable: false);
                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenEdge,
                    ),
                    sliver: SliverList.builder(
                      itemCount: entries.length,
                      itemBuilder: (_, i) => _DayBlock(
                        day: entries[i].key,
                        entries: entries[i].value,
                      ),
                    ),
                  );
                },
              ),
              const SliverToBoxAdapter(child: Gap(40)),
            ],
          ),
        ),
      ),
    );
  }
}

class _DayBlock extends StatelessWidget {
  const _DayBlock({required this.day, required this.entries});

  final DateTime day;
  final List<DhikrHistoryEntry> entries;

  @override
  Widget build(BuildContext context) {
    final label = _dayLabel(day);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionLabel(label),
          const Gap(10),
          for (final e in entries) ...[_EntryRow(entry: e), const Gap(8)],
        ],
      ),
    );
  }

  String _dayLabel(DateTime d) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final diffDays = today.difference(d).inDays;
    if (diffDays == 0) return 'Today';
    if (diffDays == 1) return 'Yesterday';
    if (diffDays < 7) return DateFormat.EEEE().format(d);
    return DateFormat.MMMd().format(d);
  }
}

class _EntryRow extends StatelessWidget {
  const _EntryRow({required this.entry});

  final DhikrHistoryEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final time = entry.recordedAt != null
        ? DateFormat.jm().format(entry.recordedAt!)
        : '—';
    final phrase = entry.phraseEnglish ?? entry.phraseArabic ?? 'Dhikr';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.base,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: cs.outline),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              phrase,
              style: theme.textTheme.titleMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Gap(12),
          Text('${entry.count}', style: theme.textTheme.titleMedium),
          const Gap(12),
          Text(time, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenEdge,
        AppSpacing.xxl,
        AppSpacing.screenEdge,
        AppSpacing.xxl,
      ),
      child: Column(
        children: [
          Icon(
            Icons.history,
            size: 36,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const Gap(12),
          Text(
            'Your history will appear here',
            style: theme.textTheme.titleMedium,
          ),
          const Gap(4),
          Text(
            'as you remember.',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _Shimmer extends StatelessWidget {
  const _Shimmer();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
      sliver: SliverList.list(
        children: [
          for (var i = 0; i < 4; i++) ...[
            Shimmer.fromColors(
              baseColor: cs.surface,
              highlightColor: cs.outline.withValues(alpha: 0.4),
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: cs.outline),
                  color: cs.surface,
                ),
              ),
            ),
            const Gap(8),
          ],
        ],
      ),
    );
  }
}

class _ErrorBlock extends StatelessWidget {
  const _ErrorBlock({required this.message});

  final String message;

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
          Text('Couldn\'t load history', style: theme.textTheme.titleMedium),
          const Gap(6),
          Text(message, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
