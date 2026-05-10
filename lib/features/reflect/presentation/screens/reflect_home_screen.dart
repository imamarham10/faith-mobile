import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/section_label.dart';
import '../../../feelings/data/dtos/journal_entry.dart';
import '../../../feelings/presentation/controllers/journal_controller.dart';
import '../../../feelings/presentation/widgets/mood_chip_row.dart';

/// `/reflect` — the calm landing for the Reflect tab.
///
/// Tone: unhurried, never gamified. Three doors (mood, journal, history)
/// stacked vertically with hairline borders, plus a small "Recent" preview.
class ReflectHomeScreen extends ConsumerWidget {
  const ReflectHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final entriesThisMonth = ref.watch(journalEntriesThisMonthProvider);
    final recents = ref.watch(recentJournalEntriesProvider);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenEdge,
                  AppSpacing.lg,
                  AppSpacing.screenEdge,
                  AppSpacing.xl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Reflect', style: theme.textTheme.headlineMedium),
                    const Gap(AppSpacing.xs),
                    Text('A quiet place.', style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenEdge,
                0,
                AppSpacing.screenEdge,
                AppSpacing.xxl,
              ),
              sliver: SliverList.list(
                children: [
                  _MoodCard(onTap: () => _openMoodSheet(context)),
                  const Gap(AppSpacing.base),
                  _LinkCard(
                    title: 'Reflection journal',
                    subtitle: _journalSubtitle(entriesThisMonth),
                    icon: Icons.auto_stories_outlined,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      context.push('/reflect/journal');
                    },
                  ),
                  const Gap(AppSpacing.base),
                  _LinkCard(
                    title: 'Mood history',
                    subtitle: 'Last 30 days at a glance',
                    icon: Icons.timeline_outlined,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      context.push('/reflect/history');
                    },
                  ),
                  if (recents.isNotEmpty) ...[
                    const Gap(AppSpacing.xl),
                    const SectionLabel('Recent'),
                    const Gap(AppSpacing.md),
                    for (final entry in recents) ...[
                      _RecentRow(entry: entry),
                      const Gap(AppSpacing.sm),
                    ],
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _journalSubtitle(int count) {
    if (count == 0) return 'No entries yet this month';
    if (count == 1) return '1 entry this month';
    return '$count entries this month';
  }

  Future<void> _openMoodSheet(BuildContext context) async {
    HapticFeedback.lightImpact();
    final theme = Theme.of(context);
    final selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (_) => const _MoodSheet(),
    );
    if (selected == null || !context.mounted) return;
    context.push('/reflect/feelings/$selected');
  }
}

class _MoodCard extends StatelessWidget {
  const _MoodCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.lg,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: cs.outline),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How are you feeling?',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: cs.primary,
                      ),
                    ),
                    const Gap(AppSpacing.xs),
                    Text(
                      "There's a dua for what you're carrying.",
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward,
                size: 18,
                color: cs.onSurface.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LinkCard extends StatelessWidget {
  const _LinkCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.lg,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: cs.outline),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: cs.onSurface),
              const Gap.h(AppSpacing.base),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleMedium),
                    const Gap(AppSpacing.xs),
                    Text(subtitle, style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward,
                size: 18,
                color: cs.onSurface.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentRow extends StatelessWidget {
  const _RecentRow({required this.entry});

  final JournalEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final mood = entry.mood.isEmpty
        ? ''
        : entry.mood[0].toUpperCase() + entry.mood.substring(1);
    final note = entry.note.isEmpty ? 'Saved without a note.' : entry.note;
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.md),
      onTap: () => context.push('/reflect/journal'),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: cs.secondary,
                shape: BoxShape.circle,
              ),
            ),
            const Gap.h(AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(mood, style: theme.textTheme.titleMedium),
                  const Gap(AppSpacing.xs),
                  Text(
                    note,
                    style: theme.textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Gap.h(AppSpacing.sm),
            Text(
              _relativeTime(entry.createdAt),
              style: theme.textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }

  static String _relativeTime(DateTime when) {
    final delta = DateTime.now().difference(when);
    if (delta.inMinutes < 60) return '${delta.inMinutes.clamp(1, 59)}m';
    if (delta.inHours < 24) return '${delta.inHours}h';
    if (delta.inDays < 7) return '${delta.inDays}d';
    if (delta.inDays < 30) return '${(delta.inDays / 7).floor()}w';
    return '${(delta.inDays / 30).floor()}mo';
  }
}

class _MoodSheet extends StatelessWidget {
  const _MoodSheet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenEdge,
          12,
          AppSpacing.screenEdge,
          AppSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: cs.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const Gap(AppSpacing.lg),
            Text('How are you?', style: theme.textTheme.headlineMedium),
            const Gap(AppSpacing.sm),
            Text(
              "There's a dua for what you're carrying.",
              style: theme.textTheme.bodyMedium,
            ),
            const Gap(AppSpacing.lg),
            MoodChipRow(onSelected: (slug) => Navigator.of(context).pop(slug)),
            const Gap(AppSpacing.md),
          ],
        ),
      ),
    );
  }
}
