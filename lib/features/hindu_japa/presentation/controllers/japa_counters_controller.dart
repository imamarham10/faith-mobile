import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/dtos/japa_counter.dart';
import '../../data/dtos/japa_phrase.dart';
import '../../data/hindu_japa_repository.dart';

part 'japa_counters_controller.g.dart';

/// Loads the user's japa counters and exposes mutating actions. Mirrors
/// `DhikrCountersController` — per-counter increments are owned by
/// [JapaCounterController] (a family) so the count number can update at
/// 60fps without rebuilding the whole list.
@Riverpod(keepAlive: true)
class JapaCountersController extends _$JapaCountersController {
  @override
  Future<List<JapaCounter>> build() async {
    final repo = ref.watch(hinduJapaRepositoryProvider);
    return repo.getCounters();
  }

  /// Re-fetches the list from the server.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(hinduJapaRepositoryProvider).getCounters(),
    );
  }

  /// Creates a new counter from a dictionary phrase or custom input.
  Future<JapaCounter> create({
    required String name,
    String? mantraSanskrit,
    String? mantraEnglish,
    int? targetCount,
    String? deityKey,
  }) async {
    try {
      final created = await ref
          .read(hinduJapaRepositoryProvider)
          .createCounter(
            name: name,
            mantraSanskrit: mantraSanskrit,
            mantraEnglish: mantraEnglish,
            targetCount: targetCount,
            deityKey: deityKey,
          );
      final current = state.valueOrNull ?? const <JapaCounter>[];
      state = AsyncValue.data([created, ...current]);
      return created;
    } on Object catch (e, st) {
      developer.log('Create japa counter failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Convenience — create a counter from a [JapaPhrase]. Custom entries
  /// (from the New Counter sheet's "Create custom" path) carry empty
  /// sanskrit/english strings rather than nulls; treat blank as absent so
  /// the counter doesn't store an empty-string mantra.
  Future<JapaCounter> createFromPhrase(JapaPhrase phrase) {
    return create(
      name: phrase.transliteration,
      mantraSanskrit: phrase.sanskrit.isNotEmpty ? phrase.sanskrit : null,
      mantraEnglish: phrase.english.isNotEmpty ? phrase.english : null,
      targetCount: phrase.recommendedCount,
      deityKey: phrase.deityKey,
    );
  }

  /// Removes a counter both locally and on the server.
  Future<void> delete(String id) async {
    final current = state.valueOrNull ?? const <JapaCounter>[];
    state = AsyncValue.data(
      current.where((c) => c.id != id).toList(growable: false),
    );
    try {
      await ref.read(hinduJapaRepositoryProvider).deleteCounter(id);
    } on Object catch (e, st) {
      developer.log('Delete japa counter failed', error: e, stackTrace: st);
      state = AsyncValue.data(current);
    }
  }

  /// Patches a counter's local copy — used by the per-counter controller
  /// after successful mutations so the home list stays fresh without a
  /// round-trip.
  void patchLocal(JapaCounter next) {
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
List<JapaPhrase> suggestedJapaPhrases(Ref ref) {
  final dictionary =
      ref.watch(japaDictionaryProvider).valueOrNull ?? const <JapaPhrase>[];
  final counters =
      ref.watch(japaCountersControllerProvider).valueOrNull ??
      const <JapaCounter>[];
  if (dictionary.isEmpty) return const <JapaPhrase>[];
  // Unlike Dhikr's `phraseEnglish` (itself a transliteration-equivalent
  // identity field), this backend's `mantraEnglish` is a prose meaning
  // ("Salutations to Shiva"), not a name — comparing against it would never
  // match `phrase.transliteration`. `name` is what `createFromPhrase` sets
  // to the transliteration, so that's the correct comparison key.
  final taken = counters.map((c) => c.name.toLowerCase().trim()).toSet();
  return dictionary
      .where((p) => !taken.contains(p.transliteration.toLowerCase()))
      .toList(growable: false);
}

/// Dictionary loader — predefined mantras.
@Riverpod(keepAlive: true)
Future<List<JapaPhrase>> japaDictionary(Ref ref) async {
  final repo = ref.watch(hinduJapaRepositoryProvider);
  return repo.getMantras();
}
