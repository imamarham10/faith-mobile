import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/providers.dart';
import 'dtos/dua.dart';
import 'dtos/dua_category.dart';

part 'duas_repository.g.dart';

/// HTTP boundary for `/api/v1/islam/duas/*`.
///
/// Surfaces all transport failures as [ApiException]; widgets never see a
/// raw [DioException].
class DuasRepository {
  DuasRepository(this._dio);

  static const String _base = '/api/v1/islam/duas';

  final Dio _dio;

  /// `GET /categories` — all dua categories (sorted alphabetically server-side).
  Future<List<DuaCategory>> getCategories() async {
    try {
      final res = await _dio.get<dynamic>('$_base/categories');
      final data = res.data;
      if (data is! List) {
        throw const ApiException(
          message: 'Unexpected response shape from /duas/categories.',
        );
      }
      return data
          .whereType<Map<String, dynamic>>()
          .map(DuaCategory.fromJson)
          .toList(growable: false);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `GET ?categoryId=...` — duas filtered by category.
  Future<List<Dua>> getDuasByCategory(String categoryId) async {
    try {
      final res = await _dio.get<dynamic>(
        _base,
        queryParameters: {'categoryId': categoryId},
      );
      final data = res.data;
      if (data is! List) return const <Dua>[];
      return data
          .whereType<Map<String, dynamic>>()
          .map(Dua.fromJson)
          .toList(growable: false);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `GET /:id` — single dua with its category.
  Future<Dua> getDua(String id) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('$_base/$id');
      final data = res.data;
      if (data == null) {
        throw const ApiException(message: 'Empty dua response.');
      }
      return Dua.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `GET /search?q=...` — full-text-ish search across title/translation.
  Future<List<Dua>> search(String query) async {
    try {
      final res = await _dio.get<dynamic>(
        '$_base/search',
        queryParameters: {'q': query},
      );
      final data = res.data;
      if (data is! List) return const <Dua>[];
      return data
          .whereType<Map<String, dynamic>>()
          .map(Dua.fromJson)
          .toList(growable: false);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `GET /favorites` — current user's favorited duas. Auth required.
  /// Returns empty on auth/transport failure so the UI degrades gracefully.
  Future<List<Dua>> getFavorites() async {
    try {
      final res = await _dio.get<dynamic>('$_base/favorites');
      final data = res.data;
      if (data is! List) return const <Dua>[];
      return data
          .whereType<Map<String, dynamic>>()
          .map(Dua.fromJson)
          .toList(growable: false);
    } on DioException {
      return const <Dua>[];
    }
  }

  /// `POST /favorites` — add a dua to favorites server-side. Best-effort.
  Future<void> addFavorite(String duaId) async {
    try {
      await _dio.post<dynamic>('$_base/favorites', data: {'duaId': duaId});
    } on DioException {
      // Local mirror remains canonical.
    }
  }
}

@Riverpod(keepAlive: true)
DuasRepository duasRepository(Ref ref) =>
    DuasRepository(ref.watch(dioProvider));
