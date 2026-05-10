// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dhikr_phrase.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DhikrPhrase _$DhikrPhraseFromJson(Map<String, dynamic> json) => _DhikrPhrase(
  id: json['id'] as String,
  phraseArabic: json['phraseArabic'] as String,
  phraseTransliteration: json['phraseTransliteration'] as String,
  meaning: json['meaning'] as String,
  recommendedCount: (json['recommendedCount'] as num?)?.toInt() ?? 33,
);

Map<String, dynamic> _$DhikrPhraseToJson(_DhikrPhrase instance) =>
    <String, dynamic>{
      'id': instance.id,
      'phraseArabic': instance.phraseArabic,
      'phraseTransliteration': instance.phraseTransliteration,
      'meaning': instance.meaning,
      'recommendedCount': instance.recommendedCount,
    };
