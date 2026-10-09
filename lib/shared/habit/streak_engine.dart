/// The streak, computed on the device.
///
/// Task 1.10. The client computes the streak and the day's goal locally so
/// that tapping "read" moves the number immediately, and then reconciles
/// against `GET /today`, where **the server wins** (§2.7). That only works
/// if the two agree: if they disagree the number visibly flickers on every
/// sync, which reads as a bug about the one thing the feature is for.
///
/// So this file is a **port**, not a reimplementation. Its source of truth
/// is `unified-faith-service/src/activity/services/rollup.service.ts`
/// (`computeStreak`) against the frozen contract
/// `docs/contracts/activity-api.md` §2.4–§2.6. Where this file and that one
/// disagree, this one is wrong. The spec file next door mirrors
/// `rollup.service.spec.ts` case for case for the same reason.
///
/// ## What the caller must feed it, and the one rule that is not obvious
///
/// `metDays` must come from **`GET /history`'s `goalMet`** for every day
/// that has closed, not from replaying the local event stream.
///
/// The server evaluates each day against the `UserGoal` **in force on that
/// day** — goals are effective-dated and append-only, and a change is never
/// retroactive (§7.4, §7.5). The client holds only the *current* goal. So a
/// client that recomputed history from its own events would score every day
/// before a goal change against the wrong target and produce a different
/// run length from the server — the exact flicker this engine exists to
/// prevent. A closed day's verdict is the server's; only the open day is
/// computed here, which is also precisely the day §7.4 says is re-evaluated
/// against the current goal.
///
/// Days the device recorded while offline are the one honest exception:
/// the server has not seen them, so the client scores them with the goal it
/// has, which is the goal that was in force while they were queued.
///
/// ## Day arithmetic is calendar-only, and goes through UTC
///
/// Every day in this file is a `YYYY-MM-DD` string. Stepping one goes
/// through [DateTime.utc], never `DateTime.parse(day).add(Duration(days: 1))`
/// and never local-time components. Europe/London on 2026-10-25 is 25 hours
/// long — the clocks go *back* — so adding 24 hours to its midnight lands
/// back on 2026-10-25, two days collapse into one, and the user loses a day
/// off a streak they earned. [addDays] is the only way to step a day here.
///
/// [practiceDay.dart]-style local `DateTime` arithmetic is a different
/// representation for a different number (the Today screen's "days with any
/// activity" chip) and the two are deliberately not shared.
library;

import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'activity_event.dart';

/// §2.6 — two freezes per calendar month, granted not earned.
const int freezesPerMonth = 2;

/// The goal in force right now, for one faith.
///
/// Nullable at every call site on purpose: `null` means **no `UserGoal` row
/// is in force**, which §2.4 and §5.4 are emphatic is not the same as "no
/// events". A user who set a goal and has recorded nothing today gets
/// `progress: 0, met: false` — the empty ring. A user who has never set one
/// gets `null` — the goal-setting prompt. Modelling "no goal" as
/// `target: 0` would collapse the two and silently mark every day met.
class DailyGoal {
  /// Builds a goal, validating [target] against §1.3's range for [goalType].
  factory DailyGoal({required GoalType goalType, required int target}) {
    if (target < 1 || target > goalType.maxTarget) {
      throw ArgumentError.value(
        target,
        'target',
        'must be 1…${goalType.maxTarget} for ${goalType.wireValue}',
      );
    }
    return DailyGoal._(goalType: goalType, target: target);
  }

  const DailyGoal._({required this.goalType, required this.target});

  /// What the user counts in. Decides which activity type is summed.
  final GoalType goalType;

  /// How many units a day needs to be met.
  final int target;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyGoal &&
          goalType == other.goalType &&
          target == other.target;

  @override
  int get hashCode => Object.hash(goalType, target);

  @override
  String toString() => 'DailyGoal(${goalType.wireValue} x$target)';
}

/// One day's counts and whether it met the goal (§2.4).
class DayProgress {
  const DayProgress({
    required this.counts,
    required this.progress,
    required this.met,
  });

  /// `activityType` wire value -> summed `quantity`. §5.3: a zero total is
  /// an **absent key**, never a `0` value, so this map matches what
  /// `/today` and `/history` return and can be compared against them
  /// directly.
  final Map<String, int> counts;

  /// The summed `quantity` of the one activity type the goal counts, or `0`
  /// when there is no goal.
  final int progress;

  /// `progress >= target`, and always `false` when there is no goal.
  final bool met;

  @override
  String toString() => 'DayProgress($counts, $progress, met: $met)';
}

