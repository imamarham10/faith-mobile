import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/arabic_text.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../../../core/theme/sanskrit_text.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../data/dtos/journal_entry.dart';
import 'mood_chip.dart';

/// One line of the journal list. Compact by default; pass `expanded: true`
/// to show the full note plus the remedy(ies) that were on screen when the
/// entry was saved — so a past reflection can still be traced back to the
/// dua/hadith or Gita verse that prompted it.
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

    return PoppyCard(
      radius: AppRadius.lg,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.base,
      ),
      onTap: onTap,
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
              style: theme.textTheme.bodyMedium?.copyWith(color: cs.onSurface),
              maxLines: expanded ? null : 3,
              overflow: expanded ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
          ],
          if (expanded && entry.remedies.isNotEmpty) ...[
            const Gap(AppSpacing.md),
            Container(height: 1, color: cs.outlineVariant),
            for (final remedy in entry.remedies) ...[
              const Gap(AppSpacing.md),
              _RemedySnapshotView(remedy: remedy),
            ],
          ],
        ],
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

/// A saved remedy — tappable through to its source when [deepLink] is set
/// (Hindu Gita verses); Islam's duas/hadith have no addressable in-app
/// location, so those render inert.
class _RemedySnapshotView extends ConsumerWidget {
  const _RemedySnapshotView({required this.remedy});

  final JournalRemedySnapshot remedy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final accentText = theme
        .extension<FaithThemeExtension>()!
        .palette
        .accentText;
    final hasTranslit = (remedy.transliteration ?? '').trim().isNotEmpty;
    final hasTranslation = (remedy.translation ?? '').trim().isNotEmpty;
    final hasReference = (remedy.reference ?? '').trim().isNotEmpty;
    final hasNote = (remedy.note ?? '').trim().isNotEmpty;
    final canNavigate = (remedy.deepLink ?? '').isNotEmpty;

    final primaryStyle = switch (remedy.script) {
      JournalRemedyScript.arabic => arabicTextStyleOf(
        ref,
        fontSize: 18,
        height: 1.7,
        color: cs.onSurface,
      ),
      JournalRemedyScript.sanskrit => sanskritTextStyle(
        fontSize: 16,
        height: 1.6,
        color: cs.onSurface,
      ),
      null => theme.textTheme.bodyMedium?.copyWith(color: cs.onSurface),
    };

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasNote) ...[
          Text(
            remedy.note!,
            style: theme.textTheme.bodySmall?.copyWith(
              fontStyle: FontStyle.italic,
            ),
          ),
          const Gap(AppSpacing.sm),
        ],
        if (remedy.script == JournalRemedyScript.arabic)
          Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              remedy.primaryText,
              textAlign: TextAlign.right,
              style: primaryStyle,
            ),
          )
        else
          Text(remedy.primaryText, style: primaryStyle),
        if (hasTranslit) ...[
          const Gap(AppSpacing.sm),
          Text(
            remedy.transliteration!,
            style: theme.textTheme.bodySmall?.copyWith(
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
        if (hasTranslation) ...[
          const Gap(AppSpacing.sm),
          Text(remedy.translation!, style: theme.textTheme.bodyMedium),
        ],
        if (hasReference) ...[
          const Gap(AppSpacing.sm),
          Text(
            remedy.reference!.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(color: accentText),
          ),
        ],
      ],
    );

    if (!canNavigate) return content;

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.md),
      onTap: () {
        HapticFeedback.lightImpact();
        context.push(remedy.deepLink!);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: content),
          const Gap.h(AppSpacing.sm),
          Icon(Icons.chevron_right, size: 20, color: cs.onSurfaceVariant),
        ],
      ),
    );
  }
}
