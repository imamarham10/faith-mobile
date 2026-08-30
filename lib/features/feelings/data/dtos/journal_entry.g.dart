// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JournalRemedySnapshot _$JournalRemedySnapshotFromJson(
  Map<String, dynamic> json,
) => _JournalRemedySnapshot(
  primaryText: json['primaryText'] as String,
  script: $enumDecodeNullable(_$JournalRemedyScriptEnumMap, json['script']),
  transliteration: json['transliteration'] as String?,
  translation: json['translation'] as String?,
  reference: json['reference'] as String?,
  note: json['note'] as String?,
  deepLink: json['deepLink'] as String?,
);

Map<String, dynamic> _$JournalRemedySnapshotToJson(
  _JournalRemedySnapshot instance,
) => <String, dynamic>{
  'primaryText': instance.primaryText,
  'script': _$JournalRemedyScriptEnumMap[instance.script],
  'transliteration': instance.transliteration,
  'translation': instance.translation,
  'reference': instance.reference,
  'note': instance.note,
  'deepLink': instance.deepLink,
};

const _$JournalRemedyScriptEnumMap = {
  JournalRemedyScript.arabic: 'arabic',
  JournalRemedyScript.sanskrit: 'sanskrit',
};

_JournalEntry _$JournalEntryFromJson(Map<String, dynamic> json) =>
    _JournalEntry(
      id: json['id'] as String,
      mood: json['mood'] as String,
      note: json['note'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      remedies:
          (json['remedies'] as List<dynamic>?)
              ?.map(
                (e) =>
                    JournalRemedySnapshot.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <JournalRemedySnapshot>[],
    );

Map<String, dynamic> _$JournalEntryToJson(_JournalEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'mood': instance.mood,
      'note': instance.note,
      'createdAt': instance.createdAt.toIso8601String(),
      'remedies': instance.remedies,
    };
