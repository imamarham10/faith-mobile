// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_collection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StoryCollection _$StoryCollectionFromJson(Map<String, dynamic> json) =>
    _StoryCollection(
      id: json['id'] as String,
      slug: json['slug'] as String,
      name: json['name'] as String,
      sourceText: json['sourceText'] as String,
      isPremium: json['isPremium'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      storyCount: (json['storyCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$StoryCollectionToJson(_StoryCollection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'name': instance.name,
      'sourceText': instance.sourceText,
      'isPremium': instance.isPremium,
      'createdAt': instance.createdAt?.toIso8601String(),
      'storyCount': instance.storyCount,
    };

_StoryCollectionRef _$StoryCollectionRefFromJson(Map<String, dynamic> json) =>
    _StoryCollectionRef(
      slug: json['slug'] as String,
      name: json['name'] as String,
      sourceText: json['sourceText'] as String,
    );

Map<String, dynamic> _$StoryCollectionRefToJson(_StoryCollectionRef instance) =>
    <String, dynamic>{
      'slug': instance.slug,
      'name': instance.name,
      'sourceText': instance.sourceText,
    };
