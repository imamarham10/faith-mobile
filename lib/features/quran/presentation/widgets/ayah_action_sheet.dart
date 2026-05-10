import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../share/domain/shareable_content.dart';
import '../../data/dtos/verse.dart';
import '../controllers/audio_controller.dart';
import '../controllers/bookmarks_controller.dart';

/// Bottom-sheet displayed when the user taps an ayah action handle.
/// Actions: Play, Bookmark toggle, Share, Tafsir (placeholder).
class AyahActionSheet extends ConsumerWidget {
  const AyahActionSheet({
    super.key,
    required this.verse,
    required this.surahId,
    required this.surahName,
    required this.totalVerses,
  });

  final Verse verse;
  final int surahId;
  final String surahName;
  final int totalVerses;

  static Future<void> show(
    BuildContext context, {
    required Verse verse,
    required int surahId,
    required String surahName,
    required int totalVerses,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (_) => AyahActionSheet(
        verse: verse,
        surahId: surahId,
        surahName: surahName,
        totalVerses: totalVerses,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isBookmarked = ref.watch(
      bookmarksControllerProvider.select(
        (s) => (s.valueOrNull ?? const []).any(
          (b) => b.surahId == surahId && b.verseNumber == verse.verseNumber,
        ),
      ),
    );

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
            Text(
              '$surahName · ${verse.surahId}:${verse.verseNumber}',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            _ActionRow(
              icon: Icons.play_arrow_rounded,
              label: 'Play recitation',
              onTap: () {
                Navigator.of(context).pop();
                ref
                    .read(audioControllerProvider.notifier)
                    .playAyah(
                      surahId: surahId,
                      verseNumber: verse.verseNumber,
                      surahName: surahName,
                      totalVerses: totalVerses,
                    );
              },
            ),
            _ActionRow(
              icon: isBookmarked
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_border_rounded,
              label: isBookmarked ? 'Remove bookmark' : 'Bookmark',
              onTap: () async {
                await ref
                    .read(bookmarksControllerProvider.notifier)
                    .toggle(
                      surahId: surahId,
                      verseNumber: verse.verseNumber,
                      surahName: surahName,
                      textArabic: verse.textArabic,
                      translation: verse.translations.isNotEmpty
                          ? verse.translations.first.text
                          : null,
                    );
                if (context.mounted) Navigator.of(context).pop();
              },
            ),
            _ActionRow(
              icon: Icons.share_outlined,
              label: 'Share',
              onTap: () {
                HapticFeedback.selectionClick();
                Navigator.of(context).pop();
                final translation = verse.translations.isNotEmpty
                    ? verse.translations.first.text
                    : null;
                context.push(
                  '/share',
                  extra: ShareableContent(
                    eyebrow: 'Quran',
                    title:
                        '$surahName · ${verse.surahId}:${verse.verseNumber}',
                    arabic: verse.textArabic,
                    translation: translation,
                    attribution:
                        '— $surahName ${verse.surahId}:${verse.verseNumber}',
                  ),
                );
              },
            ),
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
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.md),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.base,
        ),
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
      ),
    );
  }
}
