/// Islam's content pack for the habit engine.
///
/// Task 1.11. Every Islamic string, icon and route the engine renders is
/// here. Nothing below `lib/shared/habit/` imports this file; the engine
/// reaches it only through [FaithHabitPack], so the Hindu pack next door is
/// substitutable at every call site.
///
/// The counterpart is `lib/features/hindu/habit_pack.dart`, and the two are
/// held level by `test/shared/habit/faith_habit_pack_test.dart`, which runs
/// one body over both.
library;

import 'package:flutter/material.dart';

import '../../core/theme/faith_id.dart';
import '../../shared/habit/activity_event.dart';
import '../../shared/habit/faith_habit_pack.dart';

/// The Islam pack. One instance, const, no state.
const IslamHabitPack islamHabitPack = IslamHabitPack();

/// Labels, icons, goal types and deep links for Islam.
class IslamHabitPack implements FaithHabitPack {
  /// Builds the pack. Const — it holds only literals.
  const IslamHabitPack();

  @override
  ActivityFaith get faith => ActivityFaith.islam;

  @override
  FaithId get faithId => FaithId.islam;

  @override
  List<ActivityType> get activityTypes => const [
    ActivityType.prayer,
    ActivityType.quranVerse,
    ActivityType.dhikr,
  ];

  @override
  List<GoalType> get goalTypes => const [
    GoalType.prayers,
    GoalType.verses,
    GoalType.dhikr,
  ];

  /// Verses, not prayers.
  ///
  /// The five prayers are an obligation the user already carries; making
  /// them the default goal turns a duty into a score, and a missed Fajr
  /// into a broken streak. Reading is the thing a daily nudge actually
  /// moves, so that is what the app offers to count first.
  @override
  GoalType get defaultGoalType => GoalType.verses;

  @override
  int defaultTargetFor(GoalType goalType) => switch (goalType) {
    GoalType.verses => 5,
    GoalType.prayers => 5,
    GoalType.dhikr => 33,
    _ => throw ArgumentError.value(goalType, 'goalType', 'not an Islam goal'),
  };

  @override
  List<int> targetChoicesFor(GoalType goalType) => switch (goalType) {
    GoalType.verses => const [1, 3, 5, 10, 20, 50],
    // 1…5 and no further: there are five obligatory prayers and §1.3 caps
    // `prayers` at 5, so every other choice would be rejected as
    // `invalid_target`.
    GoalType.prayers => const [1, 2, 3, 4, 5],
    // The tasbih counts: 33 (one third of the post-prayer tasbih), 99, 100,
    // and a thousand for those who keep one.
    GoalType.dhikr => const [11, 33, 99, 100, 500, 1000],
    _ => throw ArgumentError.value(goalType, 'goalType', 'not an Islam goal'),
  };

  @override
  String labelFor(ActivityType type) => switch (type) {
    ActivityType.quranVerse => 'Verses',
    ActivityType.prayer => 'Prayers',
    ActivityType.dhikr => 'Dhikr',
    _ => throw ArgumentError.value(type, 'type', 'not an Islam activity'),
  };

  @override
  IconData iconFor(ActivityType type) => switch (type) {
    ActivityType.quranVerse => Icons.menu_book_outlined,
    ActivityType.prayer => Icons.mosque_outlined,
    ActivityType.dhikr => Icons.radio_button_checked,
    _ => throw ArgumentError.value(type, 'type', 'not an Islam activity'),
  };

  @override
  String routeFor(ActivityType type) => switch (type) {
    ActivityType.quranVerse => '/quran',
    ActivityType.prayer => '/today/prayers',
    ActivityType.dhikr => '/practice/dhikr',
    _ => throw ArgumentError.value(type, 'type', 'not an Islam activity'),
  };

  @override
  String unitFor(GoalType goalType, int count) => switch (goalType) {
    GoalType.verses => count == 1 ? 'verse' : 'verses',
    GoalType.prayers => count == 1 ? 'prayer' : 'prayers',
    // Uncountable in English as it is used here — "33 dhikr", never
    // "33 dhikrs".
    GoalType.dhikr => 'dhikr',
    _ => throw ArgumentError.value(goalType, 'goalType', 'not an Islam goal'),
  };

  /// The five obligatory prayers, in order.
  ///
  /// The keys are exactly what `GET /prayers/log` returns, lowercased, so
  /// the checklist can be matched against the log without a lookup table.
  /// They were previously inlined in `today_dashboard_controller.dart`,
  /// which is the duplication this pack exists to end.
  @override
  List<HabitStep> get dailySteps => const [
    HabitStep(
      key: 'fajr',
      label: 'Fajr',
      activityType: ActivityType.prayer,
      sourceRef: 'prayer:fajr',
      route: '/today/prayers',
    ),
    HabitStep(
      key: 'dhuhr',
      label: 'Dhuhr',
      activityType: ActivityType.prayer,
      sourceRef: 'prayer:dhuhr',
      route: '/today/prayers',
    ),
    HabitStep(
      key: 'asr',
      label: 'Asr',
      activityType: ActivityType.prayer,
      sourceRef: 'prayer:asr',
      route: '/today/prayers',
    ),
    HabitStep(
      key: 'maghrib',
      label: 'Maghrib',
      activityType: ActivityType.prayer,
      sourceRef: 'prayer:maghrib',
      route: '/today/prayers',
    ),
    HabitStep(
      key: 'isha',
      label: 'Isha',
      activityType: ActivityType.prayer,
      sourceRef: 'prayer:isha',
      route: '/today/prayers',
    ),
  ];

  @override
  String get goalPrompt => 'Set a daily goal to start your streak';
}
