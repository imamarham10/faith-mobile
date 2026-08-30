// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'japa_counter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JapaCounter _$JapaCounterFromJson(Map<String, dynamic> json) => _JapaCounter(
  id: json['id'] as String,
  userId: json['userId'] as String?,
  name: json['name'] as String,
  mantraSanskrit: json['mantraSanskrit'] as String?,
  mantraEnglish: json['mantraEnglish'] as String?,
  count: (json['count'] as num?)?.toInt() ?? 0,
  targetCount: (json['targetCount'] as num?)?.toInt(),
  deityKey: json['deityKey'] as String?,
  isActive: json['isActive'] as bool? ?? true,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$JapaCounterToJson(_JapaCounter instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'mantraSanskrit': instance.mantraSanskrit,
      'mantraEnglish': instance.mantraEnglish,
      'count': instance.count,
      'targetCount': instance.targetCount,
      'deityKey': instance.deityKey,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
