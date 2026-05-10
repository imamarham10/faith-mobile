import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/providers.dart';
import 'dtos/bookmark.dart';
import 'dtos/surah.dart';
import 'dtos/verse.dart';

part 'quran_repository.g.dart';

/// HTTP boundary for Quran endpoints under `/api/v1/islam/quran/*`.
///
/// Translates Dio failures into [ApiException]; never lets transport errors
/// bubble into widgets.
class QuranRepository {
  QuranRepository(this._dio);

  static const String _base = '/api/v1/islam/quran';

  final Dio _dio;

  /// `GET /surahs` — list of all 114 surahs.
  Future<List<Surah>> getSurahs() async {
    try {
      final res = await _dio.get<dynamic>('$_base/surahs');
      final data = res.data;
      if (data is! List) {
        throw const ApiException(
          message: 'Unexpected response shape from /surahs.',
        );
      }
      return data
          .whereType<Map<String, dynamic>>()
          .map(Surah.fromJson)
          .toList(growable: false);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `GET /surah/:id` — surah with all its verses + translations.
  Future<SurahDetail> getSurah(int id) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('$_base/surah/$id');
      final data = res.data;
      if (data == null) {
        throw const ApiException(message: 'Empty surah response. Try again.');
      }
      return SurahDetail.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `GET /search?q=...` — search verses for a keyword.
  Future<List<Map<String, dynamic>>> search(String query) async {
    try {
      final res = await _dio.get<dynamic>(
        '$_base/search',
        queryParameters: {'q': query},
      );
      final data = res.data;
      if (data is! List) return const <Map<String, dynamic>>[];
      return data.whereType<Map<String, dynamic>>().toList(growable: false);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `GET /bookmarks` — server-side bookmarks for the signed-in user.
  ///
  /// Returns an empty list if the user isn't authenticated or the endpoint
  /// is unavailable; UI falls back to local bookmarks transparently.
  Future<List<Bookmark>> getBookmarks() async {
    try {
      final res = await _dio.get<dynamic>('$_base/bookmarks');
      final data = res.data;
      if (data is! List) return const <Bookmark>[];
      return data
          .whereType<Map<String, dynamic>>()
          .map(Bookmark.fromJson)
          .toList(growable: false);
    } on DioException {
      // Server-side bookmarks are best-effort — the local mirror is canonical.
      return const <Bookmark>[];
    }
  }

  /// `POST /bookmarks` — register a bookmark server-side.
  ///
  /// Server failures are swallowed: the local mirror is the source of truth.
  Future<void> addBookmark({
    required int surahId,
    required int verseNumber,
  }) async {
    try {
      await _dio.post<dynamic>(
        '$_base/bookmarks',
        data: {'surahId': surahId, 'verseNumber': verseNumber},
      );
    } on DioException {
      // Best effort.
    }
  }

  /// `DELETE /bookmarks/:id` — remove a server-side bookmark.
  Future<void> removeBookmark(String id) async {
    try {
      await _dio.delete<dynamic>('$_base/bookmarks/$id');
    } on DioException {
      // Best effort.
    }
  }
}

@Riverpod(keepAlive: true)
QuranRepository quranRepository(Ref ref) =>
    QuranRepository(ref.watch(dioProvider));
