import 'package:dio/dio.dart';
import 'package:faith_mobile/core/network/api_exception.dart';
import 'package:faith_mobile/core/notifications/notification_service.dart';
import 'package:faith_mobile/core/router/routes.dart';
import 'package:faith_mobile/core/theme/app_theme.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:faith_mobile/features/auth/domain/auth_state.dart';
import 'package:faith_mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:faith_mobile/features/feelings/presentation/controllers/journal_controller.dart';
import 'package:faith_mobile/features/settings/data/account_repository.dart';
import 'package:faith_mobile/features/settings/presentation/screens/delete_account_screen.dart';
import 'package:faith_mobile/shared/habit/local_event_queue.dart';
import 'package:faith_mobile/shared/widgets/poppy_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/fake_event_queue.dart';

class _FakeAccountRepository extends AccountRepository {
  _FakeAccountRepository({this.error}) : super(Dio());

  final Object? error;
  int calls = 0;

  @override
  Future<void> deleteAccount() async {
    calls++;
    if (error != null) throw error!;
  }
}

class _FakeAuthController extends AuthController {
  int signOuts = 0;

  @override
  Future<AuthState> build() async =>
      const AuthAuthenticated(accessToken: 'token');

  @override
  Future<void> signOut() async {
    signOuts++;
    state = const AsyncValue.data(AuthUnauthenticated());
  }
}

class _FakeSink implements PrayerNotificationSink {
  int cancels = 0;

