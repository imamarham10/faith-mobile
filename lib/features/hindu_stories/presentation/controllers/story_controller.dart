import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/dtos/hindu_story.dart';
import '../../data/hindu_stories_repository.dart';

part 'story_controller.g.dart';

/// A single story, by id. `keepAlive` so opening the same story twice in a
/// session is instant.
@Riverpod(keepAlive: true)
Future<HinduStoryDetail> storyById(Ref ref, String id) {
  final repo = ref.watch(hinduStoriesRepositoryProvider);
  return repo.getStory(id);
}
