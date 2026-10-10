import 'dart:io';

import 'package:faith_mobile/shared/habit/activity_event.dart';
import 'package:faith_mobile/shared/habit/activity_recorder.dart';
import 'package:faith_mobile/shared/habit/local_event_queue.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// A real SQLite file, as in `local_event_queue_test.dart`: the recorder's
/// one job is to make an act durable, and an in-memory database cannot
/// show that.
late Directory _dir;
late LocalEventQueue _queue;

/// Builds a recorder over the open queue, with the clock, the id generator
/// and the timezone pinned.
///
/// Note what is *not* injectable: there is no transport, no client, no
/// base URL. That is the "never blocks on the network" guarantee — it is a
/// property of this constructor's signature, not of how fast `record()`
/// happens to return.
ActivityRecorder _recorder({
  DateTime? now,
  Iterable<String>? ids,
  String timezone = 'Asia/Kolkata',
}) {
  final queue = ids?.iterator;
  var n = 0;
  return ActivityRecorder(
    queue: Future.value(_queue),
    now: () => now ?? DateTime(2026, 10, 9, 14, 3, 22),
    newId: () {
      if (queue != null && queue.moveNext()) return queue.current;
      return 'id-${++n}';
    },
    timezoneName: () => timezone,
  );
}

void main() {
  setUpAll(sqfliteFfiInit);

  setUp(() async {
    _dir = Directory.systemTemp.createTempSync('faith_recorder_test');
    _queue = await LocalEventQueue.open(
      path: LocalEventQueue.databasePathIn(_dir.path),
      factory: databaseFactoryFfi,
    );
  });

  tearDown(() async {
    await _queue.close();
    if (_dir.existsSync()) _dir.deleteSync(recursive: true);
  });

  group('record', () {
    test('enqueues the act and reports that it landed', () async {
      final ok = await _recorder().record(
        ActivityType.quranVerse,
        sourceRef: 'quran:2:148',
      );

      expect(ok, isTrue);
      final event = (await _queue.peek()).single;
      expect(event.activityType, ActivityType.quranVerse);
      expect(event.faith, ActivityFaith.islam);
      expect(event.quantity, 1);
      expect(event.sourceRef, 'quran:2:148');
    });

    test('the act is durable the moment record() returns', () async {
      // The basement test. Nothing has been sent anywhere, the recorder
      // holds no transport, and yet closing and reopening the database
      // brings the act back — which is what lets the UI update
      // optimistically without lying.
      await _recorder().record(ActivityType.dhikr, quantity: 33);
      await _queue.close();

      final reopened = await LocalEventQueue.open(
        path: LocalEventQueue.databasePathIn(_dir.path),
        factory: databaseFactoryFfi,
      );
      final event = (await reopened.peek()).single;
      expect(event.activityType, ActivityType.dhikr);
      expect(event.quantity, 33);
      await reopened.close();

      // Reopen for tearDown.
      _queue = await LocalEventQueue.open(
        path: LocalEventQueue.databasePathIn(_dir.path),
        factory: databaseFactoryFfi,
      );
    });

    test('mints a fresh UUID v4 for every act', () async {
      // Real generator, not the pinned one: §4.3 makes first-write-wins the
      // basis of idempotency, so two acts sharing an id means the second is
      // silently discarded by the server forever.
      final recorder = ActivityRecorder(queue: Future.value(_queue));
      await recorder.record(ActivityType.prayer, sourceRef: 'prayer:fajr');
      await recorder.record(ActivityType.prayer, sourceRef: 'prayer:dhuhr');
      await recorder.record(ActivityType.prayer, sourceRef: 'prayer:asr');

      final ids = (await _queue.peek()).map((e) => e.clientEventId).toSet();
      expect(ids, hasLength(3));
      for (final id in ids) {
        expect(
          id,
          matches(
            RegExp(
              r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-'
              r'[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
            ),
          ),
          reason: '"$id" is not a UUID v4',
        );
      }
    });

    test(
      'a repeated id is not duplicated — the queue holds first-write',
      () async {
        // Belt and braces with the server's own rule: if the generator ever
        // repeats, the row must not double up locally either.
        final recorder = _recorder(ids: ['same', 'same']);
        expect(await recorder.record(ActivityType.quranVerse), isTrue);
        await recorder.record(ActivityType.quranVerse, quantity: 99);

        final events = await _queue.peek();
        expect(events, hasLength(1));
        expect(events.single.quantity, 1, reason: 'first write wins');
      },
    );
  });

  // The readers' side of §4.3. A verse read twice in a day is one verse
  // read, and the thing that makes that true — in both readers, across
  // screen instances and app launches — is that the id is a function of
  // the act rather than of the moment it was recorded.
  group('dedupeKey', () {
    /// A recorder with the *real* id generator, so nothing here can pass
    /// because a pinned `newId` happened to repeat.
    ActivityRecorder realIds({DateTime? now}) => ActivityRecorder(
      queue: Future.value(_queue),
      now: () => now ?? DateTime(2026, 10, 9, 14, 3, 22),
      timezoneName: () => 'Asia/Kolkata',
    );

    test('the same verse on the same day is one event', () async {
      final recorder = realIds();
      await recorder.record(
        ActivityType.quranVerse,
        sourceRef: 'quran:2:142',
        dedupeKey: 'quran:2:142',
      );
      await recorder.record(
        ActivityType.quranVerse,
        sourceRef: 'quran:2:142',
        dedupeKey: 'quran:2:142',
      );

      expect(
        await _queue.peek(),
        hasLength(1),
        reason: 'reading 2:142 in the juz reader and again in the surah '
            'reader is one verse read, not two',
      );
    });

    test('a different verse is a different event', () async {
      final recorder = realIds();
      await recorder.record(
        ActivityType.quranVerse,
        dedupeKey: 'quran:2:142',
      );
      await recorder.record(
        ActivityType.quranVerse,
        dedupeKey: 'quran:2:143',
      );

      expect(await _queue.peek(), hasLength(2));
    });

    test('the same verse tomorrow is a new event', () async {
      // Otherwise the key would be a one-time lock on a verse rather than
      // a daily one, and a user reading the same page every morning would
      // see their count stop moving.
      await realIds(
        now: DateTime(2026, 10, 9, 22),
      ).record(ActivityType.quranVerse, dedupeKey: 'quran:2:142');
      await realIds(
        now: DateTime(2026, 10, 10, 6),
      ).record(ActivityType.quranVerse, dedupeKey: 'quran:2:142');

      expect(await _queue.peek(), hasLength(2));
    });

    test('the same key under a different activity type does not collide',
        () async {
      await realIds().record(ActivityType.quranVerse, dedupeKey: 'x:1');
      await realIds().record(ActivityType.dhikr, dedupeKey: 'x:1');

      expect(await _queue.peek(), hasLength(2));
    });

    test('mints a UUID the server will accept, not a readable key', () async {
      // The server validates clientEventId against a hex-dashed UUID
      // shape and rejects anything else *permanently* (§4.5
      // invalid_client_event_id) — a permanent rejection is "settled", so
      // the flusher would delete the row and the verse would be lost in
      // silence. A key like "quran:2:142:2026-10-09" passes every local
      // test and never counts.
      await realIds().record(ActivityType.quranVerse, dedupeKey: 'quran:2:142');

      expect(
        (await _queue.peek()).single.clientEventId,
        matches(
          RegExp(
            r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-'
            r'[0-9a-f]{4}-[0-9a-f]{12}$',
          ),
        ),
      );
    });

    test('omitting it leaves every act its own event', () async {
      // The counters depend on this: thirty-three taps of a dhikr counter
      // are thirty-three acts, not one deduped one.
      final recorder = realIds();
      await recorder.record(ActivityType.dhikr, sourceRef: 'dhikr:abc');
      await recorder.record(ActivityType.dhikr, sourceRef: 'dhikr:abc');

      expect(await _queue.peek(), hasLength(2));
    });
  });

  group('stamping', () {
    test('localDay is the device calendar date, not the UTC date', () async {
      // 00:30 on 9 October in Asia/Kolkata is 19:00 on 8 October UTC. The
      // user believes it is the 9th, and §2.1 says the device is
      // authoritative, so localDay must be the 9th while occurredAt
      // remains the true instant.
      final midnightish = DateTime.utc(
        2026,
        10,
        8,
        19,
      ).add(const Duration(minutes: 0)).toLocal();

      await _recorder(now: midnightish).record(ActivityType.quranVerse);

      final event = (await _queue.peek()).single;
      final local = midnightish.toLocal();
      expect(
        event.localDay,
        '${local.year.toString().padLeft(4, '0')}-'
        '${local.month.toString().padLeft(2, '0')}-'
        '${local.day.toString().padLeft(2, '0')}',
      );
      expect(event.occurredAt.isUtc, isTrue);
      expect(event.occurredAt, midnightish.toUtc());
    });

    test('occurredAt and localDay come from one clock reading', () async {
      // A recorder that called now() twice could stamp an instant on one
      // day and a calendar date on the next. §2.2 would still *accept* that
      // pair, so it would never surface as a rejection — only as a streak
      // that broke for no visible reason. A clock that advances a full day
      // between calls makes the bug loud.
      var calls = 0;
      final recorder = ActivityRecorder(
        queue: Future.value(_queue),
        now: () => DateTime(2026, 10, 9, 23, 59).add(Duration(days: calls++)),
        newId: () => 'one',
        timezoneName: () => 'Asia/Kolkata',
      );

      await recorder.record(ActivityType.quranVerse);

      final event = (await _queue.peek()).single;
      expect(calls, 1, reason: 'now() must be read exactly once per act');
      expect(event.localDay, '2026-10-09');
      expect(event.occurredAt, DateTime(2026, 10, 9, 23, 59).toUtc());
    });

    test('localDay is never recomputed after the act', () async {
      // The flush is days late; the event still carries the day it
      // happened. Nothing downstream re-derives it (§2.2).
      await _recorder(
        now: DateTime(2026, 10, 2, 9),
      ).record(ActivityType.prayer, sourceRef: 'prayer:fajr');
      await _queue.close();
      _queue = await LocalEventQueue.open(
        path: LocalEventQueue.databasePathIn(_dir.path),
        factory: databaseFactoryFfi,
      );

      final event = (await _queue.peek()).single;
      expect(event.localDay, '2026-10-02');
      expect(event.toJson()['localDay'], '2026-10-02');
    });

    test('an abbreviation never reaches the queue', () async {
      // §1.5: the server rejects `IST` permanently, and the client then
      // deletes the row — so the event is lost forever. The recorder must
      // resolve it before it is ever stored.
      // Distinct ids: three recorders each minting "id-1" would be
      // deduplicated by the queue's first-write-wins index, and this test
      // would silently assert on one row instead of three.
      await _recorder(
        timezone: 'IST',
        ids: ['a'],
      ).record(ActivityType.quranVerse);
      await _recorder(
        timezone: '+05:30',
        ids: ['b'],
      ).record(ActivityType.dhikr);
      await _recorder(timezone: 'UTC', ids: ['c']).record(ActivityType.prayer);

      final zones = (await _queue.peek()).map((e) => e.timezone).toList();
      expect(zones, ['Asia/Kolkata', 'UTC', 'UTC']);
    });
  });

  group('failure', () {
    test('an invalid quantity is refused, not thrown', () async {
      // A recorder that threw into a tap handler is the same trap as a
      // counter that only goes up.
      final recorder = _recorder();

      expect(await recorder.record(ActivityType.dhikr, quantity: 0), isFalse);
      expect(
        await recorder.record(ActivityType.dhikr, quantity: 10001),
        isFalse,
      );
      expect(await _queue.count(), 0);
    });

    test('an over-long sourceRef is refused, not thrown', () async {
      final ok = await _recorder().record(
        ActivityType.quranVerse,
        sourceRef: 'q' * 129,
      );

      expect(ok, isFalse);
      expect(await _queue.count(), 0);
    });

    test('a dead queue is reported, not thrown', () async {
      // The storage layer failing — disk full, database corrupt — must not
      // reach the widget that tapped either.
      await _queue.close();
      final ok = await _recorder().record(ActivityType.quranVerse);
      expect(ok, isFalse);

      _queue = await LocalEventQueue.open(
        path: LocalEventQueue.databasePathIn(_dir.path),
        factory: databaseFactoryFfi,
      );
    });
  });

  group('the real timezone source', () {
    test(
      'a recorder with no overrides still queues a well-formed zone',
      () async {
        // Every other case in this file pins `timezoneName`, so none of them
        // exercises the default — which, since Task 1.9, reaches a method
        // channel through `DeviceTimezone`. There is no plugin under
        // `flutter_test`, so this is the fallback path running for real:
        // `getLocalTimezone()` raises `MissingPluginException`,
        // `DeviceTimezone` catches it and answers from the abbreviation
        // table instead. The assertion is that this is a *fallback* and not
        // a throw — if it threw, Task 1.12's first call site would be where
        // anyone found out.
        final recorder = ActivityRecorder(
          queue: Future.value(_queue),
          now: () => DateTime(2026, 10, 9, 14, 3, 22),
          newId: () => 'default-tz',
        );

        expect(await recorder.record(ActivityType.quranVerse), isTrue);

        final event = (await _queue.peek()).single;
        // §1.5 — `Region/City`, or exactly `UTC`/`GMT`. Never an
        // abbreviation, which the server rejects permanently.
        expect(
          event.timezone,
          anyOf(contains('/'), equals('UTC'), equals('GMT')),
        );
      },
    );
  });

  group('faith routing', () {
    test('faith is derived from the type, never passed alongside it', () async {
      final recorder = _recorder();
      await recorder.record(ActivityType.gitaShloka, sourceRef: 'gita:11:32');
      await recorder.record(ActivityType.japaMala, sourceRef: 'japa:om');
      await recorder.record(ActivityType.quranVerse, sourceRef: 'quran:1:1');

      final events = await _queue.peek();
      expect(events.map((e) => e.faith), [
        ActivityFaith.hindu,
        ActivityFaith.hindu,
        ActivityFaith.islam,
      ]);
      // The server's `activity_type_faith_mismatch` is unrepresentable
      // through this API — there is no faith parameter to get wrong.
      expect(events.first.toJson()['faithId'], 'hindu');
    });
  });
}
