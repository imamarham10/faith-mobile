import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/dhikr_repository.dart';
import '../../data/dtos/dhikr_counter.dart';
import '../../data/dtos/dhikr_phrase.dart';

part 'dhikr_counters_controller.g.dart';

/// Loads the user's dhikr counters and exposes mutating actions.
///
/// Counter writes (create / delete / rename) refresh the list from the
/// server. Per-counter increments are owned by [DhikrCounterController]
/// (a family) so the count number can update at 60fps without rebuilding
/// the whole list.
@Riverpod(keepAlive: true)
class DhikrCountersController extends _$DhikrCountersController {
  @override
  Future<List<DhikrCounter>> build() async {
    final repo = ref.watch(dhikrRepositoryProvider);
    return repo.getCounters();
  }

  /// Re-fetches the list from the server.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(dhikrRepositoryProvider).getCounters(),
    );
  }

  /// Creates a new counter from a dictionary phrase or custom input.
  ///
  /// On success the new counter is appended optimistically and then
  /// reconciled by re-fetching. On failure throws so callers can render a
  /// SnackBar — silent failures leave the user staring at an unchanged sheet.
  Future<DhikrCounter> create({
    required String name,
    required String phrase,
    String? phraseArabic,
    int targetCount = 33,
  }) async {
    try {
      final created = await ref
          .read(dhikrRepositoryProvider)
          .createCounter(
            name: name,
            phrase: phrase,
            phraseArabic: phraseArabic,
            targetCount: targetCount,
          );
      final current = state.valueOrNull ?? const <DhikrCounter>[];
      state = AsyncValue.data([created, ...current]);
      return created;
    } on Object catch (e, st) {
      developer.log('Create counter failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Convenience — create a counter from a [DhikrPhrase].
  ///
  /// Sends the Arabic text as the canonical `phrase` (backend's
  /// `normalizeArabic` strips tashkeel and resolves it to the dictionary
  /// entry); falls back to transliteration only when Arabic is missing
  /// (custom counters typed by the user).
  Future<DhikrCounter> createFromPhrase(DhikrPhrase phrase) {
    final arabic = phrase.phraseArabic.trim();
    return create(
      name: phrase.phraseTransliteration,
      phrase: arabic.isNotEmpty ? arabic : phrase.phraseTransliteration,
      phraseArabic: arabic.isNotEmpty ? arabic : null,
      targetCount: phrase.recommendedCount,
    );
  }

  /// Removes a counter both locally and on the server.
  Future<void> delete(String id) async {
    final current = state.valueOrNull ?? const <DhikrCounter>[];
    state = AsyncValue.data(
      current.where((c) => c.id != id).toList(growable: false),
    );
    try {
      await ref.read(dhikrRepositoryProvider).deleteCounter(id);
    } on Object catch (e, st) {
      developer.log('Delete counter failed', error: e, stackTrace: st);
      // Restore local state on failure.
      state = AsyncValue.data(current);
    }
  }

  /// Patches a counter's local copy — used by the per-counter controller
  /// after successful mutations so the home list stays fresh without a
  /// round-trip.
  void patchLocal(DhikrCounter next) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncValue.data([
      for (final c in current)
        if (c.id == next.id) next else c,
    ]);
  }
}

/// Suggested phrases — dictionary entries the user hasn't started yet.
@riverpod
List<DhikrPhrase> suggestedPhrases(Ref ref) {
  final dictionary =
      ref.watch(dhikrDictionaryProvider).valueOrNull ?? const <DhikrPhrase>[];
  final counters =
      ref.watch(dhikrCountersControllerProvider).valueOrNull ??
      const <DhikrCounter>[];
  if (dictionary.isEmpty) return const <DhikrPhrase>[];
  final taken = counters
      .map((c) => (c.phraseEnglish ?? c.name).toLowerCase().trim())
      .toSet();
  return dictionary
      .where((p) => !taken.contains(p.phraseTransliteration.toLowerCase()))
      .toList(growable: false);
}

/// Dictionary loader — predefined phrases.
@Riverpod(keepAlive: true)
Future<List<DhikrPhrase>> dhikrDictionary(Ref ref) async {
  final repo = ref.watch(dhikrRepositoryProvider);
  return repo.getDictionary();
}
