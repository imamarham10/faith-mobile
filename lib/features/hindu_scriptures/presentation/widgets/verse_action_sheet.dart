import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../../share/domain/shareable_content.dart';
import '../../data/dtos/scripture_verse.dart';
import '../controllers/scripture_audio_controller.dart';
import '../controllers/scripture_bookmarks_controller.dart';

/// Bottom-sheet displayed when the user taps a verse. Mirrors Quran's
/// `AyahActionSheet` structurally: play narration, bookmark, share.
class VerseActionSheet extends ConsumerWidget {
  const VerseActionSheet({
    super.key,
    required this.verse,
    required this.textSlug,
    required this.textName,
    required this.chapterNumber,
    required this.chapterTitle,
  });

  final ScriptureVerse verse;
  final String textSlug;
  final String textName;
  final int chapterNumber;
  final String chapterTitle;

  static Future<void> show(
    BuildContext context, {
    required ScriptureVerse verse,
    required String textSlug,
    required String textName,
    required int chapterNumber,
    required String chapterTitle,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (_) => VerseActionSheet(
        verse: verse,
        textSlug: textSlug,
        textName: textName,
        chapterNumber: chapterNumber,
        chapterTitle: chapterTitle,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isBookmarked = ref.watch(
      scriptureBookmarksControllerProvider.select(
        (s) => (s.valueOrNull ?? const []).any((b) => b.verseId == verse.id),
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
                  color: Theme.of(context).colorScheme.outline,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
              ),
            ),
            const Gap(AppSpacing.base),
            Text(
              '$textName · $chapterNumber:${verse.verseNumber}',
              style: theme.textTheme.titleMedium,
            ),
            const Gap(AppSpacing.lg),
            _ActionRow(
              icon: Icons.play_arrow_rounded,
              label: 'Play narration',
              onTap: () {
                HapticFeedback.selectionClick();
                Navigator.of(context).pop();
                ref
                    .read(scriptureAudioControllerProvider.notifier)
                    .playChapter(
                      textSlug: textSlug,
                      chapterNumber: chapterNumber,
                      chapterTitle: chapterTitle,
                    );
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
                await ref
                    .read(scriptureBookmarksControllerProvider.notifier)
                    .toggle(
                      verseId: verse.id,
                      textSlug: textSlug,
                      textName: textName,
                      chapterNumber: chapterNumber,
                      sanskritText: verse.sanskritText,
                      verseNumber: verse.verseNumber,
                      translation: verse.translations.isNotEmpty
                          ? verse.translations.first.text
                          : null,
                    );
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
                final translation = verse.translations.isNotEmpty
                    ? verse.translations.first.text
                    : null;
                context.push(
                  '/share',
                  extra: ShareableContent(
                    eyebrow: textName,
                    title: '$textName · $chapterNumber:${verse.verseNumber}',
                    sanskrit: verse.sanskritText,
                    translation: translation,
                    attribution:
                        '— $textName $chapterNumber:${verse.verseNumber}',
                  ),
                );
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
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

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
          Expanded(child: Text(label, style: theme.textTheme.bodyLarge)),
        ],
      ),
    );
  }
}
