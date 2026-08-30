// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scripture_bookmark.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScriptureBookmark _$ScriptureBookmarkFromJson(Map<String, dynamic> json) =>
    _ScriptureBookmark(
      id: json['id'] as String,
      verseId: json['verseId'] as String,
      note: json['note'] as String?,
      textSlug: json['textSlug'] as String?,
      textName: json['textName'] as String?,
      chapterNumber: (json['chapterNumber'] as num?)?.toInt(),
      sanskritText: json['sanskritText'] as String?,
      verseNumber: (json['verseNumber'] as num?)?.toInt(),
      translation: json['translation'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ScriptureBookmarkToJson(_ScriptureBookmark instance) =>
    <String, dynamic>{
      'id': instance.id,
      'verseId': instance.verseId,
      'note': instance.note,
      'textSlug': instance.textSlug,
      'textName': instance.textName,
      'chapterNumber': instance.chapterNumber,
      'sanskritText': instance.sanskritText,
      'verseNumber': instance.verseNumber,
      'translation': instance.translation,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
