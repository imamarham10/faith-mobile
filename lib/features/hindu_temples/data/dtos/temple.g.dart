// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'temple.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Temple _$TempleFromJson(Map<String, dynamic> json) => _Temple(
  id: json['id'] as String,
  name: json['name'] as String,
  deityKey: json['deityKey'] as String?,
  lat: (json['lat'] as num).toDouble(),
  lng: (json['lng'] as num).toDouble(),
  address: json['address'] as String,
  city: json['city'] as String?,
  state: json['state'] as String?,
  country: json['country'] as String,
  description: json['description'] as String?,
  significance: json['significance'] as String?,
  photos:
      (json['photos'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  googlePlaceId: json['googlePlaceId'] as String?,
  source: json['source'] as String,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  distanceKm: (json['distanceKm'] as num?)?.toDouble(),
);

Map<String, dynamic> _$TempleToJson(_Temple instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'deityKey': instance.deityKey,
  'lat': instance.lat,
  'lng': instance.lng,
  'address': instance.address,
  'city': instance.city,
  'state': instance.state,
  'country': instance.country,
  'description': instance.description,
  'significance': instance.significance,
  'photos': instance.photos,
  'googlePlaceId': instance.googlePlaceId,
  'source': instance.source,
  'createdAt': instance.createdAt?.toIso8601String(),
  'distanceKm': instance.distanceKm,
};
