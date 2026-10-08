import 'dart:developer' as developer;

import '../prayer/local_prayer_times.dart';
import '../preferences/notification_preferences.dart';

/// iOS keeps at most 64 pending local notifications and silently drops the
/// rest — no error, no callback, the tail just never fires. Android has no
/// such cap, but we schedule one window for both platforms.
const int kMaxPendingNotifications = 64;

/// 6 days x 5 prayers x 2 (at-time + lead) = 60, four under the iOS ceiling.
/// Seven days would be 70 and iOS would drop the tail silently.
const int kScheduleWindowDays = 6;

const List<String> kPrayerKeys = ['fajr', 'dhuhr', 'asr', 'maghrib', 'isha'];

/// Asr madhab used for locally-scheduled reminders.
///
/// The app has no madhab setting. The backend's
/// `prayer-calculations.service.ts` defaults `madhab` to `'shafi'` and
/// `PrayersRepository.getTimes` never sends the parameter, so every Asr the
/// user currently *sees* is a Shafi Asr. Scheduling Shafi keeps the reminder
/// consistent with the displayed time; picking Hanafi here would make the
/// notification contradict the screen by one to two hours. Adding a real
/// setting is a separate piece of work.
const String kDefaultMadhab = 'shafi';

/// One pending OS notification: when it fires and what it is for.
class ScheduledNotification {
  const ScheduledNotification({
    required this.id,
    required this.when,
    required this.prayerKey,
    required this.isLead,
  });

  final int id;
  final DateTime when;
  final String prayerKey;
  final bool isLead;
}

/// Stable, collision-free ids. The old `_idFor(key, lead:)` had no day
/// component, so day 2's Fajr overwrote day 1's.
int notificationId({
  required int dayIndex,
  required String prayerKey,
  required bool lead,
}) {
  final slot = kPrayerKeys.indexOf(prayerKey);
  // -1 would produce a negative, colliding id that silently overwrites a
  // real reminder. Callers only ever pass keys from kPrayerKeys.
  assert(slot >= 0, 'unknown prayer key: $prayerKey');
  return 1000 + (dayIndex * 100) + (slot * 2) + (lead ? 1 : 0);
}

/// Decides what to schedule. Pure: no plugin, no clock, no I/O — the rules
/// are where the bugs live, not the `zonedSchedule` call.
///
/// Returns entries sorted by fire time, past times dropped, capped at
/// [kMaxPendingNotifications] keeping the *soonest* — losing tomorrow's
/// reminder is survivable, losing tonight's is not.
List<ScheduledNotification> buildNotificationPlan({
  required List<LocalPrayerDay> days,
  required NotificationPreferences prefs,
  required DateTime now,
}) {
  final plan = <ScheduledNotification>[];

  for (var dayIndex = 0; dayIndex < days.length; dayIndex++) {
    final byKey = days[dayIndex].byKey;

    for (final key in kPrayerKeys) {
      if (!prefs.isEnabledFor(key)) continue;

      final at = byKey[key];
      if (at == null) continue;

      // Filter per entry, never per day: at high latitude Isha routinely
      // lands after midnight, i.e. on the following calendar date.
      if (at.isAfter(now)) {
        plan.add(
          ScheduledNotification(
            id: notificationId(dayIndex: dayIndex, prayerKey: key, lead: false),
            when: at,
            prayerKey: key,
            isLead: false,
          ),
        );
      }

      if (prefs.leadMinutes > 0) {
        final lead = at.subtract(Duration(minutes: prefs.leadMinutes));
        if (lead.isAfter(now)) {
          plan.add(
            ScheduledNotification(
              id: notificationId(dayIndex: dayIndex, prayerKey: key, lead: true),
              when: lead,
              prayerKey: key,
              isLead: true,
            ),
          );
        }
      }
    }
  }

  plan.sort((a, b) => a.when.compareTo(b.when));
  if (plan.length <= kMaxPendingNotifications) return plan;
  return plan.sublist(0, kMaxPendingNotifications);
}

/// Computes the prayer-time window one day at a time, keeping whatever
/// succeeds.
///
/// `adhan` throws `ArgumentError: value should not be infinite or NaN` when
/// the sun never reaches the required depression angle — Tromso (69.65N) in
/// June and December, under every `HighLatitudeRule`. The throw is *seasonal
/// and per-day*, but [LocalPrayerTimes.forRange] builds its days in one
/// `List.generate`, so a single bad day takes the whole window with it and
/// the user gets no reminders at all — precisely the failure this scheduler
/// exists to prevent.
///
/// Calling `forRange` once per day isolates the failure: a window straddling
/// the polar boundary keeps its computable days, and a fully-dark window
/// returns empty rather than throwing.
List<LocalPrayerDay> safePrayerDaysFor({
  required double latitude,
  required double longitude,
  required DateTime from,
  required int days,
  required String method,
  required String madhab,
}) {
  final out = <LocalPrayerDay>[];
  var skipped = 0;

  for (var i = 0; i < days; i++) {
    // Day-overflow in the constructor, matching LocalPrayerTimes: adding a
    // fixed 24h across a DST boundary lands on a neighbouring day.
    final day = DateTime(from.year, from.month, from.day + i);
    try {
      out.addAll(
        LocalPrayerTimes.forRange(
          latitude: latitude,
          longitude: longitude,
          from: day,
          days: 1,
          method: method,
          madhab: madhab,
        ),
      );
    } on Object catch (e) {
      skipped++;
      developer.log(
        'prayer times uncomputable for $day at $latitude,$longitude — skipping',
        name: 'notifications',
        error: e,
      );
    }
  }

  if (skipped > 0) {
    developer.log(
      'scheduling window degraded to ${out.length}/$days days '
      '(extreme latitude: $latitude)',
      name: 'notifications',
    );
  }
  return out;
}

/// Display names for notification copy. Matches `PrayerTimes.entries` so a
/// reminder reads the same as the row the user taps in the app.
const Map<String, String> kPrayerDisplayNames = {
  'fajr': 'Fajr',
  'dhuhr': 'Dhuhr',
  'asr': 'ʿAṣr',
  'maghrib': 'Maghrib',
  'isha': 'ʿIshā',
};
