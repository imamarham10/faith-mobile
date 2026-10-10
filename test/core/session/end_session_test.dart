import 'package:dio/dio.dart';
import 'package:faith_mobile/core/network/api_exception.dart';
import 'package:faith_mobile/core/notifications/notification_service.dart';
import 'package:faith_mobile/core/preferences/notification_preferences.dart';
import 'package:faith_mobile/core/session/end_session.dart';
import 'package:faith_mobile/core/storage/local_data_purge.dart';
import 'package:faith_mobile/features/auth/data/auth_repository.dart';
import 'package:faith_mobile/features/auth/domain/auth_state.dart';
import 'package:faith_mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// The order is the design, so the order is what this pins.
///
/// `endSession` erases the disk, then ends the session, then drops what is
/// held in memory, and every step is reachable from a `finally`. Each of
/// those placements answers a specific way this flow can go wrong:
///
/// * **Erase before sign-out**, because on the sign-out path the Today
///   branch is still mounted under the pushed settings route, and a
///   controller that rebuilds should find an empty store.
/// * **Invalidate after sign-out**, because `signOut` is a network call and
///   spans frames — invalidating first would let a `keepAlive` controller
///   refetch under the outgoing user's token and cache their data again.
/// * **`finally` throughout**, because half-wiped and still signed in as
///   the previous user is the worst state this can land in.
///
/// The screens' tests cover the happy path. This covers the sequence, and
/// the branch where the middle step throws.
class _RecordingPurge implements LocalDataPurge {
  _RecordingPurge(this._log);

  final List<String> _log;

  @override
  Future<void> eraseDisk() async => _log.add('eraseDisk');

  @override
  void dropCachedUserData() => _log.add('dropCachedUserData');
}

class _RecordingSink implements PrayerNotificationSink {
  _RecordingSink(this._log);

  final List<String> _log;

  @override
  Future<void> cancelAll() async => _log.add('cancelAll');

  @override
  Future<void> rescheduleWindow({
    required double latitude,
    required double longitude,
    required NotificationPreferences prefs,
    required String method,
    required String madhab,
  }) async {}
}

class _RecordingAuth extends AuthController {
  _RecordingAuth(this._log, {this.throws = false});

  final List<String> _log;
  final bool throws;

  @override
  Future<AuthState> build() async =>
      const AuthAuthenticated(accessToken: 'token-A');

  @override
  Future<void> signOut() async {
    _log.add('signOut');
    if (throws) throw const ApiException(message: 'logout exploded');
    state = const AsyncValue.data(AuthUnauthenticated());
  }
}

/// A sink whose platform channel is wedged — the first step failing.
class _ThrowingSink implements PrayerNotificationSink {
  @override
  Future<void> cancelAll() async => throw StateError('no plugin');

  @override
  Future<void> rescheduleWindow({
    required double latitude,
    required double longitude,
    required NotificationPreferences prefs,
    required String method,
    required String madhab,
  }) async {}
}

void main() {
  late List<String> log;
  late ProviderContainer container;
  late _RecordingPurge purge;

  setUp(() {
    log = [];
    purge = _RecordingPurge(log);
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(AuthRepository(Dio())),
      ],
    );
    addTearDown(container.dispose);
  });

  AuthController auth({bool throws = false}) {
    final notifier = _RecordingAuth(log, throws: throws);
    final scoped = ProviderContainer(
      parent: container,
      overrides: [authControllerProvider.overrideWith(() => notifier)],
    );
    addTearDown(scoped.dispose);
    return scoped.read(authControllerProvider.notifier);
  }

  test('erases the disk, ends the session, then forgets what was cached',
      () async {
    await endSession(
      notifications: _RecordingSink(log),
      purge: purge,
      auth: auth(),
    );

    expect(log, ['cancelAll', 'eraseDisk', 'signOut', 'dropCachedUserData']);
  });

  test('a sign-out that throws still drops the in-memory copies', () async {
    // The inner `finally`. Without it this is the worst outcome the flow
    // has: the disk wiped, the session possibly still live, and every
    // `keepAlive` controller still holding the outgoing user's lists —
    // ready to write them back on the next user's first save.
    await expectLater(
      endSession(
        notifications: _RecordingSink(log),
        purge: purge,
        auth: auth(throws: true),
      ),
      throwsA(isA<ApiException>()),
    );

    expect(log, ['cancelAll', 'eraseDisk', 'signOut', 'dropCachedUserData']);
  });

  test('alarms that cannot be cancelled do not keep the user signed in',
      () async {
    // A wedged notification channel is a mis-timed reminder at worst. It is
    // not a reason to abandon a sign-out half-way.
    await endSession(
      notifications: _ThrowingSink(),
      purge: purge,
      auth: auth(),
    );

    expect(log, ['eraseDisk', 'signOut', 'dropCachedUserData']);
  });
}