// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hindu_festival.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HinduFestival _$HinduFestivalFromJson(Map<String, dynamic> json) =>
    _HinduFestival(
      id: json['id'] as String,
      slug: json['slug'] as String,
      nameEnglish: json['nameEnglish'] as String,
      nameSanskrit: json['nameSanskrit'] as String?,
      nameHindi: json['nameHindi'] as String?,
      deityKey: json['deityKey'] as String?,
      regions:
          (json['regions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      description: json['description'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$HinduFestivalToJson(_HinduFestival instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'nameEnglish': instance.nameEnglish,
      'nameSanskrit': instance.nameSanskrit,
      'nameHindi': instance.nameHindi,
      'deityKey': instance.deityKey,
      'regions': instance.regions,
      'description': instance.description,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
