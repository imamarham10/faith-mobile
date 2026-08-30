// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'puja_times.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TimeBand _$TimeBandFromJson(Map<String, dynamic> json) => _TimeBand(
  start: DateTime.parse(json['start'] as String),
  end: DateTime.parse(json['end'] as String),
);

Map<String, dynamic> _$TimeBandToJson(_TimeBand instance) => <String, dynamic>{
  'start': instance.start.toIso8601String(),
  'end': instance.end.toIso8601String(),
};

_SandhyaInfo _$SandhyaInfoFromJson(Map<String, dynamic> json) => _SandhyaInfo(
  name: json['name'] as String,
  nameSanskrit: json['nameSanskrit'] as String,
  nameEnglish: json['nameEnglish'] as String,
  band: TimeBand.fromJson(json['band'] as Map<String, dynamic>),
  isCurrent: json['isCurrent'] as bool,
);

Map<String, dynamic> _$SandhyaInfoToJson(_SandhyaInfo instance) =>
    <String, dynamic>{
      'name': instance.name,
      'nameSanskrit': instance.nameSanskrit,
      'nameEnglish': instance.nameEnglish,
      'band': instance.band,
      'isCurrent': instance.isCurrent,
    };

_NextSandhya _$NextSandhyaFromJson(Map<String, dynamic> json) => _NextSandhya(
  sandhya: json['sandhya'] as String,
  startsInSeconds: (json['startsInSeconds'] as num).toInt(),
);

Map<String, dynamic> _$NextSandhyaToJson(_NextSandhya instance) =>
    <String, dynamic>{
      'sandhya': instance.sandhya,
      'startsInSeconds': instance.startsInSeconds,
    };

_PujaTimes _$PujaTimesFromJson(Map<String, dynamic> json) => _PujaTimes(
  date: json['date'] as String,
  timezone: json['timezone'] as String,
  sunrise: DateTime.parse(json['sunrise'] as String),
  sunset: DateTime.parse(json['sunset'] as String),
  solarNoon: DateTime.parse(json['solarNoon'] as String),
  sandhyas:
      (json['sandhyas'] as List<dynamic>?)
          ?.map((e) => SandhyaInfo.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <SandhyaInfo>[],
  next: json['next'] == null
      ? null
      : NextSandhya.fromJson(json['next'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PujaTimesToJson(_PujaTimes instance) =>
    <String, dynamic>{
      'date': instance.date,
      'timezone': instance.timezone,
      'sunrise': instance.sunrise.toIso8601String(),
      'sunset': instance.sunset.toIso8601String(),
      'solarNoon': instance.solarNoon.toIso8601String(),
      'sandhyas': instance.sandhyas,
      'next': instance.next,
    };
