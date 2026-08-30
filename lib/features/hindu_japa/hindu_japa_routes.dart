import 'package:go_router/go_router.dart';

import 'presentation/screens/japa_counter_screen.dart';
import 'presentation/screens/japa_goals_screen.dart';
import 'presentation/screens/japa_history_screen.dart';
import 'presentation/screens/japa_home_screen.dart';

/// Sub-routes nested under `/practice`. Mirrors `dhikr_routes.dart`'s shape
/// and path convention — plain literal-string segments unconditionally
/// merged into `practiceRoutes`, not gated by `FaithTabRouter` (Practice's
/// home screen switches content by faith itself instead; see C9).
///
/// Paths (relative): `japa`, `japa/counter/:id`, `japa/goals`,
/// `japa/history`.
final hinduJapaSubRoutes = <RouteBase>[
  GoRoute(
    path: 'japa',
    builder: (_, __) => const JapaHomeScreen(),
    routes: [
      GoRoute(
        path: 'counter/:id',
        builder: (_, state) =>
            JapaCounterScreen(id: state.pathParameters['id'] ?? ''),
      ),
      GoRoute(path: 'goals', builder: (_, __) => const JapaGoalsScreen()),
      GoRoute(path: 'history', builder: (_, __) => const JapaHistoryScreen()),
    ],
  ),
];
