/// The Today screen's single source of numbers, now served by the
/// retention engine.
///
/// Task 1.12. This file used to derive everything on-device from prayer
/// logs, puja logs, dhikr history and japa history, and to compute two
/// different streaks — [deriveStreak] for Islam, `PujaStats.currentStreak`
/// for Hindu. Both are gone. There is one streak metric in the app now and
/// it counts **goal-met days** (§2.5), identically for both faiths.
///
/// ## The rule this file exists to get right
///
/// **`metDays` is an input, never derived locally.**
///
/// The server scores each closed day against the `UserGoal` in force *on
/// that day* — goals are effective-dated and append-only, and a change is
/// never retroactive (§7.4, §7.5). The client holds only the *current*
/// goal. So a client that recomputed history from its own event stream
/// would score every day before a goal change against the wrong target,
/// produce a different run length from the server, and the streak would
/// visibly flicker on every sync — a bug about the one number the whole
/// feature is for.
///
/// Therefore: **closed days come from `/history`'s `goalMet` and are never
/// re-scored.** Exactly two kinds of day are scored on the device —
///
///  1. the open day, which is the one day §7.4 re-evaluates anyway; and
///  2. days carrying **unflushed queued events**, which the server has by
///     definition not seen, and which the device scores with the goal that
///     was in force while they sat in the queue.
///
/// A closed day with nothing queued against it is the server's verdict and
/// nothing else.
///
/// ## The server's streak is a floor, never a ceiling
///
/// `/history` returns at most 92 days (§6.2) and the Today screen asks for
/// far fewer. Feeding that window to [computeStreak] and rendering the
/// result would show `28` to a user with a 200-day run, then animate back
/// up on the next sync — precisely the flicker above, caused by the fix for
/// it. So the server's `streak.current` is adopted as-is and the local
/// engine is used only to compute **how many days the device can see that
/// the server cannot**, which is added on top. Both sides of that
/// subtraction run over the same window, so the window cancels out.
library;

import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/preferences/selected_faith.dart';
import '../../../../core/theme/faith_id.dart';
import '../../../../core/time/device_timezone.dart';
import '../../../../shared/habit/activity_event.dart';
import '../../../../shared/habit/activity_flush_scheduler.dart';
import '../../../../shared/habit/device_day.dart';
import '../../../../shared/habit/faith_habit_pack.dart';
import '../../../../shared/habit/local_event_queue.dart';
import '../../../../shared/habit/streak_engine.dart' as engine;
import '../../../hindu_puja_times/data/dtos/puja_log.dart';
import '../../../hindu_puja_times/data/hindu_puja_times_repository.dart';
import '../../../prayers/data/dtos/prayer_log.dart';
import '../../../prayers/data/prayers_repository.dart';
import '../../data/activity_repository.dart';
import '../../data/dtos/activity_snapshot.dart';
import '../../domain/practice_day.dart';
import '../../domain/today_dashboard.dart';

part 'today_dashboard_controller.g.dart';

/// Days of history fetched. Four weeks: enough to keep the streak honest
/// across a long offline stretch, well inside §6.2's 92-day cap, and the
/// size of the month grid a later phase will draw.
const _historyWindowDays = 28;

/// The seven days the week strip shows, today included.
const _weekDays = 7;

/// How far the requested window is padded beyond the device's own day, at
/// both ends.
///
/// The range is asked for before the server has said which day it is
/// describing (see [DeviceDayClock]), so the two can disagree — by a day,
/// for the minute either side of midnight when one clock has ticked over
/// and the other has not. One pad day at each end makes the requested
/// window a superset of `[serverDay - 27, serverDay]` for **any** such
/// disagreement, so the common case costs no second request: the window is
/// already right, and the extra day is simply never read, because
/// everything downstream indexes history by date string and walks backward
/// from the server's `localDay`.
///
/// Costed before being chosen: 30 days instead of 28 measured 0.73s against
/// 0.74s on production, and §6.2's cap is 92.
const _clockDriftPadDays = 1;

/// The last good response per faith, so a lost connection does not blank
/// the screen.
///
/// Without this a failed `GET /today` sends `TodayProgressSection` down its
/// error branch, and a user who turns off wifi and records a verse watches
/// the whole section disappear — on the one screen whose entire promise is
/// that offline worship still counts. In memory only: it is a render cache,
/// not a second source of truth, and persisting it would create a second
/// place the streak can be wrong.
@Riverpod(keepAlive: true)
class ActivitySnapshotCache extends _$ActivitySnapshotCache {
  @override
  Map<
    ActivityFaith,
    ({ActivityTodaySnapshot today, List<ActivityHistoryDay> history})
  >
  build() => const {};

