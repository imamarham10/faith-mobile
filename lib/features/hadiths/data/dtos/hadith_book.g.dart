// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hadith_book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HadithBook _$HadithBookFromJson(Map<String, dynamic> json) => _HadithBook(
  id: json['id'] as String?,
  name: json['name'] as String,
  nameArabic: json['nameArabic'] as String?,
  author: json['author'] as String?,
  authorArabic: json['authorArabic'] as String?,
  totalHadiths: (json['totalHadiths'] as num?)?.toInt() ?? 0,
  isPremium: json['isPremium'] as bool? ?? false,
  description: json['description'] as String?,
  sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$HadithBookToJson(_HadithBook instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'nameArabic': instance.nameArabic,
      'author': instance.author,
      'authorArabic': instance.authorArabic,
      'totalHadiths': instance.totalHadiths,
      'isPremium': instance.isPremium,
      'description': instance.description,
      'sortOrder': instance.sortOrder,
    };
