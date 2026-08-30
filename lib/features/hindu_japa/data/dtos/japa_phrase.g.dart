// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'japa_phrase.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JapaPhrase _$JapaPhraseFromJson(Map<String, dynamic> json) => _JapaPhrase(
  sanskrit: json['sanskrit'] as String,
  transliteration: json['transliteration'] as String,
  english: json['english'] as String,
  category: json['category'] as String,
  deityKey: json['deityKey'] as String?,
  recommendedCount: (json['recommendedCount'] as num?)?.toInt() ?? 108,
);

Map<String, dynamic> _$JapaPhraseToJson(_JapaPhrase instance) =>
    <String, dynamic>{
      'sanskrit': instance.sanskrit,
      'transliteration': instance.transliteration,
      'english': instance.english,
      'category': instance.category,
      'deityKey': instance.deityKey,
      'recommendedCount': instance.recommendedCount,
    };
