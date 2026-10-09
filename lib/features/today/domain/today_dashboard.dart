import 'package:flutter/foundation.dart';

import '../../../shared/habit/activity_event.dart';
import '../../../shared/habit/faith_habit_pack.dart';
import '../../../shared/habit/streak_engine.dart';

/// Everything the Today screen renders, in a faith-agnostic shape.
///
/// **This was the seam, and Task 1.12 moved it.** The numbers used to be
/// derived on-device from prayer logs, puja logs, dhikr history and japa
/// history; they now come from `GET /activity/today` and
/// `GET /activity/history`, with unflushed queue rows laid on top. The
/// widgets below did not all survive untouched — see [goal] and
/// [DayProgress] for the two that could not, and why pretending otherwise
/// would have put a wrong number on screen.
///
/// The standing rule still holds: a number is present only if it can be
/// derived honestly from data that exists. Where it cannot, the field is
/// null and the UI omits that element entirely. A fabricated streak in a
/// religious-practice app is worse than no streak.
@immutable
class TodayDashboard {
  /// Builds a dashboard.
  const TodayDashboard({
    required this.pack,
    required this.localDay,
    required this.week,
    required this.goal,
    required this.checklist,
    required this.stats,
    this.streak,
    this.isStale = false,
  });

  /// The active faith's content pack — the only source of labels, icons,
  /// routes and goal choices on this screen.
  final FaithHabitPack pack;

  /// **The server's `localDay`, echoed back and treated as authoritative**
  /// (§5.2). The client renders the day it is given, not the one it
  /// assumed.
  final String localDay;

  /// The one streak number this app has.
  ///
  /// Null while unknown — before the first response, and when the server
  /// is unreachable with nothing cached. A zero streak and an unknown
  /// streak are different things and the chip is omitted for the second
  /// rather than rendered as `0`.
  ///
  /// There is exactly one streak metric in the app as of Task 1.12.
  /// `deriveStreak` (days with *any* activity) and the Hindu side's
  /// `PujaStats.currentStreak` (the server's any-activity count) were both
  /// retired in the same change: three different definitions of "streak"
  /// across two faiths meant two different numbers could appear on one
  /// screen, which destroys trust in the only number the feature is for.
  /// This one counts **goal-met days** (§2.5) for both faiths.
  final StreakProjection? streak;

  /// Exactly seven days, oldest first; the last entry is today.
  ///
  /// A rolling week rather than Monday–Sunday: every ring is then a day
  /// that has actually happened, where a calendar week would paint the rest
  /// of the week as unfilled rings — which reads as failure, not "not yet".
  final List<DayProgress> week;

  /// Today's goal, or **null when the user has never set one** (§5.4).
  ///
  /// Nullable is the whole point. The server returns `goal: null` rather
  /// than a fabricated default so the client can tell "never set a goal"
  /// (show the prompt) from "set a goal and hasn't met it yet" (show the
  /// ring at 0%). A non-nullable `GoalProgress` with `target: 0` would
  /// collapse the two, and §2.4 is explicit that no day can be met before
  /// the user has agreed to a goal.
  final GoalProgress? goal;

  /// The individual acts that make up the day, each deep-linking to the
  /// screen that completes it. Nothing here is self-reported.
  final List<ChecklistItem> checklist;

  /// Window-dependent tiles, in display order. Never "points" — real units.
  final List<StatSeries> stats;

  /// True when this was rendered from the last good response because the
  /// server could not be reached. The numbers are still honest — queued
  /// events are laid on top — but the streak may lag what the server would
  /// say, and the UI says so rather than presenting stale data as live.
  final bool isStale;
}

