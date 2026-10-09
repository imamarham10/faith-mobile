/// The device's IANA timezone name, read from the platform.
///
/// Contract §1.5: *"On Flutter, use the IANA name from the device, not
/// `DateTime.timeZoneName`."* Until this file existed the app had no IANA
/// source at all — the activity recorder ran `DateTime.timeZoneName` (an
/// abbreviation: `IST`, `CST`, `PDT`) through the shared table in
/// `timezone_names.dart`. That table never emits a shape the server
/// rejects, so nothing was ever lost, but an ambiguous abbreviation
/// resolves to the most populous zone that reports it: a user in Chongqing
/// whose phone says `CST` was stored as `America/Chicago`.
///
/// That is not cosmetic. The nightly rollup closes a day using the
/// timezone carried by that day's own events (§2.8), so a zone on the
/// wrong side of the planet closes the day at the wrong instant, and a day
/// closed early is a day the user's last act of worship falls outside —
/// a wrongly broken streak.
///
/// ## What this reads
///
/// `flutter_timezone` returns `TimeZone.getDefault().getID()` on Android
/// and `TimeZone.current.identifier` on iOS. Both are tz database
/// identifiers, which is exactly what §1.5 asks for. It was chosen over
/// the alternatives because it is the only one that answers the question:
/// `timezone` (already a dependency) carries the *database* but cannot
/// name the *device's* zone — `tz.local` is UTC until something sets it;
/// `intl` formats in local time and exposes no zone identifier; and
/// `DateTime.timeZoneName` is the abbreviation §1.5 rules out.
///
/// ## Why the result is still normalised
///
/// A real IANA source is not automatically a well-formed one. An Android
/// device with no region configured reports `GMT`, and a handful report
/// `GMT+05:30`. [normaliseActivityTimezone] passes `Region/City` and
/// `GMT` through untouched and degrades anything else to `UTC`, so the
/// wire value is always one §1.5 accepts. It also keeps the collision the
/// shared table carries from reopening: that table maps `GMT` to
/// `Europe/London` for the notification scheduler, which needs a
/// *location*; §1.5 accepts `GMT` verbatim, and rewriting it here would
/// silently relocate the user to London. The ordering inside
/// `normaliseActivityTimezone` is what prevents that, and it only protects
/// this path because this path goes through it.
///
/// Aliases are deliberately *not* rewritten. Android still reports
/// `Asia/Calcutta` and `US/Pacific` on plenty of devices; the server
/// validates with `Intl.DateTimeFormat`, which knows every tz backward
/// link, so both are accepted verbatim and rewriting them would only risk
/// getting it wrong.
///
/// ## Why the read is cached, and the one thing that costs
///
/// `getLocalTimezone()` is a method channel, so it is asynchronous, and
/// `ActivityRecorder.record` stamps its event **synchronously** before it
/// awaits anything — on purpose, because the first queue write opens a
/// database and that await can cross midnight. So the name is resolved
/// once into a field that [current] reads synchronously.
///
/// A cache can go stale where `DateTime.timeZoneName` could not: a user
/// who flies with the app resident keeps the zone they took off in. That
/// is handled by re-reading on resume ([didChangeAppLifecycleState]) —
/// chosen over persisting the last-known name to `SharedPreferences`
/// because the window persistence would close is the few milliseconds
/// between `main()` and the channel answering, during which nothing can
/// have been recorded, while the window resume closes is a whole flight.
library;

import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/widgets.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

import 'timezone_names.dart';

/// Reads and caches the device's IANA zone name.
class DeviceTimezone with WidgetsBindingObserver {
  /// Builds a reader.
  ///
  /// [readPlatformZone] and [abbreviation] are injected so the fallback
  /// ordering can be asserted without a method channel; both default to
  /// the real thing.
  DeviceTimezone({
    Future<String> Function() readPlatformZone = _platformZone,
    String Function() abbreviation = _deviceAbbreviation,
  }) : _readPlatformZone = readPlatformZone,
       _abbreviation = abbreviation;

  /// The instance the app uses. Primed by `main()`.
  static final DeviceTimezone instance = DeviceTimezone();

  static Future<String> _platformZone() async =>
      (await FlutterTimezone.getLocalTimezone()).identifier;

  static String _deviceAbbreviation() => DateTime.now().timeZoneName;

  final Future<String> Function() _readPlatformZone;
  final String Function() _abbreviation;

  String? _resolved;
  bool _observing = false;

  /// Whether the platform has answered and [current] is the device's own
  /// IANA name rather than the abbreviation fallback.
  bool get isResolved => _resolved != null;

  /// The zone to stamp on an activity event, synchronously.
  ///
  /// The IANA name from the platform once [refresh] has succeeded; until
  /// then — and on a platform that fails the call — the abbreviation
  /// resolved through the shared table, which is what the recorder used
  /// before this file existed. Both are run through
  /// [normaliseActivityTimezone], so the result is always a value §1.5
  /// accepts.
  String get current => _resolved ?? normaliseActivityTimezone(_abbreviation());

  /// Reads the zone from the platform and starts watching for changes.
  ///
  /// Call once from `main()`. Never throws: a platform that cannot answer
  /// leaves [current] on the abbreviation fallback, which is a worse guess
  /// but never a rejected event.
  Future<void> start() async {
    if (!_observing) {
      _observing = true;
      WidgetsBinding.instance.addObserver(this);
    }
    await refresh();
  }

  /// Re-reads the zone from the platform.
  ///
  /// Idempotent, and safe to call at any time — the cache is only replaced
  /// once a new value is in hand, so a failed read leaves the previous
  /// answer standing rather than dropping back to the abbreviation.
  Future<void> refresh() async {
    try {
      final raw = await _readPlatformZone();
      final zone = normaliseActivityTimezone(raw);
      if (zone != _resolved) {
        developer.log('device timezone: $raw -> $zone', name: 'core.time');
      }
      _resolved = zone;
    } on Object catch (e, st) {
      developer.log(
        'could not read the device timezone; '
        'falling back to the abbreviation table',
        name: 'core.time',
        error: e,
        stackTrace: st,
      );
    }
  }

  /// Re-reads on resume, so a user who flies with the app in the
  /// background stamps events with the zone they landed in.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) unawaited(refresh());
  }

  /// Stops observing. Only the tests need this; the singleton lives as
  /// long as the process.
  @visibleForTesting
  void stop() {
    if (!_observing) return;
    _observing = false;
    WidgetsBinding.instance.removeObserver(this);
  }
}
