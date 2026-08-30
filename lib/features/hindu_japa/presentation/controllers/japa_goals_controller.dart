import 'dart:developer' as developer;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/dtos/japa_goal.dart';
import '../../data/hindu_japa_repository.dart';

part 'japa_goals_controller.g.dart';

/// User's japa goals + creation flow.
@Riverpod(keepAlive: true)
class JapaGoalsController extends _$JapaGoalsController {
  @override
  Future<List<JapaGoal>> build() async {
    final repo = ref.watch(hinduJapaRepositoryProvider);
    return repo.getGoals();
  }

  /// Re-fetches the goals list.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(hinduJapaRepositoryProvider).getGoals(),
    );
  }

  /// Creates a goal and prepends it to the local list.
  Future<JapaGoal?> create({
    required String mantraSanskrit,
    required int targetCount,
    required JapaGoalPeriod period,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final created = await ref
          .read(hinduJapaRepositoryProvider)
          .createGoal(
            mantraSanskrit: mantraSanskrit,
            targetCount: targetCount,
            period: period,
            startDate: startDate,
            endDate: endDate,
          );
      final current = state.valueOrNull ?? const <JapaGoal>[];
      state = AsyncValue.data([created, ...current]);
      return created;
    } on Object catch (e, st) {
      developer.log('Create japa goal failed', error: e, stackTrace: st);
      return null;
    }
  }
}
