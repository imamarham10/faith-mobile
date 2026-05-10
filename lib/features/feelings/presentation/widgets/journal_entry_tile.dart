import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/gap.dart';
import '../../data/dtos/journal_entry.dart';
import 'mood_chip.dart';

/// One line of the journal list. Compact by default; pass `expanded: true`
/// to show the full note (used inside the inline-expanded state).
class JournalEntryTile extends StatelessWidget {
  const JournalEntryTile({
    super.key,
    required this.entry,
    required this.moodLabel,
    this.expanded = false,
    this.onTap,
  });

  final JournalEntry entry;
  final String moodLabel;
  final bool expanded;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.base,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: cs.outline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                MoodChip(label: moodLabel, compact: true),
                const Spacer(),
                Text(
                  _relativeTime(entry.createdAt),
                  style: theme.textTheme.labelSmall,
                ),
              ],
            ),
            if (entry.note.isNotEmpty) ...[
              const Gap(AppSpacing.md),
              Text(
                entry.note,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurface,
                ),
                maxLines: expanded ? null : 3,
                overflow: expanded
                    ? TextOverflow.visible
                    : TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  static String _relativeTime(DateTime when) {
    final delta = DateTime.now().difference(when);
    if (delta.inSeconds < 60) return 'Just now';
    if (delta.inMinutes < 60) return '${delta.inMinutes}m ago';
    if (delta.inHours < 24) return '${delta.inHours}h ago';
    if (delta.inDays < 7) return '${delta.inDays}d ago';
    if (delta.inDays < 30) return '${(delta.inDays / 7).floor()}w ago';
    return '${(delta.inDays / 30).floor()}mo ago';
  }
}
