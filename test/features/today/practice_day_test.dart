import 'package:faith_mobile/features/today/domain/practice_day.dart';
import 'package:flutter_test/flutter_test.dart';

/// Builds the day-key set for a run of consecutive days ending [daysAgo]
/// days before [today].
Set<String> run({
  required DateTime today,
  required int length,
  int endingDaysAgo = 0,
}) => {
  for (var i = 0; i < length; i++)
    dayKeyOf(shiftDays(today, -(endingDaysAgo + i))),
};

void main() {
  // A fixed "today" everywhere, so a test can never pass or fail because of
  // the day it is run on.
  final today = DateTime(2026, 10, 9, 14, 30);
  final farPast = DateTime(2024, 1, 1);

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
      expect(
        dayKeyOfDateTimeColumn(DateTime.utc(2026, 10, 9)),
        '2026-10-09',
      );
    });
  });

  group('deriveStreak', () {
    test('counts a run that includes today', () {
      final streak = deriveStreak(
        practisedDays: run(today: today, length: 5),
        today: today,
        earliestKnownDay: farPast,
      );
      expect(streak.days, 5);
      expect(streak.isFloor, isFalse);
    });

    test('today not yet practised does not break the run', () {
      // The single most important case. The day is not over; a streak that
      // resets at midnight and un-resets at Fajr would be a bug the user
      // reads as the app losing their history.
      final streak = deriveStreak(
        practisedDays: run(today: today, length: 4, endingDaysAgo: 1),
        today: today,
        earliestKnownDay: farPast,
      );
      expect(streak.days, 4);
    });

    test('a full missed day does break the run', () {
      // Practised up to the day before yesterday, nothing since.
      final streak = deriveStreak(
        practisedDays: run(today: today, length: 6, endingDaysAgo: 2),
        today: today,
        earliestKnownDay: farPast,
      );
      expect(streak.days, 0);
    });

    test('stops at a gap in the middle of history', () {
      final days = <String>{
        dayKeyOf(today),
        dayKeyOf(shiftDays(today, -1)),
        // -2 missing
        dayKeyOf(shiftDays(today, -3)),
        dayKeyOf(shiftDays(today, -4)),
      };
      final streak = deriveStreak(
        practisedDays: days,
        today: today,
        earliestKnownDay: farPast,
      );
      expect(streak.days, 2);
    });

    test('is zero with no history at all', () {
      final streak = deriveStreak(
        practisedDays: const {},
        today: today,
        earliestKnownDay: farPast,
      );
      expect(streak.days, 0);
      expect(streak.isFloor, isFalse);
    });

    test('is zero when only old days were practised', () {
      final streak = deriveStreak(
        practisedDays: run(today: today, length: 10, endingDaysAgo: 30),
        today: today,
        earliestKnownDay: farPast,
      );
      expect(streak.days, 0);
    });

    test('counts a single day practised today', () {
      final streak = deriveStreak(
        practisedDays: {dayKeyOf(today)},
        today: today,
        earliestKnownDay: farPast,
      );
      expect(streak.days, 1);
    });

    test('counts a single day practised yesterday', () {
      final streak = deriveStreak(
        practisedDays: {dayKeyOf(shiftDays(today, -1))},
        today: today,
        earliestKnownDay: farPast,
      );
      expect(streak.days, 1);
    });

    test('runs across a month boundary', () {
      final novFirst = DateTime(2026, 11, 1, 9);
      final streak = deriveStreak(
        practisedDays: run(today: novFirst, length: 4),
        today: novFirst,
        earliestKnownDay: farPast,
      );
      expect(streak.days, 4); // 1 Nov, 31, 30, 29 Oct
    });

    test('runs across a year boundary', () {
      final janSecond = DateTime(2027, 1, 2, 9);
      final streak = deriveStreak(
        practisedDays: run(today: janSecond, length: 5),
        today: janSecond,
        earliestKnownDay: farPast,
      );
      expect(streak.days, 5); // 2, 1 Jan, 31, 30, 29 Dec
    });

    test('runs across a DST transition without dropping a day', () {
      final afterDst = DateTime(2026, 10, 26, 9);
      final streak = deriveStreak(
        practisedDays: run(today: afterDst, length: 4),
        today: afterDst,
        earliestKnownDay: farPast,
      );
      expect(streak.days, 4);
    });

    test('reports a floor when the run reaches the edge of known history', () {
      // Twenty days of data, all of them practised: the real streak may be
      // longer, and the chip must say "20+" rather than claim 20.
      final windowStart = shiftDays(today, -19);
      final streak = deriveStreak(
        practisedDays: run(today: today, length: 20),
        today: today,
        earliestKnownDay: windowStart,
      );
      expect(streak.days, 20);
      expect(streak.isFloor, isTrue);
    });

    test('does not report a floor when the run ends inside known history', () {
      final windowStart = shiftDays(today, -29);
      final streak = deriveStreak(
        practisedDays: run(today: today, length: 20),
        today: today,
        earliestKnownDay: windowStart,
      );
      expect(streak.days, 20);
      expect(streak.isFloor, isFalse);
    });

    test('a zero streak is never a floor', () {
      final streak = deriveStreak(
        practisedDays: run(today: today, length: 3, endingDaysAgo: 5),
        today: today,
        earliestKnownDay: shiftDays(today, -7),
      );
      expect(streak.days, 0);
      expect(streak.isFloor, isFalse);
    });
  });
}
