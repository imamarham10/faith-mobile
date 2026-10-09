import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/preferences/selected_faith.dart';
import '../../../../core/theme/faith_id.dart';
import '../../../dhikr/data/dhikr_repository.dart';
import '../../../dhikr/data/dtos/dhikr_history_entry.dart';
import '../../../hindu_japa/data/dtos/japa_history_entry.dart';
import '../../../hindu_japa/data/hindu_japa_repository.dart';
import '../../../hindu_puja_times/data/dtos/puja_log.dart';
import '../../../hindu_puja_times/data/hindu_puja_times_repository.dart';
import '../../../prayers/data/dtos/prayer_log.dart';
import '../../../prayers/data/prayers_repository.dart';
import '../../domain/practice_day.dart';
import '../../domain/today_dashboard.dart';

part 'today_dashboard_controller.g.dart';

/// How far back the on-device derivation looks.
///
/// Thirty days of prayer logs exceeds the server's 100-row cap for a user
/// logging all five daily, which is fine and deliberate: the cap truncates
/// the *oldest* rows, so what comes back is always contiguous from today
/// backwards and the streak derived from it is a correct floor. See
/// [PracticeStreak.isFloor].
const _historyWindowDays = 30;

/// The seven days the week strip shows, today included.
const _weekDays = 7;

/// Islam's daily goal: the five obligatory prayers. Hindu's: the three
/// sandhya. Both are fixed by the practice rather than chosen by the user —
/// a user-set goal arrives with `UserGoal` in Task 1.6.
const _islamDailyTarget = 5;
const _hinduDailyTarget = 3;

const _prayerOrder = <(String, String)>[
  ('fajr', 'Fajr'),
  ('dhuhr', 'Dhuhr'),
  ('asr', 'Asr'),
  ('maghrib', 'Maghrib'),
  ('isha', 'Isha'),
];

/// The three sandhya keys the puja-times endpoint returns, with the display
/// names it gives them. Hardcoded rather than read from `GET /puja-times`
/// because that call needs a location fix and a timezone, and the Today
/// dashboard must render before — and without — one. These move into
/// `lib/features/hindu/habit_pack.dart` in Task 1.11.
const _sandhyaOrder = <(String, String)>[
  ('pratah', 'Prātaḥ'),
  ('madhyahna', 'Mādhyāhna'),
  ('sayam', 'Sāyaṁ'),
];

/// The Today screen's single source of numbers.
///
/// Branches on faith here rather than in the widgets, so the screen's
/// progress section is built once for both faiths and cannot drift apart.
@riverpod
Future<TodayDashboard> todayDashboard(Ref ref) async {
  final faith = await ref.watch(selectedFaithProvider.future);
  return switch (faith ?? FaithId.islam) {
    FaithId.islam => ref.watch(islamTodayDashboardProvider.future),
    FaithId.hindu => ref.watch(hinduTodayDashboardProvider.future),
  };
}

/// Islam: prayers from the log, dhikr from history, streak derived locally.
///
/// There is no server-side prayer streak to read — the Hindu side has one
/// (`PujaStats.currentStreak`) and the Islam side does not — so this one is
/// computed on-device with [deriveStreak], which mirrors the server's rule
/// exactly so the two faiths' chips mean the same thing.
@riverpod
Future<TodayDashboard> islamTodayDashboard(Ref ref) async {
  final prayers = ref.watch(prayersRepositoryProvider);
  final dhikr = ref.watch(dhikrRepositoryProvider);

  final now = DateTime.now();
  final windowStart = shiftDays(now, -(_historyWindowDays - 1));

  // Started first so the two reads overlap; dhikr is best-effort, so its
  // failure costs one tile rather than the whole section.
  final dhikrFuture = _optional(
    dhikr.getHistory(from: windowStart, to: now, limit: 365),
  );
  final logs = await prayers.getLogsForRange(fromDate: windowStart, toDate: now);
  final dhikrHistory = await dhikrFuture;

  // One day may hold several prayers; a set of (day, prayer) pairs makes the
  // count robust to a duplicated row even though the server's unique index
  // should prevent one.
  final practisedByDay = <String, Set<String>>{};
  for (final log in logs) {
    if (!log.status.countsAsPractised) continue;
    final day = dayKeyOfDateColumn(log.date);
    (practisedByDay[day] ??= <String>{}).add(log.prayerName.toLowerCase());
  }

  final todayKey = dayKeyOf(now);
  final doneToday = practisedByDay[todayKey]?.length ?? 0;

  final truncated = logs.length >= PrayersRepository.serverLogRowCap;
  final earliestKnown = truncated && practisedByDay.isNotEmpty
      ? _earliestDay(practisedByDay.keys, fallback: windowStart)
      : windowStart;

  final week = _buildWeek(
    now: now,
    target: _islamDailyTarget,
    doneOn: (key) => practisedByDay[key]?.length ?? 0,
  );

  final dhikrByDay = <String, int>{};
  for (final entry in dhikrHistory ?? const <DhikrHistoryEntry>[]) {
    final at = entry.recordedAt;
    if (at == null) continue;
    final day = dayKeyOfDateTimeColumn(at);
    dhikrByDay[day] = (dhikrByDay[day] ?? 0) + entry.count;
  }

  return TodayDashboard(
    streak: deriveStreak(
      practisedDays: practisedByDay.keys.toSet(),
      today: now,
      earliestKnownDay: earliestKnown,
    ),
    week: week,
    goal: GoalProgress(
      done: doneToday,
      target: _islamDailyTarget,
      unit: 'prayers',
    ),
    checklist: [
      for (final (key, label) in _prayerOrder)
        ChecklistItem(
          label: label,
          done: practisedByDay[todayKey]?.contains(key) ?? false,
          route: '/today/prayers',
        ),
    ],
    stats: [
      StatSeries(
        label: 'Prayers',
        today: doneToday,
        week: week.fold(0, (sum, day) => sum + day.done),
      ),
      // Omitted entirely when the read failed — a zero would be a claim the
      // app cannot support.
      if (dhikrHistory != null)
        StatSeries(
          label: 'Dhikr',
          today: dhikrByDay[todayKey] ?? 0,
          week: _sumOverWeek(now, dhikrByDay),
        ),
    ],
  );
}

