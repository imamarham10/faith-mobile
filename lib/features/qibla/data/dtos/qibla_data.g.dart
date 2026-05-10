// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qibla_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QiblaData _$QiblaDataFromJson(Map<String, dynamic> json) => _QiblaData(
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  bearingDegrees: (json['bearingDegrees'] as num).toDouble(),
  distanceKm: (json['distanceKm'] as num).toDouble(),
);

Map<String, dynamic> _$QiblaDataToJson(_QiblaData instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'bearingDegrees': instance.bearingDegrees,
      'distanceKm': instance.distanceKm,
    };
