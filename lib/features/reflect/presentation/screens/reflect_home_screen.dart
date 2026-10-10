import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/preferences/selected_faith.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/faith_id.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../../../shared/widgets/section_label.dart';
import '../../../feelings/data/dtos/journal_entry.dart';
import '../../../feelings/presentation/controllers/journal_controller.dart';
import '../../../feelings/presentation/widgets/mood_sheet.dart';

/// `/reflect` — the calm landing for the Reflect tab.
///
/// Faith-aware: branches on [selectedFaithProvider]. Islam
/// (`_IslamReflectContent`) and Hindu (`_HinduReflectContent`) share the
/// same shape (mood door / journal / history / recent) built on the same
/// faith-neutral journal storage, but the mood door's copy and chip source
/// differ per faith — Islam's "There's a dua for what you're carrying"
/// doesn't apply to Hindu, whose emotions/remedies come from a genuinely
/// distinct backend shape (Gita verses with per-remedy notes, not duas).
class ReflectHomeScreen extends ConsumerWidget {
  const ReflectHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final faith = ref.watch(selectedFaithProvider).valueOrNull ?? FaithId.islam;
    return switch (faith) {
      FaithId.islam => const _IslamReflectContent(),
      FaithId.hindu => const _HinduReflectContent(),
    };
  }
}

/// Tone: unhurried, never gamified. Three doors (mood, journal, history)
/// stacked vertically with thick outlines, plus a small "Recent" preview.
class _IslamReflectContent extends ConsumerWidget {
  const _IslamReflectContent();

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
    final selected = await showMoodSheet(context);
    if (selected == null || !context.mounted) return;
    context.push('/reflect/feelings/$selected');
  }
}

/// Mirrors `_IslamReflectContent`'s shape exactly — mood door, journal,
/// history, recent — built on the same faith-neutral journal storage.
/// Only the mood door's copy and chip source are Hindu-specific.
class _HinduReflectContent extends ConsumerWidget {
  const _HinduReflectContent();

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
                  _MoodCard(
                    subtitle: "There's a shloka for what you're carrying.",
                    onTap: () => _openHinduMoodSheet(context),
                  ),
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

  Future<void> _openHinduMoodSheet(BuildContext context) async {
    final selected = await showMoodSheet(context);
    if (selected == null || !context.mounted) return;
    context.push('/reflect/feelings/$selected');
  }
}

class _MoodCard extends StatelessWidget {
  const _MoodCard({
    required this.onTap,
    this.subtitle = "There's a dua for what you're carrying.",
  });

  final VoidCallback onTap;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return PoppyCard(
      radius: AppRadius.lg,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      onTap: onTap,
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
    return PoppyCard(
      radius: AppRadius.lg,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      onTap: onTap,
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
