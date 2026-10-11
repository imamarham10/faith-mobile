// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CollectionItem _$CollectionItemFromJson(Map<String, dynamic> json) =>
    _CollectionItem(
      sequence: (json['sequence'] as num).toInt(),
      refType: json['refType'] as String,
      repeatCount: (json['repeatCount'] as num?)?.toInt() ?? 1,
      label: json['label'] as String,
      note: json['note'] as String?,
      citation: json['citation'] as String?,
      grading: json['grading'] as String?,
      isOptional: json['isOptional'] as bool? ?? false,
      ref: json['ref'] == null
          ? const CollectionRef()
          : CollectionRef.fromJson(json['ref'] as Map<String, dynamic>),
      unresolved: json['unresolved'] == null
          ? null
          : CollectionUnresolved.fromJson(
              json['unresolved'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$CollectionItemToJson(_CollectionItem instance) =>
    <String, dynamic>{
      'sequence': instance.sequence,
      'refType': instance.refType,
      'repeatCount': instance.repeatCount,
      'label': instance.label,
      'note': instance.note,
      'citation': instance.citation,
      'grading': instance.grading,
      'isOptional': instance.isOptional,
      'ref': instance.ref,
      'unresolved': instance.unresolved,
    };

_CollectionRef _$CollectionRefFromJson(Map<String, dynamic> json) =>
    _CollectionRef(
      surahId: (json['surahId'] as num?)?.toInt(),
      ayahStart: (json['ayahStart'] as num?)?.toInt(),
      ayahEnd: (json['ayahEnd'] as num?)?.toInt(),
      hinduTextSlug: json['hinduTextSlug'] as String?,
      chapterNumber: (json['chapterNumber'] as num?)?.toInt(),
      verseStart: (json['verseStart'] as num?)?.toInt(),
      verseEnd: (json['verseEnd'] as num?)?.toInt(),
      refSlug: json['refSlug'] as String?,
      refId: json['refId'] as String?,
    );

Map<String, dynamic> _$CollectionRefToJson(_CollectionRef instance) =>
    <String, dynamic>{
      'surahId': instance.surahId,
      'ayahStart': instance.ayahStart,
      'ayahEnd': instance.ayahEnd,
      'hinduTextSlug': instance.hinduTextSlug,
      'chapterNumber': instance.chapterNumber,
      'verseStart': instance.verseStart,
      'verseEnd': instance.verseEnd,
      'refSlug': instance.refSlug,
      'refId': instance.refId,
    };

_CollectionUnresolved _$CollectionUnresolvedFromJson(
  Map<String, dynamic> json,
) => _CollectionUnresolved(reason: json['reason'] as String);

Map<String, dynamic> _$CollectionUnresolvedToJson(
  _CollectionUnresolved instance,
) => <String, dynamic>{'reason': instance.reason};
