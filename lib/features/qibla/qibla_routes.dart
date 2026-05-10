import 'package:go_router/go_router.dart';

import 'presentation/screens/qibla_screen.dart';

/// Sub-routes nested under `/practice`. Owned by the Qibla + Reflect agent.
///
/// Path: `/practice/qibla`.
final qiblaSubRoutes = <RouteBase>[
  GoRoute(path: 'qibla', builder: (_, __) => const QiblaScreen()),
];
