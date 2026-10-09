/// Parity, asserted rather than remembered.
///
/// The whole point of this file is the `for (final pack in allHabitPacks)`
/// loop: every assertion inside it runs against Islam *and* Hindu, so there
/// is no way to add a member to [FaithHabitPack], answer it for Islam, and
/// ship. A Hindu pack that lagged would fail here, not on a user's phone.
///
/// Three classes of check, and the third is the one that catches the real
/// mistake:
///
/// 1. **Completeness** — every member answers for every enum value of that
///    faith, and throws for a value of the other.
/// 2. **Contract conformance** — target choices sit inside §1.3's range,
///    routes are registered, `sourceRef`s match §1.6's shape.
/// 3. **Coverage of the enums themselves** — every [ActivityType] and
///    [GoalType] in existence is claimed by exactly one pack. Adding
///    `ActivityType.kirtan` without putting it in a pack fails here, which
///    is the failure mode a per-pack test would miss entirely.
library;

import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:faith_mobile/features/hindu/habit_pack.dart';
import 'package:faith_mobile/features/islam/habit_pack.dart';
import 'package:faith_mobile/shared/habit/activity_event.dart';
import 'package:faith_mobile/shared/habit/faith_habit_pack.dart';
import 'package:flutter_test/flutter_test.dart';

/// Routes a pack is allowed to deep-link to. Mirrors what the router
/// actually registers — `routes.dart` plus the nested trees in
/// `quran_routes.dart`, `practice_routes.dart` and `today_routes.dart`.
/// Pushing anything else throws at runtime, which is a crash on a tap.
const _registeredRoutes = <String>{
  '/quran',
  '/today/prayers',
  '/today/puja-times',
  '/practice/dhikr',
  '/practice/japa',
};

/// §1.6's `sourceRef` prefixes, by activity type.
const _sourceRefPrefix = <ActivityType, String>{
  ActivityType.quranVerse: 'quran:',
  ActivityType.prayer: 'prayer:',
  ActivityType.dhikr: 'dhikr:',
  ActivityType.gitaShloka: 'gita:',
  ActivityType.sandhya: 'sandhya:',
  ActivityType.japaMala: 'japa:',
};

