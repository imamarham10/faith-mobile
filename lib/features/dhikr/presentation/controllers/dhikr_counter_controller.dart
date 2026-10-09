import 'dart:async';
import 'dart:developer' as developer;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../shared/habit/activity_event.dart';
import '../../../../shared/habit/activity_recorder.dart';
import '../../data/dhikr_repository.dart';
import '../../data/dtos/dhikr_counter.dart';
import 'dhikr_counters_controller.dart';

part 'dhikr_counter_controller.g.dart';

/// Per-counter state owner — fast, optimistic increments with debounced
/// server sync.
///
/// Why a family: the counter screen rebuilds its `displayLarge` count text
/// on every tap. Scoping that rebuild to a single provider keeps the home
/// list off the rebuild path and the count buttery at 120fps.
///
/// Sync strategy:
/// * Increments are applied immediately to local state and accumulated
///   into [_pendingDelta].
/// * A 5-second debounce timer fires the accumulated delta to the server.
/// * The screen also calls [flush] on pop / done, so we never lose a tap.
/// * On server failure we log + retain the pending delta so the next flush
///   tries again. We do not surface errors to UI; the local count is
///   canonical for the session.
@riverpod
class DhikrCounterController extends _$DhikrCounterController {
  /// Window we wait between successful syncs. Long enough that holding the
  /// counter at 5 taps/sec results in a single round-trip every 25 taps;
  /// short enough that backgrounding the app within a typical session
  /// flushes before the OS may discard it.
  static const Duration _syncDebounce = Duration(seconds: 5);

  Timer? _syncTimer;
  int _pendingDelta = 0;

  /// Repetitions not yet told to the activity engine.
  ///
  /// **Deliberately separate from [_pendingDelta].** That one is the
  /// dhikr API's retry buffer: a failed `incrementCounter` puts its delta
  /// back so the next flush resends it. Recording off that variable
  /// therefore records the same repetitions again on every retry — with a
  /// fresh `clientEventId` each time, so the server's idempotency cannot
  /// catch it and the count that feeds the goal and the streak inflates.
  /// That is the normal offline path, not an edge case.
  ///
  /// This one is zeroed the moment it is recorded and never re-queued: the
  /// dhikr was said once, whichever way the counter API's own sync goes.
  int _unrecordedDelta = 0;

  bool _disposed = false;

  @override
  Future<DhikrCounter> build(String id) async {
    ref.onDispose(() {
      _disposed = true;
      _syncTimer?.cancel();
      // Best-effort flush on dispose.
      _flushNow();
    });

    final list =
        ref.read(dhikrCountersControllerProvider).valueOrNull ??
        const <DhikrCounter>[];
    final cached = list
        .where((c) => c.id == id)
        .cast<DhikrCounter?>()
        .firstOrNull;
    if (cached != null) return cached;

    // Fall back to a list refetch — keeps deep links / cold starts working.
    await ref.read(dhikrCountersControllerProvider.notifier).refresh();
    final refreshed =
        ref.read(dhikrCountersControllerProvider).valueOrNull ??
        const <DhikrCounter>[];
    final found = refreshed
        .where((c) => c.id == id)
        .cast<DhikrCounter?>()
        .firstOrNull;
    if (found != null) return found;

    throw StateError('Counter $id not found');
  }

  /// Increment the count by 1, optimistic + debounced sync.
  ///
  /// Returns the new local count and whether this hit a milestone (used by
  /// the screen to fire a heavy haptic and a flash animation).
  IncrementResult increment() {
    final current = state.valueOrNull;
    if (current == null) {
      return const IncrementResult(count: 0, isMilestone: false);
    }
    final next = current.count + 1;
    final updated = current.copyWith(count: next);
    state = AsyncValue.data(updated);
    ref.read(dhikrCountersControllerProvider.notifier).patchLocal(updated);

    _pendingDelta += 1;
    _unrecordedDelta += 1;
    _scheduleSync();

    return IncrementResult(
      count: next,
      isMilestone: _isMilestone(next, updated.targetCount),
    );
  }

