import 'package:go_router/go_router.dart';

import '../calendar/calendar_routes.dart';
import '../hindu_panchang/hindu_panchang_routes.dart';
import '../hindu_puja_times/hindu_puja_times_routes.dart';
import '../prayers/prayers_routes.dart';
import 'presentation/screens/today_screen.dart';

/// Today tab — owns prayer detail, calendar, panchang, and puja-times
/// sub-routes via nesting.
final todayRoutes = <RouteBase>[
  GoRoute(
    path: '/today',
    builder: (_, __) => const TodayScreen(),
    routes: [
      ...prayersSubRoutes,
      ...calendarSubRoutes,
      ...hinduPanchangSubRoutes,
      ...hinduPujaTimesSubRoutes,
    ],
  ),
];
