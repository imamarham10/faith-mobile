import 'package:freezed_annotation/freezed_annotation.dart';

import 'story_collection.dart';

part 'hindu_story.freezed.dart';
part 'hindu_story.g.dart';

/// A story list item — `GET /`, `GET /search`. Lighter than [HinduStoryDetail]:
/// no narrative `body`. Mirrors hadiths' book/hadith split, but with
/// `characters` in place of narrator-chain/grade — these are narrative
/// katha, not citation-graded reports, so there's no "grade" concept here.
///
/// `storyNumber` is nullable at the schema level even though every seeded
/// row currently has one — the backend doesn't guarantee it.
@freezed
abstract class HinduStory with _$HinduStory {
  const factory HinduStory({
    required String id,
    int? storyNumber,
    required String title,
    required String summary,
    String? deityKey,
    @Default(<String>[]) List<String> characters,
    StoryCollectionRef? collection,
  }) = _HinduStory;

  factory HinduStory.fromJson(Map<String, dynamic> json) =>
      _$HinduStoryFromJson(json);
}

/// Full story detail — `GET /:id`. Adds the narrative `body`.
@freezed
abstract class HinduStoryDetail with _$HinduStoryDetail {
  const factory HinduStoryDetail({
    required String id,
    int? storyNumber,
    required String title,
    required String summary,
    required String body,
    String? deityKey,
    @Default(<String>[]) List<String> characters,
    StoryCollectionRef? collection,
  }) = _HinduStoryDetail;

  factory HinduStoryDetail.fromJson(Map<String, dynamic> json) =>
      _$HinduStoryDetailFromJson(json);
}
