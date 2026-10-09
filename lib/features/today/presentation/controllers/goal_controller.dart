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
///
/// ## Why this holds no state, and is `keepAlive`
///
/// It was first written as an `AsyncValue<void>` notifier, and on the
/// device that produced the worst possible outcome: the `PUT` landed, the
/// goal card behind the sheet updated to the new target — and the sheet
/// said *"Couldn't save your goal."*
///
/// The cause is disposal, and every test passed through it. The sheet calls
/// `ref.read(...notifier)` without ever watching the provider, so an
/// auto-dispose notifier has no listeners and is disposed the moment the
/// `await` yields — and the `ref.invalidate` on the next line disposes it
/// for certain. Assigning `state` afterwards throws `StateError`, which the
/// `catch` dutifully reported as a failed save.
///
/// So there is no state to assign. The sheet owns its own `_saving` flag,
/// which is the only progress anything renders, and this is `keepAlive`
/// with a plain method: nothing to dispose, nothing to race.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/time/device_timezone.dart';
import '../../../../shared/habit/activity_event.dart';
import '../../data/activity_repository.dart';
import 'today_dashboard_controller.dart';

part 'goal_controller.g.dart';

/// Writes the user's daily goal and refreshes the screen from the result.
class GoalWriter {
  /// Builds a writer over [ref].
  const GoalWriter(this._ref);

  final Ref _ref;

  /// Sets the goal for [faith] and reloads the dashboard.
  ///
  /// §7.3 — the response re-evaluates today against the **new** goal, so
  /// the card could be updated straight from it. The snapshot provider is
  /// invalidated instead, because changing `goalType` changes which
  /// activity is counted and therefore every number on the screen at once:
  /// the ring, the week strip and the streak all move together, and one
  /// refetch is both simpler and more honest than patching three of them.
  ///
  /// Throws on failure so the sheet can say so — and **only** on failure.
  /// A goal that silently failed to save is worse than one that visibly
  /// did: the user would spend days wondering why their streak never
  /// starts. The inverse, which this file's doc describes, is worse still.
  Future<void> setGoal({
    required ActivityFaith faith,
    required GoalType goalType,
    required int target,
  }) async {
    await _ref
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
    _ref.invalidate(activitySnapshotProvider(faith));
  }
}

/// The app's goal writer.
@Riverpod(keepAlive: true)
GoalWriter goalWriter(Ref ref) => GoalWriter(ref);
