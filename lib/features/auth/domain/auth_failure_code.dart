import 'package:dio/dio.dart';

import '../../../core/telemetry/telemetry_vocabulary.dart';

/// Classifies a thrown auth failure into one of six coarse buckets for
/// analytics.
///
/// Deliberately lossy. The obvious thing to send is the server's message,
/// and the server's message for a failed sign-in quotes the address that
/// was typed — which is an identifier, and identifiers do not leave this
/// device. A status code is enough to tell "nobody can sign in because the
/// API is down" apart from "people are mistyping their passwords", which
/// is the entire reason this is measured.
///
/// Anything unrecognised is [AnalyticsAuthFailure.unknown]. The app does
/// not guess, and it does not fall back to stringifying the error.
AnalyticsAuthFailure classifyAuthFailure(Object error) {
  if (error is! DioException) return AnalyticsAuthFailure.unknown;

  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.connectionError:
    case DioExceptionType.badCertificate:
      return AnalyticsAuthFailure.network;
    case DioExceptionType.cancel:
    case DioExceptionType.unknown:
      return AnalyticsAuthFailure.unknown;
    case DioExceptionType.badResponse:
      break;
  }

  final status = error.response?.statusCode;
  if (status == null) return AnalyticsAuthFailure.unknown;
  if (status == 401 || status == 403) return AnalyticsAuthFailure.credentials;
  if (status == 409) return AnalyticsAuthFailure.alreadyRegistered;
  if (status == 400 || status == 422) return AnalyticsAuthFailure.validation;
  if (status >= 500) return AnalyticsAuthFailure.server;
  return AnalyticsAuthFailure.unknown;
}
