import 'dart:async';
import 'dart:developer' as developer;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../shared/habit/activity_event.dart';
import '../../../../shared/habit/activity_recorder.dart';
import '../../data/dtos/japa_counter.dart';
import '../../data/hindu_japa_repository.dart';
import 'japa_counters_controller.dart';

part 'japa_counter_controller.g.dart';

/// Per-counter state owner — fast, optimistic increments with debounced
/// server sync. Mirrors `DhikrCounterController`, with one important
/// difference driven by the backend contract: this API's `count` field is
/// an **absolute** value, not a delta. That makes sync retries naturally
/// idempotent — a failed flush can just resend the current local count
/// next time, no delta bookkeeping required.
@riverpod
class JapaCounterController extends _$JapaCounterController {
  static const Duration _syncDebounce = Duration(seconds: 5);

  /// Beads in one mala. The engine counts **completed malas**
  /// (`japa_mala`, §1.2), not beads, so this is the conversion.
  static const int _beadsPerMala = 108;

  Timer? _syncTimer;
  bool _dirty = false;
  bool _disposed = false;

  /// Malas already recorded for this counter, so a mala is never counted
  /// twice. Seeded from the count this screen opened on: those malas were
  /// told to the engine when they happened, possibly on another day, and
  /// re-recording them on every reopen would inflate today's total.
  int? _recordedMalas;

  @override
  Future<JapaCounter> build(String id) async {
    ref.onDispose(() {
      _disposed = true;
      _syncTimer?.cancel();
      _flushNow();
    });

    final list =
        ref.read(japaCountersControllerProvider).valueOrNull ??
        const <JapaCounter>[];
    final cached = list
        .where((c) => c.id == id)
        .cast<JapaCounter?>()
        .firstOrNull;
    if (cached != null) return cached;

    await ref.read(japaCountersControllerProvider.notifier).refresh();
    final refreshed =
        ref.read(japaCountersControllerProvider).valueOrNull ??
        const <JapaCounter>[];
    final found = refreshed
        .where((c) => c.id == id)
        .cast<JapaCounter?>()
        .firstOrNull;
    if (found != null) return found;

    throw StateError('Counter $id not found');
  }

  /// Increment the count by 1, optimistic + debounced sync.
  IncrementResult increment() {
    final current = state.valueOrNull;
    if (current == null) {
      return const IncrementResult(count: 0, isMilestone: false);
    }
    final next = current.count + 1;
    final updated = current.copyWith(count: next);
    state = AsyncValue.data(updated);
    ref.read(japaCountersControllerProvider.notifier).patchLocal(updated);

    _recordCompletedMalas(from: current.count, to: next);

    _dirty = true;
    _scheduleSync();

    return IncrementResult(
      count: next,
      isMilestone: _isMilestone(next, updated.targetCount ?? 0),
    );
  }

  /// Reset the local count to 0 and sync to the server.
  Future<void> reset() async {
    final current = state.valueOrNull;
    if (current == null) return;
    final updated = current.copyWith(count: 0);
    state = AsyncValue.data(updated);
    ref.read(japaCountersControllerProvider.notifier).patchLocal(updated);
    _dirty = false;
    _syncTimer?.cancel();
    // The malas already recorded stay recorded — resetting the bead count
    // starts a new round, it does not undo the rounds already turned.
    _recordedMalas = 0;

    try {
      final synced = await ref
          .read(hinduJapaRepositoryProvider)
          .updateCounter(id: id, count: 0);
      if (_disposed) return;
      state = AsyncValue.data(synced);
      ref.read(japaCountersControllerProvider.notifier).patchLocal(synced);
    } on Object catch (e, st) {
      developer.log('Reset japa counter failed', error: e, stackTrace: st);
    }
  }

  /// Update the target. Server sync is fire-and-forget; local state is
  /// updated immediately.
  Future<void> setTarget(int target) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final updated = current.copyWith(targetCount: target);
    state = AsyncValue.data(updated);
    ref.read(japaCountersControllerProvider.notifier).patchLocal(updated);

    try {
      final synced = await ref
          .read(hinduJapaRepositoryProvider)
          .updateCounter(id: id, targetCount: target);
      if (_disposed) return;
      state = AsyncValue.data(synced);
      ref.read(japaCountersControllerProvider.notifier).patchLocal(synced);
    } on Object catch (e, st) {
      developer.log('Set japa target failed', error: e, stackTrace: st);
    }
  }

  /// Force a flush right now — called when the counter screen pops.
  Future<void> flush() async {
    _syncTimer?.cancel();
    await _flushNow();
  }

  void _scheduleSync() {
    _syncTimer?.cancel();
    _syncTimer = Timer(_syncDebounce, _flushNow);
  }

  Future<void> _flushNow() async {
    if (!_dirty) return;
    final current = state.valueOrNull;
    if (current == null) return;
    _dirty = false;
    try {
      final synced = await ref
          .read(hinduJapaRepositoryProvider)
          .updateCounter(id: id, count: current.count);
      if (_disposed) return;
      state = AsyncValue.data(synced);
      ref.read(japaCountersControllerProvider.notifier).patchLocal(synced);
    } on Object catch (e, st) {
      developer.log(
        'Japa counter sync failed; will retry next flush',
        error: e,
        stackTrace: st,
      );
      // Safe to retry: count is an absolute value here, not a delta, so
      // resending the same local count is idempotent.
      _dirty = true;
    }
  }

  /// Records one `japa_mala` per mala newly completed between [from] and
  /// [to].
  ///
  /// Recorded the moment the bead crosses 108 rather than on the debounced
  /// sync, because a mala is a discrete act with a moment, where dhikr
  /// repetitions are a running tally. The recorder is a local queue write
  /// and this fires at most once per 108 taps.
  void _recordCompletedMalas({required int from, required int to}) {
    _recordedMalas ??= from ~/ _beadsPerMala;
    final completed = to ~/ _beadsPerMala;
    final newly = completed - _recordedMalas!;
    if (newly <= 0) return;
    _recordedMalas = completed;
    unawaited(
      ref
          .read(activityRecorderProvider)
          .record(
            ActivityType.japaMala,
            quantity: newly,
            sourceRef: 'japa:$id',
          ),
    );
  }

  bool _isMilestone(int count, int target) {
    if (count <= 0) return false;
    if (count == target) return true;
    if (count == 108 || count == 1008) return true;
    if (target > 0 && count % target == 0) return true;
    return false;
  }
}

/// Outcome of an increment — surfaces enough info for the screen to drive
/// haptics + flash without re-reading state.
class IncrementResult {
  const IncrementResult({required this.count, required this.isMilestone});

  final int count;
  final bool isMilestone;
}
