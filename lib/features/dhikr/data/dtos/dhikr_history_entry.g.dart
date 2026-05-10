// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dhikr_history_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DhikrHistoryEntry _$DhikrHistoryEntryFromJson(Map<String, dynamic> json) =>
    _DhikrHistoryEntry(
      id: json['id'] as String,
      counterId: json['counterId'] as String?,
      phraseArabic: json['phraseArabic'] as String?,
      phraseEnglish: json['phraseEnglish'] as String?,
      count: (json['count'] as num?)?.toInt() ?? 0,
      recordedAt: json['recordedAt'] == null
          ? null
          : DateTime.parse(json['recordedAt'] as String),
    );

Map<String, dynamic> _$DhikrHistoryEntryToJson(_DhikrHistoryEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'counterId': instance.counterId,
      'phraseArabic': instance.phraseArabic,
      'phraseEnglish': instance.phraseEnglish,
      'count': instance.count,
      'recordedAt': instance.recordedAt?.toIso8601String(),
    };
