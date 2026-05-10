// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Verse _$VerseFromJson(Map<String, dynamic> json) => _Verse(
  id: json['id'] as String,
  surahId: (json['surahId'] as num).toInt(),
  verseNumber: (json['verseNumber'] as num).toInt(),
  textArabic: json['textArabic'] as String,
  textSimple: json['textSimple'] as String?,
  translations:
      (json['translations'] as List<dynamic>?)
          ?.map((e) => Translation.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Translation>[],
);

Map<String, dynamic> _$VerseToJson(_Verse instance) => <String, dynamic>{
  'id': instance.id,
  'surahId': instance.surahId,
  'verseNumber': instance.verseNumber,
  'textArabic': instance.textArabic,
  'textSimple': instance.textSimple,
  'translations': instance.translations,
};

_SurahDetail _$SurahDetailFromJson(Map<String, dynamic> json) => _SurahDetail(
  id: (json['id'] as num).toInt(),
  nameArabic: json['nameArabic'] as String,
  nameEnglish: json['nameEnglish'] as String,
  verses:
      (json['verses'] as List<dynamic>?)
          ?.map((e) => Verse.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Verse>[],
);

Map<String, dynamic> _$SurahDetailToJson(_SurahDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nameArabic': instance.nameArabic,
      'nameEnglish': instance.nameEnglish,
      'verses': instance.verses,
    };
