/// What calendar day the device thinks it is, so a read that needs a date
/// range does not have to wait to be told one.
///
/// ## Why this exists
///
/// `GET /activity/today` echoes the `localDay` it derived from the
/// `timezone` the client sent (§5.2), and that echo is the authority on
/// which day the dashboard is describing. It is *not*, however, the only
/// way to find out roughly what day it is: the device has a clock and an
/// IANA zone name, which is the same pair of inputs the server used.
///
/// Deriving the day only from the response made `GET /activity/history`'s
/// range depend on `GET /activity/today` having already returned, which
/// turned two independent ~1s requests into a ~2s chain before the Today
/// screen could draw a single card. The range is a *window*, not a verdict,
/// so it can be computed from the device's own clock and the two requests
/// can go out together; the server's echo still decides what is rendered.
///
/// ## Why it is a class behind a provider
///
/// So a test can pin it. A window asserted against `DateTime.now()` passes
/// on the day it was written and starts drifting the next morning, and the
/// disagreement handling below is specifically about days that differ —
/// which is untestable if one side is whatever day CI runs on.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/time/device_timezone.dart';
import 'streak_engine.dart' as engine;

part 'device_day.g.dart';

/// Reads the device's own calendar day.
class DeviceDayClock {
  /// Builds a clock. [now] is injected only so tests can pin the instant;
  /// production always reads the real one.
  const DeviceDayClock({DateTime Function() now = DateTime.now}) : _now = now;

  final DateTime Function() _now;

  /// The `YYYY-MM-DD` the device is currently on.
  ///
  /// Resolved in the device's IANA zone — the same zone the request carries
  /// — rather than from `DateTime.now()`'s components, so this matches the
  /// derivation the server performs on the other side. `localDayIn` returns
  /// null for a zone the bundled tz database lacks (Android still reports
  /// backward links such as `Asia/Calcutta`), and the fallback is exact
  /// rather than approximate: for the device's *own* zone, the device's own
  /// local time is the answer by construction.
  String today() {
    final at = _now();
    return engine.localDayIn(DeviceTimezone.instance.current, at) ??
        engine.localDayOf(at);
  }
}

/// The app's clock. Overridden in tests to pin the day.
@Riverpod(keepAlive: true)
DeviceDayClock deviceDayClock(Ref ref) => const DeviceDayClock();
