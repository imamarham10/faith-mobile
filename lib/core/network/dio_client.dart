import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../storage/secure_storage.dart';
import 'auth_interceptor.dart';

/// Where the API lives when nobody said otherwise. Debug and profile builds
/// only — a release compile that would fall back to this is a compile-time
/// error, see [_ReleaseApiBaseUrlGuard].
const String kDevApiBaseUrl = 'http://localhost:3000';

/// Whether this build was given `--dart-define=API_BASE_URL=...` at all.
/// `bool.hasEnvironment` is a const factory, so the front end answers this
/// while compiling the kernel.
const bool _apiBaseUrlWasProvided = bool.hasEnvironment('API_BASE_URL');

/// Default base URL — overridable at build time:
///   --dart-define=API_BASE_URL=https://api.example.com
///
/// Backend has inconsistent prefixing: auth/users live at the root
/// (`/auth/*`, `/users/*`), Islam features at `/api/v1/islam/*`.
/// Each repository owns the full path from the host root.
const String kApiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: kDevApiBaseUrl,
);

/// Compile-time gate on the API host.
///
/// The assert below is evaluated by the Dart front end while it builds the
/// kernel for this library, so a release build compiled without
/// `--dart-define=API_BASE_URL=...` fails `flutter build` outright. That is
/// the only place the mistake is cheap to fix: `flutter build` never executes
/// `main()`, so a runtime check — however loud — cannot stop a bad binary
/// from being produced.
///
/// Only const-evaluable expressions are legal in a const assert, which rules
/// out inspecting the URL itself (`String.contains` is not const). Whether the
/// define was *passed* is what const evaluation can answer, and that covers
/// the dangerous case: shipping a store binary that silently kept the loopback
/// default. Inspecting the value is [assertApiBaseUrlIsProductionSafe]'s job.
class _ReleaseApiBaseUrlGuard {
  const _ReleaseApiBaseUrlGuard()
    : assert(
        !kReleaseMode || _apiBaseUrlWasProvided,
        'Release build compiled without --dart-define=API_BASE_URL. It '
        'would ship pointing at $kDevApiBaseUrl — the device\'s own '
        'loopback — and every request would fail with an opaque connection '
        'error. Build it as:\n'
        '  flutter build apk --release '
        '--dart-define=API_BASE_URL=https://your.api.host',
      );
}

/// Nothing reads this and nothing needs to: const field initializers are
/// evaluated by the front end before tree shaking ever runs, so merely
/// existing is the whole mechanism.
// ignore: unused_element
const _ReleaseApiBaseUrlGuard _releaseApiBaseUrlGuard =
    _ReleaseApiBaseUrlGuard();

/// Hosts that resolve to the device itself (or, for `10.0.2.2`, to the host
/// machine of an Android emulator). Pointing a store build at any of these
/// means every request fails.
const Set<String> _loopbackHosts = {
  'localhost',
  '127.0.0.1',
  '::1',
  '10.0.2.2',
};

/// Fails loudly at boot rather than shipping a build that cannot reach the
/// API. A release binary pointed at loopback fails every single request with
/// an opaque connection error — far better to never get out of CI.
///
/// Rejects three things in release builds:
/// * a URL that is not an absolute `scheme://host` form at all;
/// * a loopback host, whatever the scheme (`https://localhost` is just as
///   unreachable as `http://localhost`);
/// * plain `http://` to any host. Cleartext is permitted only in debug builds
///   — the `networkSecurityConfig` overlay lives in `android/app/src/debug/`
///   and never reaches the release manifest — and iOS ATS blocks it outright.
///   A release build pointed at an `http://` host is broken by construction,
///   so there is no reason to let it out of the build.
///
/// The twin of this is the const assert in [_ApiBaseUrl], which stops the
/// *build* when the define is missing entirely. This one runs at boot and can
/// inspect the value, catching a define that was passed but wrong.
void assertApiBaseUrlIsProductionSafe({
  required String url,
  required bool isReleaseBuild,
}) {
  if (!isReleaseBuild) return;

  final uri = Uri.tryParse(url);
  final scheme = uri?.scheme.toLowerCase() ?? '';
  final host = uri?.host.toLowerCase() ?? '';

  final String problem;
  if (uri == null || host.isEmpty || (scheme != 'http' && scheme != 'https')) {
    problem = 'is not an absolute http(s) URL';
  } else if (_loopbackHosts.contains(host)) {
    problem =
        'points at loopback ("$host"), which on a real device is the '
        'device itself';
  } else if (scheme != 'https') {
    problem =
        'uses plain http, which release builds cannot send — cleartext '
        'is debug-only on Android and blocked by ATS on iOS';
  } else {
    return;
  }

  throw StateError(
    'Release build has API_BASE_URL="$url", which $problem. Pass a real host:\n'
    '  flutter build apk --release '
    '--dart-define=API_BASE_URL=https://your.api.host',
  );
}

/// Base URL of the `faith-web-remix` web app — overridable at build time:
///   --dart-define=WEB_BASE_URL=https://staging.example.com
///
/// Some content the API returns is hosted as a path relative to the *web
/// app's* origin, not the API's (e.g. hindu_scriptures' own audio
/// narrations live under the web app's `public/audio/`, confirmed via
/// `unified-faith-service.vercel.app/audio/...` 404ing while
/// `www.siraat.website/audio/...` 200s). Resolve those against this host,
/// not [kApiBaseUrl].
const String kWebBaseUrl = String.fromEnvironment(
  'WEB_BASE_URL',
  defaultValue: 'https://www.siraat.website',
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
