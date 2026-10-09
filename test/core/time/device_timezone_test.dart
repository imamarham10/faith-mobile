import 'package:faith_mobile/core/time/device_timezone.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Contract §1.5 — the IANA name comes from the device, and the
/// abbreviation table is only what is left when it cannot.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  DeviceTimezone build({
    Future<String> Function()? platform,
    String abbreviation = 'IST',
  }) => DeviceTimezone(
    readPlatformZone: platform ?? () async => 'Asia/Kolkata',
    abbreviation: () => abbreviation,
  );

  group('the platform is the primary source', () {
    test('uses the IANA name the platform reports, verbatim', () async {
      final tz = build(platform: () async => 'Europe/London');
      await tz.refresh();

      expect(tz.isResolved, isTrue);
      expect(tz.current, 'Europe/London');
    });

    test('passes a tz alias through rather than rewriting it', () async {
      // Android still reports `Asia/Calcutta` and `US/Pacific` on plenty of
      // devices. The server validates with `Intl.DateTimeFormat`, which
      // knows every tz backward link, so both are legal on the wire and
      // "correcting" them here could only introduce an error.
      for (final alias in ['Asia/Calcutta', 'US/Pacific']) {
        final tz = build(platform: () async => alias);
        await tz.refresh();
        expect(tz.current, alias);
      }
    });

    test('beats the abbreviation table where the table has to guess', () async {
      // The bug this file exists to fix. `CST` is US Central, China
      // Standard and Cuba Standard; the shared table resolves it to the
      // most populous, so a user in Chongqing used to be stored in
      // Chicago — and §2.8 would then close their day eleven hours early.
      final guessed = build(
        platform: () async => throw StateError('no platform'),
        abbreviation: 'CST',
      );
      await guessed.refresh();
      expect(guessed.current, 'America/Chicago');

      final read = build(platform: () async => 'Asia/Shanghai');
      await read.refresh();
      expect(read.current, 'Asia/Shanghai');
    });
  });

  group('the abbreviation table is only the fallback', () {
    test('is what `current` answers before the platform has replied', () {
      final tz = build(abbreviation: 'PKT');

      expect(tz.isResolved, isFalse);
      expect(tz.current, 'Asia/Karachi');
    });

    test('still stands when the platform call fails, without throwing', () async {
      final tz = build(
        platform: () async => throw StateError('MissingPluginException'),
        abbreviation: 'WIB',
      );

      await expectLater(tz.refresh(), completes);
      expect(tz.isResolved, isFalse);
      expect(tz.current, 'Asia/Jakarta');
    });

    test('is live, so an unresolved reader follows the device clock', () {
      var abbreviation = 'IST';
      final tz = DeviceTimezone(
        readPlatformZone: () async => throw StateError('no platform'),
        abbreviation: () => abbreviation,
      );

      expect(tz.current, 'Asia/Kolkata');
      abbreviation = 'GST';
      expect(tz.current, 'Asia/Dubai');
    });
  });

  group('GMT does not relocate the user to London', () {
    // The collision Task 1.9 pinned. `ianaByAbbreviation` maps `GMT` to
    // `Europe/London` because the notification scheduler needs a
    // *location*; §1.5 accepts `GMT` verbatim on the wire. Both paths into
    // this class must come out as `GMT`.
    test('when the platform reports it', () async {
      final tz = build(platform: () async => 'GMT');
      await tz.refresh();

      expect(tz.current, 'GMT');
    });

    test('when only the abbreviation is available', () {
      expect(build(abbreviation: 'GMT').current, 'GMT');
      expect(build(abbreviation: 'gmt').current, 'GMT');
    });
  });

  group('the platform answer is still normalised (§1.5)', () {
    test('degrades a fixed offset to UTC rather than queueing it', () async {
      // An Android device with no region configured can report `GMT+05:30`
      // from `TimeZone.getDefault().getID()`. §4.5 rejects that shape
      // permanently, so the queue row would die however often it retried.
      final tz = build(platform: () async => 'GMT+05:30');
      await tz.refresh();

      expect(tz.current, 'UTC');
    });

    test('degrades an empty answer to UTC', () async {
      final tz = build(platform: () async => '   ');
      await tz.refresh();

      expect(tz.current, 'UTC');
    });
  });

  group('the real platform call', () {
    test('a default-constructed reader survives having no plugin', () async {
      // Every other case here injects `readPlatformZone`. This one does
      // not: it runs the real `FlutterTimezone.getLocalTimezone()` against
      // the test binding, where no plugin is registered and the channel
      // answers null. That must come back as the abbreviation fallback,
      // not as a throw — a throw would surface at Task 1.12's first call
      // site, inside a tap handler, which is the one place `record()`
      // promises never to fail from.
      final tz = DeviceTimezone(abbreviation: () => 'IST');

      await expectLater(tz.refresh(), completes);

      expect(tz.isResolved, isFalse);
      expect(tz.current, 'Asia/Kolkata');
    });
  });

  group('staleness', () {
    test('re-reads on resume, so a flight lands in the new zone', () async {
      var zone = 'Asia/Kolkata';
      final tz = DeviceTimezone(
        readPlatformZone: () async => zone,
        abbreviation: () => 'IST',
      );
      await tz.start();
      addTearDown(tz.stop);
      expect(tz.current, 'Asia/Kolkata');

      zone = 'Europe/London';
      tz.didChangeAppLifecycleState(AppLifecycleState.resumed);
      await Future<void>.delayed(Duration.zero);

      expect(tz.current, 'Europe/London');
    });

    test('keeps the last good answer when a later read fails', () async {
      var fail = false;
      final tz = DeviceTimezone(
        readPlatformZone: () async {
          if (fail) throw StateError('transient');
          return 'Europe/London';
        },
        abbreviation: () => 'IST',
      );
      await tz.refresh();

      fail = true;
      await tz.refresh();

      // Not 'Asia/Kolkata' — dropping back to the guess would be a
      // regression the user never caused.
      expect(tz.current, 'Europe/London');
    });

    test('ignores lifecycle states other than resumed', () async {
      var reads = 0;
      final tz = DeviceTimezone(
        readPlatformZone: () async {
          reads += 1;
          return 'Asia/Kolkata';
        },
        abbreviation: () => 'IST',
      );

      tz.didChangeAppLifecycleState(AppLifecycleState.paused);
      tz.didChangeAppLifecycleState(AppLifecycleState.inactive);
      await Future<void>.delayed(Duration.zero);

      expect(reads, 0);
    });
  });
}
