// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_track.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AudioTrack _$AudioTrackFromJson(Map<String, dynamic> json) => _AudioTrack(
  reciterSlug: json['reciterSlug'] as String,
  name: json['name'] as String,
  language: json['language'] as String,
  credit: json['credit'] as String?,
  url: json['url'] as String,
  isPremium: json['isPremium'] as bool? ?? false,
);

Map<String, dynamic> _$AudioTrackToJson(_AudioTrack instance) =>
    <String, dynamic>{
      'reciterSlug': instance.reciterSlug,
      'name': instance.name,
      'language': instance.language,
      'credit': instance.credit,
      'url': instance.url,
      'isPremium': instance.isPremium,
    };