  /// Reset the local count to 0 and sync to the server.
  Future<void> reset() async {
    final current = state.valueOrNull;
    if (current == null) return;
    final updated = current.copyWith(count: 0);
    state = AsyncValue.data(updated);
    ref.read(dhikrCountersControllerProvider.notifier).patchLocal(updated);
    _pendingDelta = 0;
    // Repetitions already said are not unsaid by resetting the bead count,
    // so anything still unrecorded is flushed to the engine rather than
    // dropped. Reset starts a new round; it is not an undo.
    _recordPending();
    _syncTimer?.cancel();

    try {
      final synced = await ref
          .read(dhikrRepositoryProvider)
          .updateCounter(id: id, setCount: 0);
      if (_disposed) return;
      state = AsyncValue.data(synced);
      ref.read(dhikrCountersControllerProvider.notifier).patchLocal(synced);
    } on Object catch (e, st) {
      developer.log('Reset counter failed', error: e, stackTrace: st);
    }
  }

  /// Update the target. Server sync is fire-and-forget; local state is
  /// updated immediately.
  Future<void> setTarget(int target) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final updated = current.copyWith(targetCount: target);
    state = AsyncValue.data(updated);
    ref.read(dhikrCountersControllerProvider.notifier).patchLocal(updated);

    try {
      final synced = await ref
          .read(dhikrRepositoryProvider)
          .updateCounter(id: id, targetCount: target);
      if (_disposed) return;
      state = AsyncValue.data(synced);
      ref.read(dhikrCountersControllerProvider.notifier).patchLocal(synced);
    } on Object catch (e, st) {
      developer.log('Set target failed', error: e, stackTrace: st);
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

  /// Tells the engine about every repetition not yet recorded, once.
  ///
  /// One event carrying the whole delta, not `delta` events of one. The
  /// server sums `quantity` (§2.4), so 33 taps are one queue row instead
  /// of thirty-three — which is the reason `quantity` exists. Called from
  /// the debounced sync rather than from `increment()` for the same reason
  /// the sync is debounced: a tap handler at 5 taps/second must not do a
  /// SQLite write per tap.
  ///
  /// Runs whether or not the dhikr API call succeeds. The dhikr *was*
  /// said; whether this app's counter table caught up with it is a
  /// different question, and the engine's queue is the durable one.
  void _recordPending() {
    if (_unrecordedDelta <= 0) return;
    final delta = _unrecordedDelta;
    // Zeroed before recording, and never restored — `record()` does not
    // throw, and re-queueing here is exactly the double-count this field
    // exists to prevent.
    _unrecordedDelta = 0;
    unawaited(
      ref
          .read(activityRecorderProvider)
          .record(ActivityType.dhikr, quantity: delta, sourceRef: 'dhikr:$id'),
    );
  }

  Future<void> _flushNow() async {
    _recordPending();
    if (_pendingDelta <= 0) return;
    final delta = _pendingDelta;
    _pendingDelta = 0;
    try {
      final synced = await ref
          .read(dhikrRepositoryProvider)
          .incrementCounter(id: id, by: delta);
      if (_disposed) return;
      state = AsyncValue.data(synced);
      ref.read(dhikrCountersControllerProvider.notifier).patchLocal(synced);
    } on Object catch (e, st) {
      developer.log(
        'Increment sync failed; re-queueing $delta',
        error: e,
        stackTrace: st,
      );
      // Re-queue the delta so the next flush retries. Only the dhikr
      // API's delta — never `_unrecordedDelta`, which is already spent.
      _pendingDelta += delta;
    }
  }

  bool _isMilestone(int count, int target) {
    if (count <= 0) return false;
    if (count == target) return true;
    if (count == 33 || count == 99 || count == 100) return true;
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
