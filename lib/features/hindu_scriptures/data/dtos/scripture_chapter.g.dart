// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scripture_chapter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChapterSummary _$ChapterSummaryFromJson(Map<String, dynamic> json) =>
    _ChapterSummary(
      id: json['id'] as String,
      textId: json['textId'] as String,
      chapterNumber: (json['chapterNumber'] as num).toInt(),
      nameSanskrit: json['nameSanskrit'] as String?,
      nameEnglish: json['nameEnglish'] as String?,
      verseCount: (json['verseCount'] as num).toInt(),
    );

Map<String, dynamic> _$ChapterSummaryToJson(_ChapterSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'textId': instance.textId,
      'chapterNumber': instance.chapterNumber,
      'nameSanskrit': instance.nameSanskrit,
      'nameEnglish': instance.nameEnglish,
      'verseCount': instance.verseCount,
    };

_ChapterDetail _$ChapterDetailFromJson(Map<String, dynamic> json) =>
    _ChapterDetail(
      id: json['id'] as String,
      textId: json['textId'] as String,
      chapterNumber: (json['chapterNumber'] as num).toInt(),
      nameSanskrit: json['nameSanskrit'] as String?,
      nameEnglish: json['nameEnglish'] as String?,
      verses:
          (json['verses'] as List<dynamic>?)
              ?.map((e) => ScriptureVerse.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ScriptureVerse>[],
    );

Map<String, dynamic> _$ChapterDetailToJson(_ChapterDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'textId': instance.textId,
      'chapterNumber': instance.chapterNumber,
      'nameSanskrit': instance.nameSanskrit,
      'nameEnglish': instance.nameEnglish,
      'verses': instance.verses,
    };
