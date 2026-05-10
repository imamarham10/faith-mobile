// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Translation _$TranslationFromJson(Map<String, dynamic> json) => _Translation(
  language: json['language'] as String,
  authorName: json['authorName'] as String,
  text: json['text'] as String,
);

Map<String, dynamic> _$TranslationToJson(_Translation instance) =>
    <String, dynamic>{
      'language': instance.language,
      'authorName': instance.authorName,
      'text': instance.text,
    };
