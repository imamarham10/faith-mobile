// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hindu_emotion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HinduEmotion _$HinduEmotionFromJson(Map<String, dynamic> json) =>
    _HinduEmotion(
      id: json['id'] as String,
      slug: json['slug'] as String,
      nameEnglish: json['nameEnglish'] as String,
      nameHindi: json['nameHindi'] as String?,
      icon: json['icon'] as String?,
      remedyCount: (json['remedyCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$HinduEmotionToJson(_HinduEmotion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'nameEnglish': instance.nameEnglish,
      'nameHindi': instance.nameHindi,
      'icon': instance.icon,
      'remedyCount': instance.remedyCount,
    };
