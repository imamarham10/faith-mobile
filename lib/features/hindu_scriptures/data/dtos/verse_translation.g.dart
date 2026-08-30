// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verse_translation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VerseTranslation _$VerseTranslationFromJson(Map<String, dynamic> json) =>
    _VerseTranslation(
      id: json['id'] as String,
      languageCode: json['languageCode'] as String,
      authorName: json['authorName'] as String,
      text: json['text'] as String,
    );

Map<String, dynamic> _$VerseTranslationToJson(_VerseTranslation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'languageCode': instance.languageCode,
      'authorName': instance.authorName,
      'text': instance.text,
    };
