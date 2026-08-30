import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/sanskrit_text.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/poppy_button.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../../../shared/widgets/poppy_skeleton.dart';
import '../../data/dtos/scripture_chapter.dart';
import '../controllers/chapter_controller.dart';

/// `/quran/hindu-scripture/:slug` — chapter picker for one text. No Quran
/// equivalent screen exists (Quran's 114 surahs are flat-listed on the home
/// screen); scripture texts have a book→chapter hierarchy so this
/// intermediate index is needed before opening [ChapterReaderScreen].
class TextDetailScreen extends ConsumerWidget {
  const TextDetailScreen({super.key, required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDetail = ref.watch(scriptureTextDetailProvider(slug));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () {
            HapticFeedback.lightImpact();
            if (context.canPop()) context.pop();
          },
        ),
        title: Text(
          asyncDetail.valueOrNull?.nameEnglish ?? '',
        ),
      ),
      body: asyncDetail.when(
        data: (detail) => _ChapterList(slug: slug, chapters: detail.chapters),
        loading: () => const _Loading(),
        error: (e, _) => _ErrorState(
          message: e.toString(),
          onRetry: () => ref.invalidate(scriptureTextDetailProvider(slug)),
        ),
      ),
    );
  }
}

class _ChapterList extends StatelessWidget {
  const _ChapterList({required this.slug, required this.chapters});

  final String slug;
  final List<ChapterSummary> chapters;

  @override
  Widget build(BuildContext context) {
    if (chapters.isEmpty) {
      return Center(
        child: Text(
          'No chapters found for this text.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }
    return ListView.separated(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenEdge,
        AppSpacing.base,
        AppSpacing.screenEdge,
        AppSpacing.xxl,
      ),
      itemCount: chapters.length,
      separatorBuilder: (_, __) => const Gap(AppSpacing.sm),
      itemBuilder: (context, index) {
        final chapter = chapters[index];
        return _ChapterTile(
          chapter: chapter,
          onTap: () {
            HapticFeedback.lightImpact();
            context.push('/quran/hindu-scripture/$slug/${chapter.chapterNumber}');
          },
        );
      },
    );
  }
}

class _ChapterTile extends StatelessWidget {
  const _ChapterTile({required this.chapter, required this.onTap});

  final ChapterSummary chapter;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return PoppyCard(
      radius: AppRadius.lg,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.base,
        vertical: AppSpacing.base,
      ),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '${chapter.chapterNumber}',
              style: theme.textTheme.titleMedium?.copyWith(color: cs.primary),
            ),
          ),
          const SizedBox(width: AppSpacing.base),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chapter.nameEnglish ?? 'Chapter ${chapter.chapterNumber}',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  '${chapter.verseCount} verses',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          if ((chapter.nameSanskrit ?? '').isNotEmpty) ...[
            const SizedBox(width: AppSpacing.sm),
            Text(
              chapter.nameSanskrit!,
              style: sanskritTextStyle(fontSize: 18, color: cs.onSurface),
            ),
          ],
        ],
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenEdge,
        vertical: AppSpacing.base,
      ),
      child: Column(
        children: [
          for (var i = 0; i < 6; i++) ...[
            const PoppySkeleton(height: 72, radius: AppRadius.lg),
            const Gap(AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: 32,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const Gap(AppSpacing.base),
            Text(
              'We couldn\'t load this text.',
              style: theme.textTheme.titleMedium,
            ),
            const Gap(4),
            Text(
              message,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const Gap(AppSpacing.base),
            PoppyButton(label: 'Retry', onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}
