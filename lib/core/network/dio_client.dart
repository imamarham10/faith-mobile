import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../storage/secure_storage.dart';
import 'auth_interceptor.dart';

/// Default base URL — overridable at build time:
///   --dart-define=API_BASE_URL=https://api.example.com
///
/// Backend has inconsistent prefixing: auth/users live at the root
/// (`/auth/*`, `/users/*`), Islam features at `/api/v1/islam/*`.
/// Each repository owns the full path from the host root.
const String kApiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:3000',
);

/// Builds the project's [Dio] instance.
///
/// Behavior:
/// * Bearer token attachment via [AuthInterceptor]
/// * Compact request/response logging in debug mode
/// * Up to two retries on 5xx (with exponential backoff)
class DioClient {
  const DioClient._();

  static Dio create(SecureStorage storage) {
    final dio = Dio(
      BaseOptions(
        baseUrl: kApiBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        responseType: ResponseType.json,
      ),
    );

    dio.interceptors.add(AuthInterceptor(storage, dio));
    dio.interceptors.add(_RetryInterceptor(dio: dio));
    if (kDebugMode) {
      dio.interceptors.add(_LogInterceptor());
    }
    return dio;
  }
}

class _LogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    developer.log('→ ${options.method} ${options.uri}', name: 'http');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    developer.log(
      '← ${response.statusCode} ${response.requestOptions.uri}',
      name: 'http',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    developer.log(
      'x ${err.response?.statusCode ?? '-'} ${err.requestOptions.uri} :: ${err.message}',
      name: 'http',
      error: err,
    );
    handler.next(err);
  }
}

class _RetryInterceptor extends Interceptor {
  _RetryInterceptor({required this.dio});

  static const int maxRetries = 2;
  final Dio dio;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final shouldRetry = _isRetriable(err);
    final attempt = (err.requestOptions.extra['retry_attempt'] as int?) ?? 0;

    if (!shouldRetry || attempt >= maxRetries) {
      return handler.next(err);
    }

    final next = attempt + 1;
    final delay = Duration(milliseconds: 250 * (1 << attempt));
    await Future<void>.delayed(delay);

    try {
      final options = err.requestOptions..extra['retry_attempt'] = next;
      final response = await dio.fetch<dynamic>(options);
      handler.resolve(response);
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  bool _isRetriable(DioException err) {
    if (err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      return true;
    }
    final code = err.response?.statusCode ?? 0;
    return code >= 500 && code <= 599;
  }
}
