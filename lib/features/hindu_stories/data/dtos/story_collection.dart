import 'package:freezed_annotation/freezed_annotation.dart';

part 'story_collection.freezed.dart';
part 'story_collection.g.dart';

/// A story collection — `GET /collections`. Mirrors hadiths' `HadithBook`
/// role, but without an author field (these are traditional/epic sources,
/// not attributed compilers) and with `sourceText` naming which underlying
/// text the collection draws from (`ramayana`, `bhagavata_purana`, ...).
@freezed
abstract class StoryCollection with _$StoryCollection {
  const factory StoryCollection({
    required String id,
    required String slug,
    required String name,
    required String sourceText,
    @Default(false) bool isPremium,
    DateTime? createdAt,
    @Default(0) int storyCount,
  }) = _StoryCollection;

  factory StoryCollection.fromJson(Map<String, dynamic> json) =>
      _$StoryCollectionFromJson(json);
}

/// Minimal collection reference nested on story list/detail payloads.
@freezed
abstract class StoryCollectionRef with _$StoryCollectionRef {
  const factory StoryCollectionRef({
    required String slug,
    required String name,
    required String sourceText,
  }) = _StoryCollectionRef;

  factory StoryCollectionRef.fromJson(Map<String, dynamic> json) =>
      _$StoryCollectionRefFromJson(json);
}
