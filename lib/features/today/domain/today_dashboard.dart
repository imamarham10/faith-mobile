import 'package:flutter/foundation.dart';

import 'practice_day.dart';

/// Everything the rebuilt Today screen renders, in a faith-agnostic shape.
///
/// **This is the seam.** Today the numbers are *derived on-device* from
/// prayer and puja logs and from dhikr and japa history — see
/// `today_dashboard_controller.dart`. When the activity engine lands
/// (retention plan Tasks 1.8–1.12) `todayDashboardProvider` swaps its source
/// for a single `GET /activity/today` and nothing below this class changes:
/// no widget reads a repository, and none of them know which faith they are
/// drawing.
///
/// The standing rule for everything in here: a number is present only if it
/// can be derived honestly from data that exists. Where it cannot, the field
/// is null or the list entry is absent, and the UI omits that element
/// entirely. A fabricated streak in a religious-practice app is worse than
/// no streak.
@immutable
class TodayDashboard {
  const TodayDashboard({
    required this.week,
    required this.goal,
    required this.checklist,
    required this.stats,
    this.streak,
  });

  /// Null when the streak could not be established. A zero streak and an
  /// unknown streak are different things, and the chip is omitted for the
  /// second rather than rendered as `0`.
  final PracticeStreak? streak;

  /// Exactly seven days, oldest first; the last entry is today.
  ///
  /// A rolling week rather than Monday–Sunday: every ring is then a day that
  /// has actually happened, where a calendar week would paint the rest of
  /// the week as unfilled rings — which reads as failure, not as "not yet".
  final List<DayProgress> week;

  final GoalProgress goal;

  /// The individual acts that make up today's goal, each deep-linking to the
  /// screen that completes it. Nothing here is self-reported.
  final List<ChecklistItem> checklist;

  /// Window-dependent tiles, in display order. Never "points" — real units
  /// only.
  final List<StatSeries> stats;
}

/// One day's progress toward the daily goal.
@immutable
class DayProgress {
  const DayProgress({
    required this.day,
    required this.done,
    required this.target,
  });

  final DateTime day;
  final int done;
  final int target;

  double get fraction =>
      target <= 0 ? 0 : (done / target).clamp(0.0, 1.0).toDouble();

  bool get isComplete => target > 0 && done >= target;

  String get key => dayKeyOf(day);
}

/// Today's goal. [unit] is the real unit — "prayers", "sandhya" — because
/// the design's standing decision is that the UI never shows a synthetic
/// currency.
@immutable
class GoalProgress {
  const GoalProgress({
    required this.done,
    required this.target,
    required this.unit,
  });

  final int done;
  final int target;
  final String unit;

  double get fraction =>
      target <= 0 ? 0 : (done / target).clamp(0.0, 1.0).toDouble();

  bool get isComplete => target > 0 && done >= target;
}

/// One row of the practice checklist.
@immutable
class ChecklistItem {
  const ChecklistItem({
    required this.label,
    required this.done,
    required this.route,
  });

  final String label;
  final bool done;

  /// Where tapping it goes — always a screen that can complete the act.
  final String route;
}

/// A stat tile's value across the windows the segmented control offers.
///
/// Only Today and Week exist. An "All" column was specified but is not
/// shipped: the Islam side has no all-time total to read — `GET
/// /prayers/log` is capped at 100 rows server-side, so an all-time figure
/// would be a truncated number presented as a total. Hindu does have honest
/// lifetime totals, but a segment that is real for one faith and fabricated
/// for the other breaks the both-faiths-or-neither rule more badly than
/// omitting it does.
@immutable
class StatSeries {
  const StatSeries({
    required this.label,
    required this.today,
    required this.week,
  });

  final String label;
  final int today;
  final int week;

  int valueFor(StatWindow window) =>
      switch (window) { StatWindow.today => today, StatWindow.week => week };
}

enum StatWindow {
  today('Today'),
  week('Week');

  const StatWindow(this.label);

  final String label;
}
