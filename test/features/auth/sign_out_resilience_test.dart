import 'package:dio/dio.dart';
import 'package:faith_mobile/core/network/api_exception.dart';
import 'package:faith_mobile/core/providers.dart';
import 'package:faith_mobile/core/storage/secure_storage.dart';
import 'package:faith_mobile/features/auth/data/auth_repository.dart';
import 'package:faith_mobile/features/auth/domain/auth_state.dart';
import 'package:faith_mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

/// Signing out has to end the session on this device even when the parts of
/// it that talk to the outside world do not cooperate.
///
/// This stopped being a nicety the moment `endSession` started erasing the
/// user's journal, bookmarks and queued activity *before* the tokens are
/// dropped: a sign-out that aborted halfway would leave a wiped app still
/// logged in as the person whose data it had just deleted.
class _FakeStorage extends SecureStorage {
  _FakeStorage({this.readThrows = false}) : super(const FlutterSecureStorage());

  final bool readThrows;
  bool cleared = false;

  @override
  Future<String?> readAccessToken() async => 'access';

  @override
  Future<String?> readRefreshToken() async {
    if (readThrows) throw StateError('keystore is locked');
    return 'refresh';
  }

  @override
  Future<void> clear() async => cleared = true;
}

class _ThrowingRepository extends AuthRepository {
  _ThrowingRepository() : super(Dio());

  @override
  Future<void> logout(String refreshToken) async =>
      throw const ApiException(message: 'revocation refused');
}

void main() {
  Future<({ProviderContainer container, _FakeStorage storage})> signOutWith({
    bool readThrows = false,
  }) async {
    final storage = _FakeStorage(readThrows: readThrows);
    final container = ProviderContainer(
      overrides: [
        secureStorageProvider.overrideWithValue(storage),
        authRepositoryProvider.overrideWithValue(_ThrowingRepository()),
      ],
    );
    addTearDown(container.dispose);
    await container.read(authControllerProvider.future);
    await container.read(authControllerProvider.notifier).signOut();
    return (container: container, storage: storage);
  }

  test('a refused revocation still ends the session', () async {
    final result = await signOutWith();

    expect(result.storage.cleared, isTrue, reason: 'the tokens must go');
    expect(
      result.container.read(authControllerProvider).valueOrNull,
      isA<AuthUnauthenticated>(),
    );
  });

  test('a secure storage that will not answer still ends the session', () async {
    // The read in front of the revocation is a platform channel too, and it
    // used to be outside any `catch`.
    final result = await signOutWith(readThrows: true);

    expect(result.storage.cleared, isTrue);
    expect(
      result.container.read(authControllerProvider).valueOrNull,
      isA<AuthUnauthenticated>(),
    );
  });
}
