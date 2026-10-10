import 'package:faith_mobile/core/notifications/notification_service.dart';
import 'package:faith_mobile/core/preferences/notification_preferences.dart';
import 'package:faith_mobile/features/auth/domain/auth_state.dart';
import 'package:faith_mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:faith_mobile/features/feelings/presentation/controllers/journal_controller.dart';
import 'package:faith_mobile/features/settings/presentation/screens/settings_screen.dart';
import 'package:faith_mobile/shared/habit/activity_event.dart';
import 'package:faith_mobile/shared/habit/local_event_queue.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/fake_event_queue.dart';

/// Signing out as one user and in as another, in one process.
///
/// The bug this pins: `_confirmSignOut` used to cancel notifications and
/// drop the tokens, and nothing else. Every store the app keeps is either a
/// SharedPreferences blob or a `keepAlive` notifier holding a list for the
/// life of the process, so the next person to sign in on the handset was
/// shown the previous user's journal — and, because those controllers
/// persist by writing their whole in-memory list back, their first save
/// re-wrote the previous user's entries to disk under the new account.
///
/// **No restart anywhere in this file.** A `pumpWidget` with a fresh
/// `ProviderScope`, or a second `SharedPreferences.getInstance()` after new
/// mock values, would rebuild every notifier from disk and pass against the
/// unfixed code for the wrong reason. One container, one process, start to
/// finish.
class _FakeAuth extends AuthController {
  int signOuts = 0;

  @override
  Future<AuthState> build() async =>
      const AuthAuthenticated(accessToken: 'token-A', email: 'a@example.com');

  @override
  Future<void> signOut() async {
    signOuts++;
    state = const AsyncValue.data(AuthUnauthenticated());
  }

  /// The next user signs in on the same handset, in the same process.
  void signInAs(String email) => state = AsyncValue.data(
    AuthAuthenticated(accessToken: 'token-$email', email: email),
  );
}

class _FakeSink implements PrayerNotificationSink {
  int cancels = 0;

  @override
  Future<void> cancelAll() async => cancels++;

  @override
  Future<void> rescheduleWindow({
    required double latitude,
    required double longitude,
    required NotificationPreferences prefs,
    required String method,
    required String madhab,
  }) async {}
}

/// Settings the next user on this phone should still find in place. Theme,
/// script, faith and calculation method are how the device is set up, not
/// anything either user authored.
const _devicePrefs = {
  'selected_faith': 'islam',
  'theme_mode': 'dark',
  'arabic_script': 'uthmani',
  'prayer_calc_method': 'KARACHI',
  'onboarding_done': 'yes',
  'notif.permission.asked': 'yes',
};

