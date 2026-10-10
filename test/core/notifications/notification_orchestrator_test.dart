import 'package:faith_mobile/core/location/location_service.dart';
import 'package:faith_mobile/core/notifications/notification_orchestrator.dart';
import 'package:faith_mobile/core/notifications/notification_service.dart';
import 'package:faith_mobile/core/preferences/notification_preferences.dart';
import 'package:faith_mobile/core/preferences/selected_faith.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:faith_mobile/features/prayers/presentation/controllers/prayer_times_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/fake_selected_faith.dart';

/// Records what the orchestrator asked the OS to do, in order.
class _RecordingSink implements PrayerNotificationSink {
  final List<String> ops = <String>[];

  @override
  Future<void> cancelAll() async => ops.add('cancel');

  @override
  Future<void> rescheduleWindow({
    required double latitude,
    required double longitude,
    required NotificationPreferences prefs,
    required String method,
    required String madhab,
  }) async => ops.add('reschedule');
}

class _FakeLocationService extends LocationService {
  _FakeLocationService(this._position);

  final LatLng? _position;

  @override
  Future<bool> ensurePermission() async => _position != null;

  @override
  Future<LatLng?> currentPosition() async => _position;
}

/// Counts how many times the prayer-times provider was *initialised*.
///
/// Subscribing to a provider is what creates it, so this is the only thing
/// that can tell the two faiths apart here: the provider is overridden in
/// every test, so it never throws and never reaches a repository — but a
/// non-zero count still means the app went looking for prayer times.
class _PrayerTimesSpy {
  int builds = 0;
}

/// Keeps the real controller's provider wired (the orchestrator listens to
/// it on Islam) without reaching the prayers repository.
class _FakePrayerTimes extends PrayerTimesController {
  _FakePrayerTimes(this._spy);

  final _PrayerTimesSpy _spy;

  @override
  Future<PrayerTimesData?> build() async {
    _spy.builds++;
    return null;
  }
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  /// Pumps the orchestrator and returns the sink plus a handle that can flip
  /// the faith mid-test, mirroring Settings → "Switch faith".
  Future<(_RecordingSink, MutableFakeSelectedFaith, _PrayerTimesSpy)> pump(
    WidgetTester tester, {
    required FaithId faith,
    LatLng? at = (latitude: 28.61, longitude: 77.21),
  }) async {
    final sink = _RecordingSink();
    final selected = MutableFakeSelectedFaith(faith);
    final spy = _PrayerTimesSpy();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          prayerNotificationSinkProvider.overrideWithValue(sink),
          selectedFaithProvider.overrideWith(() => selected),
          locationServiceProvider.overrideWithValue(_FakeLocationService(at)),
          prayerTimesControllerProvider.overrideWith(
            () => _FakePrayerTimes(spy),
          ),
        ],
        child: const NotificationOrchestrator(child: SizedBox.shrink()),
      ),
    );
    await tester.pumpAndSettle();
    return (sink, selected, spy);
  }

  testWidgets('an Islamic launch schedules the window', (tester) async {
    final (sink, _, _) = await pump(tester, faith: FaithId.islam);

    expect(sink.ops, contains('reschedule'));
  });

  testWidgets('switching away from Islam cancels the outgoing alarms', (
    tester,
  ) async {
    final (sink, faith, _) = await pump(tester, faith: FaithId.islam);
    expect(sink.ops, contains('reschedule'));
    sink.ops.clear();

    await faith.set(FaithId.hindu);
    await tester.pumpAndSettle();

    // Settings hides every prayer-notification control once the faith is
    // Hindu, so anything still scheduled here is unreachable by the user.
    expect(sink.ops, isNotEmpty);
    expect(sink.ops, everyElement('cancel'));
  });

  testWidgets('switching back to Islam restores the window', (tester) async {
    final (sink, faith, _) = await pump(tester, faith: FaithId.islam);

    await faith.set(FaithId.hindu);
    await tester.pumpAndSettle();
    sink.ops.clear();

    await faith.set(FaithId.islam);
    await tester.pumpAndSettle();

    // Leaving the user silently unscheduled would be worse than the bug
    // this cancellation fixes.
    expect(sink.ops, contains('reschedule'));
    expect(sink.ops.last, 'reschedule');
  });

  testWidgets('a Hindu launch clears alarms a previous faith left behind', (
    tester,
  ) async {
    final (sink, _, _) = await pump(tester, faith: FaithId.hindu);

    expect(sink.ops, isNotEmpty);
    expect(sink.ops, everyElement('cancel'));
  });

  testWidgets('a Hindu launch never asks for prayer times', (tester) async {
    // The orchestrator listens to the prayer-times controller to know when
    // to reschedule. Listening is what creates the provider, so on a Hindu
    // profile that listen was sending `GET /islam/prayers/times` at boot —
    // for a user who has no prayer times, into the middle of the cold-start
    // request pile-up, only for the reschedule it triggered to fall
    // straight through the faith gate and cancel.
    final (_, _, spy) = await pump(tester, faith: FaithId.hindu);

    expect(spy.builds, 0);
  });

  testWidgets('an Islamic launch still asks for prayer times', (tester) async {
    // The other half of the gate: the trigger must still be attached for
    // the faith that has prayer reminders, or a location or calc-method
    // change would stop rescheduling the window.
    final (_, _, spy) = await pump(tester, faith: FaithId.islam);

    expect(spy.builds, greaterThan(0));
  });

  testWidgets('switching to Islam attaches the prayer-times trigger', (
    tester,
  ) async {
    // The gate is re-evaluated on every build rather than latched once, so
    // a user who starts Hindu and switches picks the trigger up — without
    // it their window would never slide on a location change.
    final (_, faith, spy) = await pump(tester, faith: FaithId.hindu);
    expect(spy.builds, 0);

    await faith.set(FaithId.islam);
    await tester.pumpAndSettle();

    expect(spy.builds, greaterThan(0));
  });

  testWidgets('the faith gate outranks the location guard', (tester) async {
    // A Hindu user who denied location never reaches the scheduling code at
    // all — so a gate placed below the `loc == null` early return would
    // leave their adhan alarms running forever. This is the ordering the
    // cancellation depends on.
    final (sink, _, _) = await pump(tester, faith: FaithId.hindu, at: null);

    expect(sink.ops, contains('cancel'));
  });
}
