// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'panchang_day.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TimeWindow _$TimeWindowFromJson(Map<String, dynamic> json) => _TimeWindow(
  start: DateTime.parse(json['start'] as String),
  end: DateTime.parse(json['end'] as String),
);

Map<String, dynamic> _$TimeWindowToJson(_TimeWindow instance) =>
    <String, dynamic>{
      'start': instance.start.toIso8601String(),
      'end': instance.end.toIso8601String(),
    };

_TithiInfo _$TithiInfoFromJson(Map<String, dynamic> json) => _TithiInfo(
  number: (json['number'] as num).toInt(),
  name: json['name'] as String,
  nameSanskrit: json['nameSanskrit'] as String,
  paksha: json['paksha'] as String,
  endTime: json['endTime'] == null
      ? null
      : DateTime.parse(json['endTime'] as String),
);

Map<String, dynamic> _$TithiInfoToJson(_TithiInfo instance) =>
    <String, dynamic>{
      'number': instance.number,
      'name': instance.name,
      'nameSanskrit': instance.nameSanskrit,
      'paksha': instance.paksha,
      'endTime': instance.endTime?.toIso8601String(),
    };

_NakshatraInfo _$NakshatraInfoFromJson(Map<String, dynamic> json) =>
    _NakshatraInfo(
      number: (json['number'] as num).toInt(),
      name: json['name'] as String,
      nameSanskrit: json['nameSanskrit'] as String,
      deity: json['deity'] as String,
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
    );

Map<String, dynamic> _$NakshatraInfoToJson(_NakshatraInfo instance) =>
    <String, dynamic>{
      'number': instance.number,
      'name': instance.name,
      'nameSanskrit': instance.nameSanskrit,
      'deity': instance.deity,
      'endTime': instance.endTime?.toIso8601String(),
    };

_YogaInfo _$YogaInfoFromJson(Map<String, dynamic> json) => _YogaInfo(
  number: (json['number'] as num).toInt(),
  name: json['name'] as String,
  nameSanskrit: json['nameSanskrit'] as String,
);

Map<String, dynamic> _$YogaInfoToJson(_YogaInfo instance) => <String, dynamic>{
  'number': instance.number,
  'name': instance.name,
  'nameSanskrit': instance.nameSanskrit,
};

_KaranaInfo _$KaranaInfoFromJson(Map<String, dynamic> json) => _KaranaInfo(
  number: (json['number'] as num).toInt(),
  name: json['name'] as String,
  nameSanskrit: json['nameSanskrit'] as String,
  isAuspicious: json['isAuspicious'] as bool,
);

Map<String, dynamic> _$KaranaInfoToJson(_KaranaInfo instance) =>
    <String, dynamic>{
      'number': instance.number,
      'name': instance.name,
      'nameSanskrit': instance.nameSanskrit,
      'isAuspicious': instance.isAuspicious,
    };

_VaaraInfo _$VaaraInfoFromJson(Map<String, dynamic> json) => _VaaraInfo(
  number: (json['number'] as num).toInt(),
  name: json['name'] as String,
  nameSanskrit: json['nameSanskrit'] as String,
);

Map<String, dynamic> _$VaaraInfoToJson(_VaaraInfo instance) =>
    <String, dynamic>{
      'number': instance.number,
      'name': instance.name,
      'nameSanskrit': instance.nameSanskrit,
    };

_AuspiciousTimes _$AuspiciousTimesFromJson(Map<String, dynamic> json) =>
    _AuspiciousTimes(
      brahmaMuhurta: TimeWindow.fromJson(
        json['brahmaMuhurta'] as Map<String, dynamic>,
      ),
      abhijitMuhurta: json['abhijitMuhurta'] == null
          ? null
          : TimeWindow.fromJson(json['abhijitMuhurta'] as Map<String, dynamic>),
      rahuKaal: TimeWindow.fromJson(json['rahuKaal'] as Map<String, dynamic>),
      yamagandam: TimeWindow.fromJson(
        json['yamagandam'] as Map<String, dynamic>,
      ),
      gulika: TimeWindow.fromJson(json['gulika'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuspiciousTimesToJson(_AuspiciousTimes instance) =>
    <String, dynamic>{
      'brahmaMuhurta': instance.brahmaMuhurta,
      'abhijitMuhurta': instance.abhijitMuhurta,
      'rahuKaal': instance.rahuKaal,
      'yamagandam': instance.yamagandam,
      'gulika': instance.gulika,
    };

_FestivalSummary _$FestivalSummaryFromJson(Map<String, dynamic> json) =>
    _FestivalSummary(
      slug: json['slug'] as String,
      nameEnglish: json['nameEnglish'] as String,
      nameSanskrit: json['nameSanskrit'] as String?,
    );

Map<String, dynamic> _$FestivalSummaryToJson(_FestivalSummary instance) =>
    <String, dynamic>{
      'slug': instance.slug,
      'nameEnglish': instance.nameEnglish,
      'nameSanskrit': instance.nameSanskrit,
    };

_PanchangDay _$PanchangDayFromJson(Map<String, dynamic> json) => _PanchangDay(
  date: json['date'] as String,
  timezone: json['timezone'] as String,
  tithi: TithiInfo.fromJson(json['tithi'] as Map<String, dynamic>),
  nakshatra: NakshatraInfo.fromJson(json['nakshatra'] as Map<String, dynamic>),
  yoga: YogaInfo.fromJson(json['yoga'] as Map<String, dynamic>),
  karana: KaranaInfo.fromJson(json['karana'] as Map<String, dynamic>),
  vaara: VaaraInfo.fromJson(json['vaara'] as Map<String, dynamic>),
  sunrise: DateTime.parse(json['sunrise'] as String),
  sunset: DateTime.parse(json['sunset'] as String),
  moonrise: json['moonrise'] == null
      ? null
      : DateTime.parse(json['moonrise'] as String),
  moonset: json['moonset'] == null
      ? null
      : DateTime.parse(json['moonset'] as String),
  auspicious: AuspiciousTimes.fromJson(
    json['auspicious'] as Map<String, dynamic>,
  ),
  festivals:
      (json['festivals'] as List<dynamic>?)
          ?.map((e) => FestivalSummary.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <FestivalSummary>[],
);

Map<String, dynamic> _$PanchangDayToJson(_PanchangDay instance) =>
    <String, dynamic>{
      'date': instance.date,
      'timezone': instance.timezone,
      'tithi': instance.tithi,
      'nakshatra': instance.nakshatra,
      'yoga': instance.yoga,
      'karana': instance.karana,
      'vaara': instance.vaara,
      'sunrise': instance.sunrise.toIso8601String(),
      'sunset': instance.sunset.toIso8601String(),
      'moonrise': instance.moonrise?.toIso8601String(),
      'moonset': instance.moonset?.toIso8601String(),
      'auspicious': instance.auspicious,
      'festivals': instance.festivals,
    };
