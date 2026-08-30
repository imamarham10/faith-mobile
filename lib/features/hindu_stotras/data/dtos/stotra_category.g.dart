// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stotra_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StotraCategory _$StotraCategoryFromJson(Map<String, dynamic> json) =>
    _StotraCategory(
      id: json['id'] as String,
      slug: json['slug'] as String,
      name: json['name'] as String,
      deityKey: json['deityKey'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      stotraCount: (json['stotraCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$StotraCategoryToJson(_StotraCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'name': instance.name,
      'deityKey': instance.deityKey,
      'createdAt': instance.createdAt?.toIso8601String(),
      'stotraCount': instance.stotraCount,
    };

_StotraCategoryRef _$StotraCategoryRefFromJson(Map<String, dynamic> json) =>
    _StotraCategoryRef(
      slug: json['slug'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$StotraCategoryRefToJson(_StotraCategoryRef instance) =>
    <String, dynamic>{'slug': instance.slug, 'name': instance.name};
