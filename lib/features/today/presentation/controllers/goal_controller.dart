/// Setting the daily goal.
///
/// Task 1.12, and scope the plan never named. Tasks 1.8–1.15 build the
/// recorder, the queue, the flush, the streak engine, the content packs and
/// the Today screen — and not one of them ever calls `PUT /activity/goal`.
/// Without it `/today` returns `goal: null` for every user forever (§5.4),
/// `met` is permanently `false` (§2.4), and §7.4 is explicit about the
/// consequence: *"the streak begins on the first day the user both has a
/// goal and meets it."* The engine would have shipped unable to count.
///
/// The UI was needed regardless: §5.4 requires the client to distinguish
/// `goal: null` — show the prompt — from a goal at `progress: 0` — show the
/// empty ring. A prompt that cannot be acted on is not a prompt.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/time/device_timezone.dart';
import '../../../../shared/habit/activity_event.dart';
import '../../data/activity_repository.dart';
import 'today_dashboard_controller.dart';

part 'goal_controller.g.dart';

/// Writes the user's daily goal and refreshes the screen from the result.
@riverpod
class GoalController extends _$GoalController {
  @override
  FutureOr<void> build() {}

  /// Sets the goal for [faith] and reloads the dashboard.
  ///
  /// §7.3 — the response re-evaluates today against the **new** goal, so
  /// the card could be updated straight from it. The snapshot provider is
  /// invalidated instead, because changing `goalType` changes which
  /// activity is counted and therefore every number on the screen at once:
  /// the ring, the week strip and the streak all move together, and one
  /// refetch is both simpler and more honest than patching three of them.
  ///
  /// Throws on failure so the sheet can say so. A goal that silently failed
  /// to save is worse than one that visibly did — the user would spend days
  /// wondering why their streak never starts.
  Future<void> setGoal({
    required ActivityFaith faith,
    required GoalType goalType,
    required int target,
  }) async {
    state = const AsyncValue.loading();
    try {
      await ref
          .read(activityRepositoryProvider)
          .putGoal(
            faith: faith,
            goalType: goalType,
            target: target,
            // §7.4 — decides which `localDay` the goal takes effect from.
            // Sent always: the server's fallbacks exist for robustness, not
            // for use.
            timezone: DeviceTimezone.instance.current,
          );
      ref.invalidate(activitySnapshotProvider(faith));
      state = const AsyncValue.data(null);
    } on Object catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}
