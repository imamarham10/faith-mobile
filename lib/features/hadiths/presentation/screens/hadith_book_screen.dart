import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/gap.dart';
import '../../data/dtos/hadith_book.dart';
import '../controllers/hadiths_by_book_controller.dart';
import '../controllers/hadiths_home_controller.dart';
import '../widgets/hadith_list_tile.dart';

/// `/hadiths/book/:id` — paginated feed of hadiths in a single collection.
class HadithBookScreen extends ConsumerStatefulWidget {
  const HadithBookScreen({super.key, required this.bookId});

  final String bookId;

  @override
  ConsumerState<HadithBookScreen> createState() => _HadithBookScreenState();
}

class _HadithBookScreenState extends ConsumerState<HadithBookScreen> {
  final ScrollController _scrollCtrl = ScrollController();
  bool _loadMoreInflight = false;

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollCtrl
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_loadMoreInflight) return;
    if (!_scrollCtrl.hasClients) return;
    final extent = _scrollCtrl.position.maxScrollExtent;
    final offset = _scrollCtrl.position.pixels;
    if (extent <= 0) return;
    if (offset / extent < 0.8) return;

    final controller = ref.read(
      hadithsByBookControllerProvider(widget.bookId).notifier,
    );
    final feed = ref
        .read(hadithsByBookControllerProvider(widget.bookId))
        .valueOrNull;
    if (feed == null || !feed.hasMore || feed.isLoadingMore) return;

    _loadMoreInflight = true;
    controller.loadMore().whenComplete(() {
      if (!mounted) return;
      _loadMoreInflight = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final feedAsync = ref.watch(hadithsByBookControllerProvider(widget.bookId));
    final booksAsync = ref.watch(hadithBooksProvider);

    final HadithBook? book = booksAsync.maybeWhen(
      data: (list) {
        for (final b in list) {
          if (b.id == widget.bookId) return b;
        }
        return null;
      },
      orElse: () => null,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(book?.name ?? 'Book', style: theme.textTheme.titleLarge),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        top: false,
        child: feedAsync.when(
          loading: () => const _BookShimmer(),
          error: (e, __) => _ErrorPanel(
            message: e is Exception
                ? _humanize(e)
                : 'Something went off track.',
            onRetry: () =>
                ref.invalidate(hadithsByBookControllerProvider(widget.bookId)),
          ),
          data: (feed) {
            if (feed.items.isEmpty) {
              return _EmptyPanel(isPremium: book?.isPremium ?? false);
            }
            return CustomScrollView(
              controller: _scrollCtrl,
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                if (book != null)
                  SliverToBoxAdapter(child: _BookHeader(book: book)),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenEdge,
                  ),
                  sliver: SliverList.separated(
                    itemCount: feed.items.length,
                    separatorBuilder: (_, __) => const Gap(AppSpacing.sm),
                    itemBuilder: (_, i) {
                      final hadith = feed.items[i];
                      return HadithListTile(
                        hadith: hadith,
                        onTap: () => context.push('/hadiths/${hadith.id}'),
                      );
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.xl,
                    ),
                    child: Center(
                      child: feed.isLoadingMore
                          ? const CircularProgressIndicator.adaptive()
                          : feed.hasMore
                          ? const SizedBox.shrink()
                          : Text(
                              'End of book.',
                              style: theme.textTheme.bodySmall,
                            ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  static String _humanize(Object e) {
    final s = e.toString();
    final colon = s.indexOf(': ');
    return colon >= 0 ? s.substring(colon + 2) : s;
  }
}

class _BookHeader extends StatelessWidget {
  const _BookHeader({required this.book});

  final HadithBook book;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenEdge,
        AppSpacing.sm,
        AppSpacing.screenEdge,
        AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(book.name, style: theme.textTheme.headlineMedium),
          if ((book.author ?? '').isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(book.author!, style: theme.textTheme.bodyMedium),
          ],
          if (book.totalHadiths > 0) ...[
            const SizedBox(height: 6),
            Text(
              '${book.totalHadiths} hadiths',
              style: theme.textTheme.labelSmall?.copyWith(color: cs.secondary),
            ),
          ],
        ],
      ),
    );
  }
}

class _BookShimmer extends StatelessWidget {
  const _BookShimmer();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenEdge,
        AppSpacing.sm,
        AppSpacing.screenEdge,
        AppSpacing.xxl,
      ),
      itemCount: 8,
      separatorBuilder: (_, __) => const Gap(AppSpacing.sm),
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: cs.surface,
        highlightColor: cs.outline,
        child: Container(
          height: 88,
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
        ),
      ),
    );
  }
}

class _EmptyPanel extends StatelessWidget {
  const _EmptyPanel({required this.isPremium});

  final bool isPremium;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isPremium ? Icons.lock_outline : Icons.inbox_outlined,
              size: 36,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const Gap(AppSpacing.md),
            Text(
              isPremium
                  ? 'This collection is part of premium.'
                  : 'No hadiths in this book yet.',
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorPanel extends StatelessWidget {
  const _ErrorPanel({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: 36,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const Gap(AppSpacing.md),
            Text(message, style: theme.textTheme.bodyLarge),
            const Gap(AppSpacing.lg),
            FilledButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}
