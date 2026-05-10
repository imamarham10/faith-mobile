import 'package:riverpod_annotation/riverpod_annotation.dart';

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

  /// Records one qada increment for [prayerName] and refreshes the view.
  Future<void> incrementQada(String prayerName) async {
    final repo = ref.read(prayersRepositoryProvider);
    await repo.logPrayer(prayerName: prayerName, status: PrayerStatus.qada);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => repo.getStats());
  }
}