/// The streak, as the client renders it before the server confirms it.
///
/// Mirrors the server's `StreakSnapshot` field for field, so a `/today`
/// response can be compared against it without a translation layer.
class StreakProjection {
  const StreakProjection({
    required this.current,
    required this.longest,
    required this.lastGoalMetDay,
    required this.freezesLeft,
    required this.freezeResetOn,
  });

  /// §2.5 — the run ending at the most recent goal-met day. Includes today
  /// **if and only if** today is goal-met; it does not drop overnight.
  final int current;

  /// The longest such run **in the days handed to [computeStreak]**.
  ///
  /// This is the *computed* longest. §2.5's "never decreases" is the
  /// server's `max(computed, persisted)` and belongs to the caller, which
  /// holds the last `/today` response — the engine cannot honour it,
  /// because a client that has only fetched a 92-day window has no way to
  /// know about a 300-day run behind it.
  final int longest;

  /// Most recent goal-met day, or `null` if there has never been one.
  final String? lastGoalMetDay;

  /// §2.6 — after freezes already consumed this month, excluding today.
  final int freezesLeft;

  /// §2.6 — the first day of the next calendar month.
  final String freezeResetOn;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreakProjection &&
          current == other.current &&
          longest == other.longest &&
          lastGoalMetDay == other.lastGoalMetDay &&
          freezesLeft == other.freezesLeft &&
          freezeResetOn == other.freezeResetOn;

  @override
  int get hashCode => Object.hash(
    current,
    longest,
    lastGoalMetDay,
    freezesLeft,
    freezeResetOn,
  );

  @override
  String toString() =>
      'StreakProjection(current: $current, longest: $longest, '
      'lastGoalMetDay: $lastGoalMetDay, freezesLeft: $freezesLeft, '
      'freezeResetOn: $freezeResetOn)';
}

// ---------------------------------------------------------------------------
// §2.4 — one day's counts and whether the goal was met.
// ---------------------------------------------------------------------------

/// Sums `quantity` per activity type (§2.4, §5.3).
///
/// **`SUM(quantity)`, never `COUNT(events)`.** Twelve verses recorded as one
/// event and as twelve events are the same act of worship logged with
/// different granularity, and the server cannot tell them apart. If this
/// counted events instead, the Qur'an reader's batching strategy would
/// silently decide whether the user kept their streak.
///
/// [events] should already be the events for a single day; nothing here
/// filters by `localDay`, because the caller holds the day index.
Map<String, int> sumCounts(Iterable<ActivityEvent> events) {
  final counts = <String, int>{};
  for (final event in events) {
    final key = event.activityType.wireValue;
    counts[key] = (counts[key] ?? 0) + event.quantity;
  }
  // §5.3 — only non-zero totals are keys. `quantity` is validated >= 1 on
  // construction so this cannot trigger today, but a future corrected row
  // must not leave a `0` behind for the UI to render as a dot.
  counts.removeWhere((_, total) => total == 0);
  return counts;
}

/// Adds two days' counts together, for a day the server knows about and the
/// device also holds unflushed events for.
Map<String, int> mergeCounts(Map<String, int> a, Map<String, int> b) {
  final merged = Map<String, int>.of(a);
  b.forEach((key, value) => merged[key] = (merged[key] ?? 0) + value);
  merged.removeWhere((_, total) => total == 0);
  return merged;
}

/// §2.4 — `progress` and `met` for one day's [counts] under [goal].
///
/// A `null` [goal] yields `met: false` and `progress: 0`: the server never
/// invents a default target, and a day cannot be met before the user has
/// agreed to a goal (§7.4's consequence — 40 days of reading before a goal
/// existed are 40 closed days of `goalMet: false`).
DayProgress dayProgress({
  required Map<String, int> counts,
  required DailyGoal? goal,
}) {
  if (goal == null) {
    return DayProgress(counts: counts, progress: 0, met: false);
  }
  final progress = counts[goal.goalType.counts.wireValue] ?? 0;
  return DayProgress(
    counts: counts,
    progress: progress,
    met: progress >= goal.target,
  );
}

// ---------------------------------------------------------------------------
// §2.5, §2.6 — the streak, as one pure function.
// ---------------------------------------------------------------------------

