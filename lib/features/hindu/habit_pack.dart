/// Hindu's content pack for the habit engine.
///
/// Task 1.11. The mirror of `lib/features/islam/habit_pack.dart`, and the
/// reason the parity test exists: a Hindu pack that silently lagged the
/// Islam one would show blanks on a screen nobody on the team uses daily,
/// which is exactly how the "both faiths or neither" rule gets broken in
/// practice. `test/shared/habit/faith_habit_pack_test.dart` runs one body
/// over both packs so neither can fall behind.
library;

import 'package:flutter/material.dart';

import '../../core/theme/faith_id.dart';
import '../../shared/habit/activity_event.dart';
import '../../shared/habit/faith_habit_pack.dart';

/// The Hindu pack. One instance, const, no state.
const HinduHabitPack hinduHabitPack = HinduHabitPack();

/// Labels, icons, goal types and deep links for Hindu practice.
class HinduHabitPack implements FaithHabitPack {
  /// Builds the pack. Const — it holds only literals.
  const HinduHabitPack();

  @override
  ActivityFaith get faith => ActivityFaith.hindu;

  @override
  FaithId get faithId => FaithId.hindu;

  @override
  List<ActivityType> get activityTypes => const [
    ActivityType.sandhya,
    ActivityType.gitaShloka,
    ActivityType.japaMala,
  ];

  @override
  List<GoalType> get goalTypes => const [
    GoalType.sandhyas,
    GoalType.shlokas,
    GoalType.malas,
  ];

  /// Shlokas, matching Islam's choice of verses for the same reason: the
  /// reading is what a daily nudge moves, where the sandhyas are an
  /// observance the user already keeps.
  @override
  GoalType get defaultGoalType => GoalType.shlokas;

  @override
  int defaultTargetFor(GoalType goalType) => switch (goalType) {
    GoalType.shlokas => 3,
    GoalType.sandhyas => 3,
    GoalType.malas => 1,
    _ => throw ArgumentError.value(goalType, 'goalType', 'not a Hindu goal'),
  };

  @override
  List<int> targetChoicesFor(GoalType goalType) => switch (goalType) {
    GoalType.shlokas => const [1, 3, 5, 10, 18, 50],
    // Three sandhyas and §1.3 caps `sandhyas` at 3; anything above is
    // rejected as `invalid_target`.
    GoalType.sandhyas => const [1, 2, 3],
    // A mala is 108 beads, so these are whole malas, not beads. §1.3 caps
    // `malas` at 108.
    GoalType.malas => const [1, 2, 3, 5, 11],
    _ => throw ArgumentError.value(goalType, 'goalType', 'not a Hindu goal'),
  };

  @override
  String labelFor(ActivityType type) => switch (type) {
    ActivityType.gitaShloka => 'Shlokas',
    ActivityType.sandhya => 'Sandhya',
    ActivityType.japaMala => 'Japa',
    _ => throw ArgumentError.value(type, 'type', 'not a Hindu activity'),
  };

  @override
  IconData iconFor(ActivityType type) => switch (type) {
    ActivityType.gitaShloka => Icons.auto_stories_outlined,
    ActivityType.sandhya => Icons.wb_twilight,
    ActivityType.japaMala => Icons.blur_circular,
    _ => throw ArgumentError.value(type, 'type', 'not a Hindu activity'),
  };

  @override
  String routeFor(ActivityType type) => switch (type) {
    // `/quran` is the shared scripture tab — [FaithTabRouter] renders the
    // Hindu scripture index there. The reader itself lives at
    // `/quran/hindu-scripture/:slug/:chapter`, whose slug comes from the
    // server, so the index is the deepest link that is safe to hardcode.
    ActivityType.gitaShloka => '/quran',
    ActivityType.sandhya => '/today/puja-times',
    ActivityType.japaMala => '/practice/japa',
    _ => throw ArgumentError.value(type, 'type', 'not a Hindu activity'),
  };

  @override
  String unitFor(GoalType goalType, int count) => switch (goalType) {
    GoalType.shlokas => count == 1 ? 'shloka' : 'shlokas',
    // Sanskrit, and uncountable as used here — "3 sandhya", the way the
    // existing Today card already reads.
    GoalType.sandhyas => 'sandhya',
    GoalType.malas => count == 1 ? 'mala' : 'malas',
    _ => throw ArgumentError.value(goalType, 'goalType', 'not a Hindu goal'),
  };

  /// The three sandhyas, in order through the day.
  ///
  /// Keys are what `GET /puja-times/log` returns. Previously inlined in
  /// `today_dashboard_controller.dart`, whose comment said outright that
  /// they belonged here.
  @override
  List<HabitStep> get dailySteps => const [
    HabitStep(
      key: 'pratah',
      label: 'Prātaḥ',
      activityType: ActivityType.sandhya,
      sourceRef: 'sandhya:pratah',
      route: '/today/puja-times',
    ),
    HabitStep(
      key: 'madhyahna',
      label: 'Mādhyāhna',
      activityType: ActivityType.sandhya,
      sourceRef: 'sandhya:madhyahna',
      route: '/today/puja-times',
    ),
    HabitStep(
      key: 'sayam',
      label: 'Sāyaṁ',
      activityType: ActivityType.sandhya,
      sourceRef: 'sandhya:sayam',
      route: '/today/puja-times',
    ),
  ];

  @override
  String get goalPrompt => 'Set a daily goal to start your streak';
}
