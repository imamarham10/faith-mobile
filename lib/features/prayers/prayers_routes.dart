import 'package:go_router/go_router.dart';

import 'presentation/screens/prayer_detail_screen.dart';
import 'presentation/screens/qaza_tracker_screen.dart';

/// Sub-routes nested under `/today`. Owned by the Prayers + Calendar agent.
///
/// Resolved paths:
/// * `/today/prayers` — prayer detail (full schedule)
/// * `/today/prayers/qaza` — qaḍāʾ tracker
final prayersSubRoutes = <RouteBase>[
  GoRoute(
    path: 'prayers',
    builder: (_, __) => const PrayerDetailScreen(),
    routes: [
      GoRoute(path: 'qaza', builder: (_, __) => const QazaTrackerScreen()),
    ],
  ),
];
