import 'package:go_router/go_router.dart';

import 'presentation/screens/dhikr_counter_screen.dart';
import 'presentation/screens/dhikr_goals_screen.dart';
import 'presentation/screens/dhikr_history_screen.dart';
import 'presentation/screens/dhikr_home_screen.dart';

/// Sub-routes nested under `/practice`. Owned by the Dhikr + Practice agent.
///
/// Paths (relative): `dhikr`, `dhikr/counter/:id`, `dhikr/goals`,
/// `dhikr/history`. Matches the contract specified in `practice_routes.dart`.
final dhikrSubRoutes = <RouteBase>[
  GoRoute(
    path: 'dhikr',
    builder: (_, __) => const DhikrHomeScreen(),
    routes: [
      GoRoute(
        path: 'counter/:id',
        builder: (_, state) =>
            DhikrCounterScreen(id: state.pathParameters['id'] ?? ''),
      ),
      GoRoute(path: 'goals', builder: (_, __) => const DhikrGoalsScreen()),
      GoRoute(path: 'history', builder: (_, __) => const DhikrHistoryScreen()),
    ],
  ),
];
