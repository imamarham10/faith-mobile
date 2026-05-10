import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/providers.dart';
import 'dtos/emotion.dart';
import 'dtos/remedy.dart';

part 'feelings_repository.g.dart';

/// HTTP boundary for `/api/v1/islam/feelings/*`.
///
/// Per APIs.md only two endpoints are confirmed:
///   * `GET /api/v1/islam/feelings`         — list emotions
///   * `GET /api/v1/islam/feelings/:slug`   — emotion detail with remedies
///
/// Journal + history are persisted client-side (see [JournalController] /
/// [MoodHistoryController]). When the backend ships those endpoints, the
/// methods here can be filled in without UI changes.
class FeelingsRepository {
  FeelingsRepository(this._dio);

  static const String _base = '/api/v1/islam/feelings';

  final Dio _dio;

  /// `GET /` — list all emotions.
  Future<List<Emotion>> getEmotions() async {
    try {
      final res = await _dio.get<dynamic>(_base);
      final data = res.data;
      if (data is! List) return const <Emotion>[];
      return data
          .whereType<Map<String, dynamic>>()
          .map(Emotion.fromJson)
          .toList(growable: false);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `GET /:slug` — single emotion with attached remedies.
  Future<EmotionDetail> getEmotion(String slug) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('$_base/$slug');
      final data = res.data;
      if (data == null) {
        throw const ApiException(message: 'Empty feelings response.');
      }
      final remedies =
          (data['remedies'] as List?)
              ?.whereType<Map<String, dynamic>>()
              .map(Remedy.parse)
              .toList(growable: false) ??
          const <Remedy>[];
      return EmotionDetail(
        slug: (data['slug'] as String?) ?? slug,
        name: (data['name'] as String?) ?? slug,
        icon: data['icon'] as String?,
        description: data['description'] as String?,
        remedies: remedies,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

@Riverpod(keepAlive: true)
FeelingsRepository feelingsRepository(Ref ref) =>
    FeelingsRepository(ref.watch(dioProvider));
