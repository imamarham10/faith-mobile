// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dua_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DuaCategory _$DuaCategoryFromJson(Map<String, dynamic> json) => _DuaCategory(
  id: json['id'] as String,
  name: json['name'] as String,
  nameArabic: json['nameArabic'] as String?,
  description: json['description'] as String?,
  count: (json['count'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$DuaCategoryToJson(_DuaCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'nameArabic': instance.nameArabic,
      'description': instance.description,
      'count': instance.count,
    };