  /// Remembers the latest good pair for [faith].
  void store(
    ActivityFaith faith,
    ActivityTodaySnapshot today,
    List<ActivityHistoryDay> history,
  ) => state = {...state, faith: (today: today, history: history)};
}

/// The raw engine reads, cached across rebuilds.
///
/// Separate from [todayDashboard] so that recording something rebuilds the
/// *projection* — which is local and instant — without firing a network
/// request per tap. A dhikr counter tapped a hundred times would otherwise
/// make a hundred `GET /today`s.
///
/// Invalidated after a flush actually lands, which is when the server has
/// something new to say.
@riverpod
Future<
  ({
    ActivityTodaySnapshot today,
    List<ActivityHistoryDay> history,
    bool isStale,
  })
>
activitySnapshot(Ref ref, ActivityFaith faith) async {
  // Re-reads whenever a flush lands something new. The rows that were
  // standing in for the server have just been deleted, so a snapshot older
  // than the flush under-reports by exactly what synced.
  ref.watch(activityFlushCompletedProvider);

  final repo = ref.watch(activityRepositoryProvider);
  final cache = ref.watch(activitySnapshotCacheProvider.notifier);
  // §1.5 — the IANA name from the device, never `DateTime.timeZoneName`.
  // §5.2 — required, and the server derives `localDay` from it.
  final timezone = DeviceTimezone.instance.current;
  final clientDay = ref.watch(deviceDayClockProvider).today();

  try {
    // Both in flight at once. The range below used to be hung off the
    // `localDay` the *response* echoed, which meant `/history` could not be
    // sent until `/today` had come back — two independent ~1s requests in
    // series, and nothing on the Today screen could draw until both had
    // landed. The device knows what day it is (§1.5 gives it the same zone
    // the request carries), so the window is computed here and the two go
    // out together.
    final todayCall = repo.getToday(faith: faith, timezone: timezone);
    final historyCall = repo.getHistory(
      faith: faith,
      from: engine.addDays(
        clientDay,
        -(_historyWindowDays - 1) - _clockDriftPadDays,
      ),
      to: engine.addDays(clientDay, _clockDriftPadDays),
    );
    // Record `.wait` rather than two sequential awaits: it awaits both even
    // when one fails, so an abandoned request cannot surface its own
    // failure later as an unhandled async error. The cost is paid in
    // [_firstFailure], which unwraps the result back to the `ApiException`
    // the repository threw.
    final (today, window) = await (todayCall, historyCall).wait;

    // §5.2 — the response is the authority on which day is being described,
    // and everything rendered downstream is anchored on it. All that is
    // settled here is whether the window actually *covers* that day.
    final drift = engine.daysBetween(clientDay, today.localDay);
    final history = drift.abs() <= _clockDriftPadDays
        ? window
        : await _refetchForServerDay(
            repo,
            faith: faith,
            serverDay: today.localDay,
            clientDay: clientDay,
            drift: drift,
          );

    cache.store(faith, today, history);
    return (today: today, history: history, isStale: false);
  } on Object catch (e, st) {
    final (cause, causeStack) = _firstFailure(e, st);
    final cached = ref.read(activitySnapshotCacheProvider)[faith];
    if (cached == null) Error.throwWithStackTrace(cause, causeStack);
    developer.log(
      'activity read failed; rendering the last good response',
      name: 'habit.today',
      error: cause,
    );
    return (today: cached.today, history: cached.history, isStale: true);
  }
}

/// Re-asks for the window the server's day actually needs.
///
/// Only reachable when the device clock is wrong by more than a midnight
/// race — more than [_clockDriftPadDays] days out. That is not a tolerable
/// miss: at two days' drift the week strip's oldest cell has no history
/// entry, falls to `goalMet: false`, and a user who met their goal every
/// day sees a hole in the week and a streak that looks broken. Paying a
/// second request to be right is the correct trade, and it is paid by
/// nobody whose clock is roughly correct.
///
/// Anchored on the server's day, which is the one §5.2 makes authoritative.
Future<List<ActivityHistoryDay>> _refetchForServerDay(
  ActivityRepository repo, {
  required ActivityFaith faith,
  required String serverDay,
  required String clientDay,
  required int drift,
}) {
  developer.log(
    'device clock is $drift day(s) from the server: asked for a window '
    'ending $clientDay, server is describing $serverDay — refetching',
    name: 'habit.today',
  );
  return repo.getHistory(
    faith: faith,
    from: engine.addDays(serverDay, -(_historyWindowDays - 1)),
    to: serverDay,
  );
}

