/// The dhikr counter's one `record()` line, and the retry that used to
/// double it.
///
/// `DhikrCounterController` keeps a `_pendingDelta` that the dhikr API's
/// own sync puts *back* when `incrementCounter` fails, so the next flush
/// resends it. Recording off that variable therefore recorded the same
/// repetitions again on every retry — and with a fresh `clientEventId`
/// each time, so the server's idempotency could not catch it. The count
/// that feeds the goal and the streak inflated, on the normal offline
/// path.
///
/// The fix is a second counter, `_unrecordedDelta`, zeroed when recorded
/// and never re-queued. These tests are the reason it exists.
library;

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:faith_mobile/core/providers.dart';
import 'package:faith_mobile/features/dhikr/presentation/controllers/dhikr_counter_controller.dart';
import 'package:faith_mobile/features/dhikr/presentation/controllers/dhikr_counters_controller.dart';
import 'package:faith_mobile/shared/habit/activity_event.dart';
import 'package:faith_mobile/shared/habit/local_event_queue.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

const _counterId = 'c-1';

late Directory _dir;
late LocalEventQueue _queue;

/// Serves the counter list; fails every increment.
///
/// An increment is `PATCH /counters/:id` carrying a delta in `count` —
/// the same route an absolute update uses, which the backend partitions by
/// field (`setCount` resets, `count` increments). Keying on the path alone
/// would catch the reset too.
class _Api implements HttpClientAdapter {
  /// Whether `POST .../increment` should fail.
  bool failIncrements = true;

  int incrementCalls = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final data = options.data;
    final isIncrement =
        options.method == 'PATCH' && data is Map && data.containsKey('count');
    if (isIncrement) {
      incrementCalls += 1;
      if (failIncrements) {
        throw DioException.connectionError(
          requestOptions: options,
          reason: 'offline',
        );
      }
    }
    final counter = {
      'id': _counterId,
      'name': 'SubhanAllah',
      'count': 0,
      'targetCount': 33,
      'isActive': true,
    };
    final body = options.path.endsWith('/counters') ? [counter] : counter;
    return ResponseBody.fromString(
      jsonEncode(body),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

/// A container with the counter list already warm.
///
/// `DhikrCounterController.build` falls back to refreshing the list when
/// the counter is not already cached, and Riverpod forbids a provider
/// mutating another while building. The real app always arrives here from
/// the list screen, so the cached path is the production one; warming it
/// is fidelity, not a workaround.
Future<DhikrCounterController> _controller(ProviderContainer container) async {
  await container.read(dhikrCountersControllerProvider.future);
  await container.read(dhikrCounterControllerProvider(_counterId).future);
  return container.read(dhikrCounterControllerProvider(_counterId).notifier);
}

ProviderContainer _container(_Api api) {
  final dio = Dio(BaseOptions(baseUrl: 'http://test.local'))
    ..httpClientAdapter = api;
  final container = ProviderContainer(
    overrides: [
      dioProvider.overrideWithValue(dio),
      localEventQueueProvider.overrideWith((ref) async => _queue),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

/// Every dhikr event sitting in the queue.
Future<List<ActivityEvent>> _recorded() async {
  final all = await _queue.peek(limit: 1000);
  return [
    for (final e in all)
      if (e.activityType == ActivityType.dhikr) e,
  ];
}

void main() {
  setUpAll(sqfliteFfiInit);

  setUp(() async {
    _dir = Directory.systemTemp.createTempSync('faith_dhikr_test');
    _queue = await LocalEventQueue.open(
      path: LocalEventQueue.databasePathIn(_dir.path),
      factory: databaseFactoryFfi,
    );
  });

  tearDown(() async {
    await _queue.close();
    if (_dir.existsSync()) _dir.deleteSync(recursive: true);
  });

  test(
    'a failing sync, retried, records the repetitions exactly once',
    () async {
      final api = _Api();
      final container = _container(api);
      final controller = await _controller(container);

      for (var i = 0; i < 7; i++) {
        controller.increment();
      }

      // The dhikr API is down, so this fails and re-queues its own delta.
      await controller.flush();
      // ...and the next attempt resends it. Before the fix this recorded a
      // second seven, inflating the user's day by a factor of two.
      await controller.flush();
      await controller.flush();
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(api.incrementCalls, 3, reason: 'the dhikr API really did retry');

      final events = await _recorded();
      expect(events.length, 1, reason: 'one event, however many retries');
      expect(events.single.quantity, 7);
      expect(events.single.sourceRef, 'dhikr:$_counterId');
    },
  );

  test('sums quantity into one row rather than one row per tap', () async {
    // §2.4 — the server sums `quantity`, so 33 taps are one queue row.
    final api = _Api()..failIncrements = false;
    final container = _container(api);
    final controller = await _controller(container);

    for (var i = 0; i < 33; i++) {
      controller.increment();
    }
    await controller.flush();
    await Future<void>.delayed(const Duration(milliseconds: 20));

    final events = await _recorded();
    expect(events.length, 1);
    expect(events.single.quantity, 33);
  });

  test('repetitions said before a reset are still recorded', () async {
    // Resetting the bead count starts a new round. It does not unsay the
    // dhikr already said, so anything unrecorded is flushed rather than
    // dropped on the floor.
    final api = _Api()..failIncrements = false;
    final container = _container(api);
    final controller = await _controller(container);

    for (var i = 0; i < 5; i++) {
      controller.increment();
    }
    await controller.reset();
    await Future<void>.delayed(const Duration(milliseconds: 20));

    final events = await _recorded();
    expect(events.length, 1);
    expect(events.single.quantity, 5);
  });

  test('a flush with nothing new records nothing', () async {
    final api = _Api()..failIncrements = false;
    final container = _container(api);
    final controller = await _controller(container);

    await controller.flush();
    await controller.flush();
    await Future<void>.delayed(const Duration(milliseconds: 20));

    expect(await _recorded(), isEmpty);
  });
}
