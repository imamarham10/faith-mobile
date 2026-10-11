import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:faith_mobile/core/notifications/exact_alarm_policy.dart';

/// These encode the Play-policy consequence of dropping `USE_EXACT_ALARM`:
/// with only `SCHEDULE_EXACT_ALARM`, Android 14+ denies exact alarms on a
/// fresh install, and a prayer reminder that degrades to "a few minutes
/// late" is the required outcome. Silence is not.
void main() {
  group('ExactAlarmPolicy.fromCapability', () {
    test('schedules exactly when the OS permits exact alarms', () {
      final policy = ExactAlarmPolicy.fromCapability(canScheduleExact: true);

      expect(policy.isExact, isTrue);
      expect(policy.mode, AndroidScheduleMode.exactAllowWhileIdle);
    });

    test('falls back to inexact — never to not scheduling — when denied', () {
      final policy = ExactAlarmPolicy.fromCapability(canScheduleExact: false);

      expect(policy.isExact, isFalse);
      expect(policy.mode, AndroidScheduleMode.inexactAllowWhileIdle);
    });

    test('keeps allowWhileIdle in both modes so Doze cannot swallow a '
        'reminder', () {
      for (final can in [true, false]) {
        final mode = ExactAlarmPolicy.fromCapability(
          canScheduleExact: can,
        ).mode;
        expect(
          mode,
          anyOf(
            AndroidScheduleMode.exactAllowWhileIdle,
            AndroidScheduleMode.inexactAllowWhileIdle,
          ),
          reason: 'allowWhileIdle needs no permission and is what lets an '
              'alarm fire through Doze',
        );
      }
    });
  });

  group('downgrade', () {
    test('drops an exact policy to inexact and asks for a retry', () {
      final policy = ExactAlarmPolicy.fromCapability(canScheduleExact: true);

      expect(policy.downgrade(), isTrue, reason: 'retry this entry inexact');
      expect(policy.mode, AndroidScheduleMode.inexactAllowWhileIdle);
    });

    test('is sticky: every later entry in the pass goes straight to inexact', () {
      final policy = ExactAlarmPolicy.fromCapability(canScheduleExact: true);
      policy.downgrade();

      expect(policy.isExact, isFalse);
      expect(policy.mode, AndroidScheduleMode.inexactAllowWhileIdle);
    });

    test('refuses a second downgrade, so one bad entry cannot loop forever', () {
      final policy = ExactAlarmPolicy.fromCapability(canScheduleExact: true);
      policy.downgrade();

      expect(policy.downgrade(), isFalse);
    });

    test('an already-inexact policy never asks for a retry', () {
      final policy = ExactAlarmPolicy.fromCapability(canScheduleExact: false);

      expect(policy.downgrade(), isFalse);
      expect(policy.mode, AndroidScheduleMode.inexactAllowWhileIdle);
    });
  });

  group('the whole-window contract', () {
    test('a denied permission still produces a mode for every notification', () {
      // The failure this guards against is the real one observed on device:
      // exact mode + no permission meant zero of sixty alarms were accepted
      // and the user got no reminders at all, silently.
      final policy = ExactAlarmPolicy.fromCapability(canScheduleExact: false);
      final modes = [for (var i = 0; i < 60; i++) policy.mode];

      expect(modes, hasLength(60));
      expect(
        modes.every((m) => m == AndroidScheduleMode.inexactAllowWhileIdle),
        isTrue,
      );
    });

    test('a mid-pass revocation costs exactly one retry, not sixty', () {
      final policy = ExactAlarmPolicy.fromCapability(canScheduleExact: true);
      var retries = 0;

      for (var i = 0; i < 60; i++) {
        // Simulate the OS rejecting every exact write from entry 0 onwards.
        final accepted = !policy.isExact;
        if (!accepted && policy.downgrade()) retries++;
      }

      expect(retries, 1);
      expect(policy.mode, AndroidScheduleMode.inexactAllowWhileIdle);
    });
  });
}
