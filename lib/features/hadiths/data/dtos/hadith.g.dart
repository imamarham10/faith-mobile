// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hadith.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Hadith _$HadithFromJson(Map<String, dynamic> json) => _Hadith(
  id: json['id'] as String,
  bookId: json['bookId'] as String,
  hadithNumber: (json['hadithNumber'] as num).toInt(),
  textArabic: json['textArabic'] as String,
  textEnglish: json['textEnglish'] as String,
  chapterTitle: json['chapterTitle'] as String?,
  chapterTitleArabic: json['chapterTitleArabic'] as String?,
  narratorChain: json['narratorChain'] as String?,
  narratorChainArabic: json['narratorChainArabic'] as String?,
  grade: json['grade'] as String?,
  reference: json['reference'] as String?,
  book: json['book'] == null
      ? null
      : HadithBook.fromJson(json['book'] as Map<String, dynamic>),
);

Map<String, dynamic> _$HadithToJson(_Hadith instance) => <String, dynamic>{
  'id': instance.id,
  'bookId': instance.bookId,
  'hadithNumber': instance.hadithNumber,
  'textArabic': instance.textArabic,
  'textEnglish': instance.textEnglish,
  'chapterTitle': instance.chapterTitle,
  'chapterTitleArabic': instance.chapterTitleArabic,
  'narratorChain': instance.narratorChain,
  'narratorChainArabic': instance.narratorChainArabic,
  'grade': instance.grade,
  'reference': instance.reference,
  'book': instance.book,
};
