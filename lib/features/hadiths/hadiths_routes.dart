import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../shared/widgets/hindu_coming_soon_placeholder.dart';
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
/// `/hadiths/hindu-stories` is a reserved relative anchor for the
/// `hindu_stories` module's own sub-routes once C7 lands — not an
/// independent top-level path; both faiths' landing content lives at the
/// single shared `/hadiths` path above, switched by [FaithTabRouter].
final hadithsRoutes = <RouteBase>[
  GoRoute(
    path: Routes.hadiths,
    builder: (_, __) => FaithTabRouter(
      islam: (_) => const HadithsHomeScreen(),
      hindu: (_) => const HinduComingSoonPlaceholder(label: 'Stories'),
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
        builder: (_, __) => const HinduComingSoonPlaceholder(label: 'Stories'),
        routes: const <RouteBase>[],
      ),
    ],
  ),
];
