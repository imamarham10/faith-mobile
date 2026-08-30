// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'puja_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PujaStats _$PujaStatsFromJson(Map<String, dynamic> json) => _PujaStats(
  total: (json['total'] as num?)?.toInt() ?? 0,
  onTime: (json['onTime'] as num?)?.toInt() ?? 0,
  late: (json['late'] as num?)?.toInt() ?? 0,
  missed: (json['missed'] as num?)?.toInt() ?? 0,
  currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
  longestStreak: (json['longestStreak'] as num?)?.toInt() ?? 0,
  completionRate: (json['completionRate'] as num?)?.toDouble() ?? 0,
);

Map<String, dynamic> _$PujaStatsToJson(_PujaStats instance) =>
    <String, dynamic>{
      'total': instance.total,
      'onTime': instance.onTime,
      'late': instance.late,
      'missed': instance.missed,
      'currentStreak': instance.currentStreak,
      'longestStreak': instance.longestStreak,
      'completionRate': instance.completionRate,
    };
