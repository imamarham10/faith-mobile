import 'package:go_router/go_router.dart';

import '../dhikr/dhikr_routes.dart';
import '../duas/duas_routes.dart';
import '../names/names_routes.dart';
import '../qibla/qibla_routes.dart';
import 'presentation/screens/practice_home_screen.dart';

/// Practice tab — hub screen that links to Dhikr, Duas, Names, and Qibla.
/// The Dhikr agent owns the home screen replacement; each sub-feature owns
/// its own routes file.
///
/// Path convention: `/practice`, `/practice/dhikr/...`, `/practice/duas/...`,
/// `/practice/names/...`, `/practice/qibla/...`.
final practiceRoutes = <RouteBase>[
  GoRoute(
    path: '/practice',
    builder: (_, __) => const PracticeHomeScreen(),
    routes: [
      ...dhikrSubRoutes,
      ...duasSubRoutes,
      ...namesSubRoutes,
      ...qiblaSubRoutes,
    ],
  ),
];
