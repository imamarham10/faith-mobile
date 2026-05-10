import 'dart:developer' as developer;
import 'dart:io' show Platform;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../preferences/notification_preferences.dart';
import '../../features/prayers/data/dtos/prayer_times.dart';

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

  /// Cancels all previously-scheduled prayer notifications and reschedules
  /// today's enabled ones.
  Future<void> rescheduleForToday(
    PrayerTimes times,
    NotificationPreferences prefs,
  ) async {
    await _plugin.cancelAll();

    final now = DateTime.now();
    for (final entry in times.entries) {
      if (!entry.isPrayer) continue; // skip Sunrise
      if (!prefs.isEnabledFor(entry.key)) continue;

      final at = entry.time;
      // At-time notification
      if (at.isAfter(now)) {
        await _scheduleOne(
          id: _idFor(entry.key, lead: false),
          when: at,
          title: '${entry.displayName} — time for prayer',
          body: 'It is now time to pray ${entry.displayName}.',
        );
      }
      // Lead-time notification
      if (prefs.leadMinutes > 0) {
        final lead = at.subtract(Duration(minutes: prefs.leadMinutes));
        if (lead.isAfter(now)) {
          await _scheduleOne(
            id: _idFor(entry.key, lead: true),
            when: lead,
            title: '${entry.displayName} in ${prefs.leadMinutes} min',
            body:
                '${entry.displayName} prayer at ${_clock(at)} '
                '— get ready.',
          );
        }
      }
    }
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

  Future<void> _scheduleOne({
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
    } on Object catch (e, st) {
      developer.log(
        'scheduleOne failed for id=$id at=$when',
        error: e,
        stackTrace: st,
      );
    }
  }

  /// Stable per-prayer ID so repeat reschedules overwrite cleanly.
  /// Ranges: 100..104 = at-time; 200..204 = lead-time.
  static int _idFor(String key, {required bool lead}) {
    final base = lead ? 200 : 100;
    return base +
        switch (key) {
          'fajr' => 0,
          'dhuhr' => 1,
          'asr' => 2,
          'maghrib' => 3,
          'isha' => 4,
          _ => 9,
        };
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
