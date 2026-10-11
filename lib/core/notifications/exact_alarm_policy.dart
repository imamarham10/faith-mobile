import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Picks the Android alarm precision for a reschedule pass, and degrades it
/// once if the OS turns out to disagree.
///
/// ## Why this exists
///
/// The app used to declare `USE_EXACT_ALARM` alongside `SCHEDULE_EXACT_ALARM`.
/// `USE_EXACT_ALARM` is install-granted and makes
/// `AlarmManager.canScheduleExactAlarms()` return true unconditionally, so
/// the exact branch was always taken and nothing here was needed. Google
/// restricts that permission to apps whose *core function* is an alarm clock
/// or calendar; a prayer-reminder app does not qualify and is directed to
/// `SCHEDULE_EXACT_ALARM`, which on Android 14+ is **denied by default** for
/// a fresh install.
///
/// With only `SCHEDULE_EXACT_ALARM`, and it ungranted,
/// `AndroidScheduleMode.exactAllowWhileIdle` makes the plugin throw
/// `ExactAlarmPermissionException` on *every* call. The scheduling loop
/// catches per-notification failures, so the user's visible symptom would be
/// a silent 0-of-60: no crash, no error, no reminders. That is the worst
/// possible outcome for the app's most-used feature.
///
/// ## The policy
///
/// A prayer reminder a few minutes late beats no reminder at all, so a denied
/// exact-alarm permission degrades to [AndroidScheduleMode.inexactAllowWhileIdle]
/// rather than failing. `allowWhileIdle` is kept in both modes — it is what
/// lets an alarm fire through Doze, and it needs no permission. The cost is
/// precision, not a dropped notification.
///
/// How much precision is lost is the OEM's business, not ours. On the OnePlus
/// 9R used for QA (OxygenOS, Android 14), `dumpsys alarm` reports a one-hour
/// `windowLength` on this app's alarms in *both* modes — the platform relaxes
/// third-party `setExactAndAllowWhileIdle` calls regardless of the permission.
/// Stock Android honours the distinction. Either way the contract this class
/// enforces is the one that matters: every planned reminder is accepted by
/// the OS, in both modes.
///
/// ## Two independent signals
///
/// [ExactAlarmPolicy.fromCapability] reads the capability up front — one
/// platform-channel round trip per reschedule, not one per notification.
/// [downgrade] covers the case where that answer was wrong or went stale
/// between the check and the write (the user can revoke exact-alarm access
/// in system settings while the app is running). The first rejected alarm
/// flips the whole remaining pass to inexact, so one wasted call is the
/// entire cost of being optimistic.
class ExactAlarmPolicy {
  ExactAlarmPolicy._(this._mode);

  /// Starts exact when the OS says exact alarms are permitted.
  factory ExactAlarmPolicy.fromCapability({required bool canScheduleExact}) =>
      ExactAlarmPolicy._(
        canScheduleExact
            ? AndroidScheduleMode.exactAllowWhileIdle
            : AndroidScheduleMode.inexactAllowWhileIdle,
      );

  AndroidScheduleMode _mode;

  /// The mode to pass to the next `zonedSchedule` call.
  AndroidScheduleMode get mode => _mode;

  /// Whether alarms are still being written at exact precision.
  bool get isExact => _mode == AndroidScheduleMode.exactAllowWhileIdle;

  /// Call after a rejected schedule. Returns whether the caller should retry
  /// that same notification at the new, lower precision.
  ///
  /// Returns `false` once already inexact — a failure there is a real failure
  /// (invalid time, dead plugin) and retrying it forever would turn one bad
  /// entry into an infinite loop.
  bool downgrade() {
    if (!isExact) return false;
    _mode = AndroidScheduleMode.inexactAllowWhileIdle;
    return true;
  }
}
