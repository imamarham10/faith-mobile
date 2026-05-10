// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'divine_name.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DivineName _$DivineNameFromJson(Map<String, dynamic> json) => _DivineName(
  id: (json['id'] as num).toInt(),
  nameArabic: json['nameArabic'] as String,
  nameTranslit: json['nameTranslit'] as String,
  nameEnglish: json['nameEnglish'] as String,
  meaning: json['meaning'] as String?,
  description: json['description'] as String?,
  audioUrl: json['audioUrl'] as String?,
);

Map<String, dynamic> _$DivineNameToJson(_DivineName instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nameArabic': instance.nameArabic,
      'nameTranslit': instance.nameTranslit,
      'nameEnglish': instance.nameEnglish,
      'meaning': instance.meaning,
      'description': instance.description,
      'audioUrl': instance.audioUrl,
    };
