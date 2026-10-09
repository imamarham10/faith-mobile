/// Wall-clock calendar-day arithmetic for the Today screen's log reads.
///
/// A streak is a day-boundary bug waiting to happen, and this project has
/// already paid for the lesson once — the Hindu panchang bug compared a real
/// instant against wall-clock time and cost a day of debugging. So nothing
/// here ever converts a day to an instant: days are `yyyy-MM-dd` strings,
/// compared as strings (ISO dates sort correctly) and stepped with
/// `DateTime(y, m, d - n)`, which Dart normalises and which cannot be
/// shifted by a DST transition the way `subtract(Duration(days: 1))` can.
///
/// ## `deriveStreak` and `PracticeStreak` were removed here — Task 1.12
///
/// They counted **days with any logged activity**. The retention engine
/// counts **goal-met days** (§2.5). Those are two different measurements of
/// the same word, and until Task 1.12 the app computed both: this one for
/// Islam, and `PujaStats.currentStreak` — the server's own any-activity
/// count — for Hindu. Wiring `/today` without removing them would have put
/// two different streak numbers on one screen, which does not read as a
/// discrepancy to a user. It reads as the app not knowing, about the single
/// number the whole feature exists to show.
///
/// So they went in the same change that introduced the replacement, not
/// after it. What survives here is the day arithmetic the prayer and puja
/// **log** reads still need for the checklist; the streak's own day
/// stepping lives in `streak_engine.dart`, goes through UTC, and is
/// deliberately not shared with this file — a 25-hour day in Europe/London
/// is a bug in one representation and correct in the other.
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
