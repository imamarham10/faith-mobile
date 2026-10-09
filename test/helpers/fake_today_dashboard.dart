import 'package:faith_mobile/features/hindu/habit_pack.dart';
import 'package:faith_mobile/features/islam/habit_pack.dart';
import 'package:faith_mobile/features/today/domain/today_dashboard.dart';
import 'package:faith_mobile/shared/habit/activity_event.dart';
import 'package:faith_mobile/shared/habit/faith_habit_pack.dart';
// Prefixed: the engine has its own `DayProgress` (counts + met for one
// day) and the dashboard has another (one ring in the week strip). Two
// different shapes for two different jobs, deliberately not merged.
import 'package:faith_mobile/shared/habit/streak_engine.dart' as engine;

/// Deterministic [TodayDashboard] fixtures, in the same spirit as
/// `fake_selected_faith.dart`: the Today goldens must never touch the
/// network, and must never depend on the day they are run on.
///
/// Overriding `todayDashboardProvider` with one of these is all a test
/// needs — the widgets read nothing else. That seam held through Task
/// 1.12, which swapped the controller's source from four on-device
/// derivations to `GET /activity/today`; what changed under it is the
/// *shape* of two fields, and both changes are the point:
///
/// * [TodayDashboard.goal] is now nullable, because §5.4 returns
///   `goal: null` for a user who has never set one and that is not the
///   same as a goal at zero. [noGoal] is the fixture for it.
/// * [DayProgress] carries `goalMet`, because a closed day's verdict comes
///   from `/history` and must not be re-derived from `done / target`.
abstract final class FakeTodayDashboard {
  /// A fixed reference day, so the week strip renders the same weekday
  /// letters on every machine and every run. 9 October 2026 is a Friday.
  static const String anchorDay = '2026-10-09';

  /// The same day as a [DateTime], for callers that need one.
  static final DateTime anchor = DateTime(2026, 10, 9);

  /// A week whose closed days are met iff `done >= target`.
  ///
  /// Fixtures may set `goalMet` independently of `done` — that is exactly
  /// what a goal change produces in reality (§7.4) — but the common case
  /// is that they agree, so this derives it.
  static List<DayProgress> _week(int target, List<int> done) => [
    for (var i = 0; i < done.length; i++)
      DayProgress(
        day: DateTime(2026, 10, 9 - (done.length - 1 - i)),
        done: done[i],
        target: target,
        goalMet: target > 0 && done[i] >= target,
        isToday: i == done.length - 1,
      ),
  ];

  static engine.StreakProjection _streak(int current) =>
      engine.StreakProjection(
        current: current,
        longest: current,
        lastGoalMetDay: current > 0 ? anchorDay : null,
        freezesLeft: 2,
        freezeResetOn: '2026-11-01',
      );

  /// Mid-day Islam state: a live streak, four of five verses read.
  static TodayDashboard islam() => TodayDashboard(
    pack: islamHabitPack,
    localDay: anchorDay,
    streak: _streak(12),
    week: _week(5, [5, 5, 3, 5, 5, 4, 4]),
    goal: const GoalProgress(
      goalType: GoalType.prayers,
      done: 4,
      target: 5,
      unit: 'prayers',
    ),
    checklist: const [
      ChecklistItem(label: 'Fajr', done: true, route: '/today/prayers'),
      ChecklistItem(label: 'Dhuhr', done: true, route: '/today/prayers'),
      ChecklistItem(label: 'Asr', done: true, route: '/today/prayers'),
      ChecklistItem(label: 'Maghrib', done: true, route: '/today/prayers'),
      ChecklistItem(label: 'Isha', done: false, route: '/today/prayers'),
    ],
    stats: const [
      StatSeries(label: 'Prayers', today: 4, week: 31),
      StatSeries(label: 'Verses', today: 9, week: 64),
      StatSeries(label: 'Dhikr', today: 133, week: 892),
    ],
  );

