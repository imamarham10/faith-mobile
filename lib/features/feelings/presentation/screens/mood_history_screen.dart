import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/section_label.dart';
import '../../data/dtos/journal_entry.dart';
import '../controllers/emotions_controller.dart';
import '../controllers/mood_history_controller.dart';

/// `/reflect/history` — last 30 days of mood entries with frequency dots.
class MoodHistoryScreen extends ConsumerWidget {
  const MoodHistoryScreen({super.key});

  static const int _windowDays = 30;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final entries = ref.watch(moodHistoryEntriesProvider(days: _windowDays));
    final freq = ref.watch(moodFrequencyProvider(days: _windowDays));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.pop(),
        ),
        title: Text('Mood history', style: theme.textTheme.titleLarge),
      ),
      body: SafeArea(
        child: entries.isEmpty
            ? const _Empty()
            : ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenEdge,
                  AppSpacing.base,
                  AppSpacing.screenEdge,
                  AppSpacing.xxl,
                ),
                children: [
                  const SectionLabel('Last 30 days'),
                  const Gap(AppSpacing.md),
                  _FrequencyRow(frequency: freq),
                  const Gap(AppSpacing.xl),
                  const SectionLabel('Timeline'),
                  const Gap(AppSpacing.md),
                  for (final entry in entries) ...[
                    _TimelineRow(entry: entry),
                    const Gap(AppSpacing.sm),
                  ],
                ],
              ),
      ),
    );
  }
}

class _FrequencyRow extends StatelessWidget {
  const _FrequencyRow({required this.frequency});

  final Map<String, int> frequency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final maxCount = frequency.values.fold<int>(0, (a, b) => a > b ? a : b);

    return Wrap(
      spacing: AppSpacing.base,
      runSpacing: AppSpacing.md,
      children: [
        for (final mood in kDefaultMoods)
          _FrequencyDot(
            label: mood.name,
            count: frequency[mood.slug] ?? 0,
            maxCount: maxCount,
            color: _moodColor(context, mood.slug),
            textColor: _moodTextColor(context, mood.slug),
            mutedColor: cs.outline,
            theme: theme,
          ),
      ],
    );
  }

  Color _moodColor(BuildContext context, String slug) {
    // Sage for "calm/positive" hues, gold for "warmer/heavier" hues. Doesn't
    // depend on hardcoded hex — pulled from the theme.
    final cs = Theme.of(context).colorScheme;
    const warmer = {'tested', 'lonely', 'lost', 'heavy', 'searching'};
    return warmer.contains(slug) ? cs.secondary : cs.primary;
  }

  /// Same warm/calm split as [_moodColor], but for the count text drawn
  /// inside the dot — `secondary` fails WCAG AA as text on `surface`, so
  /// warmer moods use the palette's contrast-safe `accentText` instead.
  Color _moodTextColor(BuildContext context, String slug) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final accentText = theme
        .extension<FaithThemeExtension>()!
        .palette
        .accentText;
    const warmer = {'tested', 'lonely', 'lost', 'heavy', 'searching'};
    return warmer.contains(slug) ? accentText : cs.primary;
  }
}

class _FrequencyDot extends StatelessWidget {
  const _FrequencyDot({
    required this.label,
    required this.count,
    required this.maxCount,
    required this.color,
    required this.textColor,
    required this.mutedColor,
    required this.theme,
  });

  final String label;
  final int count;
  final int maxCount;
  final Color color;
  final Color textColor;
  final Color mutedColor;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    const minSize = 18.0;
    const maxSize = 56.0;
    final size = maxCount == 0
        ? minSize
        : minSize + (maxSize - minSize) * (count / maxCount);
    final filled = count > 0;

    return SizedBox(
      width: 72,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: filled
                  ? color.withValues(alpha: 0.18)
                  : Colors.transparent,
              border: Border.all(
                color: filled ? color : mutedColor,
                width: filled ? 1.4 : 1,
              ),
            ),
            child: Center(
              child: Text(
                count.toString(),
                style: theme.textTheme.labelLarge?.copyWith(
                  color: filled
                      ? textColor
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
          const Gap(AppSpacing.xs + 2),
          Text(
            label,
            style: theme.textTheme.labelMedium,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.entry});

  final JournalEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final dateLabel = DateFormat.MMMd().format(entry.createdAt);
    final mood = entry.mood.isEmpty
        ? ''
        : entry.mood[0].toUpperCase() + entry.mood.substring(1);

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 56,
            child: Text(dateLabel, style: theme.textTheme.labelMedium),
          ),
          const Gap.h(AppSpacing.sm),
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: cs.primary,
              shape: BoxShape.circle,
            ),
          ),
          const Gap.h(AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(mood, style: theme.textTheme.titleMedium),
                if (entry.note.isNotEmpty) ...[
                  const Gap(AppSpacing.xs),
                  Text(
                    entry.note,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ),
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
    final cs = theme.colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.timeline_outlined, size: 40, color: cs.onSurfaceVariant),
            const Gap(AppSpacing.base),
            Text(
              'No history yet.',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const Gap(AppSpacing.sm),
            Text(
              'Once you save reflections, you\'ll see them here.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
