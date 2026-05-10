import 'package:go_router/go_router.dart';

import '../calendar/calendar_routes.dart';
import '../prayers/prayers_routes.dart';
import 'presentation/screens/today_screen.dart';

/// Today tab — owns prayer detail and calendar sub-routes via nesting.
final todayRoutes = <RouteBase>[
  GoRoute(
    path: '/today',
    builder: (_, __) => const TodayScreen(),
    routes: [...prayersSubRoutes, ...calendarSubRoutes],
  ),
];
