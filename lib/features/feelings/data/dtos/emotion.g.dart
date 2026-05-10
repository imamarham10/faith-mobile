// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emotion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Emotion _$EmotionFromJson(Map<String, dynamic> json) => _Emotion(
  id: json['id'] as String,
  name: json['name'] as String,
  slug: json['slug'] as String,
  icon: json['icon'] as String?,
  description: json['description'] as String?,
);

Map<String, dynamic> _$EmotionToJson(_Emotion instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'slug': instance.slug,
  'icon': instance.icon,
  'description': instance.description,
};
