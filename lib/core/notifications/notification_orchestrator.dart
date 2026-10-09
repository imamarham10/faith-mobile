import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../location/location_service.dart';
import '../preferences/notification_preferences.dart';
import '../preferences/selected_faith.dart';
import '../theme/faith_id.dart';
import '../../features/prayers/presentation/controllers/prayer_times_controller.dart';
import 'notification_schedule.dart';
import 'notification_service.dart';

/// Mounts near the app root and reschedules the rolling notification window
/// whenever:
///   * prayer times update (location change, calc-method change, refresh),
///   * notification preferences change (toggle a prayer, change lead time), or
///   * the app returns to the foreground, or
///   * the selected faith changes.
///
/// The resume trigger is the one that makes the window a *rolling* one. The
/// OS only holds [kScheduleWindowDays] days of alarms; without a slide on
/// every open, the window still expires — just six days later instead of one.
///
/// Faith is read as an *input* to the reschedule decision rather than
/// tracked as an event. That is why there is no cold-start filter here like
/// the one `AppShell` needs: resetting a navigation branch is destructive
/// and must not fire spuriously, whereas a reschedule is idempotent and
/// already runs on three other triggers. A redundant pass just rewrites the
/// same window — or re-cancels an already empty one.
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
    ref.listen(selectedFaithProvider, (prev, next) {
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
    // Faith is checked first, above every other early return. Prayer
    // reminders are an Islamic feature and Settings hides the entire
    // "Prayer notifications" section once the faith is Hindu — so a user
    // who switches away keeps six days of adhan alarms with no control left
    // in the UI to stop them. The prefs and location guards below return
    // early often enough (prefs still loading, location denied) that a gate
    // placed under them would miss exactly that case.
    //
    // Cancellation runs through _maybeReschedule's lock rather than from
    // the shell, so it can never land between rescheduleWindow's own
    // cancelAll and its scheduling loop and have 60 alarms written back
    // behind it. Routing both directions through here is also what makes
    // the switch *back* to Islam restore the window with no restore logic
    // of its own: the faith is Islam again, so the normal path runs.
    final faith = ref.read(selectedFaithProvider).valueOrNull;
    if (faith != null && faith != FaithId.islam) {
      await ref.read(prayerNotificationSinkProvider).cancelAll();
      return;
    }

    final prefs = ref.read(notificationPrefsProvider).valueOrNull;
    if (prefs == null) return;

    // Coordinates come from the location service, not from the prayer-times
    // payload: that DTO falls back to (0, 0) when the backend omits the
    // location echo, which would schedule for the Gulf of Guinea.
    final loc = await ref.read(locationServiceProvider).currentPosition();
    if (loc == null) {
      developer.log('reschedule skipped — no location', name: 'notifications');
      return;
    }

    final method =
        ref.read(calcMethodPrefProvider).valueOrNull ?? CalcMethod.fallbackCode;

    await ref
        .read(prayerNotificationSinkProvider)
        .rescheduleWindow(
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
