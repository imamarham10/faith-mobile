import 'package:faith_mobile/features/today/domain/practice_day.dart';
import 'package:faith_mobile/features/today/domain/today_dashboard.dart';

/// Deterministic [TodayDashboard] fixtures, in the same spirit as
/// `fake_selected_faith.dart`: the Today goldens must never touch the
/// network, and must never depend on the day they are run on.
///
/// Overriding `todayDashboardProvider` with one of these is all a test
/// needs — the widgets read nothing else. That is the same seam the
/// activity engine will use when it replaces the on-device derivation in
/// Tasks 1.8–1.12.
abstract final class FakeTodayDashboard {
  /// A fixed reference day, so the week strip renders the same weekday
  /// letters on every machine and every run. 9 October 2026 is a Friday.
  static final DateTime anchor = DateTime(2026, 10, 9);

  static List<DayProgress> _week(int target, List<int> done) => [
    for (var i = 0; i < done.length; i++)
      DayProgress(
        day: shiftDays(anchor, -(done.length - 1 - i)),
        done: done[i],
        target: target,
      ),
  ];

  /// Mid-day Islam state: a live streak, four of five prayers logged, both
  /// stat tiles present.
  static TodayDashboard islam() => TodayDashboard(
    streak: const PracticeStreak(days: 12),
    week: _week(5, [5, 5, 3, 5, 5, 4, 4]),
    goal: const GoalProgress(done: 4, target: 5, unit: 'prayers'),
    checklist: const [
      ChecklistItem(label: 'Fajr', done: true, route: '/today/prayers'),
      ChecklistItem(label: 'Dhuhr', done: true, route: '/today/prayers'),
      ChecklistItem(label: 'Asr', done: true, route: '/today/prayers'),
      ChecklistItem(label: 'Maghrib', done: true, route: '/today/prayers'),
      ChecklistItem(label: 'Isha', done: false, route: '/today/prayers'),
    ],
    stats: const [
      StatSeries(label: 'Prayers', today: 4, week: 31),
      StatSeries(label: 'Dhikr', today: 133, week: 892),
    ],
  );

  /// The Hindu equivalent, same skeleton: three sandhya instead of five
  /// prayers, japa instead of dhikr.
  static TodayDashboard hindu() => TodayDashboard(
    streak: const PracticeStreak(days: 12),
    week: _week(3, [3, 3, 2, 3, 3, 2, 2]),
    goal: const GoalProgress(done: 2, target: 3, unit: 'sandhya'),
    checklist: const [
      ChecklistItem(label: 'Prātaḥ', done: true, route: '/today/puja-times'),
      ChecklistItem(
        label: 'Mādhyāhna',
        done: true,
        route: '/today/puja-times',
      ),
      ChecklistItem(label: 'Sāyaṁ', done: false, route: '/today/puja-times'),
    ],
    stats: const [
      StatSeries(label: 'Sandhya', today: 2, week: 18),
      StatSeries(label: 'Japa', today: 108, week: 756),
    ],
  );

  /// A first-run user: nothing logged, so the chip and the streak tile are
  /// both absent. This is what a new install actually looks like and it has
  /// to hold together too.
  ///
  /// The streak is `PracticeStreak(days: 0)`, not null — that is what the
  /// local derivation really returns for a user with no history, and a
  /// fixture the controller cannot produce would make the test that reads
  /// it green against a state that never happens.
  static TodayDashboard empty() => TodayDashboard(
    streak: const PracticeStreak(days: 0),
    week: _week(5, [0, 0, 0, 0, 0, 0, 0]),
    goal: const GoalProgress(done: 0, target: 5, unit: 'prayers'),
    checklist: const [
      ChecklistItem(label: 'Fajr', done: false, route: '/today/prayers'),
      ChecklistItem(label: 'Dhuhr', done: false, route: '/today/prayers'),
      ChecklistItem(label: 'Asr', done: false, route: '/today/prayers'),
      ChecklistItem(label: 'Maghrib', done: false, route: '/today/prayers'),
      ChecklistItem(label: 'Isha', done: false, route: '/today/prayers'),
    ],
    stats: const [StatSeries(label: 'Prayers', today: 0, week: 0)],
  );

  /// A streak that reaches the edge of the history the server will return,
  /// so the chip must read `20+` rather than claim exactly 20.
  static TodayDashboard flooredStreak() => TodayDashboard(
    streak: const PracticeStreak(days: 20, isFloor: true),
    week: _week(5, [5, 5, 5, 5, 5, 5, 5]),
    goal: const GoalProgress(done: 5, target: 5, unit: 'prayers'),
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
