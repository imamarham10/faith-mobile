import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/dtos/hadith.dart';
import '../../data/hadiths_repository.dart';

part 'hadiths_by_book_controller.g.dart';

/// Paginated hadith feed for a given book, with manual `loadMore`.
///
/// State is the accumulated list plus pagination metadata. The first page is
/// loaded in [build]; subsequent pages are appended via [loadMore]. We avoid
/// rebuilding the list on every page fetch by toggling [isLoadingMore]
/// independently from `state` so the existing `data` keeps rendering.
class HadithFeed {
  const HadithFeed({
    required this.items,
    required this.page,
    required this.totalPages,
    this.isLoadingMore = false,
  });

  final List<Hadith> items;
  final int page;
  final int totalPages;
  final bool isLoadingMore;

  bool get hasMore => page < totalPages;

  HadithFeed copyWith({
    List<Hadith>? items,
    int? page,
    int? totalPages,
    bool? isLoadingMore,
  }) {
    return HadithFeed(
      items: items ?? this.items,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

const int _kPageSize = 20;

@riverpod
class HadithsByBookController extends _$HadithsByBookController {
  @override
  Future<HadithFeed> build(String bookId) async {
    final repo = ref.watch(hadithsRepositoryProvider);
    final page = await repo.getHadithsByBook(
      bookId: bookId,
      page: 1,
      limit: _kPageSize,
    );
    return HadithFeed(
      items: page.hadiths,
      page: page.page,
      totalPages: page.totalPages,
    );
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    state = AsyncValue.data(current.copyWith(isLoadingMore: true));

    final repo = ref.read(hadithsRepositoryProvider);
    try {
      final next = await repo.getHadithsByBook(
        bookId: bookId,
        page: current.page + 1,
        limit: _kPageSize,
      );
      state = AsyncValue.data(
        current.copyWith(
          items: [...current.items, ...next.hadiths],
          page: next.page,
          totalPages: next.totalPages,
          isLoadingMore: false,
        ),
      );
    } catch (_) {
      // Surface failure quietly — the user can scroll back up and retry.
      state = AsyncValue.data(current.copyWith(isLoadingMore: false));
    }
  }
}
