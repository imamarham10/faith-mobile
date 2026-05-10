// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dua.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Dua _$DuaFromJson(Map<String, dynamic> json) => _Dua(
  id: json['id'] as String,
  categoryId: json['categoryId'] as String,
  titleArabic: json['titleArabic'] as String,
  titleEnglish: json['titleEnglish'] as String,
  textArabic: json['textArabic'] as String,
  textEnglish: json['textEnglish'] as String,
  textTransliteration: json['textTransliteration'] as String?,
  reference: json['reference'] as String?,
  audioUrl: json['audioUrl'] as String?,
  category: json['category'] == null
      ? null
      : DuaCategory.fromJson(json['category'] as Map<String, dynamic>),
);

Map<String, dynamic> _$DuaToJson(_Dua instance) => <String, dynamic>{
  'id': instance.id,
  'categoryId': instance.categoryId,
  'titleArabic': instance.titleArabic,
  'titleEnglish': instance.titleEnglish,
  'textArabic': instance.textArabic,
  'textEnglish': instance.textEnglish,
  'textTransliteration': instance.textTransliteration,
  'reference': instance.reference,
  'audioUrl': instance.audioUrl,
  'category': instance.category,
};
