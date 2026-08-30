import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/dtos/hindu_story.dart';
import '../../data/hindu_stories_repository.dart';

part 'stories_by_collection_controller.g.dart';

/// All stories inside a specific collection (by slug). Cached so back-nav
/// is instant.
@Riverpod(keepAlive: true)
Future<List<HinduStory>> storiesByCollection(Ref ref, String collectionSlug) {
  final repo = ref.watch(hinduStoriesRepositoryProvider);
  return repo.getStories(collection: collectionSlug);
}

/// Server-side search across all stories. Not `keepAlive` — per-query
/// results aren't worth caching indefinitely.
@riverpod
Future<List<HinduStory>> storiesSearch(Ref ref, String query) async {
  final trimmed = query.trim();
  if (trimmed.length < 2) return const <HinduStory>[];
  final repo = ref.watch(hinduStoriesRepositoryProvider);
  return repo.search(trimmed);
}
