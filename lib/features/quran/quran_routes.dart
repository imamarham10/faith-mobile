import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../hindu_scriptures/hindu_scriptures_routes.dart';
import '../hindu_scriptures/presentation/screens/bookmarks_screen.dart'
    as hindu_scriptures;
import '../hindu_scriptures/presentation/screens/hindu_scriptures_home_screen.dart';
import '../collections/presentation/screens/collection_screen.dart';
import '../shell/faith_tab_router.dart';
import 'presentation/screens/bookmarks_screen.dart';
import 'presentation/screens/juz_reader_screen.dart';
import 'presentation/screens/quran_home_screen.dart';
import 'presentation/screens/surah_reader_screen.dart';
import 'presentation/screens/surah_verse_reader_screen.dart';

/// Routes for the Quran/Scripture tab (shared branch — see
/// [FaithTabRouter]).
///
/// Paths:
/// * `/quran` — surah index + search + last-read resume + bookmarks shortcut
///   (Islam), or the scripture text index (Hindu), switched by
///   [FaithTabRouter].
/// * `/quran/surah/:id` — continuous reader with audio mini-player.
///   Optional query: `?ayah=<n>` jumps to and highlights a specific verse.
/// * `/quran/surah/:id/verses` — the same surah one verse at a time.
///   Optional query: `?from=<n>` opens on a verse; `?from=<a>&to=<b>`
///   fences the reader to a span, which is how a curated passage like
///   2:285-286 is read. Which of the two surah readers a tap opens is the
///   user's remembered [ReadingMode].
/// * `/quran/collection/:slug` — a curated set, e.g. `nightly-recitation`
///   (Islam) or `gita-daily` (Hindu). Faith-neutral: the screen resolves
///   the vertical from the selected faith, the way `/quran` itself does.
/// * `/quran/juz/:number` — the juz reader: one verse at a time, back and
///   forward across surah boundaries. Islam only; the Hindu branch of this
///   tab never links to it.
/// * `/quran/bookmarks` — saved verses with swipe-to-delete (Islam), or
///   saved scripture verses (Hindu), switched by [FaithTabRouter].
/// * `/quran/hindu-scripture/:slug`, `/quran/hindu-scripture/:slug/:chapter`
///   — the `hindu_scriptures` module's chapter picker and reader. Relative
///   child segments, not independent top-level paths.
final quranRoutes = <RouteBase>[
  GoRoute(
    path: Routes.quran,
    builder: (_, __) => FaithTabRouter(
      islam: (_) => const QuranHomeScreen(),
      hindu: (_) => const HinduScripturesHomeScreen(),
    ),
    routes: [
      GoRoute(
        path: 'surah/:id',
        builder: (_, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 1;
          final ayah = int.tryParse(state.uri.queryParameters['ayah'] ?? '');
          return SurahReaderScreen(surahId: id, initialAyah: ayah);
        },
        routes: [
          GoRoute(
            path: 'verses',
            builder: (_, state) {
              final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 1;
              final q = state.uri.queryParameters;
              // Unparseable bounds are dropped rather than defaulted: a
              // bad `to` must not fence the reader to a span nobody asked
              // for, and the screen already clamps whatever survives to
              // the verses the surah actually has.
              return SurahVerseReaderScreen(
                surahId: id,
                from: int.tryParse(q['from'] ?? ''),
                to: int.tryParse(q['to'] ?? ''),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: 'collection/:slug',
        builder: (_, state) =>
            CollectionScreen(slug: state.pathParameters['slug'] ?? ''),
      ),
      GoRoute(
        path: 'juz/:number',
        builder: (_, state) {
          // The contract rejects anything outside 1-30 with a 400. Clamping
          // here means a hand-typed or stale deep link lands on a real juz
          // instead of an error screen.
          final raw = int.tryParse(state.pathParameters['number'] ?? '') ?? 1;
          return JuzReaderScreen(juzNumber: raw.clamp(1, 30));
        },
      ),
      GoRoute(
        path: 'bookmarks',
        builder: (_, __) => FaithTabRouter(
          islam: (_) => const BookmarksScreen(),
          hindu: (_) => const hindu_scriptures.HinduScripturesBookmarksScreen(),
        ),
      ),
      GoRoute(
        path: Routes.hinduScripture,
        // Bare `/quran/hindu-scripture` is never linked to directly — only
        // its `:slug`/`:slug/:chapter` children are — but GoRoute requires
        // a builder, pageBuilder, or redirect even so. A `redirect` here
        // would be the wrong choice: go_router applies a parent route's
        // redirect to every matched sub-route too ("parent route's redirect
        // takes priority over sub-route's" — go_router docs), which would
        // bounce `/quran/hindu-scripture/:slug` back to `/quran` before the
        // child ever renders. A builder only fires when this exact bare
        // path is matched, so it's safe as a same-content fallback.
        builder: (_, __) => const HinduScripturesHomeScreen(),
        routes: hinduScriptureSubRoutes,
      ),
    ],
  ),
];
