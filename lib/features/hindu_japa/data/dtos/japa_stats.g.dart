// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'japa_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JapaStats _$JapaStatsFromJson(Map<String, dynamic> json) => _JapaStats(
  totalCount: (json['totalCount'] as num?)?.toInt() ?? 0,
  dailyAverage: (json['dailyAverage'] as num?)?.toDouble() ?? 0,
  currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
  longestStreak: (json['longestStreak'] as num?)?.toInt() ?? 0,
  mostRecitedPhrase: json['mostRecitedPhrase'] as String?,
);

Map<String, dynamic> _$JapaStatsToJson(_JapaStats instance) =>
    <String, dynamic>{
      'totalCount': instance.totalCount,
      'dailyAverage': instance.dailyAverage,
      'currentStreak': instance.currentStreak,
      'longestStreak': instance.longestStreak,
      'mostRecitedPhrase': instance.mostRecitedPhrase,
    };
