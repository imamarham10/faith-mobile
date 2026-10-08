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

/// Keeps the real controller's provider wired (the orchestrator listens to
/// it) without reaching the prayers repository.
class _FakePrayerTimes extends PrayerTimesController {
  @override
  Future<PrayerTimesData?> build() async => null;
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  /// Pumps the orchestrator and returns the sink plus a handle that can flip
  /// the faith mid-test, mirroring Settings → "Switch faith".
  Future<(_RecordingSink, MutableFakeSelectedFaith)> pump(
    WidgetTester tester, {
    required FaithId faith,
    LatLng? at = (latitude: 28.61, longitude: 77.21),
  }) async {
    final sink = _RecordingSink();
    final selected = MutableFakeSelectedFaith(faith);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          prayerNotificationSinkProvider.overrideWithValue(sink),
          selectedFaithProvider.overrideWith(() => selected),
          locationServiceProvider.overrideWithValue(_FakeLocationService(at)),
          prayerTimesControllerProvider.overrideWith(_FakePrayerTimes.new),
        ],
        child: const NotificationOrchestrator(child: SizedBox.shrink()),
      ),
    );
    await tester.pumpAndSettle();
    return (sink, selected);
  }

  testWidgets('an Islamic launch schedules the window', (tester) async {
    final (sink, _) = await pump(tester, faith: FaithId.islam);

    expect(sink.ops, contains('reschedule'));
  });

  testWidgets('switching away from Islam cancels the outgoing alarms', (
    tester,
  ) async {
    final (sink, faith) = await pump(tester, faith: FaithId.islam);
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
    final (sink, faith) = await pump(tester, faith: FaithId.islam);

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
    final (sink, _) = await pump(tester, faith: FaithId.hindu);

    expect(sink.ops, isNotEmpty);
    expect(sink.ops, everyElement('cancel'));
  });

  testWidgets('the faith gate outranks the location guard', (tester) async {
    // A Hindu user who denied location never reaches the scheduling code at
    // all — so a gate placed below the `loc == null` early return would
    // leave their adhan alarms running forever. This is the ordering the
    // cancellation depends on.
    final (sink, _) = await pump(tester, faith: FaithId.hindu, at: null);

    expect(sink.ops, contains('cancel'));
  });
}
