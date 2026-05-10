import 'package:go_router/go_router.dart';

import 'presentation/screens/dua_category_screen.dart';
import 'presentation/screens/dua_detail_screen.dart';
import 'presentation/screens/dua_favorites_screen.dart';
import 'presentation/screens/duas_home_screen.dart';

/// Sub-routes nested under `/practice`. Owned by the Duas + Names agent.
///
/// Paths (relative): `duas`, `duas/favorites`, `duas/category/:id`, `duas/:id`.
/// `favorites` and `category/:id` come before the bare `:id` route so they
/// aren't swallowed by the dynamic segment.
final duasSubRoutes = <RouteBase>[
  GoRoute(
    path: 'duas',
    builder: (_, __) => const DuasHomeScreen(),
    routes: [
      GoRoute(
        path: 'favorites',
        builder: (_, __) => const DuaFavoritesScreen(),
      ),
      GoRoute(
        path: 'category/:id',
        builder: (_, state) =>
            DuaCategoryScreen(categoryId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: ':id',
        builder: (_, state) =>
            DuaDetailScreen(duaId: state.pathParameters['id']!),
      ),
    ],
  ),
];
