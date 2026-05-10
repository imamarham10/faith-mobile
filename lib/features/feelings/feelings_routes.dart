import 'package:go_router/go_router.dart';

import 'presentation/screens/journal_screen.dart';
import 'presentation/screens/mood_history_screen.dart';
import 'presentation/screens/mood_result_screen.dart';

/// Sub-routes nested under `/reflect`. Owned by the Qibla + Reflect agent.
///
/// Paths (relative): `feelings/:mood`, `journal`, `history`.
final feelingsSubRoutes = <RouteBase>[
  GoRoute(
    path: 'feelings/:mood',
    builder: (_, state) =>
        MoodResultScreen(moodSlug: state.pathParameters['mood'] ?? ''),
  ),
  GoRoute(path: 'journal', builder: (_, __) => const JournalScreen()),
  GoRoute(path: 'history', builder: (_, __) => const MoodHistoryScreen()),
];
