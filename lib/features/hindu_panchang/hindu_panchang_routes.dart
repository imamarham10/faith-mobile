import 'package:go_router/go_router.dart';

import 'presentation/screens/festival_detail_screen.dart';
import 'presentation/screens/panchang_day_detail_screen.dart';
import 'presentation/screens/panchang_screen.dart';

/// Sub-routes nested under `/today`. Mirrors `calendar_routes.dart`'s shape
/// and path convention.
///
/// Paths (relative): `panchang`, `panchang/day/:date`,
/// `panchang/festival/:slug`.
final hinduPanchangSubRoutes = <RouteBase>[
  GoRoute(
    path: 'panchang',
    builder: (_, __) => const PanchangScreen(),
    routes: [
      GoRoute(
        path: 'day/:date',
        builder: (_, state) =>
            PanchangDayDetailScreen(date: state.pathParameters['date']!),
      ),
      GoRoute(
        path: 'festival/:slug',
        builder: (_, state) =>
            FestivalDetailScreen(slug: state.pathParameters['slug']!),
      ),
    ],
  ),
];
