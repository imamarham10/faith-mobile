import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/arabic_text.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../../../shared/widgets/gap.dart';
import '../../data/dtos/bookmark.dart';
import '../controllers/bookmarks_controller.dart';

/// `/quran/bookmarks` — list of saved verses.
class BookmarksScreen extends ConsumerWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncBookmarks = ref.watch(bookmarksControllerProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () {
            HapticFeedback.lightImpact();
            if (context.canPop()) context.pop();
          },
        ),
        title: const Text('Bookmarks'),
      ),
      body: asyncBookmarks.when(
        data: (items) =>
            items.isEmpty ? const _EmptyState() : _BookmarksList(items: items),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorState(message: e.toString()),
      ),
    );
  }
}

class _BookmarksList extends ConsumerWidget {
  const _BookmarksList({required this.items});

  final List<Bookmark> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      itemCount: items.length,
      separatorBuilder: (_, __) => const Gap(AppSpacing.sm),
      itemBuilder: (context, index) {
        final item = items[index];
        return Dismissible(
          key: ValueKey('${item.surahId}:${item.verseNumber}'),
          direction: DismissDirection.endToStart,
          background: _DismissBackground(),
          onDismissed: (_) {
            HapticFeedback.mediumImpact();
            ref.read(bookmarksControllerProvider.notifier).remove(item);
          },
          child: _BookmarkTile(
            item: item,
            onTap: () {
              HapticFeedback.lightImpact();
              context.push(
                '/quran/surah/${item.surahId}?ayah=${item.verseNumber}',
              );
            },
          ),
        );
      },
    );
  }
}

class _BookmarkTile extends ConsumerWidget {
  const _BookmarkTile({required this.item, required this.onTap});

  final Bookmark item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final accentText = theme
        .extension<FaithThemeExtension>()!
        .palette
        .accentText;
    final name = item.surahName ?? 'Surah ${item.surahId}';
    final snippet = item.textArabic;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: cs.outline),
            color: cs.surface,
          ),
          padding: const EdgeInsets.all(AppSpacing.base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.bookmark, size: 16, color: accentText),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      '$name · ${item.surahId}:${item.verseNumber}',
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
              if (snippet != null && snippet.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    snippet,
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: arabicTextStyleOf(
                      ref,
                      fontSize: 20,
                      height: 1.6,
                      color: cs.onSurface,
                    ),
                  ),
                ),
              ],
              if (item.translation != null) ...[
                const SizedBox(height: 6),
                Text(
                  item.translation!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _DismissBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        color: cs.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Icon(Icons.delete_outline, color: cs.error),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: cs.primaryContainer,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.bookmark_border_rounded,
                size: 32,
                color: cs.primary,
              ),
            ),
            const Gap(AppSpacing.lg),
            Text('No bookmarks yet', style: theme.textTheme.titleLarge),
            const Gap(AppSpacing.sm),
            Text(
              'Tap any ayah to bookmark it.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends ConsumerWidget {
  const _ErrorState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 32,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const Gap(AppSpacing.base),
            Text(
              'Couldn\'t load bookmarks.',
              style: theme.textTheme.titleMedium,
            ),
            const Gap(4),
            Text(
              message,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const Gap(AppSpacing.base),
            FilledButton.tonal(
              onPressed: () {
                HapticFeedback.heavyImpact();
                ref.invalidate(bookmarksControllerProvider);
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
