// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hijri_day.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HijriDay _$HijriDayFromJson(Map<String, dynamic> json) => _HijriDay(
  hijriDay: (json['hijriDay'] as num).toInt(),
  hijriMonth: (json['hijriMonth'] as num).toInt(),
  hijriYear: (json['hijriYear'] as num).toInt(),
  hijriMonthName: json['hijriMonthName'] as String,
  gregorianDate: json['gregorianDate'] as String,
  dayOfWeek: json['dayOfWeek'] as String,
);

Map<String, dynamic> _$HijriDayToJson(_HijriDay instance) => <String, dynamic>{
  'hijriDay': instance.hijriDay,
  'hijriMonth': instance.hijriMonth,
  'hijriYear': instance.hijriYear,
  'hijriMonthName': instance.hijriMonthName,
  'gregorianDate': instance.gregorianDate,
  'dayOfWeek': instance.dayOfWeek,
};
