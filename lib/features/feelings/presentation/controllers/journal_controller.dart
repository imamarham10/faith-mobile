import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/dtos/journal_entry.dart';

part 'journal_controller.g.dart';

/// Persisted reflection journal.
///
/// The backend exposes no journal endpoint (per APIs.md), so the device is
/// the source of truth for now. All mutations go through this controller
/// so the screens never touch SharedPreferences directly.
@Riverpod(keepAlive: true)
class JournalController extends _$JournalController {
  static const String _kStorageKey = 'feelings.journal.v1';

  @override
  Future<List<JournalEntry>> build() => _load();

  Future<List<JournalEntry>> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kStorageKey);
    if (raw == null || raw.isEmpty) return const <JournalEntry>[];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const <JournalEntry>[];
      final entries =
          decoded
              .whereType<Map<String, dynamic>>()
              .map(JournalEntry.fromJson)
              .toList(growable: false)
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return entries;
    } on Object catch (e, st) {
      developer.log(
        'Failed to parse journal',
        name: 'feelings.journal',
        error: e,
        stackTrace: st,
      );
      return const <JournalEntry>[];
    }
  }

  Future<void> _persist(List<JournalEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(
      entries.map((e) => e.toJson()).toList(growable: false),
    );
    await prefs.setString(_kStorageKey, encoded);
  }

  /// Adds a new entry. Returns the entry that was saved.
  Future<JournalEntry> add({required String mood, required String note}) async {
    final entry = JournalEntry(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      mood: mood,
      note: note.trim(),
      createdAt: DateTime.now(),
    );
    final current =
        state.valueOrNull?.toList(growable: true) ?? <JournalEntry>[];
    current.insert(0, entry);
    await _persist(current);
    state = AsyncValue.data(current);
    return entry;
  }

  Future<void> remove(String id) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final next = current.where((e) => e.id != id).toList(growable: false);
    await _persist(next);
    state = AsyncValue.data(next);
  }

  Future<void> clear() async {
    await _persist(const <JournalEntry>[]);
    state = const AsyncValue.data(<JournalEntry>[]);
  }
}

/// Three most-recent entries, cheap to read on the Reflect home.
@riverpod
List<JournalEntry> recentJournalEntries(Ref ref) {
  final all =
      ref.watch(journalControllerProvider).valueOrNull ??
      const <JournalEntry>[];
  return all.take(3).toList(growable: false);
}

/// Count of entries created in the current calendar month — used by the
/// "Journal" home card subtitle.
@riverpod
int journalEntriesThisMonth(Ref ref) {
  final all =
      ref.watch(journalControllerProvider).valueOrNull ??
      const <JournalEntry>[];
  final now = DateTime.now();
  return all
      .where(
        (e) => e.createdAt.year == now.year && e.createdAt.month == now.month,
      )
      .length;
}
