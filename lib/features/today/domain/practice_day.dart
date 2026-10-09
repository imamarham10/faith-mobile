/// Wall-clock calendar-day arithmetic for everything the Today screen
/// counts.
///
/// A streak is a day-boundary bug waiting to happen, and this project has
/// already paid for the lesson once — the Hindu panchang bug compared a real
/// instant against wall-clock time and cost a day of debugging. So nothing
/// here ever converts a day to an instant: days are `yyyy-MM-dd` strings,
/// compared as strings (ISO dates sort correctly) and stepped with
/// `DateTime(y, m, d - n)`, which Dart normalises and which cannot be
/// shifted by a DST transition the way `subtract(Duration(days: 1))` can.
library;

/// The `yyyy-MM-dd` key for a local wall-clock date.
String dayKeyOf(DateTime day) {
  final y = day.year.toString().padLeft(4, '0');
  final m = day.month.toString().padLeft(2, '0');
  final d = day.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

/// [day] shifted by [days] calendar days, as a local midnight.
///
/// `DateTime(2026, 3, 0)` is 28 February and `DateTime(2026, 13, 1)` is
/// January of 2027 — Dart normalises out-of-range components, so month and
/// year boundaries need no special case.
DateTime shiftDays(DateTime day, int days) =>
    DateTime(day.year, day.month, day.day + days);

/// The day key carried by an API field backed by a Postgres `date` column.
///
/// Those serialise as `2026-10-09T00:00:00.000Z`. The calendar date is
/// already in the leading ten characters; parsing and calling `.toLocal()`
/// would land on 8 October for any user west of UTC, which is the off-by-one
/// that silently eats a day of a streak.
String dayKeyOfDateColumn(String isoDate) =>
    isoDate.length >= 10 ? isoDate.substring(0, 10) : isoDate;

/// As [dayKeyOfDateColumn], for a field the DTO has already parsed into a
/// [DateTime]. The UTC components are the stored calendar date.
String dayKeyOfDateTimeColumn(DateTime value) => dayKeyOf(
  DateTime(value.toUtc().year, value.toUtc().month, value.toUtc().day),
);

/// A practice streak, and whether the number can be trusted as exact.
class PracticeStreak {
  const PracticeStreak({required this.days, this.isFloor = false});

  final int days;

  /// True when the run reached the oldest day the data can speak to, so the
  /// real streak may be longer. Rendered as `12+` rather than `12` — an
  /// understated streak reads as a bug to the person who earned it.
  final bool isFloor;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PracticeStreak && days == other.days && isFloor == other.isFloor;

  @override
  int get hashCode => Object.hash(days, isFloor);

  @override
  String toString() => 'PracticeStreak($days${isFloor ? '+' : ''})';
}

/// Consecutive days, ending today or yesterday, on which at least one act of
/// worship was logged.
///
/// **Today not yet practised does not break the run** — the day is not over,
/// and a streak that resets at midnight and un-resets at Fajr is the single
/// most trust-destroying behaviour this feature could have. A full missed
/// day does break it.
///
/// This mirrors, deliberately and exactly, the rule the backend already
/// applies to the Hindu side in `puja-log.service.ts`. The two faiths' chips
/// have to mean the same thing or they are not comparable, and no test
/// catches a parity break in a number's *definition*.
///
/// [earliestKnownDay] is the oldest day the caller's data covers. The walk
/// stops there and reports [PracticeStreak.isFloor], rather than pretending
/// the run ended at the edge of a query window.
PracticeStreak deriveStreak({
  required Set<String> practisedDays,
  required DateTime today,
  required DateTime earliestKnownDay,
}) {
  if (practisedDays.isEmpty) return const PracticeStreak(days: 0);

  final edgeKey = dayKeyOf(earliestKnownDay);
  var cursor = practisedDays.contains(dayKeyOf(today))
      ? today
      : shiftDays(today, -1);

  var days = 0;
  while (practisedDays.contains(dayKeyOf(cursor))) {
    days++;
    final previous = shiftDays(cursor, -1);
    if (dayKeyOf(previous).compareTo(edgeKey) < 0) {
      return PracticeStreak(days: days, isFloor: true);
    }
    cursor = previous;
  }
  return PracticeStreak(days: days);
}
