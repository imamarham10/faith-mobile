import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../location/location_service.dart';
import '../preferences/notification_preferences.dart';
import '../../features/prayers/presentation/controllers/prayer_times_controller.dart';
import 'notification_schedule.dart';
import 'notification_service.dart';

/// Mounts near the app root and reschedules the rolling notification window
/// whenever:
///   * prayer times update (location change, calc-method change, refresh),
///   * notification preferences change (toggle a prayer, change lead time), or
///   * the app returns to the foreground.
///
/// The resume trigger is the one that makes the window a *rolling* one. The
/// OS only holds [kScheduleWindowDays] days of alarms; without a slide on
/// every open, the window still expires — just six days later instead of one.
///
/// Renders [child] verbatim — it's a side-effect carrier, not a layout widget.
class NotificationOrchestrator extends ConsumerStatefulWidget {
  const NotificationOrchestrator({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<NotificationOrchestrator> createState() =>
      _NotificationOrchestratorState();
}

class _NotificationOrchestratorState
    extends ConsumerState<NotificationOrchestrator>
    with WidgetsBindingObserver {
  /// Held while a reschedule is running. The three triggers routinely
  /// overlap at startup, and one pass's `cancelAll()` would delete the
  /// notifications another pass had just written.
  Future<void>? _inFlight;

  /// Set when a trigger arrives mid-pass. The running pass read the old
  /// state, so it must be followed by one more — otherwise toggling a prayer
  /// while a reschedule is waiting on the GPS fix is silently dropped.
  bool _rerunRequested = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_maybeReschedule());
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(prayerTimesControllerProvider, (prev, next) {
      unawaited(_maybeReschedule());
    });
    ref.listen(notificationPrefsProvider, (prev, next) {
      unawaited(_maybeReschedule());
    });
    return widget.child;
  }

  Future<void> _maybeReschedule() {
    final running = _inFlight;
    if (running != null) {
      _rerunRequested = true;
      return running;
    }
    final next = _reschedule().whenComplete(() {
      _inFlight = null;
      if (_rerunRequested) {
        _rerunRequested = false;
        unawaited(_maybeReschedule());
      }
    });
    _inFlight = next;
    return next;
  }

  Future<void> _reschedule() async {
    final prefs = ref.read(notificationPrefsProvider).valueOrNull;
    if (prefs == null) return;

    // Coordinates come from the location service, not from the prayer-times
    // payload: that DTO falls back to (0, 0) when the backend omits the
    // location echo, which would schedule for the Gulf of Guinea.
    final loc = await ref.read(locationServiceProvider).currentPosition();
    if (loc == null) {
      developer.log(
        'reschedule skipped — no location',
        name: 'notifications',
      );
      return;
    }

    final method =
        ref.read(calcMethodPrefProvider).valueOrNull ?? CalcMethod.fallbackCode;

    await NotificationService.instance.rescheduleWindow(
      latitude: loc.latitude,
      longitude: loc.longitude,
      prefs: prefs,
      method: method,
      // No madhab setting exists yet; kDefaultMadhab matches what the
      // backend computes for the times shown on screen.
      madhab: kDefaultMadhab,
    );
  }
}
