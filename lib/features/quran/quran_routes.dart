import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../hindu_scriptures/hindu_scriptures_routes.dart';
import '../hindu_scriptures/presentation/screens/bookmarks_screen.dart'
    as hindu_scriptures;
import '../hindu_scriptures/presentation/screens/hindu_scriptures_home_screen.dart';
import '../shell/faith_tab_router.dart';
import 'presentation/screens/bookmarks_screen.dart';
import 'presentation/screens/quran_home_screen.dart';
import 'presentation/screens/surah_reader_screen.dart';

/// Routes for the Quran/Scripture tab (shared branch — see
/// [FaithTabRouter]).
///
/// Paths:
/// * `/quran` — surah index + search + last-read resume + bookmarks shortcut
///   (Islam), or the scripture text index (Hindu), switched by
///   [FaithTabRouter].
/// * `/quran/surah/:id` — continuous reader with audio mini-player.
///   Optional query: `?ayah=<n>` jumps to and highlights a specific verse.
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
