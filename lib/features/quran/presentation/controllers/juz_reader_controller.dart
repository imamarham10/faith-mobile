import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/dtos/juz.dart';
import '../../data/juz_repository.dart';

part 'juz_reader_controller.g.dart';

/// One verse at a time inside one juz.
///
/// ## Why the cursor is a juz-wide index
///
/// The only coordinate this reader navigates by is `indexInJuz` — 1-based
/// across the whole juz. Everything else about a verse's identity resets
/// under it: `verseNumber` goes back to 1 at every surah boundary, and juz
/// 30 crosses 37 of them. Holding an absolute index means crossing a surah
/// is not a case the navigation code handles at all — the cursor advances,
/// the next verse carries a different `surahId`/`surahName`, and the header
/// re-renders. There is no boundary branch to get wrong.
///
/// It also makes the two things the user sees fall straight out:
/// * position in surah — the verse's own `verseNumber`
/// * verses left in juz — [versesLeft], `verseCount - cursor`
class JuzReaderState {
  const JuzReaderState({
    required this.juzNumber,
    required this.cursor,
    required this.verseCount,
    required this.limit,
    required this.totalPages,
    required this.pages,
  });

  final int juzNumber;

  /// 1-based `indexInJuz` of the verse on screen.
  final int cursor;

  /// Verses in the whole juz, from the server. Forward navigation stops here.
  final int verseCount;

  /// Page size the server actually used, echoed back on every page. Taken
  /// from the response rather than assumed, so the client keeps working if
  /// the default moves off 50.
  final int limit;

  final int totalPages;

  /// Sparse: page number -> that page's verses. Pages arrive out of order
  /// (a prefetch can land before the page being read) and gaps are normal.
  ///
  /// Nothing is evicted. A juz is at most ~564 verses — twelve pages at the
  /// default limit — and the whole of the longest one is a few hundred
  /// kilobytes of text held only while this reader is on screen. An eviction
  /// policy here could only ever cost correctness (dropping the page under
  /// the cursor) to save an amount of memory that does not matter.
  final Map<int, List<JuzVerse>> pages;

  /// Page holding a given 1-based juz index.
  int pageOf(int index) => ((index - 1) ~/ limit) + 1;

  /// Offset of a given 1-based juz index within its page.
  int offsetOf(int index) => (index - 1) % limit;

  int get currentPage => pageOf(cursor);

  /// The verse on screen, or null while its page is still in flight.
  JuzVerse? get currentVerse {
    final page = pages[currentPage];
    if (page == null) return null;
    final offset = offsetOf(cursor);
    if (offset < 0 || offset >= page.length) return null;
    return page[offset];
  }

  bool get canGoBack => cursor > 1;

  bool get canGoForward => cursor < verseCount;

  /// Verses after this one in the juz. Zero on the last verse — the UI says
  /// "Last verse" there rather than "0 verses left".
  int get versesLeft => verseCount - cursor;

  JuzReaderState copyWith({int? cursor, Map<int, List<JuzVerse>>? pages}) {
    return JuzReaderState(
      juzNumber: juzNumber,
      cursor: cursor ?? this.cursor,
      verseCount: verseCount,
      limit: limit,
      totalPages: totalPages,
      pages: pages ?? this.pages,
    );
  }
}

/// Drives [JuzReaderState]: loads the first page, then keeps the pages
/// either side of the cursor resident so a step forward never waits.
@riverpod
class JuzReaderController extends _$JuzReaderController {
  /// Pages currently being fetched, so a prefetch and an arrival-load of the
  /// same page cannot both go out.
  final _inFlight = <int>{};

  /// Pages that arrived before [state] was first assigned. See [_flush].
  final _pending = <JuzPage>[];

  /// Bumped on every [build]. An in-flight fetch started before a refresh
  /// carries the old value and drops its result rather than merging a page
  /// into a state it no longer belongs to.
  int _generation = 0;

  bool _disposed = false;

  @override
  Future<JuzReaderState> build(int juzNumber) async {
    // Riverpod keeps one notifier instance across rebuilds, so the caches
    // below outlive a refresh unless they are cleared here. Dispose
    // callbacks registered during build run *before* the next build, which
    // is what makes resetting `_disposed` here correct rather than racy.
    _generation++;
    _disposed = false;
    _inFlight.clear();
    _pending.clear();
    ref.onDispose(() => _disposed = true);

    final repo = ref.watch(juzRepositoryProvider);
    final first = await repo.getJuzPage(juzNumber, page: 1);
    final initial = JuzReaderState(
      juzNumber: juzNumber,
      cursor: 1,
      verseCount: first.verseCount,
      limit: first.limit,
      totalPages: first.totalPages,
      pages: {first.page: first.verses},
    );
    // Start page 2 before anyone has read a word of page 1. Fifty taps of
    // lead time is as much warning as this reader will ever get, and taking
    // all of it is what keeps a spinner off the screen at verse 51.
    unawaited(_fetch(2, totalPages: initial.totalPages));
    return initial;
  }

  /// Moves one verse forward. No-op on the last verse of the juz.
  void next() {
    _flush();
    final current = state.valueOrNull;
    if (current == null || !current.canGoForward) return;
    _moveTo(current, current.cursor + 1);
  }

  /// Moves one verse back. No-op on the first verse of the juz.
  void previous() {
    _flush();
    final current = state.valueOrNull;
    if (current == null || !current.canGoBack) return;
    _moveTo(current, current.cursor - 1);
  }

  void _moveTo(JuzReaderState current, int index) {
    final moved = current.copyWith(cursor: index);
    state = AsyncValue.data(moved);

    final page = moved.currentPage;
    // Only one of these can actually be missing after a single step, but
    // asking for all three is how a resumed or jumped-to cursor heals too.
    for (final p in [page, page + 1, page - 1]) {
      unawaited(_fetch(p, totalPages: moved.totalPages));
    }
  }

  /// Fetches one page unless it is already loaded, already in flight, or out
  /// of range. Failures are swallowed: a prefetch that fails costs nothing,
  /// and a page the reader actually reaches is retried on the next step.
  Future<void> _fetch(int page, {required int totalPages}) async {
    if (page < 1 || page > totalPages) return;
    if (state.valueOrNull?.pages.containsKey(page) ?? false) return;
    if (!_inFlight.add(page)) return;
    final generation = _generation;
    try {
      final loaded = await ref
          .read(juzRepositoryProvider)
          .getJuzPage(juzNumber, page: page);
      if (_disposed || generation != _generation) return;
      _pending.add(loaded);
      _flush();
    } catch (_) {
      // Best effort — see above.
    } finally {
      if (generation == _generation) _inFlight.remove(page);
    }
  }

  /// Merges arrived pages into [state].
  ///
  /// The queue exists because [build] starts page 2 *before* it returns, so
  /// that fetch can resolve while [state] is still `AsyncLoading` and has
  /// nothing to merge into. Rather than race the framework, such a page
  /// waits here and is folded in by the next flush — which both [next] and
  /// [previous] run before reading the cursor, and every later arrival runs
  /// itself.
  void _flush() {
    if (_disposed || _pending.isEmpty) return;
    final current = state.valueOrNull;
    if (current == null) return;
    final merged = Map<int, List<JuzVerse>>.of(current.pages);
    for (final page in _pending) {
      merged.putIfAbsent(page.page, () => page.verses);
    }
    _pending.clear();
    state = AsyncValue.data(current.copyWith(pages: merged));
  }
}
