import 'package:go_router/go_router.dart';

import 'presentation/screens/story_collection_screen.dart';
import 'presentation/screens/story_detail_screen.dart';
import 'presentation/screens/story_favorites_screen.dart';
import 'presentation/screens/story_search_screen.dart';

/// Sub-routes nested under `/hadiths/hindu-stories` (the reserved anchor
/// segment from `Routes.hinduStories`). Mirrors
/// `hindu_scriptures_routes.dart`'s shape and its go_router gotcha: these
/// are relative child segments of that anchor, not independent top-level
/// paths.
///
/// Paths (relative, nested under `/hadiths/hindu-stories`):
/// * `favorites` — saved stories.
/// * `search` — server-side search.
/// * `collection/:slug` — a collection's story list.
/// * `:id` — a single story, addressed by UUID.
final hinduStoriesSubRoutes = <RouteBase>[
  GoRoute(
    path: 'favorites',
    builder: (_, __) => const StoryFavoritesScreen(),
  ),
  GoRoute(
    path: 'search',
    builder: (_, __) => const StorySearchScreen(),
  ),
  GoRoute(
    path: 'collection/:slug',
    builder: (_, state) =>
        StoryCollectionScreen(collectionSlug: state.pathParameters['slug']!),
  ),
  GoRoute(
    path: ':id',
    builder: (_, state) =>
        StoryDetailScreen(storyId: state.pathParameters['id']!),
  ),
];
