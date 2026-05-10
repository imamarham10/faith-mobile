import 'package:freezed_annotation/freezed_annotation.dart';

part 'dhikr_goal.freezed.dart';
part 'dhikr_goal.g.dart';

/// Period a dhikr goal repeats over.
enum DhikrGoalPeriod {
  @JsonValue('daily')
  daily,
  @JsonValue('weekly')
  weekly,
  @JsonValue('monthly')
  monthly,
}

extension DhikrGoalPeriodX on DhikrGoalPeriod {
  String get apiValue => switch (this) {
    DhikrGoalPeriod.daily => 'daily',
    DhikrGoalPeriod.weekly => 'weekly',
    DhikrGoalPeriod.monthly => 'monthly',
  };

  String get label => switch (this) {
    DhikrGoalPeriod.daily => 'Daily',
    DhikrGoalPeriod.weekly => 'Weekly',
    DhikrGoalPeriod.monthly => 'Monthly',
  };
}

/// `POST /api/v1/islam/dhikr/goals` request + response shape.
@freezed
abstract class DhikrGoal with _$DhikrGoal {
  const factory DhikrGoal({
    required String id,
    String? userId,
    String? phraseArabic,
    String? phraseEnglish,
    required int targetCount,
    @Default(0) int currentCount,
    required DhikrGoalPeriod period,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
  }) = _DhikrGoal;

  factory DhikrGoal.fromJson(Map<String, dynamic> json) =>
      _$DhikrGoalFromJson(json);
}