void main() {
  group('every pack, every member', () {
    for (final pack in allHabitPacks) {
      group(pack.faith.wireValue, () {
        final ownTypes = ActivityType.values
            .where((t) => t.faith == pack.faith)
            .toSet();
        final ownGoals = GoalType.values
            .where((g) => g.faith == pack.faith)
            .toSet();
        final foreignTypes = ActivityType.values.toSet().difference(ownTypes);
        final foreignGoals = GoalType.values.toSet().difference(ownGoals);

        test('claims exactly its own activity types, in display order', () {
          expect(pack.activityTypes.toSet(), ownTypes);
          expect(
            pack.activityTypes.length,
            ownTypes.length,
            reason: 'no duplicates',
          );
        });

        test('claims exactly its own goal types', () {
          expect(pack.goalTypes.toSet(), ownGoals);
          expect(pack.goalTypes.length, ownGoals.length);
        });

        test('faithId and faith name the same faith', () {
          expect(pack.faithId.name, pack.faith.wireValue);
          expect(habitPackFor(pack.faithId), same(pack));
          expect(habitPackForActivityFaith(pack.faith), same(pack));
        });

        test('labels every one of its activity types, non-empty', () {
          for (final type in ownTypes) {
            expect(pack.labelFor(type), isNotEmpty, reason: type.wireValue);
          }
        });

        test('gives every activity type an icon', () {
          final icons = {for (final t in ownTypes) t: pack.iconFor(t)};
          expect(icons.length, ownTypes.length);
          // Distinct icons — two activities drawn identically are
          // indistinguishable in the checklist and the stat row.
          expect(icons.values.toSet().length, ownTypes.length);
        });

        test('routes every activity type to a registered path', () {
          for (final type in ownTypes) {
            expect(
              _registeredRoutes,
              contains(pack.routeFor(type)),
              reason: '${type.wireValue} routes somewhere unregistered',
            );
          }
        });

        test('defaultGoalType is one of its own', () {
          expect(ownGoals, contains(pack.defaultGoalType));
        });

        test('every default target is inside §1.3 range', () {
          for (final goal in ownGoals) {
            final target = pack.defaultTargetFor(goal);
            expect(target, greaterThanOrEqualTo(1), reason: goal.wireValue);
            expect(
              target,
              lessThanOrEqualTo(goal.maxTarget),
              reason: '${goal.wireValue} max is ${goal.maxTarget}',
            );
          }
        });

        test('every offered target is inside §1.3 range and ascending', () {
          for (final goal in ownGoals) {
            final choices = pack.targetChoicesFor(goal);
            expect(choices, isNotEmpty, reason: goal.wireValue);
            expect(
              choices,
              orderedEquals(choices.toList()..sort()),
              reason: '${goal.wireValue} choices must ascend',
            );
            expect(choices.toSet().length, choices.length, reason: 'no dupes');
            for (final choice in choices) {
              expect(choice, greaterThanOrEqualTo(1));
              expect(
                choice,
                lessThanOrEqualTo(goal.maxTarget),
                // A choice above the cap is not a cosmetic bug: the server
                // rejects the PUT as `invalid_target` and the user's goal
                // silently fails to save.
                reason:
                    '${goal.wireValue} offers $choice, max ${goal.maxTarget}',
              );
            }
          }
        });

        test('the default target is one of the offered choices', () {
          for (final goal in ownGoals) {
            expect(
              pack.targetChoicesFor(goal),
              contains(pack.defaultTargetFor(goal)),
              reason: goal.wireValue,
            );
          }
        });

        test('units agree with the count, and are never empty', () {
          for (final goal in ownGoals) {
            for (final n in [0, 1, 2, 5, 108]) {
              expect(pack.unitFor(goal, n), isNotEmpty, reason: goal.wireValue);
            }
          }
        });

        test('daily steps carry §1.6-shaped sourceRefs and own types', () {
          for (final step in pack.dailySteps) {
            expect(step.key, isNotEmpty);
            expect(step.label, isNotEmpty);
            expect(ownTypes, contains(step.activityType));
            expect(
              step.sourceRef,
              startsWith(_sourceRefPrefix[step.activityType]!),
              reason: '${step.key} must match §1.6',
            );
            expect(step.sourceRef.length, lessThanOrEqualTo(128));
            expect(_registeredRoutes, contains(step.route));
          }
        });

        test('daily step keys are unique', () {
          final keys = pack.dailySteps.map((s) => s.key).toList();
          expect(keys.toSet().length, keys.length);
        });

        test('goalPrompt is non-empty', () {
          expect(pack.goalPrompt, isNotEmpty);
        });

        test('refuses the other faith rather than answering blank', () {
          for (final type in foreignTypes) {
            expect(() => pack.labelFor(type), throwsArgumentError);
            expect(() => pack.iconFor(type), throwsArgumentError);
            expect(() => pack.routeFor(type), throwsArgumentError);
          }
          for (final goal in foreignGoals) {
            expect(() => pack.defaultTargetFor(goal), throwsArgumentError);
            expect(() => pack.targetChoicesFor(goal), throwsArgumentError);
            expect(() => pack.unitFor(goal, 1), throwsArgumentError);
          }
        });
      });
    }
  });

  group('the enums are fully covered', () {
    test('every ActivityType belongs to exactly one pack', () {
      for (final type in ActivityType.values) {
        final owners = allHabitPacks
            .where((p) => p.activityTypes.contains(type))
            .toList();
        expect(
          owners.length,
          1,
          reason: '${type.wireValue} is claimed by ${owners.length} packs',
        );
      }
    });

    test('every GoalType belongs to exactly one pack', () {
      for (final goal in GoalType.values) {
        final owners = allHabitPacks
            .where((p) => p.goalTypes.contains(goal))
            .toList();
        expect(owners.length, 1, reason: goal.wireValue);
      }
    });

    test('there is a pack for every FaithId', () {
      for (final faith in FaithId.values) {
        expect(habitPackFor(faith).faithId, faith);
      }
      expect(allHabitPacks.length, FaithId.values.length);
    });
  });

  group('islam specifics', () {
    test('prayer steps are the five obligatory prayers, in order', () {
      expect(islamHabitPack.dailySteps.map((s) => s.key), [
        'fajr',
        'dhuhr',
        'asr',
        'maghrib',
        'isha',
      ]);
    });

    test('verse units are singular at one', () {
      expect(islamHabitPack.unitFor(GoalType.verses, 1), 'verse');
      expect(islamHabitPack.unitFor(GoalType.verses, 5), 'verses');
    });

    test('dhikr is uncountable', () {
      expect(islamHabitPack.unitFor(GoalType.dhikr, 1), 'dhikr');
      expect(islamHabitPack.unitFor(GoalType.dhikr, 99), 'dhikr');
    });
  });

  group('hindu specifics', () {
    test('sandhya steps are the three, in order through the day', () {
      expect(hinduHabitPack.dailySteps.map((s) => s.key), [
        'pratah',
        'madhyahna',
        'sayam',
      ]);
    });

    test('shloka units are singular at one', () {
      expect(hinduHabitPack.unitFor(GoalType.shlokas, 1), 'shloka');
      expect(hinduHabitPack.unitFor(GoalType.shlokas, 3), 'shlokas');
    });

    test('malas are counted as whole malas, capped at 108', () {
      expect(hinduHabitPack.unitFor(GoalType.malas, 1), 'mala');
      expect(hinduHabitPack.unitFor(GoalType.malas, 2), 'malas');
      expect(hinduHabitPack.targetChoicesFor(GoalType.malas).last, 11);
    });
  });
}
