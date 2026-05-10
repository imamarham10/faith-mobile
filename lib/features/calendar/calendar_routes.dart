import 'package:go_router/go_router.dart';

import 'presentation/screens/calendar_screen.dart';
import 'presentation/screens/event_detail_screen.dart';

/// Sub-routes nested under `/today`. Owned by the Prayers + Calendar agent.
///
/// Resolved paths:
/// * `/today/calendar` — month view + Islamic events
/// * `/today/calendar/event/:id` — event detail
final calendarSubRoutes = <RouteBase>[
  GoRoute(
    path: 'calendar',
    builder: (_, __) => const CalendarScreen(),
    routes: [
      GoRoute(
        path: 'event/:id',
        builder: (_, state) =>
            EventDetailScreen(id: state.pathParameters['id'] ?? ''),
      ),
    ],
  ),
];
