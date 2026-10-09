/// The three read shapes of the activity API, parsed defensively.
///
/// Contract §5.3, §5.4 and §6.3. Every one of these is parsed rather than
/// code-generated because two of the rules are about *absence* and a
/// generated `fromJson` would quietly get them wrong:
///
/// * **`goal` is `null` when the user has never set one** (§5.4), and that
///   is categorically different from a goal sitting at `progress: 0`. The
///   first is an invitation to set one; the second is an empty ring. A
///   non-nullable `GoalSnapshot` with a zero target would collapse them and
///   silently mark every day met.
/// * **An absent key in `counts` means zero** (§5.3), never "unknown". The
///   server omits zero totals, so `counts['dhikr'] ?? 0` is the only
///   correct read and the maps here are already dense-by-default.
library;

import '../../../../shared/habit/activity_event.dart';

/// `GET /activity/today` (§5.3).
class ActivityTodaySnapshot {
  /// Builds a snapshot.
  const ActivityTodaySnapshot({
    required this.faith,
    required this.localDay,
    required this.timezone,
    required this.counts,
    required this.goal,
    required this.streak,
  });

  /// Parses §5.3's body. Throws [FormatException] on a shape that is not it.
  factory ActivityTodaySnapshot.fromJson(Map<String, Object?> json) {
    final localDay = json['localDay'];
    if (localDay is! String) {
      throw const FormatException('today: localDay missing');
    }
    final streak = json['streak'];
    if (streak is! Map) {
      throw const FormatException('today: streak missing');
    }
    final goal = json['goal'];
    return ActivityTodaySnapshot(
      faith: ActivityFaith.fromWire(json['faithId']! as String),
      localDay: localDay,
      timezone: json['timezone']?.toString() ?? 'UTC',
      counts: _counts(json['counts']),
      // Null, not a fabricated default. §5.4.
      goal: goal is Map ? ActivityGoalSnapshot.fromJson(goal) : null,
      streak: ActivityStreakSnapshot.fromJson(streak),
    );
  }

  /// Which faith this describes.
  final ActivityFaith faith;

  /// **The server's derivation of today, and the authority on it** (§5.2).
  ///
  /// Rendered and used verbatim. The client sends a `timezone` and reads
  /// back the day the server decided that means; assuming its own would
  /// reintroduce exactly the 02:00-IST bug §5.2 exists to close.
  final String localDay;

  /// Echo of the zone that was sent.
  final String timezone;

  /// `activityType` wire value -> summed quantity today. Absent key is zero.
  final Map<String, int> counts;

  /// `null` when the user has never set a goal for this faith (§5.4).
  final ActivityGoalSnapshot? goal;

  /// The streak, as the server computed it.
  final ActivityStreakSnapshot streak;
}

/// §5.3's `goal` object.
class ActivityGoalSnapshot {
  /// Builds a goal snapshot.
  const ActivityGoalSnapshot({
    required this.goalType,
    required this.target,
    required this.progress,
    required this.met,
  });

  /// Parses, throwing on a `goalType` this build does not know — §1.4 says
  /// unknown enum values are never silently defaulted, and a client older
  /// than the server is the case that produces one.
  factory ActivityGoalSnapshot.fromJson(Map<Object?, Object?> json) =>
      ActivityGoalSnapshot(
        goalType: GoalType.fromWire(json['goalType']! as String),
        target: (json['target']! as num).toInt(),
        progress: (json['progress'] as num?)?.toInt() ?? 0,
        met: json['met'] == true,
      );

  /// What the user set their target in.
  final GoalType goalType;

  /// How many units a day needs.
  final int target;

  /// Today's summed quantity of the counted activity (§2.4).
  final int progress;

  /// `progress >= target`.
  final bool met;
}

/// §5.3's `streak` object.
class ActivityStreakSnapshot {
  /// Builds a streak snapshot.
  const ActivityStreakSnapshot({
    required this.current,
    required this.longest,
    required this.freezesLeft,
    required this.freezeResetOn,
    required this.lastGoalMetDay,
  });

  /// Parses §5.3's streak.
  factory ActivityStreakSnapshot.fromJson(Map<Object?, Object?> json) =>
      ActivityStreakSnapshot(
        current: (json['current'] as num?)?.toInt() ?? 0,
        longest: (json['longest'] as num?)?.toInt() ?? 0,
        freezesLeft: (json['freezesLeft'] as num?)?.toInt() ?? 0,
        freezeResetOn: json['freezeResetOn']?.toString() ?? '',
        lastGoalMetDay: json['lastGoalMetDay']?.toString(),
      );

  /// §2.5 — includes today **iff** the goal is met. Does not drop overnight.
  final int current;

  /// Never decreases.
  final int longest;

  /// §2.6 — after freezes consumed this month, excluding today.
  final int freezesLeft;

  /// First day of next month in the user's zone.
  final String freezeResetOn;

  /// Most recent goal-met day, or `null` if never.
  final String? lastGoalMetDay;

  /// A user who has never met a goal anywhere.
  static const ActivityStreakSnapshot zero = ActivityStreakSnapshot(
    current: 0,
    longest: 0,
    freezesLeft: 2,
    freezeResetOn: '',
    lastGoalMetDay: null,
  );
}

/// One row of `GET /activity/history` (§6.3).
class ActivityHistoryDay {
  /// Builds a day.
  const ActivityHistoryDay({
    required this.localDay,
    required this.counts,
    required this.goalMet,
  });

  /// Parses one `days[]` entry.
  factory ActivityHistoryDay.fromJson(Map<Object?, Object?> json) =>
      ActivityHistoryDay(
        localDay: json['localDay']! as String,
        counts: _counts(json['counts']),
        goalMet: json['goalMet'] == true,
      );

  /// `YYYY-MM-DD`. The response is dense and ascending (§6.3).
  final String localDay;

  /// Same semantics as `/today`: absent key is zero.
  final Map<String, int> counts;

  /// **Whether that day met the goal as it stood when the day closed.**
  ///
  /// This is an input and is never recomputed on the device. The server
  /// scores each day against the `UserGoal` in force *on that day* (§7.5);
  /// the client holds only the current goal, so a client that replayed its
  /// own events would score every pre-goal-change day against the wrong
  /// target and the streak would flicker on every sync. §7.4 re-evaluates
  /// exactly one day — the open one — and that is the only day scored
  /// locally.
  final bool goalMet;
}

/// §5.3 / §6.3 — zero totals are absent keys, so a missing one is `0`.
Map<String, int> _counts(Object? raw) {
  if (raw is! Map) return const <String, int>{};
  final counts = <String, int>{};
  raw.forEach((key, value) {
    if (key is String && value is num) counts[key] = value.toInt();
  });
  return counts;
}
