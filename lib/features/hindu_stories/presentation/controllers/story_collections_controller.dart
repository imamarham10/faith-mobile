import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/dtos/story_collection.dart';
import '../../data/hindu_stories_repository.dart';

part 'story_collections_controller.g.dart';

/// All story collections, alphabetized server-side.
@Riverpod(keepAlive: true)
Future<List<StoryCollection>> storyCollections(Ref ref) {
  final repo = ref.watch(hinduStoriesRepositoryProvider);
  return repo.getCollections();
}
