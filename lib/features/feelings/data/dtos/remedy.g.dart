// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remedy.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Remedy _$RemedyFromJson(Map<String, dynamic> json) => _Remedy(
  id: json['id'] as String,
  kind: json['kind'] as String?,
  arabicText: json['arabicText'] as String,
  transliteration: json['transliteration'] as String?,
  translation: json['translation'] as String,
  source: json['source'] as String?,
);

Map<String, dynamic> _$RemedyToJson(_Remedy instance) => <String, dynamic>{
  'id': instance.id,
  'kind': instance.kind,
  'arabicText': instance.arabicText,
  'transliteration': instance.transliteration,
  'translation': instance.translation,
  'source': instance.source,
};

_EmotionDetail _$EmotionDetailFromJson(Map<String, dynamic> json) =>
    _EmotionDetail(
      slug: json['slug'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String?,
      description: json['description'] as String?,
      remedies:
          (json['remedies'] as List<dynamic>?)
              ?.map((e) => Remedy.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Remedy>[],
    );

Map<String, dynamic> _$EmotionDetailToJson(_EmotionDetail instance) =>
    <String, dynamic>{
      'slug': instance.slug,
      'name': instance.name,
      'icon': instance.icon,
      'description': instance.description,
      'remedies': instance.remedies,
    };