void main() {
  late FakeEventQueue queue;
  late _FakeAuth auth;
  late _FakeSink sink;

  setUp(() {
    // `_confirmSignOut` awaits `HapticFeedback.mediumImpact()` before it
    // does anything else, and an unhandled platform channel never answers
    // inside `FakeAsync` — the handler would simply stop there and the test
    // would report whatever it checked next as unmet. Answering the channel
    // lets the real sequence run.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (_) async => null);
    // Same for the notifications plugin, which sign-out reaches before it
    // touches any data. Answered here so that an unfixed build gets as far
    // as the assertions about data and fails on those, rather than stalling
    // on a channel and failing for a reason that has nothing to do with the
    // leak.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('dexterous.com/flutter/local_notifications'),
          (_) async => null,
        );
    SharedPreferences.setMockInitialValues({..._devicePrefs});
    queue = FakeEventQueue();
    auth = _FakeAuth();
    sink = _FakeSink();
  });

  ActivityEvent event(String id) => ActivityEvent(
    clientEventId: id,
    activityType: ActivityType.quranVerse,
    occurredAt: DateTime.utc(2026, 10, 10, 9),
    localDay: '2026-10-10',
    timezone: 'Asia/Kolkata',
  );

  // The real `LocalDataPurge` throughout — only the queue's path (a platform
  // channel) and the two collaborators sign-out calls out to are stood in
  // for. A fake purge is exactly how this leak slipped through once already.
  Future<ProviderContainer> pumpSettings(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          localEventQueueProvider.overrideWith((ref) async => queue),
          authControllerProvider.overrideWith(() => auth),
          prayerNotificationSinkProvider.overrideWithValue(sink),
        ],
        child: MaterialApp.router(
          routerConfig: GoRouter(
            initialLocation: '/settings',
            routes: [
              GoRoute(
                path: '/settings',
                builder: (_, __) => const SettingsScreen(),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pump();
    return ProviderScope.containerOf(tester.element(find.byType(SettingsScreen)));
  }

  Future<void> tapSignOut(WidgetTester tester) async {
    await tester.scrollUntilVisible(
      find.text('Sign out'),
      500,
      scrollable: find.byType(Scrollable),
    );
    await tester.tap(find.text('Sign out').first);
    await tester.pumpAndSettle();
    // The confirmation dialog's action, not the list tile behind it: the
    // dialog is pushed above the screen, so its copy of the label is last.
    await tester.tap(find.text('Sign out').last);
    await tester.pumpAndSettle();
  }

  /// Everything user A leaves behind on this device.
  Future<void> seedUserA(ProviderContainer container) async {
    await container
        .read(journalControllerProvider.notifier)
        .add(mood: 'grateful', note: "A's private reflection");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('quran.bookmarks.v1', '["2:255"]');
    await prefs.setString('names.allah.favorites.v1', '[{"id":"ar-rahman"}]');
    await prefs.setString('quran.lastRead.surah', '18');
    await queue.enqueueAll([event('a-1'), event('a-2')]);
  }

  testWidgets('user B sees nothing of user A — no restart', (tester) async {
    final container = await pumpSettings(tester);
    await seedUserA(container);
    expect(container.read(journalControllerProvider).valueOrNull, hasLength(1));

    await tapSignOut(tester);

    // Same process, same container: the next person signs in.
    auth.signInAs('b@example.com');
    await tester.pump();

    // Awaited, not read synchronously: an invalidated async provider keeps
    // serving its previous value until the new `build()` resolves. Where it
    // lands is what B's screens — and B's next save — will see.
    expect(
      await container.read(journalControllerProvider.future),
      isEmpty,
      reason: "B must not be shown A's journal",
    );

    final prefs = await SharedPreferences.getInstance();
    for (final key in const [
      'feelings.journal.v1',
      'quran.bookmarks.v1',
      'names.allah.favorites.v1',
      'quran.lastRead.surah',
    ]) {
      expect(prefs.get(key), isNull, reason: '$key is A\'s own content');
    }
    expect(
      await queue.count(),
      0,
      reason: "A's unflushed acts would otherwise upload under B's token",
    );

    expect(auth.signOuts, 1);
    expect(
      sink.cancels,
      1,
      reason: "A's prayer alarms must not fire for B — and sign-out reaches "
          'the sink through the provider, as deletion does, so a test can '
          'see it at all',
    );
  });

  testWidgets("B's first save cannot resurrect A's entries on disk", (
    tester,
  ) async {
    // The worse half of the bug, and the reason a stale-read assertion is
    // not enough: `JournalController` persists by writing its whole
    // in-memory list back, so with A's entries still held, B's first save
    // wrote them out again — under B's account, after A had signed out.
    final container = await pumpSettings(tester);
    await seedUserA(container);

    await tapSignOut(tester);
    auth.signInAs('b@example.com');
    await tester.pump();

    await container
        .read(journalControllerProvider.notifier)
        .add(mood: 'calm', note: "B's own reflection");

    final prefs = await SharedPreferences.getInstance();
    final onDisk = prefs.getString('feelings.journal.v1') ?? '';
    expect(onDisk, contains("B's own reflection"));
    expect(
      onDisk,
      isNot(contains("A's private reflection")),
      reason: "B's save must not re-write A's entries to disk",
    );
  });

  testWidgets('device preferences survive — they are settings, not data', (
    tester,
  ) async {
    final container = await pumpSettings(tester);
    await seedUserA(container);

    await tapSignOut(tester);

    final prefs = await SharedPreferences.getInstance();
    for (final entry in _devicePrefs.entries) {
      expect(
        prefs.get(entry.key),
        entry.value,
        reason: '${entry.key} is how the device is set up, not user content',
      );
    }
  });

  testWidgets('a purge that fails still ends the session', (tester) async {
    // Ordering insurance: half-wiped and still signed in as the outgoing
    // user is the worst state this flow could land in, so the sign-out is
    // reached from a `finally`. A queue that cannot be opened stands in for
    // any failure inside the purge.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          localEventQueueProvider.overrideWith(
            (ref) async => throw StateError('no database'),
          ),
          authControllerProvider.overrideWith(() => auth),
          prayerNotificationSinkProvider.overrideWithValue(sink),
        ],
        child: MaterialApp.router(
          routerConfig: GoRouter(
            initialLocation: '/settings',
            routes: [
              GoRoute(
                path: '/settings',
                builder: (_, __) => const SettingsScreen(),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pump();
    final container = ProviderScope.containerOf(
      tester.element(find.byType(SettingsScreen)),
    );
    await container
        .read(journalControllerProvider.notifier)
        .add(mood: 'grateful', note: "A's private reflection");

    await tapSignOut(tester);

    expect(auth.signOuts, 1, reason: 'the session must end regardless');
    final prefs = await SharedPreferences.getInstance();
    expect(
      prefs.get('feelings.journal.v1'),
      isNull,
      reason: 'the preferences half of the purge still ran',
    );
    expect(await container.read(journalControllerProvider.future), isEmpty);
  });
}
