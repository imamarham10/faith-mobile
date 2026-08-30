// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hindu_story.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HinduStory _$HinduStoryFromJson(Map<String, dynamic> json) => _HinduStory(
  id: json['id'] as String,
  storyNumber: (json['storyNumber'] as num?)?.toInt(),
  title: json['title'] as String,
  summary: json['summary'] as String,
  deityKey: json['deityKey'] as String?,
  characters:
      (json['characters'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  collection: json['collection'] == null
      ? null
      : StoryCollectionRef.fromJson(json['collection'] as Map<String, dynamic>),
);

Map<String, dynamic> _$HinduStoryToJson(_HinduStory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'storyNumber': instance.storyNumber,
      'title': instance.title,
      'summary': instance.summary,
      'deityKey': instance.deityKey,
      'characters': instance.characters,
      'collection': instance.collection,
    };

_HinduStoryDetail _$HinduStoryDetailFromJson(Map<String, dynamic> json) =>
    _HinduStoryDetail(
      id: json['id'] as String,
      storyNumber: (json['storyNumber'] as num?)?.toInt(),
      title: json['title'] as String,
      summary: json['summary'] as String,
      body: json['body'] as String,
      deityKey: json['deityKey'] as String?,
      characters:
          (json['characters'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      collection: json['collection'] == null
          ? null
          : StoryCollectionRef.fromJson(
              json['collection'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$HinduStoryDetailToJson(_HinduStoryDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'storyNumber': instance.storyNumber,
      'title': instance.title,
      'summary': instance.summary,
      'body': instance.body,
      'deityKey': instance.deityKey,
      'characters': instance.characters,
      'collection': instance.collection,
    };
