import 'package:faith_mobile/core/notifications/notification_schedule.dart';
import 'package:faith_mobile/core/preferences/notification_preferences.dart';
import 'package:faith_mobile/core/prayer/local_prayer_times.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final days = LocalPrayerTimes.forRange(
    latitude: 12.9716,
    longitude: 77.5946,
    from: DateTime(2026, 10, 8),
    days: 6,
    method: 'MWL',
    madhab: 'shafi',
  );

  test('never exceeds the iOS 64-notification ceiling', () {
    final plan = buildNotificationPlan(
      days: days,
      prefs: const NotificationPreferences(leadMinutes: 15),
      now: DateTime(2026, 10, 8, 0, 1),
    );
    expect(plan.length, lessThanOrEqualTo(64));
  });

  test('skips times already in the past', () {
    final plan = buildNotificationPlan(
      days: days,
      prefs: const NotificationPreferences(leadMinutes: 0),
      now: DateTime(2026, 10, 8, 23, 59),
    );
    expect(
      plan.every((e) => e.when.isAfter(DateTime(2026, 10, 8, 23, 59))),
      isTrue,
    );
    expect(
      plan.any((e) => e.when.day == 9),
      isTrue,
      reason: 'late on day 1 we should still hold future days',
    );
  });

  test('allocates unique ids so later days do not overwrite earlier ones', () {
    final plan = buildNotificationPlan(
      days: days,
      prefs: const NotificationPreferences(leadMinutes: 15),
      now: DateTime(2026, 10, 8, 0, 1),
    );
    expect(plan.map((e) => e.id).toSet().length, plan.length);
  });

  test('lead notifications disappear when leadMinutes is 0', () {
    final plan = buildNotificationPlan(
      days: days,
      prefs: const NotificationPreferences(leadMinutes: 0),
      now: DateTime(2026, 10, 8, 0, 1),
    );
    expect(plan.every((e) => !e.isLead), isTrue);
  });

  extra();
}

// --- Added beyond the task spec: the cases the four tests above cannot see.

void extra() {
  group('polar latitudes', () {
    test('a fully-dark window degrades to empty instead of throwing', () {
      // adhan throws ArgumentError (infinite/NaN) for Tromso in December
      // under every HighLatitudeRule. forRange builds all days in one
      // List.generate, so one bad day would take the whole window with it.
      late List<LocalPrayerDay> days;
      expect(
        () => days = safePrayerDaysFor(
          latitude: 69.6492,
          longitude: 18.9553,
          from: DateTime(2026, 12, 15),
          days: kScheduleWindowDays,
          method: 'MWL',
          madhab: kDefaultMadhab,
        ),
        returnsNormally,
      );
      expect(days, isEmpty);

      final plan = buildNotificationPlan(
        days: days,
        prefs: const NotificationPreferences(),
        now: DateTime(2026, 12, 15, 0, 1),
      );
      expect(plan, isEmpty, reason: 'no times means no reminders, not a crash');
    });

    test('a computable polar window still schedules in full', () {
      // Same coordinates in October compute fine — the failure is seasonal,
      // so we must not blanket-disable high latitudes.
      final days = safePrayerDaysFor(
        latitude: 69.6492,
        longitude: 18.9553,
        from: DateTime(2026, 10, 8),
        days: kScheduleWindowDays,
        method: 'MWL',
        madhab: kDefaultMadhab,
      );
      expect(days, hasLength(kScheduleWindowDays));

      final plan = buildNotificationPlan(
        days: days,
        prefs: const NotificationPreferences(leadMinutes: 15),
        now: DateTime(2026, 10, 8, 0, 1),
      );
      expect(plan, hasLength(60));
      expect(plan.map((e) => e.id).toSet(), hasLength(plan.length));
    });

    test('Isha past midnight is kept, and judged on its own time', () {
      // Tromso 8 Oct: Isha falls at 00:17 on the 9th. A day-level date
      // filter would drop it; a per-entry one keeps it.
      final days = safePrayerDaysFor(
        latitude: 69.6492,
        longitude: 18.9553,
        from: DateTime(2026, 10, 8),
        days: 1,
        method: 'MWL',
        madhab: kDefaultMadhab,
      );
      final plan = buildNotificationPlan(
        days: days,
        prefs: const NotificationPreferences(leadMinutes: 0),
        now: DateTime(2026, 10, 8, 22, 0),
      );
      expect(plan, hasLength(1));
      expect(plan.single.prayerKey, 'isha');
      expect(plan.single.when.day, 9);
    });
  });

  group('planner rules', () {
    final days = LocalPrayerTimes.forRange(
      latitude: 12.9716,
      longitude: 77.5946,
      from: DateTime(2026, 10, 8),
      days: kScheduleWindowDays,
      method: 'MWL',
      madhab: kDefaultMadhab,
    );

    test('a disabled prayer is never scheduled', () {
      final plan = buildNotificationPlan(
        days: days,
        prefs: const NotificationPreferences(fajr: false, leadMinutes: 15),
        now: DateTime(2026, 10, 8, 0, 1),
      );
      expect(plan.any((e) => e.prayerKey == 'fajr'), isFalse);
      expect(plan, hasLength(48), reason: '6 days x 4 prayers x 2');
    });

    test('schedules the whole six-day window, not just today', () {
      final plan = buildNotificationPlan(
        days: days,
        prefs: const NotificationPreferences(leadMinutes: 15),
        now: DateTime(2026, 10, 8, 0, 1),
      );
      // The bug this task fixes: the old rescheduleForToday produced 10.
      expect(plan, hasLength(60));
      expect(plan.map((e) => e.when.day).toSet(), hasLength(6));
    });

    test('entries come out sorted, soonest first', () {
      final plan = buildNotificationPlan(
        days: days,
        prefs: const NotificationPreferences(leadMinutes: 15),
        now: DateTime(2026, 10, 8, 0, 1),
      );
      for (var i = 1; i < plan.length; i++) {
        expect(plan[i].when.isBefore(plan[i - 1].when), isFalse);
      }
    });

    test('on overflow it keeps the soonest and drops the furthest', () {
      // 12 days x 5 x 2 = 120 candidates, trimmed to the ceiling.
      final wide = LocalPrayerTimes.forRange(
        latitude: 12.9716,
        longitude: 77.5946,
        from: DateTime(2026, 10, 8),
        days: 12,
        method: 'MWL',
        madhab: kDefaultMadhab,
      );
      final plan = buildNotificationPlan(
        days: wide,
        prefs: const NotificationPreferences(leadMinutes: 15),
        now: DateTime(2026, 10, 8, 0, 1),
      );
      expect(plan, hasLength(kMaxPendingNotifications));
      expect(plan.first.when.day, 8, reason: 'tonight survives the trim');
      expect(plan.map((e) => e.id).toSet(), hasLength(plan.length));
    });

    test('ids are stable across rebuilds of the same window', () {
      List<int> idsFor(DateTime now) => buildNotificationPlan(
        days: days,
        prefs: const NotificationPreferences(leadMinutes: 15),
        now: now,
      ).map((e) => e.id).toList();

      // Rescheduling on resume must not renumber surviving entries.
      final first = idsFor(DateTime(2026, 10, 8, 0, 1));
      final later = idsFor(DateTime(2026, 10, 8, 6, 0));
      expect(later.every(first.contains), isTrue);
    });
  });
}
