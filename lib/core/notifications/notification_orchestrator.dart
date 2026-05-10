import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../preferences/notification_preferences.dart';
import '../../features/prayers/presentation/controllers/prayer_times_controller.dart';
import 'notification_service.dart';

/// Mounts near the app root and reschedules prayer-time notifications
/// whenever:
///   * prayer times update (location change, calc-method change, refresh), or
///   * notification preferences change (toggle a prayer, change lead time).
///
/// Renders [child] verbatim — it's a side-effect carrier, not a layout widget.
class NotificationOrchestrator extends ConsumerWidget {
  const NotificationOrchestrator({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(prayerTimesControllerProvider, (prev, next) {
      _maybeReschedule(ref);
    });
    ref.listen(notificationPrefsProvider, (prev, next) {
      _maybeReschedule(ref);
    });
    return child;
  }

  Future<void> _maybeReschedule(WidgetRef ref) async {
    final timesData = ref.read(prayerTimesControllerProvider).valueOrNull;
    final prefs = ref.read(notificationPrefsProvider).valueOrNull;
    if (timesData == null || prefs == null) return;
    await NotificationService.instance.rescheduleForToday(
      timesData.times,
      prefs,
    );
  }
}
