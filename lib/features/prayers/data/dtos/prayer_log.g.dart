// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prayer_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PrayerLog _$PrayerLogFromJson(Map<String, dynamic> json) => _PrayerLog(
  id: json['id'] as String?,
  userId: json['userId'] as String?,
  prayerName: json['prayerName'] as String,
  date: json['date'] as String,
  status: $enumDecode(_$PrayerStatusEnumMap, json['status']),
  loggedAt: json['loggedAt'] == null
      ? null
      : DateTime.parse(json['loggedAt'] as String),
);

Map<String, dynamic> _$PrayerLogToJson(_PrayerLog instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'prayerName': instance.prayerName,
      'date': instance.date,
      'status': _$PrayerStatusEnumMap[instance.status]!,
      'loggedAt': instance.loggedAt?.toIso8601String(),
    };

const _$PrayerStatusEnumMap = {
  PrayerStatus.onTime: 'on_time',
  PrayerStatus.late: 'late',
  PrayerStatus.qada: 'qada',
};
