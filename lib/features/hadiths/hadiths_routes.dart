import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../hindu_stories/hindu_stories_routes.dart';
import '../hindu_stories/presentation/screens/stories_home_screen.dart';
import '../shell/faith_tab_router.dart';
import 'presentation/screens/hadith_book_screen.dart';
import 'presentation/screens/hadith_detail_screen.dart';
import 'presentation/screens/hadith_search_screen.dart';
import 'presentation/screens/hadiths_home_screen.dart';

/// Routes for the Hadiths/Stories tab (shared branch — see
/// [FaithTabRouter]).
///
/// Path order matters: the static `search` and `book/:id` routes must come
/// before the bare `:id` dynamic segment, otherwise the latter will swallow
/// them. Mirrors the duas/quran convention.
///
/// `/hadiths/hindu-stories` nests the `hindu_stories` module's own
/// sub-routes — not an independent top-level path; both faiths' landing
/// content lives at the single shared `/hadiths` path above, switched by
/// [FaithTabRouter].
final hadithsRoutes = <RouteBase>[
  GoRoute(
    path: Routes.hadiths,
    builder: (_, __) => FaithTabRouter(
      islam: (_) => const HadithsHomeScreen(),
      hindu: (_) => const StoriesHomeScreen(),
    ),
    routes: [
      GoRoute(path: 'search', builder: (_, __) => const HadithSearchScreen()),
      GoRoute(
        path: 'book/:id',
        builder: (_, state) =>
            HadithBookScreen(bookId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: ':id',
        builder: (_, state) =>
            HadithDetailScreen(hadithId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: Routes.hinduStories,
        // Bare path is never linked to directly — only its children are —
        // but GoRoute requires a builder/pageBuilder/redirect regardless. A
        // `redirect` would be wrong here: go_router applies a parent
        // route's redirect to every matched sub-route too, which would
        // bounce `/hadiths/hindu-stories/:id` back to `/hadiths` before the
        // child ever renders (see quran_routes.dart's identical note). A
        // builder only fires when this exact bare path is matched, so it's
        // safe as a same-content fallback.
        builder: (_, __) => const StoriesHomeScreen(),
        routes: hinduStoriesSubRoutes,
      ),
    ],
  ),
];
