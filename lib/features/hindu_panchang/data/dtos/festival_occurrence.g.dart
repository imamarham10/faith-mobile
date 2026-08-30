// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'festival_occurrence.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FestivalOccurrence _$FestivalOccurrenceFromJson(Map<String, dynamic> json) =>
    _FestivalOccurrence(
      festival: HinduFestival.fromJson(
        json['festival'] as Map<String, dynamic>,
      ),
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$FestivalOccurrenceToJson(_FestivalOccurrence instance) =>
    <String, dynamic>{
      'festival': instance.festival,
      'date': instance.date.toIso8601String(),
    };
