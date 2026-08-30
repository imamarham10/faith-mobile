import 'package:go_router/go_router.dart';

import 'presentation/screens/temple_deity_screen.dart';
import 'presentation/screens/temple_detail_screen.dart';
import 'presentation/screens/temple_favorites_screen.dart';
import 'presentation/screens/temple_search_screen.dart';
import 'presentation/screens/temple_state_screen.dart';
import 'presentation/screens/temples_home_screen.dart';

/// Sub-routes nested under `/practice`. Mirrors `hindu_stotras_routes.dart`'s
/// shape and path convention.
///
/// Paths (relative): `temples`, `temples/favorites`, `temples/search`,
/// `temples/state/:state`, `temples/deity/:deity`, `temples/:id`. Static
/// segments come before the bare `:id` route so they aren't swallowed by
/// the dynamic segment.
final hinduTemplesSubRoutes = <RouteBase>[
  GoRoute(
    path: 'temples',
    builder: (_, __) => const TemplesHomeScreen(),
    routes: [
      GoRoute(
        path: 'favorites',
        builder: (_, __) => const TempleFavoritesScreen(),
      ),
      GoRoute(
        path: 'search',
        builder: (_, __) => const TempleSearchScreen(),
      ),
      GoRoute(
        path: 'state/:state',
        builder: (_, state) =>
            TempleStateScreen(state: state.pathParameters['state']!),
      ),
      GoRoute(
        path: 'deity/:deity',
        builder: (_, state) =>
            TempleDeityScreen(deity: state.pathParameters['deity']!),
      ),
      GoRoute(
        path: ':id',
        builder: (_, state) =>
            TempleDetailScreen(templeId: state.pathParameters['id']!),
      ),
    ],
  ),
];
