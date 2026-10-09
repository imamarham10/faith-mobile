/// The flush, against a real SQLite queue and a stubbed transport.
///
/// The queue is the real [LocalEventQueue] on a real file rather than a
/// fake, because every assertion here is about *what is left in the queue*
/// afterwards — and a fake queue would be asserting that the test's own
/// bookkeeping works. Only the network is stubbed, at Dio's
/// [HttpClientAdapter] seam, so the interceptors, serialisation and error
/// classification under test are the production ones.
///
/// The case that matters most is the one `614cde4` already wrote for the
/// queue in isolation and that this file now pins for the real flush: a
/// 5xx, a timeout or an unparseable body leaves the **whole** batch queued
/// (§4.8). Getting that wrong loses a user's worship silently, which is the
/// one failure mode this feature cannot have.
library;

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:faith_mobile/shared/habit/activity_event.dart';
import 'package:faith_mobile/shared/habit/activity_flusher.dart';
import 'package:faith_mobile/shared/habit/local_event_queue.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

late Directory _dir;
late String _dbPath;

/// Captures every request and replies with whatever the test queued up.
class _StubAdapter implements HttpClientAdapter {
  _StubAdapter(this._reply);

  /// Called with the parsed request body; returns a response or throws.
  final Future<ResponseBody> Function(Map<String, Object?> body, int call)
  _reply;

  /// Every batch sent, in order, as the list of `clientEventId`s in it.
  final List<List<String>> sentBatches = <List<String>>[];

