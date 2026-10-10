/// The projection: `/today` + `/history` + the local queue, into one
/// dashboard.
///
/// Driven through a stubbed Dio adapter rather than a faked repository, so
/// the DTO parsing, the §5.3 absent-key-means-zero rule and the query
/// parameters are all under test alongside the arithmetic. The queue is the
/// real [LocalEventQueue] on a real file.
///
/// Three properties carry most of the weight here, and each one is a bug
/// the contract warns about by name:
///
///  1. **The history window must never shorten the streak.** A seven-day
///     window beside a 200-day run has to render `200`.
///  2. **A closed day's verdict is the server's.** Nothing re-scores it
///     against the current goal, because the server used the goal in force
///     *that day* (§7.5).
///  3. **Offline still counts.** With the network gone, the last good
///     response plus the queue must still move the numbers.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:faith_mobile/core/preferences/selected_faith.dart';
import 'package:faith_mobile/core/providers.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:faith_mobile/features/today/presentation/controllers/today_dashboard_controller.dart';
import 'package:faith_mobile/shared/habit/activity_event.dart';
import 'package:faith_mobile/shared/habit/device_day.dart';
import 'package:faith_mobile/shared/habit/local_event_queue.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

const _today = '2026-10-09';

late Directory _dir;
late LocalEventQueue _queue;

/// Answers `/today` and `/history` from whatever the test set up.
class _Api implements HttpClientAdapter {
  _Api({required this.today, required this.history});

  Map<String, Object?> today;
  List<Map<String, Object?>> history;

  /// When set, every call throws it — the offline case.
  DioException? failure;

  /// When set, no response is produced until it completes. The seam the
  /// concurrency tests need: without it, "both were called" is satisfied by
  /// the serial implementation too, and the test proves nothing.
  Completer<void>? gate;

  final List<Uri> calls = <Uri>[];

  /// Every `/activity/history` request, so a test can assert on the window
  /// that was actually asked for — and on how many were sent.
  Iterable<Uri> get historyCalls =>
      calls.where((u) => u.path.endsWith('/activity/history'));

  Uri get todayCall =>
      calls.firstWhere((u) => u.path.endsWith('/activity/today'));

