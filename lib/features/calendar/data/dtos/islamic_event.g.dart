// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'islamic_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_IslamicEvent _$IslamicEventFromJson(Map<String, dynamic> json) =>
    _IslamicEvent(
      id: json['id'] as String,
      name: json['name'] as String,
      nameArabic: json['nameArabic'] as String?,
      description: json['description'] as String?,
      hijriMonth: (json['hijriMonth'] as num).toInt(),
      hijriDay: (json['hijriDay'] as num).toInt(),
      importance: json['importance'] as String? ?? 'regular',
    );

Map<String, dynamic> _$IslamicEventToJson(_IslamicEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'nameArabic': instance.nameArabic,
      'description': instance.description,
      'hijriMonth': instance.hijriMonth,
      'hijriDay': instance.hijriDay,
      'importance': instance.importance,
    };
