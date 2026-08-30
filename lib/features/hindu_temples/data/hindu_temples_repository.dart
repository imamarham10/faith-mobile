import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/providers.dart';
import 'dtos/temple.dart';

part 'hindu_temples_repository.g.dart';

/// HTTP boundary for `/api/v1/hindu/temples/*` (backend controller class is
/// `TempleLocatorController`). Net-new module — no Islam precedent to
/// mirror for the shape itself, though the surrounding conventions (try/
/// catch → [ApiException], `keepAlive` repository provider) follow every
/// other Hindu module built this session.
class HinduTemplesRepository {
  HinduTemplesRepository(this._dio);

  static const String _base = '/api/v1/hindu/temples';

  final Dio _dio;

  /// `GET /states` — distinct states with at least one temple, sorted.
  Future<List<String>> getStates() async {
    try {
      final res = await _dio.get<dynamic>('$_base/states');
      final data = res.data;
      if (data is! List) return const <String>[];
      return data.whereType<String>().toList(growable: false);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `GET /nearby?lat&lng&radiusKm` — temples within [radiusKm] (backend
  /// default 100), pre-sorted ascending by distance, each carrying a
  /// server-computed `distanceKm`.
  Future<List<Temple>> getNearby({
    required double lat,
    required double lng,
    double? radiusKm,
  }) async {
    try {
      final res = await _dio.get<dynamic>(
        '$_base/nearby',
        queryParameters: {
          'lat': lat,
          'lng': lng,
          if (radiusKm != null) 'radiusKm': radiusKm,
        },
      );
      final data = res.data;
      if (data is! List) return const <Temple>[];
      return data
          .whereType<Map<String, dynamic>>()
          .map(Temple.fromJson)
          .toList(growable: false);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `GET ?state=&deity=&q=` — filtered/browsed list, ordered by name.
  /// Note the query param is `deity`, not `deityKey` — the backend silently
  /// ignores an unrecognized param name rather than 400ing, so this is easy
  /// to get wrong without noticing.
  Future<List<Temple>> getTemples({String? state, String? deity, String? q}) async {
    try {
      final res = await _dio.get<dynamic>(
        _base,
        queryParameters: {
          if (state != null) 'state': state,
          if (deity != null) 'deity': deity,
          if (q != null) 'q': q,
        },
      );
      final data = res.data;
      if (data is! List) return const <Temple>[];
      return data
          .whereType<Map<String, dynamic>>()
          .map(Temple.fromJson)
          .toList(growable: false);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `GET /:id` — a single temple.
  Future<Temple> getTemple(String id) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('$_base/$id');
      final data = res.data;
      if (data == null) {
        throw const ApiException(message: 'Empty temple response.');
      }
      return Temple.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `GET /favorites` — current user's favorited temples. Auth required;
  /// returns empty on any failure. Unwraps the backend's `{id, createdAt,
  /// temple}[]` wrapper shape.
  Future<List<Temple>> getFavorites() async {
    try {
      final res = await _dio.get<dynamic>('$_base/favorites');
      final data = res.data;
      if (data is! List) return const <Temple>[];
      return data
          .whereType<Map<String, dynamic>>()
          .map((row) => row['temple'])
          .whereType<Map<String, dynamic>>()
          .map(Temple.fromJson)
          .toList(growable: false);
    } on DioException {
      return const <Temple>[];
    }
  }

  /// `POST /favorites` — add a temple to favorites server-side. Best-effort.
  Future<void> addFavorite(String templeId) async {
    try {
      await _dio.post<dynamic>('$_base/favorites', data: {'templeId': templeId});
    } on DioException {
      // Local mirror remains canonical.
    }
  }

  /// `DELETE /favorites/:templeId` — remove a favorite server-side.
  Future<void> removeFavorite(String templeId) async {
    try {
      await _dio.delete<dynamic>('$_base/favorites/$templeId');
    } on DioException {
      // Local mirror remains canonical.
    }
  }
}

@Riverpod(keepAlive: true)
HinduTemplesRepository hinduTemplesRepository(Ref ref) =>
    HinduTemplesRepository(ref.watch(dioProvider));