/// Project the streak from the goal-met days, as of [today].
///
/// [metDays] is every `YYYY-MM-DD` the goal was met on, in any order. It is
/// sorted, de-duplicated and filtered to `<= today` here — the server does
/// that in `projectStreak` before calling its `computeStreak`, and the
/// filter is load-bearing: §2.2 accepts a tampered clock, so an event
/// stamped in the future must not be able to become the anchor of a streak
/// that is "as of today".
///
/// ## The shape: a forward scan, not the backward walk §2.5 describes
///
/// They compute the same number, and forward is better behaved twice over:
/// gaps *before* the user's first goal-met day are never examined, so a new
/// user cannot spend freezes bridging prehistory; and freeze consumption is
/// deterministic in one direction.
///
/// ## Lazy freezes (§2.6)
///
/// A freeze is charged only by a gap day that actually **bridges** — one
/// with a goal-met day on both sides. A frozen day bridges but does not
/// count: Oct 1–25 met, Oct 26 frozen, Oct 27 met is `26`, not `27`.
///
/// The gap between the last goal-met day and today is **tested but never
/// charged**, which is §2.6's worked example: on the morning of Oct 27 after
/// missing Oct 26 the user sees `25` and `freezesLeft: 2`; when they meet
/// the goal that evening, `26` and `freezesLeft: 1`. The eager
/// implementation shows `1` all morning and then §2.7 overrides it on the
/// next sync, and the user watches their freeze count change for no reason.
///
/// ## Two rules the contract never states
///
/// Both are pinned by server tests, and both are here because the mobile
/// engine has to match them rather than guess:
///
///  1. **Which month pays.** A gap day is charged to the allowance of the
///     calendar month *that gap day falls in*. A single running budget
///     would let two freezes bridge arbitrarily long gaps anywhere in
///     history, and streaks would be effectively unbreakable.
///  2. **A failed bridge charges nothing.** Paying for a gap is
///     all-or-nothing and rolled back if it cannot be completed: a freeze
///     spent on a bridge that then fails has bought the user nothing, and
///     charging for it would quietly cost them a freeze they could have
///     used the next day. So a user who broke their streak on Oct 7 with
///     one freeze left still shows `freezesLeft: 1` on Oct 10.
StreakProjection computeStreak(Iterable<String> metDays, String today) {
  final freezeResetOn = firstDayOfNextMonth(today);

  final days = metDays.where((day) => day.compareTo(today) <= 0).toSet().toList()
    ..sort();

  if (days.isEmpty) {
    return StreakProjection(
      current: 0,
      longest: 0,
      lastGoalMetDay: null,
      freezesLeft: freezesPerMonth,
      freezeResetOn: freezeResetOn,
    );
  }

  // Remaining allowance keyed by the `YYYY-MM` of the day being bridged.
  // Absent means the full monthly grant is untouched.
  final remaining = <String, int>{};
  int remainingFor(String day) => remaining[monthKey(day)] ?? freezesPerMonth;

  /// Pay for a whole gap, or for none of it. See rule 2 above.
  bool payFor(List<String> gapDays, {required bool commit}) {
    final needed = <String, int>{};
    for (final day in gapDays) {
      final month = monthKey(day);
      needed[month] = (needed[month] ?? 0) + 1;
    }
    for (final entry in needed.entries) {
      if ((remaining[entry.key] ?? freezesPerMonth) < entry.value) return false;
    }
    if (commit) {
      for (final entry in needed.entries) {
        remaining[entry.key] =
            (remaining[entry.key] ?? freezesPerMonth) - entry.value;
      }
    }
    return true;
  }

  var runLength = 1;
  var longest = 1;

  for (var i = 1; i < days.length; i++) {
    final previous = days[i - 1];
    final day = days[i];
    final gap = daysBetween(previous, day) - 1;

    if (gap == 0) {
      runLength += 1;
    } else if (payFor(
      daysInRange(addDays(previous, 1), addDays(day, -1)),
      commit: true,
    )) {
      // Bridged. The frozen days themselves add nothing to the length.
      runLength += 1;
    } else {
      // §2.6 — with no freezes left a gap breaks the streak. `longest` is
      // preserved; the new run starts at this day.
      runLength = 1;
    }
    if (runLength > longest) longest = runLength;
  }

  final lastGoalMetDay = days.last;

  // §2.5 — `current` includes today iff today is goal-met, and that falls
  // out of the anchor being the most recent goal-met day: when today is met
  // it IS the anchor and is counted; when it is not, it is the trailing
  // gap's first day and is never examined. There is no separate flag.
  final trailing = daysInRange(addDays(lastGoalMetDay, 1), addDays(today, -1));
  final alive = trailing.isEmpty || payFor(trailing, commit: false);

  return StreakProjection(
    current: alive ? runLength : 0,
    longest: longest,
    lastGoalMetDay: lastGoalMetDay,
    // Reported after freezes already consumed this month, and excluding
    // today — today is not a gap until it is over. The trailing gap was
    // tested with `commit: false`, so nothing it would need was deducted.
    freezesLeft: remainingFor(today).clamp(0, freezesPerMonth),
    freezeResetOn: freezeResetOn,
  );
}

