import 'package:go_router/go_router.dart';

import '../dhikr/dhikr_routes.dart';
import '../duas/duas_routes.dart';
import '../hindu_japa/hindu_japa_routes.dart';
import '../hindu_stotras/hindu_stotras_routes.dart';
import '../hindu_temples/hindu_temples_routes.dart';
import '../names/names_routes.dart';
import '../qibla/qibla_routes.dart';
import 'presentation/screens/practice_home_screen.dart';

/// Practice tab — hub screen that links to Dhikr, Duas, Names, Qibla
/// (Islam) and Japa, Stotras, Temples (Hindu). Each sub-feature owns its
/// own routes file.
///
/// Path convention: `/practice`, `/practice/dhikr/...`, `/practice/duas/...`,
/// `/practice/names/...`, `/practice/qibla/...`, `/practice/japa/...`,
/// `/practice/stotras/...`, `/practice/temples/...`.
final practiceRoutes = <RouteBase>[
  GoRoute(
    path: '/practice',
    builder: (_, __) => const PracticeHomeScreen(),
    routes: [
      ...dhikrSubRoutes,
      ...duasSubRoutes,
      ...namesSubRoutes,
      ...qiblaSubRoutes,
      ...hinduJapaSubRoutes,
      ...hinduStotrasSubRoutes,
      ...hinduTemplesSubRoutes,
    ],
  ),
];
