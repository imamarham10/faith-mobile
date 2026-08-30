import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../../../core/theme/sanskrit_text.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/poppy_button.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../data/dtos/scripture_bookmark.dart';
import '../controllers/scripture_bookmarks_controller.dart';

/// `/quran/bookmarks` (Hindu content) — saved verses, mirrors Quran's own
/// `BookmarksScreen` structurally.
class HinduScripturesBookmarksScreen extends ConsumerWidget {
  const HinduScripturesBookmarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncBookmarks = ref.watch(scriptureBookmarksControllerProvider);

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

  final List<ScriptureBookmark> items;

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
          key: ValueKey(item.verseId),
          direction: DismissDirection.endToStart,
          background: _DismissBackground(),
          onDismissed: (_) {
            HapticFeedback.mediumImpact();
            ref
                .read(scriptureBookmarksControllerProvider.notifier)
                .remove(item);
          },
          child: _BookmarkTile(
            item: item,
            onTap: () {
              HapticFeedback.lightImpact();
              if (item.textSlug == null || item.chapterNumber == null) return;
              context.push(
                '/quran/hindu-scripture/${item.textSlug}/${item.chapterNumber}'
                '?verse=${item.verseNumber ?? 1}',
              );
            },
          ),
        );
      },
    );
  }
}

class _BookmarkTile extends StatelessWidget {
  const _BookmarkTile({required this.item, required this.onTap});

  final ScriptureBookmark item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final accentText = theme
        .extension<FaithThemeExtension>()!
        .palette
        .accentText;
    final name = item.textName ?? item.textSlug ?? 'Scripture';
    final ref = item.chapterNumber != null && item.verseNumber != null
        ? '$name · ${item.chapterNumber}:${item.verseNumber}'
        : name;

    return PoppyCard(
      radius: AppRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.base),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bookmark, size: 16, color: accentText),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Text(ref, style: theme.textTheme.titleMedium)),
            ],
          ),
          if ((item.sanskritText ?? '').isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              item.sanskritText!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: sanskritTextStyle(fontSize: 20, color: cs.onSurface),
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
              'Tap any verse to bookmark it.',
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
            PoppyButton(
              label: 'Retry',
              onPressed: () =>
                  ref.invalidate(scriptureBookmarksControllerProvider),
            ),
          ],
        ),
      ),
    );
  }
}