// ---------------------------------------------------------------------------
// Calendar-date arithmetic. UTC only — see the library doc for why.
// ---------------------------------------------------------------------------

/// `YYYY-MM-DD` -> a [DateTime] at UTC midnight.
DateTime _utcMidnight(String day) => DateTime.utc(
  int.parse(day.substring(0, 4)),
  int.parse(day.substring(5, 7)),
  int.parse(day.substring(8, 10)),
);

/// `YYYY-MM-DD` from a [DateTime]'s own components, whatever zone it is in.
String _format(DateTime at) {
  final y = at.year.toString().padLeft(4, '0');
  final m = at.month.toString().padLeft(2, '0');
  final d = at.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

/// Step whole calendar days. [DateTime.utc] normalises month and year
/// overflow, so `addDays('2026-12-31', 1)` is `2027-01-01`.
String addDays(String day, int delta) {
  final from = _utcMidnight(day);
  return _format(DateTime.utc(from.year, from.month, from.day + delta));
}

/// Calendar days from [from] to [to]; negative if [to] precedes [from].
int daysBetween(String from, String to) =>
    (_utcMidnight(to).difference(_utcMidnight(from)).inHours / 24).round();

/// Every day in `[from, to]` inclusive; empty when [to] precedes [from].
///
/// Indexed off [from] rather than walking day-by-day, which the server does
/// (`for (day = from; day <= to; day = addDays(day, 1))`). The walk is one
/// bad [addDays] away from never terminating — step a local midnight by 24
/// hours on the day British Summer Time ends and it returns the same date
/// forever — and this runs on the UI isolate, where that is a frozen app
/// rather than a wrong number. Indexing cannot loop however [addDays]
/// behaves, and each entry is computed independently so one bad step
/// cannot cascade into the rest.
List<String> daysInRange(String from, String to) {
  final span = daysBetween(from, to);
  if (span < 0) return const [];
  return [for (var i = 0; i <= span; i++) addDays(from, i)];
}

/// The `YYYY-MM` a day belongs to — the key the freeze allowance is held
/// under (§2.6, and rule 1 on [computeStreak]).
String monthKey(String day) => day.substring(0, 7);

/// §2.6 — `freezeResetOn`: the first day of the next calendar month.
String firstDayOfNextMonth(String day) {
  final at = _utcMidnight(day);
  return _format(DateTime.utc(at.year, at.month + 1, 1));
}

/// The calendar date [at] falls on, in the device's own zone.
///
/// This is what the production caller uses for `today`, and it is the same
/// derivation `ActivityRecorder` stamps `localDay` with — which is the
/// point: the day a streak is computed against must be the day the events
/// were filed under, or the two disagree at every midnight.
String localDayOf(DateTime at) => _format(at.toLocal());

/// The calendar date [at] falls on **in [timezone]**, or `null` when the tz
/// database does not carry that zone.
///
/// This matches the server's derivation, which is
/// `Intl.DateTimeFormat(…, {timeZone}).formatToParts` and **not** `Date`'s
/// UTC methods: `2026-10-08T20:30Z` is `2026-10-09` in `Asia/Kolkata` and
/// `2026-10-08` in `America/Los_Angeles`, and taking UTC components would
/// answer `2026-10-08` for both.
///
/// Null rather than a fallback, because every fallback here is a *wrong
/// day*, which is the bug this function exists to avoid. The production
/// path does not need one: on the device the user's zone is the device's
/// zone and [localDayOf] answers it exactly. This exists for the server's
/// echoed `timezone` (§5.2) and for asserting parity with it.
///
/// The tz database bundled with `package:timezone` carries the canonical
/// zones but not the backward links, so a device reporting `Asia/Calcutta`
/// — which the server accepts, because `Intl` knows every alias — resolves
/// to null here. That is the right answer rather than a guess: the caller
/// falls back to [localDayOf], which for the device's own zone is correct
/// by construction.
String? localDayIn(String timezone, DateTime at) {
  if (!_tzReady) {
    tz_data.initializeTimeZones();
    _tzReady = true;
  }
  final tz.Location location;
  try {
    location = tz.getLocation(timezone);
  } on Object {
    return null;
  }
  return _format(tz.TZDateTime.from(at, location));
}

bool _tzReady = false;
