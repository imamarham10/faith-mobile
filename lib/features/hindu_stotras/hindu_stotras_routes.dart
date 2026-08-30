import 'package:go_router/go_router.dart';

import 'presentation/screens/stotra_category_screen.dart';
import 'presentation/screens/stotra_detail_screen.dart';
import 'presentation/screens/stotra_favorites_screen.dart';
import 'presentation/screens/stotras_home_screen.dart';

/// Sub-routes nested under `/practice`. Mirrors `duas_routes.dart`'s shape
/// and path convention.
///
/// Paths (relative): `stotras`, `stotras/favorites`, `stotras/category/:slug`,
/// `stotras/:slug`. `favorites` and `category/:slug` come before the bare
/// `:slug` route so they aren't swallowed by the dynamic segment — same
/// ordering constraint as duas (and the backend's own stotras controller).
final hinduStotrasSubRoutes = <RouteBase>[
  GoRoute(
    path: 'stotras',
    builder: (_, __) => const StotrasHomeScreen(),
    routes: [
      GoRoute(
        path: 'favorites',
        builder: (_, __) => const StotraFavoritesScreen(),
      ),
      GoRoute(
        path: 'category/:slug',
        builder: (_, state) => StotraCategoryScreen(
          categorySlug: state.pathParameters['slug']!,
        ),
      ),
      GoRoute(
        path: ':slug',
        builder: (_, state) =>
            StotraDetailScreen(slug: state.pathParameters['slug']!),
      ),
    ],
  ),
];
