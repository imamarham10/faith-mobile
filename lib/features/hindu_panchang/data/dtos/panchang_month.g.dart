// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'panchang_month.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PanchangMonth _$PanchangMonthFromJson(Map<String, dynamic> json) =>
    _PanchangMonth(
      year: (json['year'] as num).toInt(),
      month: (json['month'] as num).toInt(),
      days:
          (json['days'] as List<dynamic>?)
              ?.map((e) => PanchangDay.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <PanchangDay>[],
    );

Map<String, dynamic> _$PanchangMonthToJson(_PanchangMonth instance) =>
    <String, dynamic>{
      'year': instance.year,
      'month': instance.month,
      'days': instance.days,
    };
