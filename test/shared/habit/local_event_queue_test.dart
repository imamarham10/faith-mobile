import 'dart:io';

import 'package:faith_mobile/shared/habit/activity_event.dart';
import 'package:faith_mobile/shared/habit/local_event_queue.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// A real SQLite file in a real directory.
///
/// Deliberately *not* `inMemoryDatabasePath`: an in-memory database is
/// destroyed by `close()`, so a close/reopen durability test against one
/// would prove nothing at all — it would be testing that an empty database
/// is empty.
late Directory _dir;
late String _dbPath;

Future<LocalEventQueue> _openQueue() =>
    LocalEventQueue.open(path: _dbPath, factory: databaseFactoryFfi);

ActivityEvent _event(
  String id, {
  ActivityType type = ActivityType.quranVerse,
  int quantity = 1,
  String localDay = '2026-10-09',
  String occurredAt = '2026-10-09T14:03:22Z',
  String timezone = 'Asia/Kolkata',
  String? sourceRef = 'quran:2:148',
}) => ActivityEvent(
  clientEventId: id,
  activityType: type,
  quantity: quantity,
  occurredAt: DateTime.parse(occurredAt),
  localDay: localDay,
  timezone: timezone,
  sourceRef: sourceRef,
);

void main() {
  setUpAll(sqfliteFfiInit);

  setUp(() {
    _dir = Directory.systemTemp.createTempSync('faith_queue_test');
    _dbPath = LocalEventQueue.databasePathIn(_dir.path);
  });

  tearDown(() {
    if (_dir.existsSync()) _dir.deleteSync(recursive: true);
  });

  group('durability', () {
    test('events survive closing and reopening the database', () async {
      final first = await _openQueue();
      await first.enqueueAll([
        _event('evt-1'),
        _event('evt-2', type: ActivityType.prayer, sourceRef: 'prayer:fajr'),
        _event('evt-3', type: ActivityType.dhikr, quantity: 33),
      ]);
      expect(await first.count(), 3);
      await first.close();

      // A process restart, as far as SQLite is concerned: the handle is
      // gone, and the only thing carrying state forward is the file.
      expect(File(_dbPath).existsSync(), isTrue);

      final reopened = await _openQueue();
      final rows = await reopened.peek();

      expect(rows.map((e) => e.clientEventId), ['evt-1', 'evt-2', 'evt-3']);
      expect(rows[2].quantity, 33);
      expect(rows[1].sourceRef, 'prayer:fajr');
      expect(rows[1].faith, ActivityFaith.islam);
      await reopened.close();
    });

    test('occurredAt and localDay come back exactly as stamped', () async {
      // Legal under §2.2: |localDay − dateOf(occurredAt, UTC)| ≤ 1. A user
      // in Pacific/Kiritimati (UTC+14) just past midnight is genuinely on
      // the next local day from the UTC date of the same instant. Nothing
      // in the queue may "helpfully" reconcile the two.
      final queue = await _openQueue();
      await queue.enqueue(
        _event(
          'evt-kiritimati',
          occurredAt: '2026-10-08T11:30:00Z',
          localDay: '2026-10-09',
          timezone: 'Pacific/Kiritimati',
        ),
      );
      await queue.close();

      final reopened = await _openQueue();
      final event = (await reopened.peek()).single;

      expect(event.localDay, '2026-10-09');
      expect(event.occurredAt.toIso8601String(), '2026-10-08T11:30:00.000Z');
      expect(event.timezone, 'Pacific/Kiritimati');
      // The wire payload is the same pair — a flush days later re-stamps
      // nothing, which is what makes a late batch validate identically.
      expect(event.toJson()['localDay'], '2026-10-09');
      expect(event.toJson()['occurredAt'], '2026-10-08T11:30:00.000Z');
      await reopened.close();
    });

    test('a non-UTC occurredAt is stored as the same instant in UTC', () async {
      final queue = await _openQueue();
      await queue.enqueue(
        _event('evt-offset', occurredAt: '2026-10-09T19:33:22+05:30'),
      );
      final event = (await queue.peek()).single;

      expect(event.occurredAt.isUtc, isTrue);
      expect(event.toJson()['occurredAt'], '2026-10-09T14:03:22.000Z');
      await queue.close();
    });
  });

  group('flush settlement', () {
    test('acknowledge removes only the rows it names', () async {
      final queue = await _openQueue();
      await queue.enqueueAll([for (var i = 1; i <= 5; i++) _event('evt-$i')]);

      final batch = await queue.peek(limit: 3);
      // Mirrors a 200 where two landed and one was permanently rejected —
      // §4.8 settles all three, so all three leave the queue.
      await queue.acknowledge(batch.map((e) => e.clientEventId));

      expect(await queue.count(), 2);
      expect((await queue.peek()).map((e) => e.clientEventId), [
        'evt-4',
        'evt-5',
      ]);
      await queue.close();
    });

    test('acknowledging an unknown id removes nothing', () async {
      final queue = await _openQueue();
      await queue.enqueue(_event('evt-1'));

      expect(await queue.acknowledge(['not-in-the-queue']), 0);
      expect(await queue.count(), 1);
      await queue.close();
    });

    test('a failed flush leaves the queue byte-for-byte intact', () async {
      final queue = await _openQueue();
      await queue.enqueueAll([
        _event('evt-1'),
        _event('evt-2', type: ActivityType.prayer, sourceRef: 'prayer:isha'),
        _event(
          'evt-3',
          type: ActivityType.japaMala,
          quantity: 2,
          localDay: '2026-10-08',
          occurredAt: '2026-10-08T03:15:00Z',
          timezone: 'UTC',
          sourceRef: null,
        ),
      ]);

      final before = (await queue.peek()).map((e) => e.toJson()).toList();

      // The flush: read the batch, hand it to a transport that fails. No
      // acknowledge() follows, because nothing was settled — §4.8's
      // "5xx, timeout, DNS failure, socket error, or any response the
      // client cannot parse" row.
      final batch = await queue.peek();
      await expectLater(
        _alwaysFailingTransport(batch),
        throwsA(isA<SocketException>()),
      );

      final after = (await queue.peek()).map((e) => e.toJson()).toList();

      expect(await queue.count(), 3);
      // Not just the count: every field of every row, in order. A queue
      // that kept three rows but mangled a localDay would still have lost
      // the user's day.
      expect(after, equals(before));

      // And it is still intact across a restart, not merely in memory.
      await queue.close();
      final reopened = await _openQueue();
      expect((await reopened.peek()).map((e) => e.toJson()).toList(), before);
      await reopened.close();
    });

    test('a retry after a failed flush sends the identical batch', () async {
      final queue = await _openQueue();
      await queue.enqueueAll([_event('evt-1'), _event('evt-2')]);

      final firstAttempt = await queue.peek(limit: 2);
      // ...fails, nothing acknowledged...
      final secondAttempt = await queue.peek(limit: 2);

      expect(
        secondAttempt.map((e) => e.clientEventId),
        firstAttempt.map((e) => e.clientEventId),
      );
      // Same clientEventIds means the server counts the retry once (§4.3),
      // which is what makes "always retry, never try to detect" safe.
      await queue.close();
    });
  });

  group('cap', () {
    test('drops the oldest rows beyond maxRows', () async {
      final queue = await _openQueue();
      const overflow = 120;

      await queue.enqueueAll([
        for (var i = 0; i < LocalEventQueue.maxRows + overflow; i++)
          _event('evt-${i.toString().padLeft(5, '0')}'),
      ]);

      expect(await queue.count(), LocalEventQueue.maxRows);

      final oldest = await queue.peek(limit: 1);
      // The first `overflow` events are the ones gone; the survivors are
      // the newest maxRows, oldest-first.
      expect(oldest.single.clientEventId, 'evt-00120');
      await queue.close();
    });

    test('the cap holds across separate enqueues and a restart', () async {
      final queue = await _openQueue();
      for (var chunk = 0; chunk < 6; chunk++) {
        await queue.enqueueAll([
          for (var i = 0; i < 1000; i++)
            _event('evt-${(chunk * 1000 + i).toString().padLeft(5, '0')}'),
        ]);
      }
      expect(await queue.count(), LocalEventQueue.maxRows);
      await queue.close();

      final reopened = await _openQueue();
      expect(await reopened.count(), LocalEventQueue.maxRows);
      // 6000 enqueued, 5000 kept: the survivors start at the 1000th.
      expect((await reopened.peek(limit: 1)).single.clientEventId, 'evt-01000');
      await reopened.close();
    });
  });

  group('idempotency', () {
    test('a duplicate clientEventId cannot create a second row', () async {
      final queue = await _openQueue();
      await queue.enqueue(_event('evt-dup', quantity: 1));
      await queue.enqueue(_event('evt-dup', quantity: 99));
      await queue.enqueueAll([
        _event('evt-dup', quantity: 7),
        _event('evt-dup', quantity: 8),
      ]);

      expect(await queue.count(), 1);
      // First write wins, matching the server (§4.3). INSERT OR REPLACE
      // would also leave one row — and would have quantity 8 here.
      expect((await queue.peek()).single.quantity, 1);
      await queue.close();
    });

    test('first-write-wins survives a restart', () async {
      final queue = await _openQueue();
      await queue.enqueue(_event('evt-dup', sourceRef: 'quran:2:148'));
      await queue.close();

      final reopened = await _openQueue();
      await reopened.enqueue(_event('evt-dup', sourceRef: 'quran:18:10'));

      expect(await reopened.count(), 1);
      expect((await reopened.peek()).single.sourceRef, 'quran:2:148');
      await reopened.close();
    });
  });

  group('a row this build cannot decode', () {
    test('is dropped instead of poisoning the whole queue', () async {
      final queue = await _openQueue();
      await queue.enqueueAll([_event('evt-1'), _event('evt-3')]);
      await queue.close();

      // Written straight to the file, the way a newer build of the app
      // would: an activity_type this version has never heard of.
      final raw = await databaseFactoryFfi.openDatabase(_dbPath);
      await raw.insert('activity_event_queue', {
        'client_event_id': 'evt-2',
        'faith_id': 'islam',
        'activity_type': 'tarawih_rakah',
        'quantity': 8,
        'occurred_at': '2026-10-09T14:03:22.000Z',
        'local_day': '2026-10-09',
        'timezone': 'Asia/Kolkata',
        'source_ref': null,
      });
      await raw.close();

      final reopened = await _openQueue();
      final events = await reopened.peek();

      // The two good rows still come back. Without the guard the
      // validating fromRow would throw and the user would lose every
      // event in the queue, not one — the poison pill §4.2 exists to
      // avoid, in local form.
      expect(events.map((e) => e.clientEventId), ['evt-1', 'evt-3']);
      // And the unsendable row is gone, so it cannot block a later peek.
      expect(await reopened.count(), 2);
      await reopened.close();
    });
  });

  group('ActivityEvent validation', () {
    test('activityType carries its own faith, so it cannot mismatch', () {
      expect(ActivityType.quranVerse.faith, ActivityFaith.islam);
      expect(ActivityType.japaMala.faith, ActivityFaith.hindu);
      expect(
        _event('evt-1', type: ActivityType.gitaShloka).toJson()['faithId'],
        'hindu',
      );
    });

    test('rejects a quantity outside 1…10000', () {
      expect(() => _event('evt-1', quantity: 0), throwsArgumentError);
      expect(() => _event('evt-1', quantity: -3), throwsArgumentError);
      expect(() => _event('evt-1', quantity: 10001), throwsArgumentError);
    });

    test('rejects a localDay that is not a bare calendar date', () {
      expect(
        () => _event('evt-1', localDay: '2026-10-09T00:00:00Z'),
        throwsArgumentError,
      );
      expect(
        () => _event('evt-1', localDay: '09/10/2026'),
        throwsArgumentError,
      );
    });

    test('rejects an empty clientEventId and an oversized sourceRef', () {
      expect(() => _event('   '), throwsArgumentError);
      expect(() => _event('evt-1', sourceRef: 'q' * 129), throwsArgumentError);
      expect(_event('evt-1', sourceRef: 'q' * 128).sourceRef, hasLength(128));
    });

    test('an empty sourceRef becomes null rather than an empty string', () {
      // §1.6: "Omit the field, or send null... Do not send an empty string."
      final event = _event('evt-1', sourceRef: '  ');
      expect(event.sourceRef, isNull);
      expect(event.toJson().containsKey('sourceRef'), isFalse);
    });
  });

  group('timezone normalisation at construction', () {
    test('an event normalises its timezone on construction', () async {
      final queue = await _openQueue();
      await queue.enqueue(_event('evt-1', timezone: 'IST'));
      await queue.enqueue(_event('evt-2', timezone: '+05:30'));

      final stored = await queue.peek();
      expect(stored.map((e) => e.timezone), ['Asia/Kolkata', 'UTC']);
      await queue.close();
    });
  });
}

/// Stands in for Task 1.12's HTTP flush, failing the way a basement does.
Future<void> _alwaysFailingTransport(List<ActivityEvent> batch) async {
  throw const SocketException('Network is unreachable');
}
