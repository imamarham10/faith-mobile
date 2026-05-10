// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Bookmark _$BookmarkFromJson(Map<String, dynamic> json) => _Bookmark(
  id: json['id'] as String,
  surahId: (json['surahId'] as num).toInt(),
  verseNumber: (json['verseNumber'] as num).toInt(),
  surahName: json['surahName'] as String?,
  textArabic: json['textArabic'] as String?,
  translation: json['translation'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$BookmarkToJson(_Bookmark instance) => <String, dynamic>{
  'id': instance.id,
  'surahId': instance.surahId,
  'verseNumber': instance.verseNumber,
  'surahName': instance.surahName,
  'textArabic': instance.textArabic,
  'translation': instance.translation,
  'createdAt': instance.createdAt?.toIso8601String(),
};
