// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'puja_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PujaLog _$PujaLogFromJson(Map<String, dynamic> json) => _PujaLog(
  id: json['id'] as String?,
  userId: json['userId'] as String?,
  sandhya: json['sandhya'] as String,
  date: json['date'] as String,
  status: $enumDecode(_$PujaStatusEnumMap, json['status']),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$PujaLogToJson(_PujaLog instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'sandhya': instance.sandhya,
  'date': instance.date,
  'status': _$PujaStatusEnumMap[instance.status]!,
  'createdAt': instance.createdAt?.toIso8601String(),
};

const _$PujaStatusEnumMap = {
  PujaStatus.onTime: 'on_time',
  PujaStatus.late_: 'late',
  PujaStatus.missed: 'missed',
};
