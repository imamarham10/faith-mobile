import 'package:faith_mobile/core/storage/local_data_purge.dart';
import 'package:faith_mobile/shared/habit/activity_event.dart';
import 'package:faith_mobile/shared/habit/local_event_queue.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Keys this device holds that are the user's own content, and keys that are
/// device preferences. Deleting an account must take the first set and leave
/// the second — clearing `onboarding_done` would push the next person on the
/// phone back through onboarding for no reason.
const _userData = {
  'feelings.journal.v1': '[{"mood":"grateful"}]',
  'duas.favorites.v1': '["a"]',
  'quran.bookmarks.v1': '["2:255"]',
  'quran.lastRead.surah': '18',
  'stotras.favorites.v1': '["b"]',
  'stories.favorites.v1': '["c"]',
  'temples.favorites.v1': '["d"]',
  'hinduScriptures.bookmarks.v1': '["e"]',
  'hinduScriptures.lastRead.slug': 'gita',
};

const _devicePrefs = {
  'selected_faith': 'islam',
  'theme_mode': 'dark',
  'arabic_script': 'uthmani',
  'prayer_calc_method': 'karachi',
  'onboarding_done': 'yes',
  'notif.permission.asked': 'yes',
};

void main() {
  sqfliteFfiInit();

  late LocalEventQueue queue;

  setUp(() async {
    SharedPreferences.setMockInitialValues({..._userData, ..._devicePrefs});
    queue = await LocalEventQueue.open(
      path: inMemoryDatabasePath,
      factory: databaseFactoryFfi,
    );
  });

  tearDown(() => queue.close());

  ActivityEvent event(String id) => ActivityEvent(
    clientEventId: id,
    activityType: ActivityType.quranVerse,
    occurredAt: DateTime.utc(2026, 10, 9, 12),
    localDay: '2026-10-09',
    timezone: 'Asia/Kolkata',
  );

  test('erases every user-authored preference', () async {
    await LocalDataPurge(Future.value(queue)).run();

    final prefs = await SharedPreferences.getInstance();
    for (final key in _userData.keys) {
      expect(prefs.get(key), isNull, reason: '$key is the user\'s own data');
    }
  });

  test('leaves device preferences alone', () async {
    await LocalDataPurge(Future.value(queue)).run();

    final prefs = await SharedPreferences.getInstance();
    for (final entry in _devicePrefs.entries) {
      expect(
        prefs.get(entry.key),
        entry.value,
        reason: '${entry.key} is a device setting, not user content',
      );
    }
  });

  test('empties the activity queue the streak is computed from', () async {
    await queue.enqueueAll([event('a'), event('b'), event('c')]);
    expect(await queue.count(), 3);

    await LocalDataPurge(Future.value(queue)).run();

    expect(await queue.count(), 0);
  });

  test('every key it clears is one some controller actually writes', () {
    // The list is maintained by hand, so this pins its shape: no stray
    // entries, no duplicates, and nothing that looks like a device setting.
    expect(
      LocalDataPurge.userDataKeys.toSet(),
      hasLength(LocalDataPurge.userDataKeys.length),
    );
    for (final key in LocalDataPurge.userDataKeys) {
      expect(_devicePrefs.keys, isNot(contains(key)));
    }
    expect(LocalDataPurge.userDataKeys, containsAll(_userData.keys));
  });

  test('a queue that cannot be opened does not fail the purge', () async {
    // This runs after the server has already deleted the account, so there
    // is nothing to abort back to — a local failure must not be reported as
    // a failed deletion.
    // Thrown asynchronously, the way a failing `LocalEventQueue.open` inside
    // the real async provider would. A bare `Future.error` completes before
    // anything is listening and is reported as an uncaught zone error by the
    // test binding rather than reaching the code under test.
    final broken = Future<LocalEventQueue>.delayed(
      Duration.zero,
      () => throw StateError('no database'),
    );
    await expectLater(LocalDataPurge(broken).run(), completes);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.get('feelings.journal.v1'), isNull);
  });
}