/// The error a record `.wait` is actually reporting.
///
/// `(a, b).wait` reports a [ParallelWaitError] whose `errors` is a record of
/// nullable [AsyncError]s. Letting that reach the caller would replace the
/// repository's [ApiException] — which carries the status and the message —
/// with a wrapper that carries neither, so it is unwrapped to the first
/// real failure. Anything that is not a parallel error passes through
/// untouched.
(Object, StackTrace) _firstFailure(Object error, StackTrace stack) {
  if (error is ParallelWaitError) {
    final AsyncError? first = switch (error.errors) {
      (final AsyncError? a, final AsyncError? b) => a ?? b,
      (final AsyncError? a, final AsyncError? b, final AsyncError? c) =>
        a ?? b ?? c,
      _ => null,
    };
    if (first != null) return (first.error, first.stackTrace);
  }
  return (error, stack);
}

/// Awaits a record `.wait`, reporting what actually failed.
///
/// Without this the Today screen's error branch would be handed a
/// [ParallelWaitError] in place of the `ApiException` the repository threw,
/// and every log line about a failed read would name the wrapper instead of
/// the status code.
Future<T> _joined<T>(Future<T> wait) async {
  try {
    return await wait;
  } on Object catch (e, st) {
    final (cause, causeStack) = _firstFailure(e, st);
    Error.throwWithStackTrace(cause, causeStack);
  }
}

/// The Today screen's numbers, for whichever faith is selected.
///
/// Branches on faith exactly once — to pick the content pack — rather than
/// in the widgets, so the progress section is built once for both faiths
/// and cannot drift apart. There is no Islam copy of this function and no
/// Hindu one; that is the change Task 1.12 makes possible, because the two
/// faiths now read the same endpoint instead of four different ones.
@riverpod
Future<TodayDashboard> todayDashboard(Ref ref) async {
  final faith = await ref.watch(selectedFaithProvider.future) ?? FaithId.islam;
  final pack = habitPackFor(faith);

  // Rebuilds the projection whenever something is recorded, so a verse
  // read offline moves the ring on the next frame. Cheap: the network read
  // is memoised in `activitySnapshot`, and only the local overlay below is
  // recomputed.
  ref.watch(activityFlushRequestProvider);

  // Nothing below needs the server's answer in order to *start*, so nothing
  // below waits for it. The checklist reads a different endpoint entirely
  // (`GET /prayers/log`) and the overlay reads the local queue — both were
  // awaited after the snapshot purely because that is the order they are
  // written in, which cost a third serial network round trip and a cold
  // sqflite open on the critical path.
  final clientDay = ref.watch(deviceDayClockProvider).today();
  final snapshotCall = ref.watch(activitySnapshotProvider(pack.faith).future);
  final checklistCall = ref.watch(
    practiceChecklistProvider(pack.faithId).future,
  );
  // Padded like the server window and for the same reason: the day the
  // overlay is keyed by comes from the response, which may not be the day
  // this range was built from. Keys outside `[localDay - 27, localDay]` are
  // simply never looked up.
  final pendingCall = _pendingCountsByDay(
    ref,
    faith: pack.faith,
    from: engine.addDays(
      clientDay,
      -(_historyWindowDays - 1) - _clockDriftPadDays,
    ),
    to: engine.addDays(clientDay, _clockDriftPadDays),
  );

  // `.wait` again, so a snapshot failure cannot abandon the other two.
  final (snapshot, checklist, pendingByDay) = await _joined(
    (snapshotCall, checklistCall, pendingCall).wait,
  );

  final today = snapshot.today;
  final localDay = today.localDay;

  final historyByDay = {for (final day in snapshot.history) day.localDay: day};

  final goal = today.goal;
  final dailyGoal = goal == null
      ? null
      : engine.DailyGoal(goalType: goal.goalType, target: goal.target);

  /// The counts for [day], server plus anything still queued.
  Map<String, int> countsOn(String day) => engine.mergeCounts(
    day == localDay
        ? today.counts
        : (historyByDay[day]?.counts ?? const <String, int>{}),
    pendingByDay[day] ?? const <String, int>{},
  );

  final todayCounts = countsOn(localDay);
  final todayProgress = engine.dayProgress(
    counts: todayCounts,
    goal: dailyGoal,
  );

  return TodayDashboard(
    pack: pack,
    localDay: localDay,
    isStale: snapshot.isStale,
    streak: _projectStreak(
      server: today.streak,
      serverMetToday: goal?.met ?? false,
      history: snapshot.history,
      localDay: localDay,
      locallyScorableDays: {localDay, ...pendingByDay.keys},
      countsOn: countsOn,
      goal: dailyGoal,
    ),
    week: _buildWeek(
      localDay: localDay,
      historyByDay: historyByDay,
      pendingByDay: pendingByDay,
      countsOn: countsOn,
      goal: dailyGoal,
      todayMet: todayProgress.met,
    ),
    // Null all the way through when no goal exists (§5.4). The card shows
    // the prompt rather than a `0 / 0` bar.
    goal: goal == null
        ? null
        : GoalProgress(
            goalType: goal.goalType,
            done: todayProgress.progress,
            target: goal.target,
            unit: pack.unitFor(goal.goalType, todayProgress.progress),
          ),
    checklist: checklist,
    stats: [
      for (final type in pack.activityTypes)
        StatSeries(
          label: pack.labelFor(type),
          today: todayCounts[type.wireValue] ?? 0,
          week: _sumOverWeek(
            localDay: localDay,
            key: type.wireValue,
            countsOn: countsOn,
          ),
        ),
    ],
  );
}

