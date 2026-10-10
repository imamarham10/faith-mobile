// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'juz.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JuzBoundary _$JuzBoundaryFromJson(Map<String, dynamic> json) => _JuzBoundary(
  surahId: (json['surahId'] as num).toInt(),
  surahName: json['surahName'] as String,
  verseNumber: (json['verseNumber'] as num).toInt(),
);

Map<String, dynamic> _$JuzBoundaryToJson(_JuzBoundary instance) =>
    <String, dynamic>{
      'surahId': instance.surahId,
      'surahName': instance.surahName,
      'verseNumber': instance.verseNumber,
    };

_JuzSummary _$JuzSummaryFromJson(Map<String, dynamic> json) => _JuzSummary(
  number: (json['number'] as num).toInt(),
  start: JuzBoundary.fromJson(json['start'] as Map<String, dynamic>),
  end: JuzBoundary.fromJson(json['end'] as Map<String, dynamic>),
  verseCount: (json['verseCount'] as num).toInt(),
  surahIds:
      (json['surahIds'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const <int>[],
);

Map<String, dynamic> _$JuzSummaryToJson(_JuzSummary instance) =>
    <String, dynamic>{
      'number': instance.number,
      'start': instance.start,
      'end': instance.end,
      'verseCount': instance.verseCount,
      'surahIds': instance.surahIds,
    };

_JuzVerse _$JuzVerseFromJson(Map<String, dynamic> json) => _JuzVerse(
  id: json['id'] as String,
  surahId: (json['surahId'] as num).toInt(),
  surahName: json['surahName'] as String,
  verseNumber: (json['verseNumber'] as num).toInt(),
  indexInJuz: (json['indexInJuz'] as num).toInt(),
  textArabic: json['textArabic'] as String,
  textUthmani: json['textUthmani'] as String?,
  textIndopak: json['textIndopak'] as String?,
  translation: json['translation'] as String?,
);

Map<String, dynamic> _$JuzVerseToJson(_JuzVerse instance) => <String, dynamic>{
  'id': instance.id,
  'surahId': instance.surahId,
  'surahName': instance.surahName,
  'verseNumber': instance.verseNumber,
  'indexInJuz': instance.indexInJuz,
  'textArabic': instance.textArabic,
  'textUthmani': instance.textUthmani,
  'textIndopak': instance.textIndopak,
  'translation': instance.translation,
};

_JuzPage _$JuzPageFromJson(Map<String, dynamic> json) => _JuzPage(
  number: (json['number'] as num).toInt(),
  verseCount: (json['verseCount'] as num).toInt(),
  page: (json['page'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
  totalPages: (json['totalPages'] as num).toInt(),
  verses:
      (json['verses'] as List<dynamic>?)
          ?.map((e) => JuzVerse.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <JuzVerse>[],
);

Map<String, dynamic> _$JuzPageToJson(_JuzPage instance) => <String, dynamic>{
  'number': instance.number,
  'verseCount': instance.verseCount,
  'page': instance.page,
  'limit': instance.limit,
  'totalPages': instance.totalPages,
  'verses': instance.verses,
};
