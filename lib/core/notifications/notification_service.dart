import 'dart:developer' as developer;
import 'dart:io' show Platform;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../preferences/notification_preferences.dart';
import '../time/timezone_names.dart';
import '../../features/prayers/data/dtos/prayer_times.dart';
import '../../features/prayers/presentation/controllers/prayer_times_controller.dart';
import 'exact_alarm_policy.dart';
import 'notification_schedule.dart';

part 'notification_service.g.dart';

/// How the Settings "Send test notification" tile actually delivered.
enum TestNotificationOutcome {
  /// Exact alarms are permitted — the test will arrive in about 5 seconds.
  scheduled,

  /// Exact alarms are denied, so the test was posted immediately rather than
  /// handed to Android's inexact alarm batcher, which would have delayed it
  /// past the point of being a useful diagnostic.
  shownImmediately,
}

/// The slice of [NotificationService] that [NotificationOrchestrator]
/// drives. Narrow on purpose: it exists so the orchestrator's scheduling
/// decisions can be asserted without a platform channel, and widening it
/// would start pulling plugin behaviour into those tests.
abstract class PrayerNotificationSink {
  Future<void> rescheduleWindow({
    required double latitude,
    required double longitude,
    required NotificationPreferences prefs,
    required String method,
    required String madhab,
  });

  Future<void> cancelAll();
}

/// Wraps `flutter_local_notifications` for prayer-time reminders.
///
/// Two notifications per enabled prayer when [NotificationPreferences.leadMinutes]
/// > 0: one at `time - leadMinutes` and one at `time`. Past times are skipped
/// silently. The plugin survives app process death (alarms live in the OS),
/// so the user gets reminders without the app open — provided times were
/// scheduled while the app was last opened.
class NotificationService implements PrayerNotificationSink {
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

  /// Whether the OS will accept exact alarms from this app right now.
  ///
  /// Android 12+ gates `SCHEDULE_EXACT_ALARM` behind a user toggle in system
  /// settings, and Android 14+ leaves it **off** on a fresh install. Reading
  /// it costs a platform-channel round trip, so callers resolve it once per
  /// scheduling pass rather than once per notification.
  ///
  /// Non-Android platforms have no such concept and answer `true`; so does a
  /// failed check, deliberately — an optimistic start costs at most one
  /// rejected alarm before [ExactAlarmPolicy.downgrade] takes over, whereas a
  /// pessimistic one would permanently demote a user who actually granted it.
  Future<bool> canScheduleExactAlarms() async {
    if (!Platform.isAndroid) return true;
    try {
      final can = await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.canScheduleExactNotifications();
      return can ?? true;
    } on Object catch (e, st) {
      developer.log(
        'exact-alarm capability check failed — assuming permitted',
        name: 'notifications',
        error: e,
        stackTrace: st,
      );
      return true;
    }
  }

