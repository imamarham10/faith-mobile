import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

/// A [Dio] adapter that answers from a route table instead of the network.
///
/// Lets a repository be exercised across its real JSON boundary — the
/// parsing, the filtering and the `DioException` translation all run — with
/// only the socket replaced. Keys are matched as path *suffixes*, so
/// `'/hadiths/books'` answers `/api/v1/islam/hadiths/books`; put the more
/// specific key first where two could both match.
class StubHttpAdapter implements HttpClientAdapter {
  StubHttpAdapter(this.routes);

  /// Path suffix → `(statusCode, jsonBody)`. Mutable so a test can change
  /// one answer after `setUp` has built the table.
  final Map<String, (int, Object)> routes;

  /// Every URL asked for, in order. The assertion that a request was *not*
  /// made is often the whole point.
  final List<String> requested = [];

  /// A [Dio] wired to this adapter.
  Dio dio() =>
      Dio(BaseOptions(baseUrl: 'https://example.test'))
        ..httpClientAdapter = this;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requested.add(options.uri.toString());
    for (final entry in routes.entries) {
      if (options.path.endsWith(entry.key)) {
        final (status, body) = entry.value;
        return ResponseBody.fromString(
          jsonEncode(body),
          status,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      }
    }
    return ResponseBody.fromString('{}', 404);
  }

  @override
  void close({bool force = false}) {}
}
