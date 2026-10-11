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

  /// `GET /books` — hadith collections, **free editions only**.
  ///
  /// The endpoint serves every collection, premium included, because the web
  /// client paywalls them and needs the full list to do it. This app has no
  /// billing, so it may not surface paid content at all: a store listing that
  /// shows a collection it cannot open is a locked door with no handle, and
  /// selling the key would need Play Billing. Filtering here rather than in a
  /// controller or a screen means no consumer — the books grid, the search
  /// screen's corpus count, [HadithBookScreen]'s lookup, or anything added
  /// later — can see a premium row at all.
  ///
  /// The filter wants to move server-side (`?freeOnly=true`) once that ships;
  /// doing it here keeps the release off a deploy. `isPremium` stays on
  /// [HadithBook] because the wire still sends it and this is what reads it.
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
          .where((b) => !b.isPremium)
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
      final failure = ApiException.fromDio(e);
      // A premium `bookId` answers 403 with the server's own sales copy
      // ("This collection requires a premium subscription"), and
      // [ApiException.fromDio] passes a server `message` through verbatim.
      // [getBooks] means nothing in the app can reach that id any more, but
      // a stale deep link still can, and that sentence must never render.
      if (failure.statusCode == 403) throw _collectionUnavailable;
      throw failure;
    }
  }

  /// `GET /:id` — single hadith with the full book joined.
  ///
  /// The endpoint has no entitlement check of its own, so a shared or stale
  /// link to a hadith in a paid collection would render it in full. The
  /// detail response carries the whole book, `isPremium` included, which is
  /// what makes the check possible here: such a hadith is reported as
  /// missing, the same answer a deleted id gets, because as far as this
  /// build is concerned it does not exist.
  Future<Hadith> getHadith(String id) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('$_base/$id');
      final data = res.data;
      if (data == null) {
        throw const ApiException(message: 'Empty hadith response.');
      }
      final hadith = Hadith.fromJson(data);
      if (hadith.book?.isPremium ?? false) throw _hadithNotFound;
      return hadith;
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

/// What a reader sees instead of a paid collection they linked into.
///
/// Deliberately free of any hint that there is something to unlock — this
/// build does not sell content, so an "upgrade" prompt would be both a lie
/// and, with no Play Billing wired up, a store-policy problem.
const ApiException _collectionUnavailable = ApiException(
  message: 'This collection isn\'t available.',
  statusCode: 403,
);

/// A hadith this build does not carry. Same wording as a genuine 404.
const ApiException _hadithNotFound = ApiException(
  message: 'We couldn\'t find that hadith.',
  statusCode: 404,
);

@Riverpod(keepAlive: true)
HadithsRepository hadithsRepository(Ref ref) =>
    HadithsRepository(ref.watch(dioProvider));
