import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/dhikr_repository.dart';
import '../../data/dtos/dhikr_history_entry.dart';

part 'dhikr_history_controller.g.dart';

/// Dhikr session history grouped by day, descending.
///
/// Defaults to the last 30 days; the screen can pass a custom range later
/// (Phase 2 — analytics view).
@riverpod
Future<Map<DateTime, List<DhikrHistoryEntry>>> dhikrHistoryGrouped(
  Ref ref, {
  DateTime? fromDate,
  DateTime? toDate,
}) async {
  final now = DateTime.now();
  final repo = ref.watch(dhikrRepositoryProvider);
  final entries = await repo.getHistory(
    from: fromDate ?? DateTime(now.year, now.month, now.day - 30),
    to: toDate ?? DateTime(now.year, now.month, now.day),
  );

  final grouped = <DateTime, List<DhikrHistoryEntry>>{};
  for (final e in entries) {
    final at = e.recordedAt;
    if (at == null) continue;
    final day = DateTime(at.year, at.month, at.day);
    grouped.putIfAbsent(day, () => <DhikrHistoryEntry>[]).add(e);
  }

  // Sort each day descending by time, then return a Map ordered by day desc.
  final orderedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));
  return {
    for (final k in orderedKeys)
      k: (grouped[k]!
        ..sort(
          (a, b) => (b.recordedAt ?? DateTime(0)).compareTo(
            a.recordedAt ?? DateTime(0),
          ),
        )),
  };
}
