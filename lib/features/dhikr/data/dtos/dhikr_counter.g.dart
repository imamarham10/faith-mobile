// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dhikr_counter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DhikrCounter _$DhikrCounterFromJson(Map<String, dynamic> json) =>
    _DhikrCounter(
      id: json['id'] as String,
      userId: json['userId'] as String?,
      name: json['name'] as String,
      phraseArabic: json['phraseArabic'] as String?,
      phraseEnglish: json['phraseEnglish'] as String?,
      phraseTransliteration: json['phraseTransliteration'] as String?,
      meaning: json['meaning'] as String?,
      count: (json['count'] as num?)?.toInt() ?? 0,
      targetCount: (json['targetCount'] as num?)?.toInt() ?? 33,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$DhikrCounterToJson(_DhikrCounter instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'phraseArabic': instance.phraseArabic,
      'phraseEnglish': instance.phraseEnglish,
      'phraseTransliteration': instance.phraseTransliteration,
      'meaning': instance.meaning,
      'count': instance.count,
      'targetCount': instance.targetCount,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
