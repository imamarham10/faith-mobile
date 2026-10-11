import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/art/artwork.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/illustrated_empty_state.dart';
import '../../../../shared/widgets/mascot_view.dart';
import '../../../../shared/widgets/poppy_button.dart';
import '../../../../shared/widgets/poppy_skeleton.dart';
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

  /// Walks the books list — which [HadithsRepository.getBooks] has already
  /// reduced to the free collections — for the id this route was opened
  /// with. A null answer means the id is not one this build carries.
  HadithBook? _bookIn(List<HadithBook> books) {
    for (final b in books) {
      if (b.id == widget.bookId) return b;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final booksAsync = ref.watch(hadithBooksProvider);
    final HadithBook? book = booksAsync.maybeWhen(
      data: _bookIn,
      orElse: () => null,
    );

    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(book?.name ?? 'Book', style: theme.textTheme.titleLarge),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      // The books list is resolved *before* the feed, and the feed provider
      // is never watched for a book that is not in it. Nothing in the app
      // links here with an id the list lacks; a deep link or a stale
      // bookmark still can, and this is what stops that becoming a request
      // the server answers 403 to.
      body: SafeArea(
        top: false,
        child: booksAsync.when(
          loading: () => const _BookShimmer(),
          error: (e, __) => _ErrorPanel(
            message: e is Exception
                ? _humanize(e)
                : 'Something went off track.',
            onRetry: () => ref.invalidate(hadithBooksProvider),
          ),
          data: (books) {
            final resolved = _bookIn(books);
            if (resolved == null) return const _UnavailablePanel();
            return _feed(context, resolved);
          },
        ),
      ),
    );
  }

  Widget _feed(BuildContext context, HadithBook book) {
    final theme = Theme.of(context);
    final feedAsync = ref.watch(hadithsByBookControllerProvider(widget.bookId));
    return feedAsync.when(
      loading: () => const _BookShimmer(),
      error: (e, __) => _ErrorPanel(
        message: e is Exception ? _humanize(e) : 'Something went off track.',
        onRetry: () =>
            ref.invalidate(hadithsByBookControllerProvider(widget.bookId)),
      ),
      data: (feed) {
        if (feed.items.isEmpty) {
          return const _EmptyPanel();
        }
        return CustomScrollView(
          controller: _scrollCtrl,
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
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
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
                child: Center(
                  child: feed.isLoadingMore
                      ? const CircularProgressIndicator.adaptive()
                      : feed.hasMore
                      ? const SizedBox.shrink()
                      : Text('End of book.', style: theme.textTheme.bodySmall),
                ),
              ),
            ),
          ],
        );
      },
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
    final accentText = theme
        .extension<FaithThemeExtension>()!
        .palette
        .accentText;
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
              style: theme.textTheme.labelSmall?.copyWith(color: accentText),
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
      itemBuilder: (_, __) =>
          const PoppySkeleton(height: 88, radius: AppRadius.lg),
    );
  }
}

class _EmptyPanel extends StatelessWidget {
  const _EmptyPanel();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: IllustratedEmptyState(
        title: 'Nothing here yet',
        message: 'No hadiths in this book yet.',
        slot: ArtSlot.emptyCollection,
        mascot: MascotState.sleep,
      ),
    );
  }
}

/// Shown when the route's `bookId` is not a collection this build carries.
///
/// Reachable only from outside the app — a deep link, or a link shared from
/// the web, where the full library is listed. It reads as a dead link
/// because that is what it is here: there is no door, so there is no lock to
/// describe and nothing to offer to unlock.
class _UnavailablePanel extends StatelessWidget {
  const _UnavailablePanel();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IllustratedEmptyState(
        title: 'This collection isn\'t available',
        message: 'Browse the collections on the Hadiths home.',
        slot: ArtSlot.emptyCollection,
        mascot: MascotState.sleep,
        action: PoppyButton(
          label: 'Browse hadiths',
          onPressed: () =>
              context.canPop() ? context.pop() : context.go('/hadiths'),
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
            PoppyButton(label: 'Try again', onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}
