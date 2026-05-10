import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/providers.dart';
import 'dtos/auth_response.dart';
import 'dtos/login_request.dart';
import 'dtos/register_request.dart';

part 'auth_repository.g.dart';

/// HTTP-only auth boundary. Translates Dio errors into [ApiException] so the
/// UI never sees raw transport failures.
class AuthRepository {
  AuthRepository(this._dio);

  final Dio _dio;

  /// Email + password sign in. Returns tokens on success.
  Future<AuthResponse> login(LoginRequest req) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/auth/login',
        data: req.toJson(),
      );
      final data = res.data;
      if (data == null) {
        throw const ApiException(
          message: 'Empty response from the server. Try again.',
        );
      }
      return AuthResponse.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Create a new account. Backend returns the user record but no tokens —
  /// callers should follow up with [login] using the same credentials.
  Future<void> register(RegisterRequest req) async {
    try {
      await _dio.post<dynamic>('/auth/register', data: req.toJson());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Server-side revocation of the current refresh token.
  Future<void> logout(String refreshToken) async {
    try {
      await _dio.post<dynamic>(
        '/auth/logout',
        data: {'refresh_token': refreshToken},
      );
    } on DioException {
      // Best-effort: never block local logout on server failure.
    }
  }
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) =>
    AuthRepository(ref.watch(dioProvider));
