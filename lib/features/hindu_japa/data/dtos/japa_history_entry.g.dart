// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'japa_history_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JapaHistoryEntry _$JapaHistoryEntryFromJson(Map<String, dynamic> json) =>
    _JapaHistoryEntry(
      id: json['id'] as String,
      userId: json['userId'] as String?,
      mantra: json['mantra'] as String,
      count: (json['count'] as num?)?.toInt() ?? 0,
      date: DateTime.parse(json['date'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$JapaHistoryEntryToJson(_JapaHistoryEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'mantra': instance.mantra,
      'count': instance.count,
      'date': instance.date.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
    };
