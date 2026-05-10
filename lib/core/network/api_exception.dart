import 'package:dio/dio.dart';

/// User-readable exception thrown by repositories on API failure.
class ApiException implements Exception {
  const ApiException({required this.message, this.statusCode});

  /// Translates a [DioException] into a clean message we can show in UI.
  factory ApiException.fromDio(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiException(
          message: 'Connection timed out. Check your internet and try again.',
        );
      case DioExceptionType.connectionError:
        return const ApiException(
          message: 'Could not reach the server. Check your internet.',
        );
      case DioExceptionType.cancel:
        return const ApiException(message: 'Request was cancelled.');
      case DioExceptionType.badCertificate:
        return const ApiException(
          message: 'Secure connection failed. Try again.',
        );
      case DioExceptionType.unknown:
        return const ApiException(message: 'Something went off track.');
      case DioExceptionType.badResponse:
        final status = e.response?.statusCode;
        final data = e.response?.data;
        return ApiException(
          message: _extractMessage(data) ?? _defaultForStatus(status),
          statusCode: status,
        );
    }
  }

  final String message;
  final int? statusCode;

  static String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final raw = data['message'];
      if (raw is String && raw.isNotEmpty) return raw;
      if (raw is List && raw.isNotEmpty) return raw.first.toString();
    }
    return null;
  }

  static String _defaultForStatus(int? status) {
    if (status == null) return 'Something went off track.';
    if (status >= 500 && status <= 599) {
      return 'The server is having a moment. Try again shortly.';
    }
    return switch (status) {
      400 => 'That request didn\'t look right.',
      401 => 'Your session expired. Please sign in again.',
      403 => 'You don\'t have access to that.',
      404 => 'We couldn\'t find that.',
      429 => 'Too many tries. Take a breath, then try again.',
      _ => 'Something went off track.',
    };
  }

  @override
  String toString() => message;
}