/// §2.5 — the streak, with the server as the floor.
///
/// The arithmetic is a difference of two runs over the *same* window:
/// `after` is the run the device can see, `before` is the run the server's
/// data alone supports. Their difference is the number of days the device
/// knows about that the server does not, and that — never the raw local
/// run — is what is added to the server's number.
///
/// Erring upward is deliberate. A device that has been offline across a
/// genuine break can overstate until the next sync, and §2.7's answer is to
/// animate down to the server's value. The opposite error — showing a
/// smaller number than the user earned — is the one that destroys trust.
engine.StreakProjection _projectStreak({
  required ActivityStreakSnapshot server,
  required bool serverMetToday,
  required List<ActivityHistoryDay> history,
  required String localDay,
  required Set<String> locallyScorableDays,
  required Map<String, int> Function(String day) countsOn,
  required engine.DailyGoal? goal,
}) {
  final base = engine.StreakProjection(
    current: server.current,
    longest: server.longest,
    lastGoalMetDay: server.lastGoalMetDay,
    freezesLeft: server.freezesLeft,
    freezeResetOn: server.freezeResetOn,
  );

  // §2.4 — no goal, no met days, no streak. The server already says `0`;
  // there is nothing the device could add.
  if (goal == null) return base;

  // The server's own verdicts. Closed days as `/history` reported them —
  // never re-scored — plus today as `/today` evaluated it.
  final serverMet = <String>{
    for (final day in history)
      if (day.goalMet && day.localDay != localDay) day.localDay,
    if (serverMetToday) localDay,
  };

  // The same set plus the days the device can score: the open day, and any
  // day still carrying unflushed events.
  final withLocal = {...serverMet};
  for (final day in locallyScorableDays) {
    // Never let a day stamped in the future anchor a streak that is "as of
    // today" — §2.2 accepts a tampered clock by design.
    if (day.compareTo(localDay) > 0) continue;
    if (engine.dayProgress(counts: countsOn(day), goal: goal).met) {
      withLocal.add(day);
    }
  }

  final before = engine.computeStreak(serverMet, localDay).current;
  final after = engine.computeStreak(withLocal, localDay).current;
  final delta = after > before ? after - before : 0;
  if (delta == 0) return base;

  final current = server.current + delta;
  return engine.StreakProjection(
    current: current,
    // §2.5 — `longest` never decreases, and the server's persisted value
    // can exceed anything this window shows.
    longest: current > server.longest ? current : server.longest,
    lastGoalMetDay: localDay,
    freezesLeft: server.freezesLeft,
    freezeResetOn: server.freezeResetOn,
  );
}

