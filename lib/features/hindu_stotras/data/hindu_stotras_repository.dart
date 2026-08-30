import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/providers.dart';
import 'dtos/stotra.dart';
import 'dtos/stotra_category.dart';

part 'hindu_stotras_repository.g.dart';

/// HTTP boundary for `/api/v1/hindu/stotras/*`. Mirrors `duas_repository.dart`
/// shape, adapted for two backend differences:
/// * the list-filter query param is `category` (a slug), not `categoryId`;
/// * `GET /favorites` returns favorite-record wrappers (`{id, createdAt,
///   stotra: {...}}`), not a flat stotra array, so [getFavorites] unwraps
///   `.stotra` to keep the same flat `List<Stotra>` shape duas' controller
///   code expects.
class HinduStotrasRepository {
  HinduStotrasRepository(this._dio);

  static const String _base = '/api/v1/hindu/stotras';

  final Dio _dio;

  /// `GET /categories` — all stotra categories, alphabetized server-side.
  Future<List<StotraCategory>> getCategories() async {
    try {
      final res = await _dio.get<dynamic>('$_base/categories');
      final data = res.data;
      if (data is! List) {
        throw const ApiException(
          message: 'Unexpected response shape from /stotras/categories.',
        );
      }
      return data
          .whereType<Map<String, dynamic>>()
          .map(StotraCategory.fromJson)
          .toList(growable: false);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `GET ?category=&deity=&type=` — stotras filtered by any combination of
  /// category slug, deity key, and type (`stotra`/`aarti`/`bhajan`).
  Future<List<Stotra>> getStotras({
    String? category,
    String? deity,
    String? type,
  }) async {
    try {
      final res = await _dio.get<dynamic>(
        _base,
        queryParameters: {
          if (category != null) 'category': category,
          if (deity != null) 'deity': deity,
          if (type != null) 'type': type,
        },
      );
      final data = res.data;
      if (data is! List) return const <Stotra>[];
      return data
          .whereType<Map<String, dynamic>>()
          .map(Stotra.fromJson)
          .toList(growable: false);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `GET /:slug?lang=` — full stotra with verses.
  Future<StotraDetail> getStotraBySlug(String slug, {String lang = 'en'}) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '$_base/$slug',
        queryParameters: {'lang': lang},
      );
      final data = res.data;
      if (data == null) {
        throw const ApiException(message: 'Empty stotra response.');
      }
      return StotraDetail.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `GET /search?q=` — title search across Sanskrit and English titles.
  Future<List<Stotra>> search(String query) async {
    try {
      final res = await _dio.get<dynamic>(
        '$_base/search',
        queryParameters: {'q': query},
      );
      final data = res.data;
      if (data is! List) return const <Stotra>[];
      return data
          .whereType<Map<String, dynamic>>()
          .map(Stotra.fromJson)
          .toList(growable: false);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `GET /favorites` — current user's favorited stotras. Auth required;
  /// returns empty on any failure so the UI degrades gracefully. Unwraps
  /// the backend's `{id, createdAt, stotra}[]` wrapper shape.
  Future<List<Stotra>> getFavorites() async {
    try {
      final res = await _dio.get<dynamic>('$_base/favorites');
      final data = res.data;
      if (data is! List) return const <Stotra>[];
      return data
          .whereType<Map<String, dynamic>>()
          .map((row) => row['stotra'])
          .whereType<Map<String, dynamic>>()
          .map(Stotra.fromJson)
          .toList(growable: false);
    } on DioException {
      return const <Stotra>[];
    }
  }

  /// `POST /favorites` — add a stotra to favorites server-side. Best-effort.
  Future<void> addFavorite(String stotraId) async {
    try {
      await _dio.post<dynamic>('$_base/favorites', data: {'stotraId': stotraId});
    } on DioException {
      // Local mirror remains canonical.
    }
  }

  /// `DELETE /favorites/:stotraId` — remove a favorite server-side.
  /// Best-effort, unlike duas (which has no DELETE endpoint at all), this
  /// backend supports a real remote-synced removal.
  Future<void> removeFavorite(String stotraId) async {
    try {
      await _dio.delete<dynamic>('$_base/favorites/$stotraId');
    } on DioException {
      // Local mirror remains canonical.
    }
  }
}

@Riverpod(keepAlive: true)
HinduStotrasRepository hinduStotrasRepository(Ref ref) =>
    HinduStotrasRepository(ref.watch(dioProvider));
