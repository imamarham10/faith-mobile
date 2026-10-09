import 'package:faith_mobile/features/today/domain/practice_day.dart';
import 'package:flutter_test/flutter_test.dart';

/// Day arithmetic only.
///
/// The `deriveStreak` suite that used to live here went with the function
/// in Task 1.12 — it counted days with *any* activity, where the retention
/// engine counts goal-met days, and shipping both put two different streak
/// numbers on one screen. Its replacement's cases live in
/// `test/shared/habit/streak_engine_test.dart`, ported from the server's
/// own spec so the two implementations cannot drift.
void main() {
  group('dayKeyOf', () {
    test('zero-pads to a sortable ISO date', () {
      expect(dayKeyOf(DateTime(2026, 1, 2)), '2026-01-02');
      expect(dayKeyOf(DateTime(2026, 12, 31)), '2026-12-31');
    });

    test('ignores the time of day', () {
      expect(
        dayKeyOf(DateTime(2026, 10, 9, 0, 0, 1)),
        dayKeyOf(DateTime(2026, 10, 9, 23, 59, 59)),
      );
    });
  });

  group('shiftDays', () {
    test('normalises across a month boundary', () {
      expect(dayKeyOf(shiftDays(DateTime(2026, 3, 1), -1)), '2026-02-28');
      expect(dayKeyOf(shiftDays(DateTime(2026, 10, 31), 1)), '2026-11-01');
    });

    test('normalises across a year boundary', () {
      expect(dayKeyOf(shiftDays(DateTime(2027, 1, 1), -1)), '2026-12-31');
    });

    test('handles a leap day', () {
      expect(dayKeyOf(shiftDays(DateTime(2028, 3, 1), -1)), '2028-02-29');
    });

    test('steps one calendar day across a DST transition', () {
      // 29 March 2026 is when most of Europe loses an hour. A
      // `subtract(Duration(days: 1))` from a midnight on that day lands on
      // 23:00 the previous day in such a zone, and would key the wrong day;
      // wall-clock construction cannot.
      expect(dayKeyOf(shiftDays(DateTime(2026, 3, 29), -1)), '2026-03-28');
      expect(dayKeyOf(shiftDays(DateTime(2026, 10, 25), -1)), '2026-10-24');
    });
  });

  group('dayKeyOfDateColumn', () {
    test('takes the stored calendar date, not a converted instant', () {
      // Postgres `@db.Date` serialises as midnight UTC. Parsing and calling
      // toLocal() would land on the 8th for anyone west of UTC.
      expect(dayKeyOfDateColumn('2026-10-09T00:00:00.000Z'), '2026-10-09');
    });

    test('passes a bare date through', () {
      expect(dayKeyOfDateColumn('2026-10-09'), '2026-10-09');
    });
  });

  group('dayKeyOfDateTimeColumn', () {
    test('reads the UTC components of a date column', () {
      expect(dayKeyOfDateTimeColumn(DateTime.utc(2026, 10, 9)), '2026-10-09');
    });
  });
}
