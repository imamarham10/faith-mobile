import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/notifications/permission_gate.dart';
import '../../../../shared/habit/activity_event.dart';
import '../../../../shared/habit/activity_recorder.dart';
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

    // One line, and the feature knows nothing about streaks or goals.
    // Only a status that actually counts as practised: a `missed` log is
    // an honest record of a prayer *not* made, and feeding it to the
    // engine would let a user build a streak out of missing prayers.
    if (status.countsAsPractised) {
      unawaited(
        ref
            .read(activityRecorderProvider)
            .record(ActivityType.prayer, sourceRef: 'prayer:$prayerName'),
      );
    }

    // Closes the loop for the checklist, which still reads the prayer log
    // — `/today`'s `counts` gives `prayer: 3`, a sum, and cannot say which
    // three. The goal, week strip and streak update on their own: the
    // recorder pokes the counter `todayDashboard` watches.
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

  /// Adds one qaza for [prayerName] and adopts the tally the server returns.
  ///
  /// Goes to `POST /qada/increment`, never `POST /log`. A `qada` log row
  /// upserts on `(userId, prayerName, date)`, so adding a qaza for a prayer
  /// already logged today would overwrite that row and quietly knock the
  /// prayer off the Today checklist and goal. The standalone tally is what
  /// this screen actually counts.
  Future<void> incrementQada(String prayerName) =>
      _adjust((repo) => repo.incrementQada(prayerName: prayerName));

  /// Removes one qaza for [prayerName] — the undo for [incrementQada].
  ///
  /// The server clamps the tally at zero, so this can never drive a count
  /// negative however many times it is called. The screen additionally
  /// hides the affordance at zero, so the no-op request is not made.
  Future<void> decrementQada(String prayerName) =>
      _adjust((repo) => repo.decrementQada(prayerName: prayerName));

  /// Runs [call] and swaps in the refreshed tally it returns.
  ///
  /// On failure the **previous** tally is restored and the error rethrown,
  /// rather than parked in `state` as an [AsyncError]. Two reasons, and the
  /// second is the one that matters:
  ///
  /// 1. `AsyncValue.guard` swallows the throw, so the caller's `catch` never
  ///    runs and the screen's "Couldn't update" snackbar was dead code.
  /// 2. An [AsyncError] state makes `statsAsync.when(error:)` replace the
  ///    whole screen with the retry view — so one failed tap wipes every
  ///    count off the list. For a *decrement* that is especially bad: the
  ///    user tapped undo, nothing visibly undid, and the numbers they were
  ///    trying to correct vanished.
  ///
  /// The response is the refreshed tally, so there is no second read and no
  /// loading flash between the tap and the new number.
  Future<void> _adjust(
    Future<PrayerStats> Function(PrayersRepository) call,
  ) async {
    final previous = state;
    final repo = ref.read(prayersRepositoryProvider);
    try {
      state = AsyncValue.data(await call(repo));
    } catch (_) {
      state = previous;
      rethrow;
    }
  }
}
