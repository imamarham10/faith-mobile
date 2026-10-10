import 'package:dio/dio.dart';
import 'package:faith_mobile/core/storage/local_data_purge.dart';
import 'package:faith_mobile/features/names/data/dtos/divine_name.dart';
import 'package:faith_mobile/features/names/data/names_repository.dart';
import 'package:faith_mobile/features/names/domain/names_kind.dart';
import 'package:faith_mobile/features/names/presentation/controllers/name_favorites_controller.dart';
import 'package:faith_mobile/features/today/data/dtos/activity_snapshot.dart';
import 'package:faith_mobile/features/today/presentation/controllers/today_dashboard_controller.dart';
import 'package:faith_mobile/shared/habit/activity_event.dart';
import 'package:faith_mobile/shared/habit/local_event_queue.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Keys this device holds that are the user's own content, and keys that are
/// device preferences. Ending a session must take the first set and leave
/// the second — clearing `onboarding_done` would push the next person on the
/// phone back through onboarding for no reason.
/// One favourited name, in the shape `DivineName.fromJson` parses.
const _nameFavorite =
    '[{"id":1,"nameArabic":"الرحمن","nameTranslit":"Ar-Rahman",'
    '"nameEnglish":"The Most Merciful"}]';

const _userData = {
  'feelings.journal.v1': '[{"mood":"grateful"}]',
  'duas.favorites.v1': '["a"]',
  'quran.bookmarks.v1': '["2:255"]',
  'quran.lastRead.surah': '18',
  'names.allah.favorites.v1': _nameFavorite,
  'names.muhammad.favorites.v1': _nameFavorite,
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

/// Keeps the favourites controller's lazy remote merge off the network: it
/// is fire-and-forget inside `build()`, and what these tests are about is the
/// local copy.
class _EmptyNamesRepository extends NamesRepository {
  _EmptyNamesRepository() : super(Dio());

  @override
  Future<List<DivineName>> getFavorites(NamesKind kind) async =>
      const <DivineName>[];
}

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

  /// Built through the provider rather than by hand: the purge invalidates
  /// providers as well as clearing storage, so it needs the container's
  /// `Ref` and a test that constructed it standalone would not be exercising
  /// the thing the app runs.
  ProviderContainer containerWith(Future<LocalEventQueue> q) {
    final container = ProviderContainer(
      overrides: [
        localEventQueueProvider.overrideWith((ref) => q),
        namesRepositoryProvider.overrideWithValue(_EmptyNamesRepository()),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  LocalDataPurge purge([Future<LocalEventQueue>? q]) =>
      containerWith(q ?? Future.value(queue)).read(localDataPurgeProvider);

  ActivityEvent event(String id) => ActivityEvent(
    clientEventId: id,
    activityType: ActivityType.quranVerse,
    occurredAt: DateTime.utc(2026, 10, 9, 12),
    localDay: '2026-10-09',
    timezone: 'Asia/Kolkata',
  );

  test('erases every user-authored preference', () async {
    await purge().eraseDisk();

    final prefs = await SharedPreferences.getInstance();
    for (final key in _userData.keys) {
      expect(prefs.get(key), isNull, reason: '$key is the user\'s own data');
    }
  });

  test('leaves device preferences alone', () async {
    await purge().eraseDisk();

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

    await purge().eraseDisk();

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

  test('covers every NamesKind, including one added later', () {
    // `NameFavoritesController` derives its key from the enum, so the list
    // above cannot — a third collection would otherwise ship with its
    // favourites quietly surviving the purge.
    for (final kind in NamesKind.values) {
      expect(
        LocalDataPurge.userDataKeys,
        contains('names.${kind.slug}.favorites.v1'),
      );
    }
  });

  group('the in-memory half', () {
    // `eraseDisk` on its own fixed nothing: every reader of these stores is a
    // `keepAlive` notifier that loaded once and holds its value for the life
    // of the process. This is the half that was missing from sign-out.
    test('drops the cached streak, goal and rollup the server sent', () async {
      final container = containerWith(Future.value(queue));
      final purge = container.read(localDataPurgeProvider);
      container
          .read(activitySnapshotCacheProvider.notifier)
          .store(
            ActivityFaith.islam,
            const ActivityTodaySnapshot(
              faith: ActivityFaith.islam,
              localDay: '2026-10-10',
              timezone: 'Asia/Kolkata',
              counts: {},
              goal: null,
              streak: ActivityStreakSnapshot(
                current: 12,
                longest: 30,
                freezesLeft: 2,
                freezeResetOn: '',
                lastGoalMetDay: '2026-10-09',
              ),
            ),
            const [],
          );
      expect(container.read(activitySnapshotCacheProvider), isNotEmpty);

      purge.dropCachedUserData();

      expect(
        container.read(activitySnapshotCacheProvider),
        isEmpty,
        reason: "the outgoing user's streak must not be the next user's "
            'first screen',
      );
    });

    test('drops both name collections, not just the one that was read', () async {
      // `nameFavoritesControllerProvider` is a family, and the purge
      // invalidates the root. This pins that that reaches every instance —
      // Muhammad's favourites would otherwise survive a purge that looked
      // like it worked because Allah's did not.
      final container = containerWith(Future.value(queue));
      final purge = container.read(localDataPurgeProvider);
      for (final kind in NamesKind.values) {
        expect(
          await container.read(nameFavoritesControllerProvider(kind).future),
          hasLength(1),
          reason: '${kind.slug} favourites are seeded on disk',
        );
      }

      await purge.eraseDisk();
      purge.dropCachedUserData();

      for (final kind in NamesKind.values) {
        expect(
          await container.read(nameFavoritesControllerProvider(kind).future),
          isEmpty,
          reason: '${kind.slug} favourites must not survive the session',
        );
      }
    });
  });

  test('a queue that cannot be opened does not fail the purge', () async {
    // On the deletion path this runs after the server has already deleted
    // the account, so there is nothing to abort back to; on the sign-out
    // path a local failure must not be the thing that keeps a user signed
    // in. Thrown asynchronously, the way a failing `LocalEventQueue.open`
    // inside the real async provider would. A bare `Future.error` completes
    // before anything is listening and is reported as an uncaught zone
    // error by the test binding rather than reaching the code under test.
    final broken = Future<LocalEventQueue>.delayed(
      Duration.zero,
      () => throw StateError('no database'),
    );
    await expectLater(purge(broken).eraseDisk(), completes);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.get('feelings.journal.v1'), isNull);
  });
}