/// The rolling seven days, today last.
List<DayProgress> _buildWeek({
  required String localDay,
  required Map<String, ActivityHistoryDay> historyByDay,
  required Map<String, Map<String, int>> pendingByDay,
  required Map<String, int> Function(String day) countsOn,
  required engine.DailyGoal? goal,
  required bool todayMet,
}) {
  final counted = goal?.goalType.counts.wireValue;
  return [
    for (var i = _weekDays - 1; i >= 0; i--)
      () {
        final day = engine.addDays(localDay, -i);
        final isToday = day == localDay;
        final counts = countsOn(day);
        return DayProgress(
          day: DateTime.parse(day),
          done: counted == null ? 0 : (counts[counted] ?? 0),
          target: goal?.target ?? 0,
          // §6.3 — a closed day's filled state is read from `goalMet` and
          // never inferred. The one exception is a closed day the device
          // still holds events for: the server has not seen those, so its
          // `false` is not yet the final word.
          goalMet: isToday
              ? todayMet
              : (historyByDay[day]?.goalMet ?? false) ||
                    (pendingByDay.containsKey(day) &&
                        goal != null &&
                        engine.dayProgress(counts: counts, goal: goal).met),
          isToday: isToday,
        );
      }(),
  ];
}

int _sumOverWeek({
  required String localDay,
  required String key,
  required Map<String, int> Function(String day) countsOn,
}) {
  var total = 0;
  for (var i = 0; i < _weekDays; i++) {
    total += countsOn(engine.addDays(localDay, -i))[key] ?? 0;
  }
  return total;
}

/// Unflushed events, summed per day.
///
/// A failure here costs the optimistic overlay and nothing else — the
/// server's numbers still render — so it is swallowed rather than allowed
/// to blank the screen.
Future<Map<String, Map<String, int>>> _pendingCountsByDay(
  Ref ref, {
  required ActivityFaith faith,
  required String from,
  required String to,
}) async {
  try {
    final queue = await ref.watch(localEventQueueProvider.future);
    final pending = await queue.pendingBetween(
      faith: faith,
      from: from,
      to: to,
    );
    final byDay = <String, List<ActivityEvent>>{};
    for (final event in pending) {
      (byDay[event.localDay] ??= <ActivityEvent>[]).add(event);
    }
    return {
      for (final entry in byDay.entries)
        entry.key: engine.sumCounts(entry.value),
    };
  } on Object catch (e, st) {
    developer.log(
      'could not read queued events for the overlay',
      name: 'habit.today',
      error: e,
      stackTrace: st,
    );
    return const <String, Map<String, int>>{};
  }
}

/// The day's named acts, ticked from the log that owns them.
///
/// Deliberately **not** read from the engine. `/today`'s `counts` says
/// `prayer: 3` — a sum, not a set — so it cannot say *which* three, and a
/// checklist is exactly a question about which. The `sourceRef` that
/// carries `prayer:fajr` is stored but not projected by any Phase 1
/// endpoint (§1.6 makes it load-bearing from Phase 2). So the prayer and
/// puja logs remain the source for the ticks, as they always were; the
/// engine mirrors them through `record()`.
///
/// **Its own provider, so it is memoised.** [todayDashboard] watches the
/// record counter and therefore re-runs its whole body on every recorded
/// act; inlined, this read fired a `GET /prayers/log` per verse scrolled
/// past. Twenty verses was twenty requests.
///
/// Being memoised, it must be invalidated explicitly when a prayer or
/// sandhya is logged — invalidating [todayDashboardProvider] does *not*
/// reach it, because invalidating a watcher does nothing to what it
/// watches. `TodayLogs.log` and `TodayPujaLogs.log` both do so, and that
/// is the only thing that changes a tick.
@riverpod
Future<List<ChecklistItem>> practiceChecklist(Ref ref, FaithId faith) async {
  final pack = habitPackFor(faith);
  final done = await _loggedStepKeys(ref, pack);
  return [
    for (final step in pack.dailySteps)
      ChecklistItem(
        label: step.label,
        done: done.contains(step.key),
        route: step.route,
      ),
  ];
}

Future<Set<String>> _loggedStepKeys(Ref ref, FaithHabitPack pack) async {
  try {
    switch (pack.faithId) {
      case FaithId.islam:
        final logs = await ref
            .watch(prayersRepositoryProvider)
            .getLogsForDate();
        return {
          for (final PrayerLog log in logs)
            if (log.status.countsAsPractised) log.prayerName.toLowerCase(),
        };
      case FaithId.hindu:
        final now = DateTime.now();
        final logs = await ref
            .watch(hinduPujaTimesRepositoryProvider)
            .getLogs(fromDate: now, toDate: now);
        final todayKey = dayKeyOf(now);
        return {
          for (final PujaLog log in logs)
            if (log.status.countsAsPractised &&
                dayKeyOfDateColumn(log.date) == todayKey)
              log.sandhya,
        };
    }
  } on Object {
    // One unticked checklist is a far smaller failure than an error card
    // over the whole progress section.
    return const <String>{};
  }
}
