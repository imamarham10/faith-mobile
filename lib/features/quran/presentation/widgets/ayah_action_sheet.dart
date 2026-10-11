import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../domain/ayah_action_target.dart';
import 'ayah_actions.dart';

/// The full per-verse menu: Play · Bookmark · Share · Tafsir.
///
/// Reached by tap or long-press in the scrolling reader, and by **More** in
/// the verse-at-a-time readers' [AyahActionBar]. One sheet for all three,
/// which is why it takes an [AyahActionTarget] rather than a `Verse` — the
/// juz payload's verse is a different DTO and could never have been passed
/// to the old signature. The actions themselves live in [AyahActions] so
/// the sheet and the bar cannot drift apart.
class AyahActionSheet extends ConsumerWidget {
  const AyahActionSheet({super.key, required this.target});

  final AyahActionTarget target;

  static Future<void> show(
    BuildContext context, {
    required AyahActionTarget target,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (_) => AyahActionSheet(target: target),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isBookmarked = AyahActions.isBookmarked(ref, target);

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
            const SizedBox(height: AppSpacing.base),
            Text(target.label, style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.lg),
            _ActionRow(
              icon: Icons.play_arrow_rounded,
              label: 'Play recitation',
              onTap: () {
                HapticFeedback.selectionClick();
                Navigator.of(context).pop();
                AyahActions.play(ref, target);
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
                await AyahActions.toggleBookmark(ref, target);
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
                AyahActions.share(context, target);
              },
            ),
            const Gap(AppSpacing.sm),
            const _ActionRow(
              icon: Icons.menu_book_outlined,
              label: 'Tafsir',
              subtitle: 'Coming soon',
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
    final disabled = onTap == null;
    return PoppyCard(
      radius: AppRadius.lg,
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            size: 22,
            color: disabled ? cs.onSurfaceVariant : cs.onSurface,
          ),
          const SizedBox(width: AppSpacing.base),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: disabled ? cs.onSurfaceVariant : cs.onSurface,
                  ),
                ),
                if (subtitle != null)
                  Text(subtitle!, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
