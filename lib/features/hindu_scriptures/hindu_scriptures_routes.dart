import 'package:go_router/go_router.dart';

import 'presentation/screens/chapter_reader_screen.dart';
import 'presentation/screens/chapter_verse_reader_screen.dart';
import 'presentation/screens/text_detail_screen.dart';

/// Sub-routes nested under `/quran/hindu-scripture` (the reserved anchor
/// segment from `Routes.hinduScripture`). The `/quran` path itself is
/// switched by [FaithTabRouter] between [QuranHomeScreen] (Islam) and
/// [HinduScripturesHomeScreen] (Hindu) — see `quran_routes.dart`.
///
/// Paths (all relative, nested under `/quran/hindu-scripture`):
/// * `` (bare) — chapter picker entry via [TextDetailScreen] is reached from
///   the home screen directly with `:slug`; there is no bare index screen
///   here since [HinduScripturesHomeScreen] IS the `/quran` landing content.
/// * `:slug` — [TextDetailScreen], chapter picker for one text.
/// * `:slug/:chapter` — [ChapterReaderScreen], continuous reader. Optional
///   `?verse=<n>` jumps to and highlights a specific verse.
/// * `:slug/:chapter/verses` — [ChapterVerseReaderScreen], one śloka at a
///   time. Optional `?from=<n>` opens on a verse, `?from=<a>&to=<b>` fences
///   the reader to a span.
///
/// Which of the last two a chapter opens in is the user's remembered
/// [ReadingMode]; every entry point resolves it through
/// `chapterReadingRoute` rather than writing a path out.
final hinduScriptureSubRoutes = <RouteBase>[
  GoRoute(
    path: ':slug',
    builder: (_, state) {
      final slug = state.pathParameters['slug']!;
      return TextDetailScreen(slug: slug);
    },
  ),
  GoRoute(
    path: ':slug/:chapter/verses',
    builder: (_, state) {
      final slug = state.pathParameters['slug']!;
      final chapter = int.tryParse(state.pathParameters['chapter'] ?? '') ?? 1;
      final q = state.uri.queryParameters;
      return ChapterVerseReaderScreen(
        textSlug: slug,
        chapterNumber: chapter,
        from: int.tryParse(q['from'] ?? ''),
        to: int.tryParse(q['to'] ?? ''),
      );
    },
  ),
  GoRoute(
    path: ':slug/:chapter',
    builder: (_, state) {
      final slug = state.pathParameters['slug']!;
      final chapter = int.tryParse(state.pathParameters['chapter'] ?? '') ?? 1;
      final verse = int.tryParse(state.uri.queryParameters['verse'] ?? '');
      return ChapterReaderScreen(
        textSlug: slug,
        chapterNumber: chapter,
        initialVerse: verse,
      );
    },
  ),
];