  /// The Hindu equivalent, same skeleton: three sandhya instead of five
  /// prayers, japa instead of dhikr.
  static TodayDashboard hindu() => TodayDashboard(
    pack: hinduHabitPack,
    localDay: anchorDay,
    streak: _streak(12),
    week: _week(3, [3, 3, 2, 3, 3, 2, 2]),
    goal: const GoalProgress(
      goalType: GoalType.sandhyas,
      done: 2,
      target: 3,
      unit: 'sandhya',
    ),
    checklist: const [
      ChecklistItem(label: 'Prātaḥ', done: true, route: '/today/puja-times'),
      ChecklistItem(label: 'Mādhyāhna', done: true, route: '/today/puja-times'),
      ChecklistItem(label: 'Sāyaṁ', done: false, route: '/today/puja-times'),
    ],
    stats: const [
      StatSeries(label: 'Sandhya', today: 2, week: 18),
      StatSeries(label: 'Shlokas', today: 4, week: 21),
      StatSeries(label: 'Japa', today: 108, week: 756),
    ],
  );

  /// A first-run user who has set a goal but done nothing today: the empty
  /// ring, and no chip — a zero streak is not worth a `🔥 0`.
  static TodayDashboard empty() => TodayDashboard(
    pack: islamHabitPack,
    localDay: anchorDay,
    streak: _streak(0),
    week: _week(5, [0, 0, 0, 0, 0, 0, 0]),
    goal: const GoalProgress(
      goalType: GoalType.verses,
      done: 0,
      target: 5,
      unit: 'verses',
    ),
    checklist: const [
      ChecklistItem(label: 'Fajr', done: false, route: '/today/prayers'),
      ChecklistItem(label: 'Dhuhr', done: false, route: '/today/prayers'),
      ChecklistItem(label: 'Asr', done: false, route: '/today/prayers'),
      ChecklistItem(label: 'Maghrib', done: false, route: '/today/prayers'),
      ChecklistItem(label: 'Isha', done: false, route: '/today/prayers'),
    ],
    stats: const [StatSeries(label: 'Prayers', today: 0, week: 0)],
  );

  /// **The state every single user passes through exactly once**: signed
  /// in, no goal ever set, so §5.4 returns `goal: null`.
  ///
  /// Distinct from [empty] on purpose, and the distinction is the contract:
  /// `goal: null` means "never set one" and gets the prompt; a goal with
  /// `progress: 0` gets the empty ring. Collapsing them leaves a new user
  /// looking at `0 / 0` with no way to start a streak, which is the whole
  /// engine failing silently on the first screen it shows.
  static TodayDashboard noGoal({FaithHabitPack? pack}) => TodayDashboard(
    pack: pack ?? islamHabitPack,
    localDay: anchorDay,
    // §2.4 — no goal, no met days, no streak.
    streak: _streak(0),
    week: _week(0, [0, 0, 0, 0, 0, 0, 0]),
    goal: null,
    checklist: const [
      ChecklistItem(label: 'Fajr', done: false, route: '/today/prayers'),
      ChecklistItem(label: 'Dhuhr', done: false, route: '/today/prayers'),
      ChecklistItem(label: 'Asr', done: false, route: '/today/prayers'),
      ChecklistItem(label: 'Maghrib', done: false, route: '/today/prayers'),
      ChecklistItem(label: 'Isha', done: false, route: '/today/prayers'),
    ],
    stats: const [StatSeries(label: 'Prayers', today: 0, week: 0)],
  );

  /// A long run the server reports, against a short history window.
  ///
  /// The old fixture here was `flooredStreak` — a `20+` the local
  /// derivation produced when it hit the edge of its query window. The
  /// engine has no such state: `/today`'s `streak.current` is exact however
  /// few days of `/history` the client asked for. This replaces it, and
  /// asserts the chip renders `200` rather than the seven days on screen.
  static TodayDashboard longServerStreak() => TodayDashboard(
    pack: islamHabitPack,
    localDay: anchorDay,
    streak: _streak(200),
    week: _week(5, [5, 5, 5, 5, 5, 5, 5]),
    goal: const GoalProgress(
      goalType: GoalType.verses,
      done: 5,
      target: 5,
      unit: 'verses',
    ),
    checklist: const [
      ChecklistItem(label: 'Fajr', done: true, route: '/today/prayers'),
      ChecklistItem(label: 'Dhuhr', done: true, route: '/today/prayers'),
      ChecklistItem(label: 'Asr', done: true, route: '/today/prayers'),
      ChecklistItem(label: 'Maghrib', done: true, route: '/today/prayers'),
      ChecklistItem(label: 'Isha', done: true, route: '/today/prayers'),
    ],
    stats: const [StatSeries(label: 'Prayers', today: 5, week: 35)],
  );
}
