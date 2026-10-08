import 'dart:developer' as developer;
import 'dart:io' show Platform;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../preferences/notification_preferences.dart';
import '../../features/prayers/data/dtos/prayer_times.dart';
import '../../features/prayers/presentation/controllers/prayer_times_controller.dart';
import 'notification_schedule.dart';

/// Wraps `flutter_local_notifications` for prayer-time reminders.
///
/// Two notifications per enabled prayer when [NotificationPreferences.leadMinutes]
/// > 0: one at `time - leadMinutes` and one at `time`. Past times are skipped
/// silently. The plugin survives app process death (alarms live in the OS),
/// so the user gets reminders without the app open — provided times were
/// scheduled while the app was last opened.
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// Stable channel ID — Android groups all prayer notifications here.
  /// Suffix is bumped whenever the channel sound changes; Android 8+ pins a
  /// channel's sound on first creation, so a new sound needs a new channel.
  static const String _channelId = 'prayer_reminders_v2_softchime';
  static const String _channelName = 'Prayer reminders';
  static const String _channelDesc = 'Reminders before and at each prayer time';

  /// Bundled raw resource (android/app/src/main/res/raw/soft_chime.wav).
  static const _androidSound = RawResourceAndroidNotificationSound(
    'soft_chime',
  );

  bool _initialized = false;

  /// Idempotent. Call once at app start (main).
  Future<void> init() async {
    if (_initialized) return;
    tz_data.initializeTimeZones();
    final localName = DateTime.now().timeZoneName;
    try {
      tz.setLocalLocation(tz.getLocation(_zoneFromName(localName)));
    } on Object {
      // Fall back to UTC if device's IANA name isn't recognized — better
      // than crashing; user will see times slightly off (rare in practice).
      tz.setLocalLocation(tz.UTC);
    }

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );

    if (Platform.isAndroid) {
      await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(
            const AndroidNotificationChannel(
              _channelId,
              _channelName,
              description: _channelDesc,
              importance: Importance.high,
              sound: _androidSound,
              playSound: true,
            ),
          );
    }
    _initialized = true;
  }

  /// Asks the OS for notification permission. Safe to call repeatedly.
  Future<bool> requestPermissions() async {
    if (Platform.isIOS) {
      final ok = await _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      return ok ?? false;
    }
    if (Platform.isAndroid) {
      final ok = await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
      return ok ?? false;
    }
    return false;
  }

  /// Cancels every pending prayer notification and reschedules a rolling
  /// [kScheduleWindowDays]-day window from now.
  ///
  /// Prayer times are computed on-device, so this works with no network. The
  /// window slides forward on every call — the orchestrator calls this on
  /// app resume, which is what keeps it from ever expiring.
  Future<void> rescheduleWindow({
    required double latitude,
    required double longitude,
    required NotificationPreferences prefs,
    required String method,
    String madhab = kDefaultMadhab,
  }) async {
    final now = DateTime.now();

    // Computed before cancelAll: if the maths throws we must not be left
    // having cancelled the user's existing reminders and scheduled nothing.
    final days = safePrayerDaysFor(
      latitude: latitude,
      longitude: longitude,
      from: now,
      days: kScheduleWindowDays,
      method: method,
      madhab: madhab,
    );
    if (days.isEmpty) {
      developer.log(
        'no computable prayer times for $latitude,$longitude — '
        'keeping existing notifications rather than clearing them',
        name: 'notifications',
      );
      return;
    }

    final plan = buildNotificationPlan(days: days, prefs: prefs, now: now);

    await _plugin.cancelAll();
    var accepted = 0;
    for (final entry in plan) {
      final name = kPrayerDisplayNames[entry.prayerKey] ?? entry.prayerKey;
      final ok = await _scheduleOne(
        id: entry.id,
        when: entry.when,
        title: entry.isLead
            ? '$name in ${prefs.leadMinutes} min'
            : '$name — time for prayer',
        body: entry.isLead
            ? '$name prayer at ${_clock(entry.when.add(Duration(minutes: prefs.leadMinutes)))} — get ready.'
            : 'It is now time to pray $name.',
      );
      if (ok) accepted++;
    }

    // Counts what the OS took, not what we planned: on Android an ungranted
    // exact-alarm permission rejects every call, and reporting the plan size
    // would make a total failure read as a success.
    developer.log(
      'scheduled $accepted/${plan.length} notifications '
      'across ${days.length} days',
      name: 'notifications',
    );
  }

  /// Compatibility shim for the old today-only API. Now schedules the full
  /// window, taking coordinates from [times] and assuming the default
  /// calculation method — call [rescheduleWindow] directly to pass the
  /// user's own method.
  @Deprecated(
    'Only today was ever scheduled, so reminders stopped the moment the app '
    'went unopened for a day. Use rescheduleWindow. Removed next release.',
  )
  Future<void> rescheduleForToday(
    PrayerTimes times,
    NotificationPreferences prefs,
  ) async {
    // PrayerTimes.fromJson falls back to 0 for a missing location echo, and
    // (0, 0) is the Gulf of Guinea — scheduling there is worse than not
    // scheduling, because the user sees reminders at plausible-looking but
    // wrong times.
    if (times.latitude == 0 && times.longitude == 0) {
      developer.log(
        'rescheduleForToday: no location on the prayer-times payload',
        name: 'notifications',
      );
      return;
    }
    await rescheduleWindow(
      latitude: times.latitude,
      longitude: times.longitude,
      prefs: prefs,
      method: CalcMethod.fallbackCode,
    );
  }

  Future<void> cancelAll() => _plugin.cancelAll();

  /// Fires a one-off notification ~5 seconds from now. Used by the Settings
  /// "Send test notification" tile to verify the OS permission grant +
  /// channel + scheduling pipeline end-to-end.
  ///
  /// Rethrows on failure so the caller can surface the real error to the
  /// user — silent failure here makes the feature look broken when it's
  /// usually a permission/exact-alarm issue.
  Future<void> sendTest() async {
    final when = DateTime.now().add(const Duration(seconds: 5));
    await _plugin.zonedSchedule(
      999,
      'Faith — test reminder',
      'Notifications are wired correctly.',
      tz.TZDateTime.from(when, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDesc,
          importance: Importance.high,
          priority: Priority.high,
          category: AndroidNotificationCategory.reminder,
          sound: _androidSound,
          playSound: true,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// Returns whether the OS accepted the schedule. Failures are logged, not
  /// thrown — one rejected alarm must not abort the rest of the window — but
  /// the caller needs the count, because a silent 0/60 is the bug this whole
  /// task exists to catch.
  Future<bool> _scheduleOne({
    required int id,
    required DateTime when,
    required String title,
    required String body,
  }) async {
    try {
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(when, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: _channelDesc,
            importance: Importance.high,
            priority: Priority.high,
            category: AndroidNotificationCategory.reminder,
            sound: _androidSound,
            playSound: true,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
      return true;
    } on Object catch (e, st) {
      developer.log(
        'scheduleOne failed for id=$id at=$when',
        name: 'notifications',
        error: e,
        stackTrace: st,
      );
      return false;
    }
  }

  static String _clock(DateTime t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  /// Maps the device's short timezone name (e.g. "IST", "PDT") to an IANA
  /// location the timezone package recognizes. Falls back to the input,
  /// which the package may also accept; if not, the caller catches.
  static String _zoneFromName(String name) {
    return switch (name) {
      'IST' => 'Asia/Kolkata',
      'PST' || 'PDT' => 'America/Los_Angeles',
      'EST' || 'EDT' => 'America/New_York',
      'CST' || 'CDT' => 'America/Chicago',
      'MST' || 'MDT' => 'America/Denver',
      'GMT' || 'BST' => 'Europe/London',
      'CET' || 'CEST' => 'Europe/Paris',
      'JST' => 'Asia/Tokyo',
      'AEST' || 'AEDT' => 'Australia/Sydney',
      _ => name,
    };
  }
}