  @override
  Future<void> cancelAll() async => cancels++;

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// A journal entry and a bookmark, standing in for everything this device
/// holds that is the user's own.
Future<void> seedLocalData(ProviderContainer container) async {
  await container
      .read(journalControllerProvider.notifier)
      .add(mood: 'grateful', note: 'must not survive');
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('quran.bookmarks.v1', '["2:255"]');
}

void main() {
  late _FakeAccountRepository repo;
  late _FakeAuthController auth;
  late _FakeSink sink;
  late FakeEventQueue queue;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    queue = FakeEventQueue();
  });

  // The real `LocalDataPurge`, over an in-memory queue. It used to be
  // faked here, and a fake that reproduced only half of what the real one
  // does is precisely how the same leak survived on the sign-out path: what
  // this flow has to get right is the state it leaves on disk and in
  // memory, so that is what the test drives.
  Future<void> pump(WidgetTester tester, {Object? error}) async {
    repo = _FakeAccountRepository(error: error);
    auth = _FakeAuthController();
    sink = _FakeSink();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          accountRepositoryProvider.overrideWithValue(repo),
          authControllerProvider.overrideWith(() => auth),
          localEventQueueProvider.overrideWith((ref) async => queue),
          prayerNotificationSinkProvider.overrideWithValue(sink),
        ],
        child: MaterialApp.router(
          theme: AppTheme.light(FaithId.islam),
          routerConfig: GoRouter(
            initialLocation: Routes.deleteAccount,
            routes: [
              GoRoute(
                path: Routes.deleteAccount,
                builder: (_, __) => const DeleteAccountScreen(),
              ),
              GoRoute(
                path: Routes.login,
                builder: (_, __) => const Text('LOGIN'),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
  }

  PoppyButton button(WidgetTester tester) =>
      tester.widget<PoppyButton>(find.byType(PoppyButton));

  ProviderContainer containerOf(WidgetTester tester) =>
      ProviderScope.containerOf(tester.element(find.byType(PoppyButton)));

  Future<String?> onDisk(String key) async =>
      (await SharedPreferences.getInstance()).getString(key);

  Future<void> type(WidgetTester tester, String text) async {
    await tester.enterText(find.byType(TextField), text);
    await tester.pump();
  }

  group('friction', () {
    testWidgets('the destructive button starts disabled', (tester) async {
      await pump(tester);
      expect(button(tester).onPressed, isNull);
    });

    testWidgets('stays disabled for a partial or wrong word', (tester) async {
      await pump(tester);
      for (final wrong in const [
        '',
        'D',
        'DELET',
        'delete my account',
        'yes',
      ]) {
        await type(tester, wrong);
        expect(
          button(tester).onPressed,
          isNull,
          reason: '"$wrong" must not arm the button',
        );
      }
    });

    testWidgets('arms only on the confirmation word', (tester) async {
      await pump(tester);
      await type(tester, DeleteAccountScreen.confirmWord);
      expect(button(tester).onPressed, isNotNull);
    });

    testWidgets('accepts the word in any case, and padded', (tester) async {
      await pump(tester);
      await type(tester, '  delete  ');
      expect(button(tester).onPressed, isNotNull);
    });

    testWidgets('deletes nothing until the button is actually pressed', (
      tester,
    ) async {
      await pump(tester);
      await type(tester, DeleteAccountScreen.confirmWord);

      expect(repo.calls, 0);
      expect(auth.signOuts, 0);
    });

    testWidgets('spells out what is destroyed', (tester) async {
      await pump(tester);
      expect(find.text('This cannot be undone.'), findsOneWidget);
      expect(
        find.text('Your journal entries and mood history'),
        findsOneWidget,
      );
      expect(find.text('Your streaks and daily goals'), findsOneWidget);
    });

    testWidgets('the destructive action is pressable, so it looks pressable', (
      tester,
    ) async {
      // `3cf750d` made decorative cards flat because a shadow that promises
      // a press and delivers nothing is a bug. The inverse holds here: this
      // button does act, so it keeps the sticker shadow.
      await pump(tester);
      expect(button(tester).variant, PoppyButtonVariant.destructive);
    });
  });

  group('success', () {
    testWidgets('calls the server, then cancels, purges and signs out', (
      tester,
    ) async {
      await pump(tester);
      await seedLocalData(containerOf(tester));
      await type(tester, DeleteAccountScreen.confirmWord);
      await tester.tap(find.byType(PoppyButton));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(repo.calls, 1);
      expect(sink.cancels, 1, reason: 'alarms for a dead account must go');
      expect(auth.signOuts, 1);
      expect(
        await onDisk('quran.bookmarks.v1'),
        isNull,
        reason: 'device-only data must go too',
      );
    });

    testWidgets('drops the deleted journal from memory, not just from disk', (
      tester,
    ) async {
      // Found on-device, and the nastiest failure in this flow: the purge
      // cleared SharedPreferences but `JournalController` is keepAlive, so
      // it kept serving the deleted entries — visible to whoever signed in
      // next, and re-persisted in full by their first save. The entries only
      // vanished on a cold start.
      await pump(tester);
      final container = containerOf(tester);
      await seedLocalData(container);
      expect(
        container.read(journalControllerProvider).valueOrNull,
        hasLength(1),
      );

      await type(tester, DeleteAccountScreen.confirmWord);
      await tester.tap(find.byType(PoppyButton));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Awaited, not read synchronously: an invalidated async provider
      // keeps serving its previous value until the new `build()` resolves.
      // What matters is where it lands — the next real read, and every save
      // written from it, must see an empty journal.
      final after = await container.read(journalControllerProvider.future);
      expect(after, isEmpty, reason: 'the in-memory copy must go too');
    });

    testWidgets('lands back on the auth screen', (tester) async {
      await pump(tester);
      await type(tester, DeleteAccountScreen.confirmWord);
      await tester.tap(find.byType(PoppyButton));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('LOGIN'), findsOneWidget);
    });
  });

  group('failure', () {
    const failure = ApiException(message: 'The server is having a moment.');

    testWidgets('leaves the session signed in', (tester) async {
      await pump(tester, error: failure);
      await type(tester, DeleteAccountScreen.confirmWord);
      await tester.tap(find.byType(PoppyButton));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // The backend deletes the user row last precisely so a failure leaves
      // the account intact and retryable. Signing out here would strand a
      // live account behind a logged-out app.
      expect(auth.signOuts, 0);
      expect(find.text('LOGIN'), findsNothing);
    });

    testWidgets('wipes nothing locally', (tester) async {
      await pump(tester, error: failure);
      await seedLocalData(containerOf(tester));
      await type(tester, DeleteAccountScreen.confirmWord);
      await tester.tap(find.byType(PoppyButton));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(await onDisk('quran.bookmarks.v1'), '["2:255"]');
      expect(
        await containerOf(tester).read(journalControllerProvider.future),
        hasLength(1),
      );
      expect(sink.cancels, 0);
    });

    testWidgets('says so, and says the account still exists', (tester) async {
      await pump(tester, error: failure);
      await type(tester, DeleteAccountScreen.confirmWord);
      await tester.tap(find.byType(PoppyButton));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(
        find.textContaining('The server is having a moment.'),
        findsOneWidget,
      );
      expect(
        find.textContaining('Your account has not been deleted.'),
        findsOneWidget,
      );
    });

    testWidgets('a 401 does not claim the account survived', (tester) async {
      // Verified against production: a delete sent with a token whose user
      // is already gone is rejected by the JWT guard as 401, not 404 — and
      // a merely-expired session looks identical from here. So this case
      // must not assert either outcome.
      await pump(
        tester,
        error: const ApiException(message: 'Session expired', statusCode: 401),
      );
      await seedLocalData(containerOf(tester));
      await type(tester, DeleteAccountScreen.confirmWord);
      await tester.tap(find.byType(PoppyButton));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(
        find.textContaining('Your account has not been deleted.'),
        findsNothing,
      );
      expect(find.textContaining('Sign out and sign in again'), findsOneWidget);
      // Still no local destruction on an unconfirmed outcome.
      expect(await onDisk('quran.bookmarks.v1'), '["2:255"]');
      expect(auth.signOuts, 0);
    });

    testWidgets('stays retryable — the button is still armed', (tester) async {
      await pump(tester, error: failure);
      await type(tester, DeleteAccountScreen.confirmWord);
      await tester.tap(find.byType(PoppyButton));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(button(tester).onPressed, isNotNull);
      await tester.tap(find.byType(PoppyButton));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(repo.calls, 2);
    });
  });
}
