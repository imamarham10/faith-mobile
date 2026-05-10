import 'package:dio/dio.dart';

import '../storage/secure_storage.dart';

/// Attaches the bearer access token and refreshes it on 401.
///
/// Authentication endpoints (login, refresh, otp) are skipped on the way out
/// — we never stamp a possibly-stale token onto a request that issues or
/// rotates it. On 401 we make one attempt to refresh via `/auth/refresh`,
/// rewrite the original request with the new token, and re-issue it. A
/// single-flight gate keeps concurrent 401s from racing N refreshes; the
/// `_retried` extra flag prevents an infinite loop if refresh itself 401s.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._storage, this._dio);

  final SecureStorage _storage;
  final Dio _dio;

  Future<bool>? _refreshing;

  static const _publicPaths = <String>{
    '/auth/login',
    '/auth/login/request-otp',
    '/auth/login/verify-otp',
    '/auth/register',
    '/auth/refresh',
  };

  static bool _isPublic(String path) => _publicPaths.any(path.endsWith);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_isPublic(options.path)) {
      return handler.next(options);
    }
    final token = await _storage.readAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final status = err.response?.statusCode;
    final path = err.requestOptions.path;
    final alreadyRetried = err.requestOptions.extra['_authRetried'] == true;

    if (status != 401 || _isPublic(path) || alreadyRetried) {
      return handler.next(err);
    }

    final refreshed = await (_refreshing ??= _refresh());
    _refreshing = null;

    if (!refreshed) {
      return handler.next(err);
    }

    final newToken = await _storage.readAccessToken();
    if (newToken == null || newToken.isEmpty) {
      return handler.next(err);
    }

    final opts = err.requestOptions
      ..headers['Authorization'] = 'Bearer $newToken'
      ..extra['_authRetried'] = true;

    try {
      final response = await _dio.fetch<dynamic>(opts);
      handler.resolve(response);
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  Future<bool> _refresh() async {
    final refresh = await _storage.readRefreshToken();
    if (refresh == null || refresh.isEmpty) return false;
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refresh_token': refresh},
        options: Options(extra: {'_authRetried': true}),
      );
      final data = res.data;
      if (data == null) return false;
      final access = data['accessToken']?.toString() ?? '';
      final nextRefresh = data['refreshToken']?.toString() ?? refresh;
      if (access.isEmpty) return false;
      await _storage.writeTokens(
        accessToken: access,
        refreshToken: nextRefresh,
      );
      return true;
    } on Object {
      return false;
    }
  }
}
