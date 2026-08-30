// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scripture_text.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScriptureText _$ScriptureTextFromJson(Map<String, dynamic> json) =>
    _ScriptureText(
      id: json['id'] as String,
      slug: json['slug'] as String,
      nameEnglish: json['nameEnglish'] as String,
      nameSanskrit: json['nameSanskrit'] as String,
      type: json['type'] as String,
      totalVerses: (json['totalVerses'] as num).toInt(),
      isPremium: json['isPremium'] as bool? ?? false,
      chapterCount: (json['chapterCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ScriptureTextToJson(_ScriptureText instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'nameEnglish': instance.nameEnglish,
      'nameSanskrit': instance.nameSanskrit,
      'type': instance.type,
      'totalVerses': instance.totalVerses,
      'isPremium': instance.isPremium,
      'chapterCount': instance.chapterCount,
    };

_ScriptureTextDetail _$ScriptureTextDetailFromJson(Map<String, dynamic> json) =>
    _ScriptureTextDetail(
      id: json['id'] as String,
      slug: json['slug'] as String,
      nameEnglish: json['nameEnglish'] as String,
      nameSanskrit: json['nameSanskrit'] as String,
      type: json['type'] as String,
      totalVerses: (json['totalVerses'] as num).toInt(),
      isPremium: json['isPremium'] as bool? ?? false,
      chapters:
          (json['chapters'] as List<dynamic>?)
              ?.map((e) => ChapterSummary.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ChapterSummary>[],
    );

Map<String, dynamic> _$ScriptureTextDetailToJson(
  _ScriptureTextDetail instance,
) => <String, dynamic>{
  'id': instance.id,
  'slug': instance.slug,
  'nameEnglish': instance.nameEnglish,
  'nameSanskrit': instance.nameSanskrit,
  'type': instance.type,
  'totalVerses': instance.totalVerses,
  'isPremium': instance.isPremium,
  'chapters': instance.chapters,
};
