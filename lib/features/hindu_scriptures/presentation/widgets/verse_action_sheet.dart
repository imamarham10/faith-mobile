import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../domain/shloka_action_target.dart';
import 'shloka_actions.dart';

/// The full per-verse menu: chapter narration · Bookmark · Share.
///
/// Reached by tap or long-press in the scrolling reader, and by **More** in
/// the pager's [ShlokaActionBar]. One sheet for both, which is why it takes
/// a [ShlokaActionTarget] rather than a verse and four loose strings — the
/// old signature could not be handed a verse whose chapter the caller only
/// knew by number. The actions themselves live in [ShlokaActions] so the
/// sheet and the bar cannot drift apart.
///
/// Structurally the Qur'an's `AyahActionSheet`, with one honest difference:
/// its first row plays *the verse*, and this one plays *the chapter*, which
/// is all the data supports and all this row claims.
class VerseActionSheet extends ConsumerWidget {
  const VerseActionSheet({super.key, required this.target});

  final ShlokaActionTarget target;

  static Future<void> show(
    BuildContext context, {
    required ShlokaActionTarget target,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (_) => VerseActionSheet(target: target),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isBookmarked = ShlokaActions.isBookmarked(ref, target);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenEdge,
          AppSpacing.base,
          AppSpacing.screenEdge,
          AppSpacing.lg,
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
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
              ),
            ),
            const Gap(AppSpacing.base),
            Text(target.label, style: theme.textTheme.titleMedium),
            const Gap(AppSpacing.lg),
            _ActionRow(
              icon: Icons.headphones_rounded,
              label: 'Play chapter narration',
              // Said out loud, because the row sits under a single verse and
              // would otherwise read as an offer to play that verse. There
              // is no per-verse narration in the data to play.
              subtitle:
                  'The whole of ${target.chapterTitle}, from the beginning',
              onTap: () {
                HapticFeedback.selectionClick();
                Navigator.of(context).pop();
                ShlokaActions.playChapter(ref, target);
              },
            ),
            const Gap(AppSpacing.sm),
            _ActionRow(
              icon: isBookmarked
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_border_rounded,
              label: isBookmarked ? 'Remove bookmark' : 'Bookmark',
              onTap: () async {
                HapticFeedback.selectionClick();
                await ShlokaActions.toggleBookmark(ref, target);
                if (context.mounted) Navigator.of(context).pop();
              },
            ),
            const Gap(AppSpacing.sm),
            _ActionRow(
              icon: Icons.share_outlined,
              label: 'Share',
              onTap: () {
                HapticFeedback.selectionClick();
                Navigator.of(context).pop();
                ShlokaActions.share(context, target);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.icon,
    required this.label,
    this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return PoppyCard(
      radius: AppRadius.lg,
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: cs.onSurface, size: 24),
          const Gap.h(AppSpacing.base),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label, style: theme.textTheme.bodyLarge),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
