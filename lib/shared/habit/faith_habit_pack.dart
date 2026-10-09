/// The one interface every faith answers, and the only place faith-specific
/// strings are allowed to live.
///
/// Task 1.11. The habit engine below this line is deliberately faith-blind:
/// [ActivityType] and [GoalType] carry wire values and arithmetic, the queue
/// carries rows, the streak engine carries days. None of them knows that
/// `quran_verse` is called "Verses" in English, that it is drawn with an
/// open book, or that tapping it should go to `/quran`. That knowledge is
/// here, twice — once per faith — and nowhere else.
///
/// ## Why an interface rather than a map or a switch
///
/// A `switch (faith)` in the Today controller works exactly as long as
/// someone remembers to add the Hindu arm, and the compiler only forces the
/// arm to *exist*, not to be complete. The parity rule this project runs on
/// is stronger than that: **both faiths or neither**. An interface plus the
/// test next door — which iterates [allHabitPacks] and asserts every member
/// answers for every one of that faith's enum values — turns "the Hindu pack
/// forgot `japa_mala`" from a blank label at runtime into a red test.
///
/// Adding a third faith is therefore: one more implementation, one more
/// entry in [allHabitPacks], and the existing test immediately covers it.
library;

import 'package:flutter/widgets.dart';

import '../../core/theme/faith_id.dart';
import '../../features/hindu/habit_pack.dart';
import '../../features/islam/habit_pack.dart';
import 'activity_event.dart';

/// One named act that makes up a day's practice — a prayer, a sandhya.
///
/// The checklist on Today renders these. They exist only for the faith's
/// *discrete* activity: five prayers and three sandhyas are enumerable acts
/// with names, where verses and dhikr repetitions are a count and have none.
///
/// [sourceRef] is the §1.6 value the act is recorded under, and it is held
/// here rather than built at the call site so the format lives in exactly
/// one place per faith.
@immutable
class HabitStep {
  /// Builds a step.
  const HabitStep({
    required this.key,
    required this.label,
    required this.activityType,
    required this.sourceRef,
    required this.route,
  });

  /// The server's lowercase key for this act — `fajr`, `pratah`. Matches
  /// what the prayer and puja log endpoints return, so a step can be
  /// looked up against them without a translation table.
  final String key;

  /// What the user reads: `Fajr`, `Prātaḥ`.
  final String label;

  /// What recording this step records.
  final ActivityType activityType;

  /// §1.6's reference for this act — `prayer:fajr`, `sandhya:pratah`.
  final String sourceRef;

  /// Where tapping it goes: a screen that can complete the act.
  final String route;
}

/// Everything the habit engine needs to render one faith.
///
/// Every member is asserted against every enum value of the faith by
/// `test/shared/habit/faith_habit_pack_test.dart`, which runs one body over
/// [allHabitPacks]. A member added here without a Hindu answer fails that
/// test rather than shipping a blank.
abstract interface class FaithHabitPack {
  /// The faith this pack speaks for, in the engine's vocabulary.
  ActivityFaith get faith;

  /// The same faith in the app's vocabulary, for theme and preference
  /// lookups. Two enums because the wire contract (§1.1) and the app's
  /// routing predate each other; the pack is where they meet.
  FaithId get faithId;

  /// Every [ActivityType] this faith records, in display order.
  ///
  /// Must be exactly the types whose [ActivityType.faith] is [faith] —
  /// no fewer (a missing one can never be labelled) and no more (a type
  /// from another faith would be rejected by the server as
  /// `activity_type_faith_mismatch`).
  List<ActivityType> get activityTypes;

  /// Every [GoalType] this faith offers, in the order the goal picker shows
  /// them. Same completeness rule as [activityTypes].
  List<GoalType> get goalTypes;

  /// The goal pre-selected when the user has never set one.
  GoalType get defaultGoalType;

  /// The target pre-selected for [goalType] in the picker.
  ///
  /// Deliberately modest — 5 verses, 1 mala. A default a user fails on day
  /// one teaches them the streak is not for them.
  int defaultTargetFor(GoalType goalType);

  /// The targets the picker offers for [goalType], ascending. Every value
  /// must be within `1…goalType.maxTarget` (§1.3) or the server rejects it
  /// as `invalid_target`.
  List<int> targetChoicesFor(GoalType goalType);

  /// Title-case name of an activity: `Verses`, `Prayers`, `Shlokas`.
  String labelFor(ActivityType type);

  /// The icon that activity carries across the app.
  IconData iconFor(ActivityType type);

  /// Where to send someone who wants to do [type] now. Must be a registered
  /// route — an unregistered one throws when pushed.
  String routeFor(ActivityType type);

  /// The unit a goal counts in, agreeing with [count]: `1 verse`,
  /// `5 verses`. Returns the noun only; the caller supplies the numeral.
  String unitFor(GoalType goalType, int count);

  /// The named acts of the day, in the order they happen. May be empty for
  /// a faith whose practice has no enumerable steps.
  List<HabitStep> get dailySteps;

  /// What the goal card says when `goal` is `null` — the user has never set
  /// one (§5.4). Not "0 / 0": a zero target and no target are different
  /// things and only one of them is an invitation.
  String get goalPrompt;
}

/// Every pack, in faith order. The parity test iterates this.
const List<FaithHabitPack> allHabitPacks = <FaithHabitPack>[
  islamHabitPack,
  hinduHabitPack,
];

/// The pack for [faith].
FaithHabitPack habitPackFor(FaithId faith) => switch (faith) {
  FaithId.islam => islamHabitPack,
  FaithId.hindu => hinduHabitPack,
};

/// The pack for an [ActivityFaith], for code holding the wire enum.
FaithHabitPack habitPackForActivityFaith(ActivityFaith faith) =>
    switch (faith) {
      ActivityFaith.islam => islamHabitPack,
      ActivityFaith.hindu => hinduHabitPack,
    };
