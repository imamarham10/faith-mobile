import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/notifications/permission_gate.dart';
import '../../../today/presentation/controllers/today_dashboard_controller.dart';
import '../../data/dtos/prayer_log.dart';
import '../../data/dtos/prayer_stats.dart';
import '../../data/prayers_repository.dart';

part 'prayer_log_controller.g.dart';

/// Today's logs, indexed by `prayerName.toLowerCase()` for O(1) lookup.
@Riverpod(keepAlive: false)
class TodayLogs extends _$TodayLogs {
  @override
  Future<Map<String, PrayerLog>> build() async {
    final repo = ref.watch(prayersRepositoryProvider);
    final logs = await repo.getLogsForDate();
    return {for (final l in logs) l.prayerName.toLowerCase(): l};
  }

  /// Logs a prayer and refreshes both the local map and qaza stats.
  Future<void> log({
    required String prayerName,
    required PrayerStatus status,
  }) async {
    final repo = ref.read(prayersRepositoryProvider);
    final created = await repo.logPrayer(
      prayerName: prayerName,
      status: status,
    );
    final current = state.value ?? const <String, PrayerLog>{};
    state = AsyncValue.data({...current, prayerName.toLowerCase(): created});
    ref.invalidate(prayerStatsControllerProvider);
    // Closes the loop. The Today branch stays mounted in the shell's
    // indexed stack, so without this the user logs a prayer, returns to
    // Today, and the ring, the goal and the checklist all still show the
    // old numbers — which is the whole feature failing silently.
    // Task 1.12's `record()` call site replaces this.
    ref.invalidate(todayDashboardProvider);

    // The one moment the notification ask has an obvious reason: the user
    // has just logged a prayer, so "remind you next time?" explains itself.
    // Fire-and-forget on purpose — the OS prompt must not delay the success
    // snackbar, and the gate swallows its own failures so a permission
    // problem can never surface as "Couldn't log:".
    unawaited(ref.read(permissionGateProvider).maybeAskAfterFirstLog());
  }
}

/// Aggregate qaza stats for the qaza tracker screen.
@Riverpod(keepAlive: false)
class PrayerStatsController extends _$PrayerStatsController {
  @override
  Future<PrayerStats> build() async {
    final repo = ref.watch(prayersRepositoryProvider);
    return repo.getStats();
  }

  /// Records one qada increment for [prayerName] and adopts the tally the
  /// server returns.
  ///
  /// Goes to `POST /qada/increment`, never `POST /log`. A `qada` log row
  /// upserts on `(userId, prayerName, date)`, so adding a qaza for a prayer
  /// already logged today would overwrite that row and quietly knock the
  /// prayer off the Today checklist and goal. The standalone tally is what
  /// this screen actually counts.
  ///
  /// The response is the refreshed tally, so there is no second read and no
  /// loading flash between the tap and the new number.
  Future<void> incrementQada(String prayerName) async {
    final repo = ref.read(prayersRepositoryProvider);
    state = await AsyncValue.guard(
      () => repo.incrementQada(prayerName: prayerName),
    );
  }
}