/// One day's progress toward the daily goal.
///
/// **A closed day and the open day are different measurements**, and this
/// class keeps them apart rather than papering over it.
///
/// For a closed day, [goalMet] comes from `/history` and is the only
/// honest answer available: the server scored that day against the goal in
/// force *on that day* (§7.5), and the device holds only the current goal.
/// Re-deriving a fraction from `done / currentTarget` would score history
/// against a target that may never have applied to it — the retroactivity
/// §7.4 forbids — and would routinely contradict the very `goalMet` beside
/// it. §6.3 says it outright: read the strip's filled state from `goalMet`
/// and do not infer it.
///
/// Today is the one day §7.4 re-evaluates, so it is the one day that can
/// honestly show a fraction.
@immutable
class DayProgress {
  /// Builds a day.
  const DayProgress({
    required this.day,
    required this.done,
    required this.target,
    required this.goalMet,
    required this.isToday,
  });

  /// The calendar day, as a local midnight.
  final DateTime day;

  /// Summed quantity of the counted activity on that day. Honest for every
  /// day; it is only the *target* that history cannot speak to.
  final int done;

  /// The current goal's target. Meaningful for [isToday] only; `0` when no
  /// goal is set.
  final int target;

  /// Whether the day met its goal — the server's verdict for a closed day,
  /// today's live evaluation for the open one.
  final bool goalMet;

  /// Whether this is the open day.
  final bool isToday;

  /// How full to draw the ring.
  ///
  /// Binary for a closed day on purpose. The alternative — `done / target`
  /// — is the local rescoring described above.
  double get fraction => isToday
      ? (target <= 0 ? 0 : (done / target).clamp(0.0, 1.0).toDouble())
      : (goalMet ? 1.0 : 0.0);

  /// Whether to draw the tick.
  bool get isComplete => goalMet;
}

/// Today's goal. [unit] is the real unit — "verses", "sandhya" — because
/// the standing decision is that the UI never shows a synthetic currency.
@immutable
class GoalProgress {
  /// Builds a goal.
  const GoalProgress({
    required this.goalType,
    required this.done,
    required this.target,
    required this.unit,
  });

  /// What the user counts in. Carried so the edit sheet opens on the goal
  /// the user actually has.
  final GoalType goalType;

  /// Summed quantity today, including anything still queued locally.
  final int done;

  /// What the user set.
  final int target;

  /// The noun, already agreeing with [done] — from the faith pack.
  final String unit;

  /// How full to draw the bar.
  double get fraction =>
      target <= 0 ? 0 : (done / target).clamp(0.0, 1.0).toDouble();

  /// §2.4 — `progress >= target`.
  bool get isComplete => target > 0 && done >= target;
}

/// One row of the practice checklist.
@immutable
class ChecklistItem {
  /// Builds a row.
  const ChecklistItem({
    required this.label,
    required this.done,
    required this.route,
  });

  /// From the faith pack — `Fajr`, `Prātaḥ`.
  final String label;

  /// Whether the act is logged for today.
  final bool done;

  /// Where tapping it goes — always a screen that can complete the act.
  final String route;
}

/// A stat tile's value across the windows the segmented control offers.
///
/// Only Today and Week exist. Both now come from the activity engine —
/// `/today`'s `counts` and `/history`'s per-day `counts` — which is also
/// why the "All" column still does not ship: the engine's history is
/// capped at 92 days per request (§6.2), so an all-time figure would be a
/// windowed number presented as a total.
@immutable
class StatSeries {
  /// Builds a series.
  const StatSeries({
    required this.label,
    required this.today,
    required this.week,
  });

  /// From the faith pack — `Verses`, `Japa`.
  final String label;

  /// Summed quantity today.
  final int today;

  /// Summed quantity over the rolling seven days.
  final int week;

  /// The value for [window].
  int valueFor(StatWindow window) => switch (window) {
    StatWindow.today => today,
    StatWindow.week => week,
  };
}

/// The windows the stat tiles offer.
enum StatWindow {
  /// Today only.
  today('Today'),

  /// The rolling seven days.
  week('Week');

  const StatWindow(this.label);

  /// What the chip says.
  final String label;
}
