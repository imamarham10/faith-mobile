import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/providers.dart';

part 'account_repository.g.dart';

/// HTTP boundary for the authenticated user's own account record.
class AccountRepository {
  AccountRepository(this._dio);

  /// `DELETE /users/me` — permanent, server-side, and not quick.
  ///
  /// The handler deletes ~28 child tables before the user row, from a
  /// serverless region that is not next to the database, so it comfortably
  /// outruns the client's default 20s read timeout on a busy account. Two
  /// deliberate deviations from every other call in the app:
  ///
  /// * a much longer receive timeout, and
  /// * [kNoRetry], because a blind re-send of a half-finished delete is not
  ///   idempotent from here.
  ///
  /// A 404 is treated as success. The server deletes the user row last, so
  /// "no such user" can only mean the account is already gone — which is
  /// exactly the outcome being asked for, and reporting it as a failure
  /// would strand the caller signed in to an account that no longer exists.
  ///
  /// A 401 is deliberately NOT treated that way, even though a second call
  /// against a deleted account produces one: verified against production,
  /// the JWT guard resolves the token's user before the handler runs and
  /// rejects an orphaned token with `401 Authentication failed: User not
  /// found` rather than letting it reach a 404. An expired session is
  /// indistinguishable from that at this layer, and claiming an account was
  /// deleted when the token had merely lapsed would be a far worse lie than
  /// asking the user to sign in again. [DeleteAccountScreen] words the 401
  /// case so it promises nothing either way.
  static const Duration deleteTimeout = Duration(seconds: 90);

  static const String _path = '/users/me';

  final Dio _dio;

  Future<void> deleteAccount() async {
    try {
      await _dio.delete<dynamic>(
        _path,
        options: Options(
          receiveTimeout: deleteTimeout,
          sendTimeout: deleteTimeout,
          extra: const {kNoRetry: true},
        ),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return;
      throw ApiException.fromDio(e);
    }
  }
}

@Riverpod(keepAlive: true)
AccountRepository accountRepository(Ref ref) =>
    AccountRepository(ref.watch(dioProvider));
