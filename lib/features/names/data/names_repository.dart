import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/providers.dart';
import '../domain/names_kind.dart';
import 'dtos/divine_name.dart';

part 'names_repository.g.dart';

/// HTTP boundary for the names endpoints under `/api/v1/islam/names/*`.
///
/// Endpoint map (verified against the backend's `NamesController`):
/// * Allah list:               `GET  /allah`
/// * Allah by id:              `GET  /allah/:id`
/// * Allah daily:              `GET  /daily`        (note: NOT `/allah/today`)
/// * Allah add favorite:       `POST /favorites`
/// * Allah remove favorite:    `POST /favorites/remove`
/// * Allah favorites list:     `GET  /favorites/list`
/// * Muhammad list:            `GET  /muhammad`
/// * Muhammad by id:           `GET  /muhammad/:id`
/// * Muhammad daily:           `GET  /muhammad/daily`
/// * Muhammad add favorite:    `POST /muhammad/favorites`
/// * Muhammad remove favorite: `POST /muhammad/favorites/remove`
/// * Muhammad favorites list:  `GET  /muhammad/favorites/list`
class NamesRepository {
  NamesRepository(this._dio);

  static const String _base = '/api/v1/islam/names';

  final Dio _dio;

  /// Returns the full 99-name list for the given [kind].
  Future<List<DivineName>> getAll(NamesKind kind) async {
    try {
      final res = await _dio.get<dynamic>(_path(kind));
      final data = res.data;
      if (data is! List) {
        throw const ApiException(message: 'Unexpected response shape.');
      }
      return data
          .whereType<Map<String, dynamic>>()
          .map(DivineName.fromJson)
          .toList(growable: false);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Returns one name by id, scoped to the given [kind].
  Future<DivineName> getById(NamesKind kind, int id) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('${_path(kind)}/$id');
      final data = res.data;
      if (data == null) {
        throw const ApiException(message: 'Empty name response.');
      }
      return DivineName.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Returns the rotating "name of the day" for the given [kind].
  Future<DivineName> getDaily(NamesKind kind) async {
    final path = switch (kind) {
      NamesKind.allah => '$_base/daily',
      NamesKind.muhammad => '$_base/muhammad/daily',
    };
    try {
      final res = await _dio.get<Map<String, dynamic>>(path);
      final data = res.data;
      if (data == null) {
        throw const ApiException(message: 'No daily name available.');
      }
      return DivineName.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `GET .../favorites/list` — best-effort. Returns empty if unavailable.
  Future<List<DivineName>> getFavorites(NamesKind kind) async {
    try {
      final res = await _dio.get<dynamic>('${_path(kind)}/favorites/list');
      final data = res.data;
      if (data is! List) return const <DivineName>[];
      return data
          .whereType<Map<String, dynamic>>()
          .map(DivineName.fromJson)
          .toList(growable: false);
    } on DioException {
      return const <DivineName>[];
    }
  }

  /// `POST .../favorites` — best-effort.
  Future<void> addFavorite(NamesKind kind, int nameId) async {
    final path = switch (kind) {
      NamesKind.allah => '$_base/favorites',
      NamesKind.muhammad => '$_base/muhammad/favorites',
    };
    try {
      await _dio.post<dynamic>(path, data: {'nameId': nameId});
    } on DioException {
      // Local mirror is canonical.
    }
  }

  /// `POST .../favorites/remove` — best-effort.
  Future<void> removeFavorite(NamesKind kind, int nameId) async {
    final path = switch (kind) {
      NamesKind.allah => '$_base/favorites/remove',
      NamesKind.muhammad => '$_base/muhammad/favorites/remove',
    };
    try {
      await _dio.post<dynamic>(path, data: {'nameId': nameId});
    } on DioException {
      // Local mirror is canonical.
    }
  }

  String _path(NamesKind kind) => '$_base/${kind.slug}';
}

@Riverpod(keepAlive: true)
NamesRepository namesRepository(Ref ref) =>
    NamesRepository(ref.watch(dioProvider));
