import 'package:freezed_annotation/freezed_annotation.dart';

part 'japa_goal.freezed.dart';
part 'japa_goal.g.dart';

/// Period a japa goal repeats over. Mirrors Dhikr's `DhikrGoalPeriod` shape
/// (kept as a separate type — faith modules don't share types cross-faith).
enum JapaGoalPeriod {
  @JsonValue('daily')
  daily,
  @JsonValue('weekly')
  weekly,
  @JsonValue('monthly')
  monthly,
}

extension JapaGoalPeriodX on JapaGoalPeriod {
  String get apiValue => switch (this) {
    JapaGoalPeriod.daily => 'daily',
    JapaGoalPeriod.weekly => 'weekly',
    JapaGoalPeriod.monthly => 'monthly',
  };

  String get label => switch (this) {
    JapaGoalPeriod.daily => 'Daily',
    JapaGoalPeriod.weekly => 'Weekly',
    JapaGoalPeriod.monthly => 'Monthly',
  };
}

/// `POST /api/v1/hindu/japa/goals` request + response shape.
///
/// Richer than Dhikr's goal: the backend decorates `GET /goals` with
/// computed `currentCount`/`progressPercent`/`daysRemaining`/`isComplete`
/// fields (summed from history rows server-side), so the client doesn't
/// need to compute progress itself. `startDate`/`endDate` are required on
/// creation, unlike Dhikr goals which have no date range.
@freezed
abstract class JapaGoal with _$JapaGoal {
  const factory JapaGoal({
    required String id,
    String? userId,
    required String mantraSanskrit,
    required int targetCount,
    @Default(0) int currentCount,
    required JapaGoalPeriod period,
    required DateTime startDate,
    required DateTime endDate,
    DateTime? createdAt,
    @Default(0) double progressPercent,
    @Default(0) int daysRemaining,
    @Default(false) bool isComplete,
  }) = _JapaGoal;

  factory JapaGoal.fromJson(Map<String, dynamic> json) =>
      _$JapaGoalFromJson(json);
}
