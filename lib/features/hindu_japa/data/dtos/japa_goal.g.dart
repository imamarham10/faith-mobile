// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'japa_goal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JapaGoal _$JapaGoalFromJson(Map<String, dynamic> json) => _JapaGoal(
  id: json['id'] as String,
  userId: json['userId'] as String?,
  mantraSanskrit: json['mantraSanskrit'] as String,
  targetCount: (json['targetCount'] as num).toInt(),
  currentCount: (json['currentCount'] as num?)?.toInt() ?? 0,
  period: $enumDecode(_$JapaGoalPeriodEnumMap, json['period']),
  startDate: DateTime.parse(json['startDate'] as String),
  endDate: DateTime.parse(json['endDate'] as String),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  progressPercent: (json['progressPercent'] as num?)?.toDouble() ?? 0,
  daysRemaining: (json['daysRemaining'] as num?)?.toInt() ?? 0,
  isComplete: json['isComplete'] as bool? ?? false,
);

Map<String, dynamic> _$JapaGoalToJson(_JapaGoal instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'mantraSanskrit': instance.mantraSanskrit,
  'targetCount': instance.targetCount,
  'currentCount': instance.currentCount,
  'period': _$JapaGoalPeriodEnumMap[instance.period]!,
  'startDate': instance.startDate.toIso8601String(),
  'endDate': instance.endDate.toIso8601String(),
  'createdAt': instance.createdAt?.toIso8601String(),
  'progressPercent': instance.progressPercent,
  'daysRemaining': instance.daysRemaining,
  'isComplete': instance.isComplete,
};

const _$JapaGoalPeriodEnumMap = {
  JapaGoalPeriod.daily: 'daily',
  JapaGoalPeriod.weekly: 'weekly',
  JapaGoalPeriod.monthly: 'monthly',
};
