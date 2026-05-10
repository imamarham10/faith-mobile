import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/dtos/journal_entry.dart';
import 'journal_controller.dart';

part 'mood_history_controller.g.dart';

/// Frequency of each mood over the trailing [days] window. Derived from the
/// journal so we have a single source of truth — no separate "history"
/// store to keep in sync.
@riverpod
Map<String, int> moodFrequency(Ref ref, {int days = 30}) {
  final journal =
      ref.watch(journalControllerProvider).valueOrNull ??
      const <JournalEntry>[];
  final cutoff = DateTime.now().subtract(Duration(days: days));
  final counts = <String, int>{};
  for (final entry in journal) {
    if (entry.createdAt.isBefore(cutoff)) continue;
    counts[entry.mood] = (counts[entry.mood] ?? 0) + 1;
  }
  return counts;
}

/// Entries within the trailing [days] window, newest first.
@riverpod
List<JournalEntry> moodHistoryEntries(Ref ref, {int days = 30}) {
  final journal =
      ref.watch(journalControllerProvider).valueOrNull ??
      const <JournalEntry>[];
  final cutoff = DateTime.now().subtract(Duration(days: days));
  return journal
      .where((e) => !e.createdAt.isBefore(cutoff))
      .toList(growable: false);
}
