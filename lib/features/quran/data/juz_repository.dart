import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/providers.dart';
import 'dtos/juz.dart';

part 'juz_repository.g.dart';

/// HTTP boundary for the two juz endpoints, per
/// `docs/contracts/quran-juz-api.md`.
///
/// Kept apart from [QuranRepository] rather than bolted onto it so the juz
/// reader can be exercised against a fake without stubbing surahs,
/// bookmarks and search as well. Tests supply their own
/// `implements JuzRepository` — every Dart class is an implicit interface,
/// so no abstract base is needed and the shape matches the repositories
/// already in this feature.
class JuzRepository {
  JuzRepository(this._dio);

  static const String _base = '/api/v1/islam/quran';

  /// The server's own default, restated here because the reader has to map a
  /// juz-wide verse index onto a page number *before* it has seen a page.
  /// The value actually used is always the `limit` the server echoes back.
  static const int defaultPageLimit = 50;

  /// The server rejects anything larger with a 400 — it does not clamp — so
  /// this is enforced here rather than discovered at runtime.
  static const int maxPageLimit = 300;

  final Dio _dio;

  /// `GET /juz` — the 30-entry chooser.
  Future<List<JuzSummary>> getJuzIndex() async {
    try {
      final res = await _dio.get<dynamic>('$_base/juz');
      final data = res.data;
      if (data is! List) {
        throw const ApiException(
          message: 'Unexpected response shape from /juz.',
        );
      }
      return data
          .whereType<Map<String, dynamic>>()
          .map(JuzSummary.fromJson)
          .toList(growable: false);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `GET /juz/:number` — one page of a juz's verses.
  ///
  /// [translationId] is the translation's **author name** (e.g.
  /// `Saheeh International`), not a uuid: the edition is the only translation
  /// identity this API exposes anywhere — `QuranTranslation.id` is a
  /// per-verse row id, 6,236 per edition, and `GET /translations` returns no
  /// id at all. Treat it as an opaque string taken from `GET /translations`
  /// and never construct one.
  ///
  /// Both juz endpoints are public, so paid editions are filtered out
  /// server-side. Asking for one — or for a name that does not exist — is
  /// not an error: the verse comes back with a null `translation`, and the
  /// reader shows the Arabic alone.
  Future<JuzPage> getJuzPage(
    int number, {
    int page = 1,
    int limit = defaultPageLimit,
    String? translationId,
  }) async {
    assert(
      limit >= 1 && limit <= maxPageLimit,
      'limit must be 1-$maxPageLimit; the server 400s above that rather '
      'than clamping.',
    );
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '$_base/juz/$number',
        queryParameters: <String, dynamic>{
          'page': page,
          'limit': limit,
          if (translationId != null) 'translationId': translationId,
        },
      );
      final data = res.data;
      if (data == null) {
        throw const ApiException(message: 'Empty juz response. Try again.');
      }
      return JuzPage.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

@Riverpod(keepAlive: true)
JuzRepository juzRepository(Ref ref) => JuzRepository(ref.watch(dioProvider));