  /// Sends the user to Android's "Alarms & reminders" settings page so they
  /// can grant `SCHEDULE_EXACT_ALARM`. Returns whether the intent launched.
  ///
  /// This is a settings *intent*, not a runtime permission dialog: it can be
  /// shown as often as the user asks for it and there is no permanent-denial
  /// state to burn — unlike the `POST_NOTIFICATIONS` prompt that
  /// `PermissionGate` exists to ration. Call it only from an explicit user
  /// tap all the same; yanking someone into system settings unasked is its
  /// own kind of hostile.
  Future<bool> openExactAlarmSettings() async {
    if (!Platform.isAndroid) return false;
    try {
      final ok = await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestExactAlarmsPermission();
      return ok ?? false;
    } on Object catch (e, st) {
      developer.log(
        'could not open exact-alarm settings',
        name: 'notifications',
        error: e,
        stackTrace: st,
      );
      return false;
    }
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
  @override
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

    // Resolved once for the whole pass. Asking per notification would be
    // sixty platform-channel round trips on the app's hottest path.
    final policy = ExactAlarmPolicy.fromCapability(
      canScheduleExact: await canScheduleExactAlarms(),
    );
    final startedExact = policy.isExact;

    await _plugin.cancelAll();
    var accepted = 0;
    for (final entry in plan) {
      final name = kPrayerDisplayNames[entry.prayerKey] ?? entry.prayerKey;
      final title = entry.isLead
          ? '$name in ${prefs.leadMinutes} min'
          : '$name — time for prayer';
      final body = entry.isLead
          ? '$name prayer at ${_clock(entry.when.add(Duration(minutes: prefs.leadMinutes)))} — get ready.'
          : 'It is now time to pray $name.';

      var ok = await _scheduleOne(
        id: entry.id,
        when: entry.when,
        title: title,
        body: body,
        mode: policy.mode,
      );
      // An exact alarm the OS refuses is retried inexact — and every later
      // entry in this pass goes straight to inexact, so the refusal costs
      // one wasted call rather than sixty.
      if (!ok && policy.downgrade()) {
        ok = await _scheduleOne(
          id: entry.id,
          when: entry.when,
          title: title,
          body: body,
          mode: policy.mode,
        );
      }
      if (ok) accepted++;
    }

    // Counts what the OS took, not what we planned: a total failure must not
    // be able to read as a success in the logs.
    developer.log(
      'scheduled $accepted/${plan.length} notifications '
      'across ${days.length} days '
      '(${policy.isExact ? 'exact' : 'inexact'}'
      '${startedExact && !policy.isExact ? ', downgraded mid-pass' : ''})',
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

  @override
  Future<void> cancelAll() => _plugin.cancelAll();

  /// Fires a one-off test notification. Used by the Settings "Send test
  /// notification" tile to verify the OS permission grant + channel +
  /// delivery pipeline end-to-end.
  ///
  /// Rethrows on failure so the caller can surface the real error to the
  /// user — silent failure here makes the feature look broken when it's
  /// usually a permission issue.
  Future<TestNotificationOutcome> sendTest() async {
    // Without exact-alarm permission a +5s alarm is the one case where
    // degrading gracefully is *not* graceful: Android batches inexact alarms
    // and would deliver this minutes later or not at all, making the
    // diagnostic tile look broken exactly when the user is diagnosing. Post
    // it immediately instead — the tile's job is to prove the channel and
    // the permission work, and an immediate post proves both.
    if (!await canScheduleExactAlarms()) {
      await _plugin.show(
        _testNotificationId,
        'Siraat — test reminder',
        'Notifications are wired correctly.',
        _details,
      );
      return TestNotificationOutcome.shownImmediately;
    }

    final when = DateTime.now().add(const Duration(seconds: 5));
    await _plugin.zonedSchedule(
      _testNotificationId,
      'Siraat — test reminder',
      'Notifications are wired correctly.',
      tz.TZDateTime.from(when, tz.local),
      _details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
    return TestNotificationOutcome.scheduled;
  }

  /// Outside the prayer-notification ID space allocated by
  /// `buildNotificationPlan`, so a test never evicts a real reminder.
  static const int _testNotificationId = 999;

  /// Returns whether the OS accepted the schedule. Failures are logged, not
  /// thrown — one rejected alarm must not abort the rest of the window — but
  /// the caller needs the count, because a silent 0/60 is the bug this whole
  /// task exists to catch.
  Future<bool> _scheduleOne({
    required int id,
    required DateTime when,
    required String title,
    required String body,
    required AndroidScheduleMode mode,
  }) async {
    try {
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(when, tz.local),
        _details,
        androidScheduleMode: mode,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
      return true;
    } on Object catch (e, st) {
      developer.log(
        'scheduleOne failed for id=$id at=$when mode=${mode.name}',
        name: 'notifications',
        error: e,
        stackTrace: st,
      );
      return false;
    }
  }

  static const NotificationDetails _details = NotificationDetails(
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
  );

  static String _clock(DateTime t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  /// Maps the device's short timezone name (e.g. "IST", "PDT") to an IANA
  /// location the timezone package recognizes.
  ///
  /// Falls back to the input, which the package may also accept — plenty of
  /// devices report `Asia/Kolkata` directly — and if it does not,
  /// `getLocation` throws and [init] settles for UTC. That tolerance is
  /// why this path can share [ianaForAbbreviation]'s table with the
  /// activity queue, which cannot afford the same fallback: a wrong guess
  /// here is a mis-timed reminder, while there it is an event the server
  /// rejects forever. The table is shared; the fallback is not.
  static String _zoneFromName(String name) => ianaForAbbreviation(name) ?? name;
}

@Riverpod(keepAlive: true)
PrayerNotificationSink prayerNotificationSink(Ref ref) =>
    NotificationService.instance;

/// Whether the OS currently lets the app set exact alarms.
///
/// Auto-disposing and deliberately uncached across screens: the user can
/// flip this in system settings at any moment, so the Settings screen reads
/// it fresh and invalidates it after sending them there.
@riverpod
Future<bool> exactAlarmsAllowed(Ref ref) =>
    NotificationService.instance.canScheduleExactAlarms();
