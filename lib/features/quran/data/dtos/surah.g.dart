// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'surah.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Surah _$SurahFromJson(Map<String, dynamic> json) => _Surah(
  id: (json['id'] as num).toInt(),
  nameArabic: json['nameArabic'] as String,
  nameEnglish: json['nameEnglish'] as String,
  nameTransliteration: json['nameTransliteration'] as String,
  revelationPlace: json['revelationPlace'] as String,
  verseCount: (json['verseCount'] as num).toInt(),
);

Map<String, dynamic> _$SurahToJson(_Surah instance) => <String, dynamic>{
  'id': instance.id,
  'nameArabic': instance.nameArabic,
  'nameEnglish': instance.nameEnglish,
  'nameTransliteration': instance.nameTransliteration,
  'revelationPlace': instance.revelationPlace,
  'verseCount': instance.verseCount,
};
