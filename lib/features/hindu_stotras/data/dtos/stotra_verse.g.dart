// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stotra_verse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StotraVerse _$StotraVerseFromJson(Map<String, dynamic> json) => _StotraVerse(
  id: json['id'] as String,
  stotraId: json['stotraId'] as String,
  verseNumber: (json['verseNumber'] as num).toInt(),
  sanskritText: json['sanskritText'] as String,
  transliteration: json['transliteration'] as String?,
  translations:
      (json['translations'] as List<dynamic>?)
          ?.map((e) => StotraTranslation.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <StotraTranslation>[],
);

Map<String, dynamic> _$StotraVerseToJson(_StotraVerse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'stotraId': instance.stotraId,
      'verseNumber': instance.verseNumber,
      'sanskritText': instance.sanskritText,
      'transliteration': instance.transliteration,
      'translations': instance.translations,
    };
