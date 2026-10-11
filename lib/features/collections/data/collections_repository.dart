import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/providers.dart';
import '../../../core/theme/faith_id.dart';
import 'dtos/curated_collection.dart';

part 'collections_repository.g.dart';

/// HTTP boundary for curated collections.
///
/// ## Why one repository and not one per faith
///
/// `/api/v1/islam/collections` and `/api/v1/hindu/collections` are two
/// controllers over one service, one table and one `faithId` discriminator
/// — the server's own comment says writing the resolver twice would
/// guarantee the halves drift, and the Hindu half would be the one that
/// rots. The same argument holds on this side of the wire: the payloads are
/// identical in shape, so the faith is a path segment here and nothing else
/// differs.
///
/// Mirrors `QuranRepository` and `HinduScripturesRepository` exactly: same
/// try/catch, same [ApiException] surfacing, same `@Riverpod(keepAlive:
/// true)` provider — transport errors never reach a widget.
class CollectionsRepository {
  CollectionsRepository(this._dio);

  final Dio _dio;

  static String _base(FaithId faith) => '/api/v1/${faith.name}/collections';

  /// `GET /collections` — every servable collection for [faith], in the
  /// server's order (`sortOrder` asc, then `priority` desc, then `slug`).
  ///
  /// That order is returned untouched. Nothing in this feature re-sorts.
  ///
  /// No `?lang=`/`?script=`: the summary payload carries no scripture, so
  /// neither parameter changes a byte of what is parsed here.
  Future<List<CuratedCollection>> getCollections(FaithId faith) async {
    try {
      final res = await _dio.get<dynamic>(_base(faith));
      final data = res.data;
      if (data is! List) {
        throw const ApiException(
          message: 'Unexpected response shape from /collections.',
        );
      }
      return data
          .whereType<Map<String, dynamic>>()
          .map(CuratedCollection.fromJson)
          .toList(growable: false);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `GET /collections/:slug` — the collection with its items resolved.
  ///
  /// 404s for a slug that does not exist *for this faith*, which is how a
  /// stale deep link to the other vertical's collection surfaces.
  ///
  /// `?lang=`/`?script=` are again not sent. The server resolves each item's
  /// full scripture inline and this client keeps none of it — see
  /// `CollectionItem`'s class doc for why.
  Future<CuratedCollection> getCollection(FaithId faith, String slug) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '${_base(faith)}/$slug',
      );
      final data = res.data;
      if (data == null) {
        throw const ApiException(
          message: 'Empty collection response. Try again.',
        );
      }
      return CuratedCollection.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

@Riverpod(keepAlive: true)
CollectionsRepository collectionsRepository(Ref ref) =>
    CollectionsRepository(ref.watch(dioProvider));
