import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../shared/habit/activity_event.dart';
import '../../../../shared/habit/activity_recorder.dart';

import '../../../today/presentation/controllers/today_dashboard_controller.dart';
import '../../data/dtos/puja_log.dart';
import '../../data/dtos/puja_stats.dart';
import '../../data/hindu_puja_times_repository.dart';

part 'puja_log_controller.g.dart';

/// Today's logs, keyed by sandhya name. Mirrors `TodayLogs` (prayers).
@Riverpod(keepAlive: false)
class TodayPujaLogs extends _$TodayPujaLogs {
  @override
  Future<Map<String, PujaLog>> build() async {
    final repo = ref.watch(hinduPujaTimesRepositoryProvider);
    final now = DateTime.now();
    final logs = await repo.getLogs(fromDate: now, toDate: now);
    return {for (final l in logs) l.sandhya: l};
  }

  /// Logs a sandhya and invalidates stats so the summary stays in sync.
  /// No qada-equivalent coupling exists here (see `PujaStatus`'s doc
  /// comment) — this is the only cross-controller invalidation needed.
  Future<void> log({
    required String sandhya,
    required PujaStatus status,
  }) async {
    final repo = ref.read(hinduPujaTimesRepositoryProvider);
    final created = await repo.logPuja(sandhya: sandhya, status: status);
    final current = state.valueOrNull ?? const <String, PujaLog>{};
    state = AsyncValue.data({...current, sandhya: created});
    ref.invalidate(pujaStatsControllerProvider);

    // Parity with the Islam side, line for line — see `TodayLogs.log`.
    // A `missed` sandhya is not an act of worship and is not recorded.
    if (status.countsAsPractised) {
      unawaited(
        ref
            .read(activityRecorderProvider)
            .record(
              ActivityType.sandhya,
              // §1.6, as on the Islam side.
              sourceRef: 'sandhya:${sandhya.toLowerCase()}',
            ),
      );
    }
    // Closes the loop for the checklist, which still reads the log —
    // `/today`'s `counts` gives a sum and cannot say *which* acts. The
    // checklist provider is memoised, so it is invalidated by name:
    // invalidating `todayDashboardProvider` would not reach it. The goal,
    // week strip and streak update on their own — the recorder pokes the
    // counter `todayDashboard` watches.
    ref.invalidate(practiceChecklistProvider);
    ref.invalidate(todayDashboardProvider);
  }
}

/// Aggregate stats — totals, streaks, completion rate. Read-only; no
/// increment method (unlike `PrayerStatsController.incrementQada`, which
/// has no analogue here).
@Riverpod(keepAlive: false)
class PujaStatsController extends _$PujaStatsController {
  @override
  Future<PujaStats> build() {
    final repo = ref.watch(hinduPujaTimesRepositoryProvider);
    return repo.getStats();
  }
}
