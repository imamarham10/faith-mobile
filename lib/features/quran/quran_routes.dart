import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../shared/widgets/hindu_coming_soon_placeholder.dart';
import '../shell/faith_tab_router.dart';
import 'presentation/screens/bookmarks_screen.dart';
import 'presentation/screens/quran_home_screen.dart';
import 'presentation/screens/surah_reader_screen.dart';

/// Routes for the Quran/Scripture tab (shared branch — see
/// [FaithTabRouter]).
///
/// Paths:
/// * `/quran` — surah index + search + last-read resume + bookmarks shortcut
///   (Islam), or the Hindu scriptures placeholder until Part C's C2 task
///   lands, switched by [FaithTabRouter].
/// * `/quran/surah/:id` — continuous reader with audio mini-player.
///   Optional query: `?ayah=<n>` jumps to and highlights a specific verse.
/// * `/quran/bookmarks` — saved verses with swipe-to-delete.
/// * `/quran/hindu-scripture` — reserved anchor for the `hindu_scriptures`
///   module's own sub-routes once C2 lands (a relative child segment, not
///   an independent top-level path — the tab's landing content for both
///   faiths lives at the single shared `/quran` path above, switched by
///   [FaithTabRouter]).
final quranRoutes = <RouteBase>[
  GoRoute(
    path: Routes.quran,
    builder: (_, __) => FaithTabRouter(
      islam: (_) => const QuranHomeScreen(),
      hindu: (_) => const HinduComingSoonPlaceholder(label: 'Scripture'),
    ),
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
      GoRoute(
        path: Routes.hinduScripture,
        builder: (_, __) =>
            const HinduComingSoonPlaceholder(label: 'Scripture'),
        routes: const <RouteBase>[],
      ),
    ],
  ),
];
