import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/providers.dart';
import 'dtos/hindu_emotion.dart';
import 'dtos/hindu_remedy.dart';

part 'hindu_feelings_repository.g.dart';

/// HTTP boundary for `/api/v1/hindu/feelings/*`. Mirrors
/// `feelings_repository.dart`'s shape, but the backend is genuinely
/// distinct here — not a namespace swap of the same data: emotions carry
/// a Hindi name alongside English, and each remedy is a Gita verse (with
/// its own reflective note) rather than a flat dua/hadith string.
class HinduFeelingsRepository {
  HinduFeelingsRepository(this._dio);

  static const String _base = '/api/v1/hindu/feelings';

  final Dio _dio;

  /// `GET /` — list all emotions.
  Future<List<HinduEmotion>> getEmotions() async {
    try {
      final res = await _dio.get<dynamic>(_base);
      final data = res.data;
      if (data is! List) return const <HinduEmotion>[];
      return data
          .whereType<Map<String, dynamic>>()
          .map(HinduEmotion.fromJson)
          .toList(growable: false);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `GET /:slug` — single emotion with attached remedies.
  Future<HinduEmotionDetail> getEmotion(String slug) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('$_base/$slug');
      final data = res.data;
      if (data == null) {
        throw const ApiException(message: 'Empty feelings response.');
      }
      final remedies =
          (data['remedies'] as List?)
              ?.whereType<Map<String, dynamic>>()
              .map(HinduRemedy.parse)
              .toList(growable: false) ??
          const <HinduRemedy>[];
      return HinduEmotionDetail(
        slug: (data['slug'] as String?) ?? slug,
        nameEnglish: (data['nameEnglish'] as String?) ?? slug,
        nameHindi: data['nameHindi'] as String?,
        icon: data['icon'] as String?,
        remedies: remedies,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

@Riverpod(keepAlive: true)
HinduFeelingsRepository hinduFeelingsRepository(Ref ref) =>
    HinduFeelingsRepository(ref.watch(dioProvider));
