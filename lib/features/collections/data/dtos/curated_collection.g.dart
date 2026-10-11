// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'curated_collection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CuratedCollection _$CuratedCollectionFromJson(Map<String, dynamic> json) =>
    _CuratedCollection(
      slug: json['slug'] as String,
      faithId: json['faithId'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String?,
      description: json['description'] as String?,
      occasionType: json['occasionType'] as String?,
      occasionConfig: json['occasionConfig'] as Map<String, dynamic>?,
      orderSemantics: json['orderSemantics'] as String?,
      artworkKey: json['artworkKey'] as String?,
      estimatedMinutes: (json['estimatedMinutes'] as num?)?.toInt(),
      showOnHome: json['showOnHome'] as bool? ?? false,
      priority: (json['priority'] as num?)?.toInt() ?? 0,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      provenance: json['provenance'] == null
          ? null
          : CollectionProvenance.fromJson(
              json['provenance'] as Map<String, dynamic>,
            ),
      itemCount: (json['itemCount'] as num?)?.toInt() ?? 0,
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => CollectionItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <CollectionItem>[],
    );

Map<String, dynamic> _$CuratedCollectionToJson(_CuratedCollection instance) =>
    <String, dynamic>{
      'slug': instance.slug,
      'faithId': instance.faithId,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'description': instance.description,
      'occasionType': instance.occasionType,
      'occasionConfig': instance.occasionConfig,
      'orderSemantics': instance.orderSemantics,
      'artworkKey': instance.artworkKey,
      'estimatedMinutes': instance.estimatedMinutes,
      'showOnHome': instance.showOnHome,
      'priority': instance.priority,
      'sortOrder': instance.sortOrder,
      'provenance': instance.provenance,
      'itemCount': instance.itemCount,
      'items': instance.items,
    };

_CollectionProvenance _$CollectionProvenanceFromJson(
  Map<String, dynamic> json,
) => _CollectionProvenance(
  provenanceClass: json['provenanceClass'] as String?,
  reviewStatus: json['reviewStatus'] as String?,
  curatedBy: json['curatedBy'] as String?,
  curatedAt: json['curatedAt'] == null
      ? null
      : DateTime.parse(json['curatedAt'] as String),
  reviewedBy: json['reviewedBy'] as String?,
  reviewedAt: json['reviewedAt'] == null
      ? null
      : DateTime.parse(json['reviewedAt'] as String),
);

Map<String, dynamic> _$CollectionProvenanceToJson(
  _CollectionProvenance instance,
) => <String, dynamic>{
  'provenanceClass': instance.provenanceClass,
  'reviewStatus': instance.reviewStatus,
  'curatedBy': instance.curatedBy,
  'curatedAt': instance.curatedAt?.toIso8601String(),
  'reviewedBy': instance.reviewedBy,
  'reviewedAt': instance.reviewedAt?.toIso8601String(),
};
