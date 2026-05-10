import 'dart:developer' as developer;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/dhikr_repository.dart';
import '../../data/dtos/dhikr_goal.dart';

part 'dhikr_goals_controller.g.dart';

/// User's dhikr goals + creation flow.
@Riverpod(keepAlive: true)
class DhikrGoalsController extends _$DhikrGoalsController {
  @override
  Future<List<DhikrGoal>> build() async {
    final repo = ref.watch(dhikrRepositoryProvider);
    return repo.getGoals();
  }

  /// Re-fetches the goals list.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(dhikrRepositoryProvider).getGoals(),
    );
  }

  /// Creates a goal and prepends it to the local list.
  Future<DhikrGoal?> create({
    required String phrase,
    required int targetCount,
    required DhikrGoalPeriod period,
  }) async {
    try {
      final created = await ref
          .read(dhikrRepositoryProvider)
          .createGoal(phrase: phrase, targetCount: targetCount, period: period);
      final current = state.valueOrNull ?? const <DhikrGoal>[];
      state = AsyncValue.data([created, ...current]);
      return created;
    } on Object catch (e, st) {
      developer.log('Create goal failed', error: e, stackTrace: st);
      return null;
    }
  }
}
