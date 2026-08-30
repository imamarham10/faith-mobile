import 'package:go_router/go_router.dart';

import 'presentation/screens/puja_times_screen.dart';

/// Sub-routes nested under `/today`. Mirrors `prayers_routes.dart`'s shape,
/// minus the `qaza` sub-route — there's no qada-equivalent tracker screen
/// for puja times (see `PujaStatus`'s doc comment).
///
/// Paths (relative): `puja-times`.
final hinduPujaTimesSubRoutes = <RouteBase>[
  GoRoute(
    path: 'puja-times',
    builder: (_, __) => const PujaTimesScreen(),
  ),
];
