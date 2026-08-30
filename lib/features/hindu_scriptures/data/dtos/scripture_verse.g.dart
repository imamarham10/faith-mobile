// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scripture_verse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScriptureVerse _$ScriptureVerseFromJson(Map<String, dynamic> json) =>
    _ScriptureVerse(
      id: json['id'] as String,
      textId: json['textId'] as String,
      chapterId: json['chapterId'] as String,
      verseNumber: (json['verseNumber'] as num).toInt(),
      sanskritText: json['sanskritText'] as String,
      transliteration: json['transliteration'] as String?,
      isFeatured: json['isFeatured'] as bool? ?? false,
      translations:
          (json['translations'] as List<dynamic>?)
              ?.map((e) => VerseTranslation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <VerseTranslation>[],
      chapter: json['chapter'] == null
          ? null
          : VerseChapterRef.fromJson(json['chapter'] as Map<String, dynamic>),
      text: json['text'] == null
          ? null
          : VerseTextRef.fromJson(json['text'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ScriptureVerseToJson(_ScriptureVerse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'textId': instance.textId,
      'chapterId': instance.chapterId,
      'verseNumber': instance.verseNumber,
      'sanskritText': instance.sanskritText,
      'transliteration': instance.transliteration,
      'isFeatured': instance.isFeatured,
      'translations': instance.translations,
      'chapter': instance.chapter,
      'text': instance.text,
    };

_VerseChapterRef _$VerseChapterRefFromJson(Map<String, dynamic> json) =>
    _VerseChapterRef(
      chapterNumber: (json['chapterNumber'] as num).toInt(),
      nameEnglish: json['nameEnglish'] as String?,
    );

Map<String, dynamic> _$VerseChapterRefToJson(_VerseChapterRef instance) =>
    <String, dynamic>{
      'chapterNumber': instance.chapterNumber,
      'nameEnglish': instance.nameEnglish,
    };

_VerseTextRef _$VerseTextRefFromJson(Map<String, dynamic> json) =>
    _VerseTextRef(
      slug: json['slug'] as String,
      nameEnglish: json['nameEnglish'] as String?,
    );

Map<String, dynamic> _$VerseTextRefToJson(_VerseTextRef instance) =>
    <String, dynamic>{
      'slug': instance.slug,
      'nameEnglish': instance.nameEnglish,
    };
