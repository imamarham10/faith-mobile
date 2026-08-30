// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stotra.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Stotra _$StotraFromJson(Map<String, dynamic> json) => _Stotra(
  id: json['id'] as String,
  slug: json['slug'] as String,
  titleSanskrit: json['titleSanskrit'] as String,
  titleEnglish: json['titleEnglish'] as String,
  type: json['type'] as String,
  deityKey: json['deityKey'] as String?,
  isPremium: json['isPremium'] as bool? ?? false,
  category: json['category'] == null
      ? null
      : StotraCategoryRef.fromJson(json['category'] as Map<String, dynamic>),
  verseCount: (json['verseCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$StotraToJson(_Stotra instance) => <String, dynamic>{
  'id': instance.id,
  'slug': instance.slug,
  'titleSanskrit': instance.titleSanskrit,
  'titleEnglish': instance.titleEnglish,
  'type': instance.type,
  'deityKey': instance.deityKey,
  'isPremium': instance.isPremium,
  'category': instance.category,
  'verseCount': instance.verseCount,
};

_StotraDetail _$StotraDetailFromJson(Map<String, dynamic> json) =>
    _StotraDetail(
      id: json['id'] as String,
      categoryId: json['categoryId'] as String,
      slug: json['slug'] as String,
      titleSanskrit: json['titleSanskrit'] as String,
      titleEnglish: json['titleEnglish'] as String,
      type: json['type'] as String,
      deityKey: json['deityKey'] as String?,
      isPremium: json['isPremium'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      category: json['category'] == null
          ? null
          : StotraCategoryRef.fromJson(
              json['category'] as Map<String, dynamic>,
            ),
      verses:
          (json['verses'] as List<dynamic>?)
              ?.map((e) => StotraVerse.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <StotraVerse>[],
    );

Map<String, dynamic> _$StotraDetailToJson(_StotraDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'categoryId': instance.categoryId,
      'slug': instance.slug,
      'titleSanskrit': instance.titleSanskrit,
      'titleEnglish': instance.titleEnglish,
      'type': instance.type,
      'deityKey': instance.deityKey,
      'isPremium': instance.isPremium,
      'createdAt': instance.createdAt?.toIso8601String(),
      'category': instance.category,
      'verses': instance.verses,
    };
