// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dhikr_goal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DhikrGoal _$DhikrGoalFromJson(Map<String, dynamic> json) => _DhikrGoal(
  id: json['id'] as String,
  userId: json['userId'] as String?,
  phraseArabic: json['phraseArabic'] as String?,
  phraseEnglish: json['phraseEnglish'] as String?,
  targetCount: (json['targetCount'] as num).toInt(),
  currentCount: (json['currentCount'] as num?)?.toInt() ?? 0,
  period: $enumDecode(_$DhikrGoalPeriodEnumMap, json['period']),
  startDate: json['startDate'] == null
      ? null
      : DateTime.parse(json['startDate'] as String),
  endDate: json['endDate'] == null
      ? null
      : DateTime.parse(json['endDate'] as String),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$DhikrGoalToJson(_DhikrGoal instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'phraseArabic': instance.phraseArabic,
      'phraseEnglish': instance.phraseEnglish,
      'targetCount': instance.targetCount,
      'currentCount': instance.currentCount,
      'period': _$DhikrGoalPeriodEnumMap[instance.period]!,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
    };

const _$DhikrGoalPeriodEnumMap = {
  DhikrGoalPeriod.daily: 'daily',
  DhikrGoalPeriod.weekly: 'weekly',
  DhikrGoalPeriod.monthly: 'monthly',
};