  bool get calledPrayerLog =>
      calls.any((u) => u.path.endsWith('/prayers/log'));

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    calls.add(options.uri);
    await gate?.future;
    final failure = this.failure;
    if (failure != null) throw failure;
    final body = options.path.endsWith('/activity/today')
        ? today
        : <String, Object?>{'days': history};
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

/// A clock pinned to [day].
///
/// Every window these tests assert on is built from the device's day, so an
/// unpinned clock would make them pass today and drift tomorrow — and the
/// disagreement cases, which are *about* two days differing, could not be
/// written at all.
class _FixedClock extends DeviceDayClock {
  const _FixedClock(this.day);
  final String day;
  @override
  String today() => day;
}

Map<String, Object?> _todayBody({
  Map<String, Object?> counts = const {},
  Map<String, Object?>? goal,
  int current = 0,
  int longest = 0,
  String? lastGoalMetDay,
}) => {
  'faithId': 'islam',
  'localDay': _today,
  'timezone': 'Asia/Kolkata',
  'counts': counts,
  'goal': goal,
  'streak': {
    'current': current,
    'longest': longest,
    'freezesLeft': 2,
    'freezeResetOn': '2026-11-01',
    'lastGoalMetDay': lastGoalMetDay,
  },
};

/// `verses`, target 5 — the pack's Islam default.
Map<String, Object?> _verses({required int progress, int target = 5}) => {
  'goalType': 'verses',
  'target': target,
  'progress': progress,
  'met': progress >= target,
};

/// [n] consecutive days ending the day before [_today], all goal-met.
List<Map<String, Object?>> _metRun(int n) => [
  for (var i = n; i >= 1; i--)
    {
      'localDay': '2026-10-${(9 - i).toString().padLeft(2, '0')}',
      'counts': {'quran_verse': 5},
      'goalMet': true,
    },
];

ProviderContainer _container(_Api api, {String clientDay = _today}) {
  final dio = Dio(BaseOptions(baseUrl: 'http://test.local'))
    ..httpClientAdapter = api;
  final container = ProviderContainer(
    overrides: [
      dioProvider.overrideWithValue(dio),
      localEventQueueProvider.overrideWith((ref) async => _queue),
      selectedFaithProvider.overrideWith(() => _FixedFaith(FaithId.islam)),
      deviceDayClockProvider.overrideWithValue(_FixedClock(clientDay)),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

class _FixedFaith extends SelectedFaith {
  _FixedFaith(this._faith);
  final FaithId _faith;
  @override
  Future<FaithId?> build() async => _faith;
}

ActivityEvent _verseEvent(String id, {String day = _today}) => ActivityEvent(
  clientEventId: id,
  activityType: ActivityType.quranVerse,
  occurredAt: DateTime.parse('${day}T10:00:00Z'),
  localDay: day,
  timezone: 'Asia/Kolkata',
  sourceRef: 'quran:2:148',
);

void main() {
  setUpAll(sqfliteFfiInit);

  setUp(() async {
    _dir = Directory.systemTemp.createTempSync('faith_dash_test');
    _queue = await LocalEventQueue.open(
      path: LocalEventQueue.databasePathIn(_dir.path),
      factory: databaseFactoryFfi,
    );
  });

  tearDown(() async {
    await _queue.close();
    if (_dir.existsSync()) _dir.deleteSync(recursive: true);
  });

  group('the reads go out together', () {
    test('today, history and the checklist are all in flight at once', () async {
      // The regression this pins: `/history`'s range used to be derived
      // from the `localDay` `/today` echoed, so it could not be sent until
      // `/today` had returned, and the checklist's `/prayers/log` was
      // awaited after both. Three ~1s requests in series is ~2.4s before a
      // single card can draw; concurrently it is one.
      //
      // The gate is what makes this a real assertion. "All three were
      // called" is true of the serial version too — just not until the
      // previous one has answered. Holding every response open and
      // checking what has already been *sent* is the only version of this
      // test the old code fails.
      final api = _Api(today: _todayBody(), history: const [])
        ..gate = Completer<void>();

      final pending = _container(api).read(todayDashboardProvider.future);
      await pumpEventQueue();

      expect(
        api.historyCalls,
        hasLength(1),
        reason: '/history must not wait for /today to come back',
      );
      expect(
        api.calledPrayerLog,
        isTrue,
        reason: 'the checklist depends on nothing in the snapshot',
      );

      api.gate!.complete();
      await pending;
    });

    test('the window is built without being told what day it is', () async {
      // 28 days ending on the device's day, padded one at each end so a
      // midnight disagreement is already covered.
      final api = _Api(today: _todayBody(), history: const []);

      await _container(api).read(todayDashboardProvider.future);

      final window = api.historyCalls.single.queryParameters;
      expect(window['from'], '2026-09-11', reason: '27 + 1 days back');
      expect(window['to'], '2026-10-10', reason: '1 day forward');
    });
  });

  group('when the device and the server disagree about the day', () {
    // §5.2 — the response is the authority. The device's day is only ever
    // used to choose a *window*, never to decide what is rendered.

    test('a midnight-race day is absorbed, with no second request', () async {
      // The device has ticked over to the 10th; the server is still
      // describing the 9th. One pad day each side already covers it.
      final api = _Api(
        today: _todayBody(
          counts: {'quran_verse': 5},
          goal: _verses(progress: 5),
          current: 7,
          longest: 7,
          lastGoalMetDay: _today,
        ),
        history: _metRun(7),
      );

      final dashboard = await _container(
        api,
        clientDay: '2026-10-10',
      ).read(todayDashboardProvider.future);

      expect(api.historyCalls, hasLength(1), reason: 'no refetch');
      expect(dashboard.localDay, _today, reason: 'the server decides');
      // The bug this guards: a window off by a day shifting the strip, so
      // that a met day lands in the wrong cell and the week looks broken.
      expect(dashboard.week.last.isToday, isTrue);
      expect(dashboard.week.last.day, DateTime.parse(_today));
      expect(dashboard.week.first.day, DateTime.parse('2026-10-03'));
      expect(
        dashboard.week.where((d) => d.goalMet),
        hasLength(7),
        reason: 'all seven met days must still land in their own cells',
      );
      expect(dashboard.streak!.current, 7);
    });

    test('a device a day behind is absorbed too', () async {
      final api = _Api(
        today: _todayBody(
          counts: {'quran_verse': 5},
          goal: _verses(progress: 5),
          current: 7,
          longest: 7,
          lastGoalMetDay: _today,
        ),
        history: _metRun(7),
      );

      final dashboard = await _container(
        api,
        clientDay: '2026-10-08',
      ).read(todayDashboardProvider.future);

      expect(api.historyCalls, hasLength(1));
      expect(api.historyCalls.single.queryParameters['from'], '2026-09-10');
      expect(dashboard.localDay, _today);
      expect(dashboard.week.last.day, DateTime.parse(_today));
      expect(dashboard.week.where((d) => d.goalMet), hasLength(7));
    });

    test('a clock further out than that is refetched, not papered over', () async {
      // Two days' drift is not a midnight race, it is a wrong clock, and
      // the window genuinely misses days the week strip needs. Those cells
      // would fall back to `goalMet: false` and a user who met their goal
      // every day would see a hole in the week — a streak that looks
      // broken. One extra request is the right price.
      final api = _Api(
        today: _todayBody(
          counts: {'quran_verse': 5},
          goal: _verses(progress: 5),
          current: 7,
          longest: 7,
          lastGoalMetDay: _today,
        ),
        history: _metRun(7),
      );

      final dashboard = await _container(
        api,
        clientDay: '2026-11-20',
      ).read(todayDashboardProvider.future);

      expect(api.historyCalls, hasLength(2), reason: 'one refetch');
      final refetch = api.historyCalls.last.queryParameters;
      expect(refetch['from'], '2026-09-12', reason: 'anchored on the server');
      expect(refetch['to'], _today);
      expect(dashboard.localDay, _today);
      expect(dashboard.week.where((d) => d.goalMet), hasLength(7));
    });

    test('a stale snapshot still renders when the refetch fails', () async {
      // The refetch is on the critical path, so it must not be able to
      // turn a readable screen into an error card on its own.
      final api = _Api(
        today: _todayBody(goal: _verses(progress: 5), current: 3),
        history: _metRun(3),
      );
      final container = _container(api);
      await container.read(todayDashboardProvider.future);

      api.failure = DioException.connectionError(
        requestOptions: RequestOptions(path: '/api/v1/activity/history'),
        reason: 'Network is unreachable',
      );
      container.invalidate(activitySnapshotProvider);

      final offline = await container.read(todayDashboardProvider.future);
      expect(offline.isStale, isTrue);
      expect(offline.streak!.current, 3);
    });
  });

  group('the server is the authority', () {
    test('a short history window never shortens a long streak', () async {
      // The bug this exists to prevent: feeding a 7-day window to
      // `computeStreak` and rendering the result shows `7` to someone with
      // a 200-day run, which then animates back up on the next sync — the
      // exact flicker the local engine exists to avoid, caused by it.
      final api = _Api(
        today: _todayBody(
          counts: {'quran_verse': 5},
          goal: _verses(progress: 5),
          current: 200,
          longest: 200,
          lastGoalMetDay: _today,
        ),
        history: _metRun(7),
      );

      final dashboard = await _container(
        api,
      ).read(todayDashboardProvider.future);

      expect(dashboard.streak!.current, 200);
      expect(dashboard.week.length, 7);
    });

    test('renders the localDay the server echoed, not one it assumed', () {
      // §5.2 — there is exactly one authority on which day is being
      // described, and it is the response.
      final api = _Api(today: _todayBody(), history: const []);
      return _container(api).read(todayDashboardProvider.future).then((d) {
        expect(d.localDay, _today);
        expect(
          // Found by path, not by position: the reads now go out together,
          // so which one the adapter sees first is not a property worth
          // asserting on.
          api.todayCall.queryParameters['timezone'],
          isNotNull,
          reason: '§5.2 makes timezone required',
        );
      });
    });

    test('a closed day keeps the goalMet it closed with', () async {
      // §7.4 / §7.5 — the server scored 2 verses as met because the goal
      // that day was 2. Today's goal is 5. Re-deriving `2 >= 5` would both
      // contradict the server and backdate the goal change.
      final api = _Api(
        today: _todayBody(goal: _verses(progress: 0), current: 1),
        history: [
          {
            'localDay': '2026-10-08',
            'counts': {'quran_verse': 2},
            'goalMet': true,
          },
        ],
      );

      final dashboard = await _container(
        api,
      ).read(todayDashboardProvider.future);

      final closed = dashboard.week.firstWhere(
        (d) => !d.isToday && d.done == 2,
      );
      expect(closed.goalMet, isTrue);
      expect(closed.fraction, 1.0, reason: 'binary, not 2/5');
    });
  });

  group('no goal set', () {
    test('goal is null and nothing is scored locally', () async {
      // §5.4 — never set a goal. §2.4 — no day can be met. Even with a
      // queued verse, the streak stays 0: the device must not invent a
      // target the user never agreed to.
      await _queue.enqueue(_verseEvent('q1'));
      final api = _Api(today: _todayBody(goal: null), history: const []);

      final dashboard = await _container(
        api,
      ).read(todayDashboardProvider.future);

      expect(dashboard.goal, isNull);
      expect(dashboard.streak!.current, 0);
    });
  });

  group('the local overlay extends, never replaces', () {
    test('a queued verse the server has not seen adds today', () async {
      // The server saw 4 of 5 and says the run is 25, not including today.
      // One unflushed verse makes today met on the device.
      await _queue.enqueue(_verseEvent('q1'));
      final api = _Api(
        today: _todayBody(
          counts: {'quran_verse': 4},
          goal: _verses(progress: 4),
          current: 25,
          longest: 30,
          lastGoalMetDay: '2026-10-08',
        ),
        history: _metRun(7),
      );

      final dashboard = await _container(
        api,
      ).read(todayDashboardProvider.future);

      expect(dashboard.goal!.done, 5, reason: '4 server + 1 queued');
      expect(dashboard.goal!.isComplete, isTrue);
      expect(dashboard.streak!.current, 26, reason: '25 + today');
      // §2.5 — `longest` never decreases.
      expect(dashboard.streak!.longest, 30);
    });

    test('adds nothing when the server already counted today', () async {
      // The queued row is a duplicate of something already accepted. The
      // server's `current` already includes today; adding again would
      // double-count it.
      await _queue.enqueue(_verseEvent('q1'));
      final api = _Api(
        today: _todayBody(
          counts: {'quran_verse': 9},
          goal: _verses(progress: 9),
          current: 26,
          longest: 30,
          lastGoalMetDay: _today,
        ),
        history: _metRun(7),
      );

      final dashboard = await _container(
        api,
      ).read(todayDashboardProvider.future);

      expect(dashboard.streak!.current, 26);
    });

    test('queued events sum quantity, not events (§2.4)', () async {
      await _queue.enqueueAll([
        _verseEvent('q1'),
        ActivityEvent(
          clientEventId: 'q2',
          activityType: ActivityType.quranVerse,
          quantity: 2,
          occurredAt: DateTime.parse('${_today}T11:00:00Z'),
          localDay: _today,
          timezone: 'Asia/Kolkata',
        ),
      ]);
      final api = _Api(
        today: _todayBody(goal: _verses(progress: 0)),
        history: const [],
      );

      final dashboard = await _container(
        api,
      ).read(todayDashboardProvider.future);

      // Two events of quantity 1 and 2 are a progress of 3 — the same
      // arithmetic the live server returned for `counts.quran_verse`.
      expect(dashboard.goal!.done, 3);
    });

    test('a queued event for another faith is not counted', () async {
      await _queue.enqueue(
        ActivityEvent(
          clientEventId: 'h1',
          activityType: ActivityType.japaMala,
          occurredAt: DateTime.parse('${_today}T10:00:00Z'),
          localDay: _today,
          timezone: 'Asia/Kolkata',
        ),
      );
      final api = _Api(
        today: _todayBody(goal: _verses(progress: 0)),
        history: const [],
      );

      final dashboard = await _container(
        api,
      ).read(todayDashboardProvider.future);

      expect(dashboard.goal!.done, 0);
    });
  });

  group('offline', () {
    test(
      'the last good response plus the queue still moves the goal',
      () async {
        // This is the device test in miniature: read once on wifi, lose the
        // network, record a verse, and the screen must still update rather
        // than collapsing to an error card.
        final api = _Api(
          today: _todayBody(
            counts: {'quran_verse': 4},
            goal: _verses(progress: 4),
            current: 25,
            longest: 25,
            lastGoalMetDay: '2026-10-08',
          ),
          history: _metRun(7),
        );
        final container = _container(api);

        final online = await container.read(todayDashboardProvider.future);
        expect(online.isStale, isFalse);
        expect(online.goal!.done, 4);

        // Network gone.
        api.failure = DioException.connectionError(
          requestOptions: RequestOptions(path: '/api/v1/activity/today'),
          reason: 'Network is unreachable',
        );
        await _queue.enqueue(_verseEvent('offline-1'));
        container.invalidate(activitySnapshotProvider);

        final offline = await container.read(todayDashboardProvider.future);

        expect(offline.isStale, isTrue, reason: 'the UI says so, honestly');
        expect(offline.goal!.done, 5, reason: 'the queued verse still counts');
        expect(offline.goal!.isComplete, isTrue);
        expect(offline.streak!.current, 26);
      },
    );

    test('a first-ever read with nothing cached surfaces the error', () async {
      // There is no honest number to show, so the section shows its error
      // card and its retry. Rendering a fabricated zero would be worse.
      final api = _Api(today: _todayBody(), history: const [])
        ..failure = DioException.connectionError(
          requestOptions: RequestOptions(path: '/api/v1/activity/today'),
          reason: 'Network is unreachable',
        );

      await expectLater(
        _container(api).read(todayDashboardProvider.future),
        throwsA(anything),
      );
    });
  });

  group('counts', () {
    test('an absent key is zero, not unknown (§5.3)', () async {
      final api = _Api(
        today: _todayBody(
          counts: {'quran_verse': 7},
          goal: _verses(progress: 7),
        ),
        history: const [],
      );

      final dashboard = await _container(
        api,
      ).read(todayDashboardProvider.future);

      final dhikr = dashboard.stats.firstWhere((s) => s.label == 'Dhikr');
      expect(dhikr.today, 0);
      final verses = dashboard.stats.firstWhere((s) => s.label == 'Verses');
      expect(verses.today, 7);
    });

    test('stat tiles come from the pack, one per activity type', () async {
      final api = _Api(today: _todayBody(), history: const []);

      final dashboard = await _container(
        api,
      ).read(todayDashboardProvider.future);

      expect(dashboard.stats.map((s) => s.label), [
        'Prayers',
        'Verses',
        'Dhikr',
      ]);
    });
  });
}
