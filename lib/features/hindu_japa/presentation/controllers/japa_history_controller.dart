import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/dtos/japa_history_entry.dart';
import '../../data/hindu_japa_repository.dart';

part 'japa_history_controller.g.dart';

/// Japa session history grouped by day, descending.
///
/// Unlike Dhikr's history (`recordedAt` with time-of-day), this backend's
/// `date` field is day-granularity; `createdAt` (when present) supplies a
/// time-of-day for the row display, falling back to `date` itself.
@riverpod
Future<Map<DateTime, List<JapaHistoryEntry>>> japaHistoryGrouped(
  Ref ref,
) async {
  final repo = ref.watch(hinduJapaRepositoryProvider);
  final entries = await repo.getHistory();

  final grouped = <DateTime, List<JapaHistoryEntry>>{};
  for (final e in entries) {
    final day = DateTime(e.date.year, e.date.month, e.date.day);
    grouped.putIfAbsent(day, () => <JapaHistoryEntry>[]).add(e);
  }

  final orderedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));
  return {
    for (final k in orderedKeys)
      k: (grouped[k]!
        ..sort(
          (a, b) => (b.createdAt ?? b.date).compareTo(a.createdAt ?? a.date),
        )),
  };
}
