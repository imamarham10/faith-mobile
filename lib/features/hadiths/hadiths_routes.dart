import 'package:go_router/go_router.dart';

import 'presentation/screens/hadith_book_screen.dart';
import 'presentation/screens/hadith_detail_screen.dart';
import 'presentation/screens/hadith_search_screen.dart';
import 'presentation/screens/hadiths_home_screen.dart';

/// Routes for the Hadiths tab.
///
/// Path order matters: the static `search` and `book/:id` routes must come
/// before the bare `:id` dynamic segment, otherwise the latter will swallow
/// them. Mirrors the duas/quran convention.
final hadithsRoutes = <RouteBase>[
  GoRoute(
    path: '/hadiths',
    builder: (_, __) => const HadithsHomeScreen(),
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
    ],
  ),
];
