import 'package:go_router/go_router.dart';

import 'domain/names_kind.dart';
import 'presentation/screens/name_detail_screen.dart';
import 'presentation/screens/names_home_screen.dart';

/// Sub-routes nested under `/practice`. Owned by the Duas + Names agent.
/// Covers BOTH 99 Names of Allah and 99 Names of Muhammad ﷺ.
///
/// Paths (relative): `names`, `names/allah/:id`, `names/muhammad/:id`.
final namesSubRoutes = <RouteBase>[
  GoRoute(
    path: 'names',
    builder: (_, __) => const NamesHomeScreen(),
    routes: [
      GoRoute(
        path: 'allah/:id',
        builder: (_, state) => NameDetailScreen(
          kind: NamesKind.allah,
          id: int.tryParse(state.pathParameters['id'] ?? '') ?? 1,
        ),
      ),
      GoRoute(
        path: 'muhammad/:id',
        builder: (_, state) => NameDetailScreen(
          kind: NamesKind.muhammad,
          id: int.tryParse(state.pathParameters['id'] ?? '') ?? 1,
        ),
      ),
    ],
  ),
];
