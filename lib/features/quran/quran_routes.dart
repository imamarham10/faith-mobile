import 'package:go_router/go_router.dart';

import 'presentation/screens/bookmarks_screen.dart';
import 'presentation/screens/quran_home_screen.dart';
import 'presentation/screens/surah_reader_screen.dart';

/// Routes for the Quran tab.
///
/// Paths:
/// * `/quran` — surah index + search + last-read resume + bookmarks shortcut
/// * `/quran/surah/:id` — continuous reader with audio mini-player.
///   Optional query: `?ayah=<n>` jumps to and highlights a specific verse.
/// * `/quran/bookmarks` — saved verses with swipe-to-delete.
final quranRoutes = <RouteBase>[
  GoRoute(
    path: '/quran',
    builder: (_, __) => const QuranHomeScreen(),
    routes: [
      GoRoute(
        path: 'surah/:id',
        builder: (_, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 1;
          final ayah = int.tryParse(state.uri.queryParameters['ayah'] ?? '');
          return SurahReaderScreen(surahId: id, initialAyah: ayah);
        },
      ),
      GoRoute(path: 'bookmarks', builder: (_, __) => const BookmarksScreen()),
    ],
  ),
];
