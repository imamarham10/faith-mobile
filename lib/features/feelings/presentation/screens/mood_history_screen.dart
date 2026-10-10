import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/art/artwork.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/illustrated_empty_state.dart';
import '../../../../shared/widgets/mascot_view.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../../../shared/widgets/section_label.dart';
import '../../data/dtos/journal_entry.dart';
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

/// Slugs the two seeded mood sets treat as settled rather than difficult.
///
/// An allowlist, not a denylist of "heavier" slugs. The old denylist named
/// five moods — `tested`, `lonely`, `lost`, `heavy`, `searching` — of which
/// only `lost` exists on the Islam side and only `lonely` on the Hindu side,
/// so it coloured almost nothing it was meant to. Inverting it means a slug
/// this file has never heard of still lands on the contrast-safe branch
/// rather than failing WCAG AA by default.
const Set<String> _calmMoods = {'grateful'};

class _FrequencyRow extends StatelessWidget {
  const _FrequencyRow({required this.frequency});

  final Map<String, int> frequency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final maxCount = frequency.values.fold<int>(0, (a, b) => a > b ? a : b);

    // Charted from the moods actually logged, strongest first — not from any
    // shipped list of moods on offer. This screen is shared by both faiths
    // (the journal behind it is faith-neutral), and it used to plot Islam's
    // hardcoded nine, which meant Hindu users saw Islamic labels and every
    // user saw a row of permanent zeroes for moods no chooser can produce.
    final slugs = frequency.keys.toList()
      ..sort((a, b) {
        final byCount = frequency[b]!.compareTo(frequency[a]!);
        return byCount != 0 ? byCount : a.compareTo(b);
      });

    return Wrap(
      spacing: AppSpacing.base,
      runSpacing: AppSpacing.md,
      children: [
        for (final slug in slugs)
          _FrequencyDot(
            label: _titleCase(slug),
            count: frequency[slug] ?? 0,
            maxCount: maxCount,
            color: _moodColor(context, slug),
            textColor: _moodTextColor(context, slug),
            mutedColor: cs.outline,
            theme: theme,
          ),
      ],
    );
  }

  static String _titleCase(String slug) =>
      slug.isEmpty ? slug : slug[0].toUpperCase() + slug.substring(1);

  Color _moodColor(BuildContext context, String slug) {
    // Sage for "calm/positive" hues, gold for "warmer/heavier" hues. Doesn't
    // depend on hardcoded hex — pulled from the theme.
    final cs = Theme.of(context).colorScheme;
    return _calmMoods.contains(slug) ? cs.primary : cs.secondary;
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
    return _calmMoods.contains(slug) ? cs.primary : accentText;
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

    return PoppyCard(
      radius: AppRadius.md,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.base,
        vertical: AppSpacing.md,
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
    return const IllustratedEmptyState(
      title: 'No history yet.',
      message: "Once you save reflections, you'll see them here.",
      slot: ArtSlot.emptyHistory,
      mascot: MascotState.sleep,
    );
  }
}
