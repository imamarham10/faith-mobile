import 'package:go_router/go_router.dart';

import '../feelings/feelings_routes.dart';
import 'presentation/screens/reflect_home_screen.dart';

/// Reflect tab — owned by the Reflect/Feelings agent. Hosts the home screen
/// plus journal/history routes nested under `/reflect`.
///
/// Path convention: `/reflect`, `/reflect/feelings/:mood`, `/reflect/journal`,
/// `/reflect/history`.
final reflectRoutes = <RouteBase>[
  GoRoute(
    path: '/reflect',
    builder: (_, __) => const ReflectHomeScreen(),
    routes: [...feelingsSubRoutes],
  ),
];