  int _calls = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    // Dio leaves `data` as the Map it was given and encodes it into the
    // request stream separately, so read whichever the transformer left.
    final raw = options.data;
    final body = raw is String
        ? jsonDecode(raw) as Map<String, Object?>
        : Map<String, Object?>.from(raw! as Map);
    final events = (body['events']! as List).cast<Map<String, Object?>>();
    sentBatches.add([for (final e in events) e['clientEventId']! as String]);
    return _reply(body, _calls++);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody _json(int status, Object body) => ResponseBody.fromString(
  jsonEncode(body),
  status,
  headers: {
    Headers.contentTypeHeader: [Headers.jsonContentType],
  },
);

/// A `200` that settles everything it was sent as accepted.
ResponseBody _allAccepted(Map<String, Object?> body) {
  final n = (body['events']! as List).length;
  return _json(200, {'accepted': n, 'duplicates': 0, 'rejected': <Object>[]});
}

Dio _dio(_StubAdapter adapter) {
  final dio = Dio(BaseOptions(baseUrl: 'http://test.local'))
    ..httpClientAdapter = adapter;
  return dio;
}

ActivityEvent _event(String id, {int quantity = 1}) => ActivityEvent(
  clientEventId: id,
  activityType: ActivityType.quranVerse,
  quantity: quantity,
  occurredAt: DateTime.parse('2026-10-09T14:03:22Z'),
  localDay: '2026-10-09',
  timezone: 'Asia/Kolkata',
  sourceRef: 'quran:2:148',
);

Future<LocalEventQueue> _openQueue() =>
    LocalEventQueue.open(path: _dbPath, factory: databaseFactoryFfi);

/// A queue preloaded with [n] events, ids `e0`…`e{n-1}`.
Future<LocalEventQueue> _queueOf(int n) async {
  final queue = await _openQueue();
  await queue.enqueueAll([for (var i = 0; i < n; i++) _event('e$i')]);
  return queue;
}

void main() {
  setUpAll(sqfliteFfiInit);

  setUp(() {
    _dir = Directory.systemTemp.createTempSync('faith_flush_test');
    _dbPath = LocalEventQueue.databasePathIn(_dir.path);
  });

  tearDown(() {
    if (_dir.existsSync()) _dir.deleteSync(recursive: true);
  });

  group('a settled batch leaves the queue', () {
    test('200 all-accepted drains the queue', () async {
      final queue = await _queueOf(3);
      final adapter = _StubAdapter((body, _) async => _allAccepted(body));
      final flusher = ActivityFlusher(
        dio: _dio(adapter),
        queue: Future.value(queue),
      );

      final outcome = await flusher.flush();

      expect(outcome.accepted, 3);
      expect(outcome.retained, isFalse);
      expect(outcome.isComplete, isTrue);
      expect(await queue.count(), 0);
      await queue.close();
    });

    test('duplicates are settled, not retried forever', () async {
      final queue = await _queueOf(2);
      final adapter = _StubAdapter(
        (body, _) async =>
            _json(200, {'accepted': 0, 'duplicates': 2, 'rejected': []}),
      );
      final flusher = ActivityFlusher(
        dio: _dio(adapter),
        queue: Future.value(queue),
      );

      final outcome = await flusher.flush();

      expect(outcome.duplicates, 2);
      // §4.3: a resend writes nothing and is not an error. The rows have to
      // go, or a batch the server already holds is sent on every trigger
      // for the life of the install.
      expect(await queue.count(), 0);
      await queue.close();
    });

    test('rejected rows are deleted too — they can never succeed', () async {
      final queue = await _queueOf(3);
      final adapter = _StubAdapter(
        (body, _) async => _json(200, {
          'accepted': 2,
          'duplicates': 0,
          'rejected': [
            {
              'clientEventId': 'e1',
              'code': 'local_day_mismatch',
              'message': 'nope',
            },
          ],
        }),
      );
      final flusher = ActivityFlusher(
        dio: _dio(adapter),
        queue: Future.value(queue),
      );

      final outcome = await flusher.flush();

      expect(outcome.accepted, 2);
      expect(outcome.rejected, 1);
      // Every code in §4.5 is permanent. A retained rejection reaches the
      // head of the queue and blocks everything behind it forever — the
      // poison pill §4.2 exists to prevent.
      expect(await queue.count(), 0);
      await queue.close();
    });
  });

  group('an unsettled batch stays, whole', () {
    /// The core §4.8 guarantee, asserted for every ambiguous outcome.
    Future<void> expectWholeBatchKept(
      Future<ResponseBody> Function(Map<String, Object?>, int) reply,
    ) async {
      final queue = await _queueOf(5);
      final flusher = ActivityFlusher(
        dio: _dio(_StubAdapter(reply)),
        queue: Future.value(queue),
      );

      final outcome = await flusher.flush();

      expect(outcome.retained, isTrue);
      expect(outcome.accepted, 0);
      expect(await queue.count(), 5, reason: 'nothing may be lost');
      await queue.close();
    }

    test('500 keeps everything', () async {
      await expectWholeBatchKept(
        (_, __) async => _json(500, {
          'statusCode': 500,
          'message': 'boom',
          'code': 'internal_error',
        }),
      );
    });

    test('503 keeps everything', () async {
      await expectWholeBatchKept((_, __) async => _json(503, {'code': 'x'}));
    });

    test('a connection timeout keeps everything', () async {
      await expectWholeBatchKept(
        (_, __) async => throw DioException.connectionTimeout(
          timeout: const Duration(seconds: 1),
          requestOptions: RequestOptions(path: ActivityFlusher.path),
        ),
      );
    });

    test('a socket error keeps everything', () async {
      await expectWholeBatchKept(
        (_, __) async => throw DioException.connectionError(
          requestOptions: RequestOptions(path: ActivityFlusher.path),
          reason: 'Network is unreachable',
        ),
      );
    });

    test('a 200 with an unreadable body keeps everything', () async {
      // The ambiguous case named in §4.8: the write may or may not have
      // landed. Acknowledging on the strength of a body we cannot parse
      // would lose events; resending costs a duplicate and nothing else.
      await expectWholeBatchKept(
        (_, __) async => _json(200, {'ok': true}),
      );
    });

    test('a 200 whose counts do not add up keeps everything', () async {
      // §4.4: accepted + duplicates + rejected.length == events sent. A
      // response that violates it is not the answer to our request.
      await expectWholeBatchKept(
        (_, __) async =>
            _json(200, {'accepted': 1, 'duplicates': 0, 'rejected': []}),
      );
    });

    test('401 after refresh keeps everything', () async {
      // §3: the events are still valid. They wait for the next sign-in.
      await expectWholeBatchKept(
        (_, __) async => _json(401, {'code': 'unauthorized'}),
      );
    });

    test('a kept batch stops the flush rather than skipping past it', () async {
      final queue = await _queueOf(150);
      final adapter = _StubAdapter((_, __) async => _json(500, {'code': 'x'}));
      final flusher = ActivityFlusher(
        dio: _dio(adapter),
        queue: Future.value(queue),
      );

      await flusher.flush();

      // Order is the queue's contract. Jumping the failed batch to send the
      // next one would reorder the user's history on the server.
      expect(adapter.sentBatches.length, 1);
      expect(await queue.count(), 150);
      await queue.close();
    });
  });

  group('permanent whole-request failures drop the batch', () {
    test('a 400 that is not batch_too_large drops it', () async {
      final queue = await _queueOf(4);
      final adapter = _StubAdapter(
        (_, __) async => _json(400, {
          'statusCode': 400,
          'message': 'bad',
          'code': 'malformed_body',
        }),
      );
      final flusher = ActivityFlusher(
        dio: _dio(adapter),
        queue: Future.value(queue),
      );

      final outcome = await flusher.flush();

      // §4.8: nothing was written and retrying will not help. Keeping it
      // would block the queue permanently.
      expect(outcome.dropped, 4);
      expect(await queue.count(), 0);
      await queue.close();
    });

    test('batch_too_large re-chunks instead of dropping', () async {
      final queue = await _queueOf(10);
      final adapter = _StubAdapter((body, call) async {
        final n = (body['events']! as List).length;
        if (n > 5) return _json(400, {'code': 'batch_too_large'});
        return _allAccepted(body);
      });
      final flusher = ActivityFlusher(
        dio: _dio(adapter),
        queue: Future.value(queue),
      );

      final outcome = await flusher.flush();

      expect(outcome.accepted, 10);
      expect(outcome.dropped, 0);
      expect(await queue.count(), 0);
      // First attempt at 100 refused, then halved until it fits.
      expect(adapter.sentBatches.first.length, 10);
      expect(adapter.sentBatches.last.length, lessThanOrEqualTo(5));
      await queue.close();
    });
  });

  group('batching', () {
    test('never sends more than 100 in one request', () async {
      final queue = await _queueOf(250);
      final adapter = _StubAdapter((body, _) async => _allAccepted(body));
      final flusher = ActivityFlusher(
        dio: _dio(adapter),
        queue: Future.value(queue),
      );

      final outcome = await flusher.flush();

      expect(outcome.accepted, 250);
      expect(outcome.batches, 3);
      for (final batch in adapter.sentBatches) {
        expect(batch.length, lessThanOrEqualTo(ActivityFlusher.maxBatch));
      }
      expect(await queue.count(), 0);
      await queue.close();
    });

    test('sends oldest first, sequentially, without overlap', () async {
      final queue = await _queueOf(250);
      final adapter = _StubAdapter((body, _) async => _allAccepted(body));
      await ActivityFlusher(
        dio: _dio(adapter),
        queue: Future.value(queue),
      ).flush();

      final sent = adapter.sentBatches.expand((b) => b).toList();
      expect(sent, [for (var i = 0; i < 250; i++) 'e$i']);
      expect(sent.toSet().length, 250, reason: 'no event sent twice');
      await queue.close();
    });

    test('an empty queue makes no request at all', () async {
      final queue = await _openQueue();
      final adapter = _StubAdapter((body, _) async => _allAccepted(body));

      final outcome = await ActivityFlusher(
        dio: _dio(adapter),
        queue: Future.value(queue),
      ).flush();

      // §4.6: `events: []` is `400 empty_batch`. Never send one.
      expect(adapter.sentBatches, isEmpty);
      expect(outcome.batches, 0);
      expect(outcome.isComplete, isTrue);
      await queue.close();
    });
  });

  group('single flight', () {
    test('a concurrent flush joins rather than re-sending', () async {
      final queue = await _queueOf(3);
      final adapter = _StubAdapter((body, _) async {
        await Future<void>.delayed(const Duration(milliseconds: 40));
        return _allAccepted(body);
      });
      final flusher = ActivityFlusher(
        dio: _dio(adapter),
        queue: Future.value(queue),
      );

      // Resume, connectivity return and the post-record debounce routinely
      // land in the same second.
      final results = await Future.wait([
        flusher.flush(),
        flusher.flush(),
        flusher.flush(),
      ]);

      expect(adapter.sentBatches.length, 1);
      expect(results.where((r) => r.skipped).length, 2);
      expect(await queue.count(), 0);
      await queue.close();
    });

    test('a later flush runs normally once the first has finished', () async {
      final queue = await _queueOf(1);
      final adapter = _StubAdapter((body, _) async => _allAccepted(body));
      final flusher = ActivityFlusher(
        dio: _dio(adapter),
        queue: Future.value(queue),
      );

      await flusher.flush();
      await queue.enqueue(_event('later'));
      final second = await flusher.flush();

      expect(second.skipped, isFalse);
      expect(second.accepted, 1);
      expect(adapter.sentBatches.length, 2);
      await queue.close();
    });
  });

  group('the wire shape', () {
    test('sends exactly the contract §4.1 fields, nothing else', () async {
      final queue = await _openQueue();
      await queue.enqueue(
        ActivityEvent(
          clientEventId: 'abc',
          activityType: ActivityType.dhikr,
          quantity: 33,
          occurredAt: DateTime.parse('2026-10-09T08:30:00Z'),
          localDay: '2026-10-09',
          timezone: 'Asia/Kolkata',
          sourceRef: 'dhikr:counter-1',
        ),
      );
      Map<String, Object?>? captured;
      final adapter = _StubAdapter((body, _) async {
        captured = (body['events']! as List).first as Map<String, Object?>;
        return _allAccepted(body);
      });

      await ActivityFlusher(
        dio: _dio(adapter),
        queue: Future.value(queue),
      ).flush();

      expect(captured, {
        'clientEventId': 'abc',
        'faithId': 'islam',
        'activityType': 'dhikr',
        'quantity': 33,
        'occurredAt': '2026-10-09T08:30:00.000Z',
        'localDay': '2026-10-09',
        'timezone': 'Asia/Kolkata',
        'sourceRef': 'dhikr:counter-1',
      });
      await queue.close();
    });

    test('a six-day-old event keeps the day it happened on', () async {
      // §2.2 — the server validates `localDay` against the event's own
      // `occurredAt`, so a late flush is time-of-arrival independent. The
      // flush must not re-stamp anything.
      final queue = await _openQueue();
      await queue.enqueue(
        ActivityEvent(
          clientEventId: 'old',
          activityType: ActivityType.quranVerse,
          occurredAt: DateTime.parse('2026-10-03T19:10:00Z'),
          localDay: '2026-10-04',
          timezone: 'Pacific/Kiritimati',
        ),
      );
      Map<String, Object?>? captured;
      final adapter = _StubAdapter((body, _) async {
        captured = (body['events']! as List).first as Map<String, Object?>;
        return _allAccepted(body);
      });

      await ActivityFlusher(
        dio: _dio(adapter),
        queue: Future.value(queue),
      ).flush();

      expect(captured!['localDay'], '2026-10-04');
      expect(captured!['occurredAt'], '2026-10-03T19:10:00.000Z');
      expect(captured!['timezone'], 'Pacific/Kiritimati');
      await queue.close();
    });

    test('posts to the one write path', () async {
      expect(ActivityFlusher.path, '/api/v1/activity/events');
    });
  });
}