/// Hindu: sandhya from the puja log, japa from history, and a streak that is
/// read straight off the server — `GET /puja-times/stats` already computes
/// one, so this faith gets an authoritative number for free.
@riverpod
Future<TodayDashboard> hinduTodayDashboard(Ref ref) async {
  final puja = ref.watch(hinduPujaTimesRepositoryProvider);
  final japa = ref.watch(hinduJapaRepositoryProvider);

  final now = DateTime.now();
  final windowStart = shiftDays(now, -(_historyWindowDays - 1));

  final japaFuture = _optional(japa.getHistory());
  final statsFuture = _optional(puja.getStats());
  final logs = await puja.getLogs(fromDate: windowStart, toDate: now);
  final japaHistory = await japaFuture;
  final stats = await statsFuture;

  final practisedByDay = <String, Set<String>>{};
  for (final log in logs) {
    if (!log.status.countsAsPractised) continue;
    final day = dayKeyOfDateColumn(log.date);
    (practisedByDay[day] ??= <String>{}).add(log.sandhya);
  }

  final todayKey = dayKeyOf(now);
  final doneToday = practisedByDay[todayKey]?.length ?? 0;

  final week = _buildWeek(
    now: now,
    target: _hinduDailyTarget,
    doneOn: (key) => practisedByDay[key]?.length ?? 0,
  );

  final japaByDay = <String, int>{};
  for (final entry in japaHistory ?? const <JapaHistoryEntry>[]) {
    final day = dayKeyOfDateTimeColumn(entry.date);
    japaByDay[day] = (japaByDay[day] ?? 0) + entry.count;
  }

  return TodayDashboard(
    // Server-computed, so no floor marker — unlike Islam's, it is not
    // bounded by a query window.
    streak: stats == null ? null : PracticeStreak(days: stats.currentStreak),
    week: week,
    goal: GoalProgress(
      done: doneToday,
      target: _hinduDailyTarget,
      unit: 'sandhya',
    ),
    checklist: [
      for (final (key, label) in _sandhyaOrder)
        ChecklistItem(
          label: label,
          done: practisedByDay[todayKey]?.contains(key) ?? false,
          route: '/today/puja-times',
        ),
    ],
    stats: [
      StatSeries(
        label: 'Sandhya',
        today: doneToday,
        week: week.fold(0, (sum, day) => sum + day.done),
      ),
      if (japaHistory != null)
        StatSeries(
          label: 'Japa',
          today: japaByDay[todayKey] ?? 0,
          week: _sumOverWeek(now, japaByDay),
        ),
    ],
  );
}

List<DayProgress> _buildWeek({
  required DateTime now,
  required int target,
  required int Function(String dayKey) doneOn,
}) {
  return [
    for (var i = _weekDays - 1; i >= 0; i--)
      () {
        final day = shiftDays(now, -i);
        return DayProgress(
          day: day,
          done: doneOn(dayKeyOf(day)),
          target: target,
        );
      }(),
  ];
}

int _sumOverWeek(DateTime now, Map<String, int> byDay) {
  var total = 0;
  for (var i = 0; i < _weekDays; i++) {
    total += byDay[dayKeyOf(shiftDays(now, -i))] ?? 0;
  }
  return total;
}

DateTime _earliestDay(Iterable<String> keys, {required DateTime fallback}) {
  final sorted = keys.toList()..sort();
  if (sorted.isEmpty) return fallback;
  return DateTime.parse(sorted.first);
}

/// Runs a read whose failure should cost one tile, not the whole dashboard.
Future<T?> _optional<T>(Future<T> future) async {
  try {
    return await future;
  } on Object {
    return null;
  }
}
