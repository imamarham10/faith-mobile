import 'package:dio/dio.dart';
import 'package:faith_mobile/core/network/api_exception.dart';
import 'package:faith_mobile/core/network/dio_client.dart';
import 'package:faith_mobile/features/settings/data/account_repository.dart';
import 'package:flutter_test/flutter_test.dart';

/// A Dio adapter that answers from a script instead of the network, and
/// records every request it was handed — enough to assert *how many times*
/// a request was sent, which is the point of half of this file.
class _ScriptedAdapter implements HttpClientAdapter {
  _ScriptedAdapter(this._respond);

  final Future<ResponseBody> Function(RequestOptions options, int callIndex)
  _respond;

  final List<RequestOptions> calls = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) {
    calls.add(options);
    return _respond(options, calls.length - 1);
  }

  @override
  void close({bool force = false}) {}
}

AccountRepository _repoWith(_ScriptedAdapter adapter) {
  final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
    ..httpClientAdapter = adapter
    // The real client's retry policy, so the no-retry opt-out is exercised
    // against the thing it opts out of rather than against nothing.
    ..interceptors.add(_RetryLikeProduction(dio: Dio()));
  return AccountRepository(dio);
}

/// Mirrors the production `_RetryInterceptor`'s decision, which is private.
/// If these two ever disagree the no-retry test below stops being meaningful,
/// so the condition is spelled out rather than hidden behind a helper.
class _RetryLikeProduction extends Interceptor {
  _RetryLikeProduction({required this.dio});

  final Dio dio;
  int retries = 0;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.requestOptions.extra[kNoRetry] == true) return handler.next(err);
    final code = err.response?.statusCode ?? 0;
    final retriable =
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        (code >= 500 && code <= 599);
    if (!retriable || retries >= 2) return handler.next(err);
    retries++;
    try {
      handler.resolve(await dio.fetch<dynamic>(err.requestOptions));
    } on DioException catch (e) {
      handler.next(e);
    }
  }
}

ResponseBody _json(RequestOptions o, int status, String body) =>
    ResponseBody.fromString(
      body,
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );

void main() {
  test('sends DELETE to /users/me', () async {
    final adapter = _ScriptedAdapter(
      (o, _) async => _json(o, 200, '{"success":true}'),
    );
    await _repoWith(adapter).deleteAccount();

    expect(adapter.calls, hasLength(1));
    expect(adapter.calls.single.method, 'DELETE');
    expect(adapter.calls.single.path, '/users/me');
  });

  test('allows far longer than the default 20s to respond', () {
    // The handler clears ~28 child tables before the user row. The default
    // receive timeout would abort a delete that is still succeeding.
    expect(
      AccountRepository.deleteTimeout,
      greaterThan(const Duration(seconds: 20)),
    );
  });

  test('treats 404 as success — the account is gone either way', () async {
    final adapter = _ScriptedAdapter(
      (o, _) async => _json(o, 404, '{"message":"User not found"}'),
    );

    // Must not throw: the server deletes the user row last, so "no such
    // user" can only mean the deletion already landed.
    await expectLater(_repoWith(adapter).deleteAccount(), completes);
    expect(adapter.calls, hasLength(1));
  });

  test('never re-sends after a timeout', () async {
    // The hazard this guards: a slow-but-successful delete trips the read
    // timeout, a retry arrives after the user row is already gone, and the
    // 404 gets reported as a failure on a deletion that worked.
    final adapter = _ScriptedAdapter(
      (o, _) => Future.error(
        DioException.receiveTimeout(
          timeout: const Duration(seconds: 1),
          requestOptions: o,
        ),
      ),
    );
    final repo = _repoWith(adapter);

    await expectLater(repo.deleteAccount(), throwsA(isA<ApiException>()));
    expect(adapter.calls, hasLength(1), reason: 'sent exactly once');
  });

  test('never re-sends after a 500', () async {
    final adapter = _ScriptedAdapter(
      (o, _) async => _json(o, 500, '{"message":"boom"}'),
    );
    final repo = _repoWith(adapter);

    await expectLater(repo.deleteAccount(), throwsA(isA<ApiException>()));
    expect(adapter.calls, hasLength(1), reason: 'sent exactly once');
  });

  test('surfaces a real failure as an ApiException', () async {
    final adapter = _ScriptedAdapter(
      (o, _) async => _json(o, 401, '{"message":"Unauthorized"}'),
    );

    await expectLater(
      _repoWith(adapter).deleteAccount(),
      throwsA(isA<ApiException>()),
    );
  });
}
