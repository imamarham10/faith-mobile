import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/providers.dart';
import 'dtos/hadith.dart';
import 'dtos/hadith_book.dart';

part 'hadiths_repository.g.dart';

/// Page of hadiths returned by the paginated list endpoint.
class HadithsPage {
  const HadithsPage({
    required this.hadiths,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  final List<Hadith> hadiths;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  bool get hasMore => page < totalPages;
}

/// HTTP boundary for `/api/v1/islam/hadiths/*`.
///
/// Translates Dio failures into [ApiException] so widgets only deal with a
/// single, user-readable error type.
class HadithsRepository {
  HadithsRepository(this._dio);

  static const String _base = '/api/v1/islam/hadiths';

  final Dio _dio;

  /// `GET /books` — all hadith collections (free + premium). Sorted server-side.
  Future<List<HadithBook>> getBooks() async {
    try {
      final res = await _dio.get<dynamic>('$_base/books');
      final data = res.data;
      if (data is! List) {
        throw const ApiException(
          message: 'Unexpected response shape from /hadiths/books.',
        );
      }
      return data
          .whereType<Map<String, dynamic>>()
          .map(HadithBook.fromJson)
          .toList(growable: false);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `GET /daily` — hadith of the day, rotated daily server-side.
  ///
  /// Returns null if no eligible hadiths exist (defensive — should not
  /// happen in practice).
  Future<Hadith?> getDailyHadith() async {
    try {
      final res = await _dio.get<dynamic>('$_base/daily');
      final data = res.data;
      if (data is! Map<String, dynamic>) return null;
      return Hadith.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `GET /search?q=...` — full-text search across translation + narrator.
  ///
  /// Backend returns `[]` for queries shorter than 3 chars; we still send the
  /// request so the contract stays single-source.
  Future<List<Hadith>> search(String query) async {
    try {
      final res = await _dio.get<dynamic>(
        '$_base/search',
        queryParameters: {'q': query},
      );
      final data = res.data;
      if (data is! List) return const <Hadith>[];
      return data
          .whereType<Map<String, dynamic>>()
          .map(Hadith.fromJson)
          .toList(growable: false);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `GET /?bookId=&page=&limit=` — paginated list of hadiths in a book.
  Future<HadithsPage> getHadithsByBook({
    required String bookId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final res = await _dio.get<dynamic>(
        _base,
        queryParameters: {'bookId': bookId, 'page': page, 'limit': limit},
      );
      final data = res.data;
      if (data is! Map<String, dynamic>) {
        throw const ApiException(
          message: 'Unexpected response shape from /hadiths.',
        );
      }
      final list = data['hadiths'];
      final hadiths = list is List
          ? list
                .whereType<Map<String, dynamic>>()
                .map(Hadith.fromJson)
                .toList(growable: false)
          : const <Hadith>[];
      return HadithsPage(
        hadiths: hadiths,
        total: (data['total'] as num?)?.toInt() ?? hadiths.length,
        page: (data['page'] as num?)?.toInt() ?? page,
        limit: (data['limit'] as num?)?.toInt() ?? limit,
        totalPages: (data['totalPages'] as num?)?.toInt() ?? 1,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `GET /:id` — single hadith with the full book joined.
  Future<Hadith> getHadith(String id) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('$_base/$id');
      final data = res.data;
      if (data == null) {
        throw const ApiException(message: 'Empty hadith response.');
      }
      return Hadith.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

@Riverpod(keepAlive: true)
HadithsRepository hadithsRepository(Ref ref) =>
    HadithsRepository(ref.watch(dioProvider));
