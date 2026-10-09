import 'package:faith_mobile/shared/habit/activity_event.dart';
import 'package:faith_mobile/shared/habit/streak_engine.dart';
import 'package:flutter_test/flutter_test.dart';

/// Ported case for case from the server's `rollup.service.spec.ts`
/// (backend `feat/retention-engine`, task `ae6833f`) rather than written
/// fresh, because the point of this engine is not that it is defensible in
/// isolation — it is that it returns the same number the server does. A
/// parallel suite that happened to agree on today's cases would drift the
/// first time either side learned something.
///
/// Nothing here reads [DateTime.now]: every case pins `today`, so the suite
/// means the same thing on any host and at any hour.
void main() {
  // ------------------------------------------------------------- fixtures

  /// One event, as `ActivityRecorder` would have stamped it.
  ActivityEvent event({
    required String localDay,
    ActivityType type = ActivityType.quranVerse,
    int quantity = 1,
    String timezone = 'Asia/Kolkata',
  }) => ActivityEvent(
    clientEventId: '$localDay-$type-$quantity-${timezone.hashCode}',
    activityType: type,
    quantity: quantity,
    occurredAt: DateTime.utc(
      int.parse(localDay.substring(0, 4)),
      int.parse(localDay.substring(5, 7)),
      int.parse(localDay.substring(8, 10)),
      6,
    ),
    localDay: localDay,
    timezone: timezone,
  );

  final goal5 = DailyGoal(goalType: GoalType.verses, target: 5);

  /// The goal-met days from a day-indexed event stream.
  ///
  /// **This is not the Task 1.12 pattern, and must not be copied as one.**
  /// Scoring days from local events against the one current goal is
  /// precisely what `streak_engine.dart`'s header forbids for *closed*
  /// days — the server scores those against the goal in force on each of
  /// them (§7.5). It stands in here for the open day and for days still
  /// sitting in the queue unflushed, which are the only days a client may
  /// legitimately score itself; the cases that need a long history build
  /// their met-days directly.
  List<String> metDaysOf(
    Map<String, List<ActivityEvent>> byDay,
    DailyGoal? goal,
  ) =>
      (byDay.entries
            .where(
              (e) => dayProgress(counts: sumCounts(e.value), goal: goal).met,
            )
            .map((e) => e.key)
            .toList())
        ..sort();

  /// Every day in `[from, to]`, for building long runs without typing them.
  List<String> run(String from, String to) => daysInRange(from, to);

  // ======================================================= §2.4  goal met

  group('goalMet (§2.4)', () {
    test('counts SUM(quantity), not COUNT(events)', () {
      // Target 12. One event of 12 and twelve events of 1 are the same act
      // of worship logged with different granularity and must be
      // indistinguishable. A COUNT implementation scores the first as 1
      // (not met) and the second as 12 (met) — the Qur'an reader's
      // batching strategy would silently decide whether the user kept
      // their streak.
      final goal = DailyGoal(goalType: GoalType.verses, target: 12);

      final one = dayProgress(
        counts: sumCounts([event(localDay: '2026-10-08', quantity: 12)]),
        goal: goal,
      );
      final twelve = dayProgress(
        counts: sumCounts([
          for (var i = 0; i < 12; i++)
            event(localDay: '2026-10-08', quantity: 1),
        ]),
        goal: goal,
      );

      expect(one.counts, {'quran_verse': 12});
      expect(twelve.counts, {'quran_verse': 12});
      expect(one.progress, 12);
      expect(twelve.progress, 12);
      expect(one.met, isTrue);
      expect(twelve.met, isTrue);
    });

    test(
      'counts only the activity type the goalType names, but reports all',
      () {
        final counts = sumCounts([
          event(localDay: '2026-10-08', quantity: 40),
          event(localDay: '2026-10-08', type: ActivityType.prayer, quantity: 3),
          event(localDay: '2026-10-08', type: ActivityType.dhikr, quantity: 33),
        ]);

        final progress = dayProgress(
          counts: counts,
          goal: DailyGoal(goalType: GoalType.prayers, target: 5),
        );

        // §5.3 — every non-zero type is a key; zero totals are absent.
        expect(progress.counts, {'quran_verse': 40, 'prayer': 3, 'dhikr': 33});
        expect(progress.progress, 3);
        expect(progress.met, isFalse); // 3 prayers < 5, despite 40 verses
      },
    );

    test('a goal with no events is an empty ring, not a missing goal', () {
      // §2.4 / §5.4 — `goal: null` means no UserGoal row is in force, never
      // "no events". Conflating them shows the goal-setting prompt to a
      // user who has already set a goal and simply has not started today.
      final set = dayProgress(counts: const {}, goal: goal5);
      expect(set.progress, 0);
      expect(set.met, isFalse);

      final none = dayProgress(
        counts: sumCounts([event(localDay: '2026-10-08', quantity: 99)]),
        goal: null,
      );
      expect(none.counts, {'quran_verse': 99});
      expect(none.progress, 0);
      expect(none.met, isFalse); // the server never invents a default target
    });

    test('merges the server\'s counts with events still in the queue', () {
      final merged = mergeCounts(
        const {'quran_verse': 3, 'prayer': 5},
        sumCounts([
          event(localDay: '2026-10-08', quantity: 2),
          event(localDay: '2026-10-08', type: ActivityType.dhikr, quantity: 33),
        ]),
      );

      expect(merged, {'quran_verse': 5, 'prayer': 5, 'dhikr': 33});
      expect(dayProgress(counts: merged, goal: goal5).met, isTrue);
    });

    test('rejects a target outside §1.3\'s range for the goal type', () {
      expect(
        () => DailyGoal(goalType: GoalType.prayers, target: 6),
        throwsArgumentError,
      );
      expect(
        () => DailyGoal(goalType: GoalType.verses, target: 0),
        throwsArgumentError,
      );
      expect(DailyGoal(goalType: GoalType.malas, target: 108).target, 108);
    });
  });

  // ================================================= §2.5, §2.6  the streak

  group('streak projection (§2.5, §2.6)', () {
    test(
      'keeps the streak when the user flies Asia/Kolkata to Europe/London',
      () {
        // `localDay` is stamped by the device (§2.1) and `timezone` is stored
        // but never consulted (§2.2), so a zone change mid-run is simply
        // three consecutive local days. This is the guard against anyone
        // "improving" the day arithmetic into a timezone conversion, at which
        // point the Oct 9 boundary would move and the run would split.
        final days = metDaysOf({
          '2026-10-08': [
            event(
              localDay: '2026-10-08',
              quantity: 5,
              timezone: 'Asia/Kolkata',
            ),
          ],
          '2026-10-09': [
            event(
              localDay: '2026-10-09',
              quantity: 2,
              timezone: 'Asia/Kolkata',
            ),
            event(
              localDay: '2026-10-09',
              quantity: 3,
              timezone: 'Europe/London',
            ),
          ],
          '2026-10-10': [
            event(
              localDay: '2026-10-10',
              quantity: 5,
              timezone: 'Europe/London',
            ),
          ],
        }, goal5);

        expect(days, ['2026-10-08', '2026-10-09', '2026-10-10']);

        final streak = computeStreak(days, '2026-10-10');
        expect(streak.current, 3);
        expect(streak.lastGoalMetDay, '2026-10-10');
        expect(streak.freezesLeft, 2);
      },
    );

    test('does not drop a day across the Europe/London DST transition', () {
      // 2026-10-25 is when British Summer Time ENDS: the clocks go back and
      // the day is 25 hours long, not 23. (A 23-hour day would be
      // 2026-03-29.) Either way the hazard is the same — step a day by
      // adding 24 hours to a local midnight and the two days collapse into
      // one, and the user is robbed of a day they earned.
      //
      // The engine is structurally immune because every step goes through
      // `DateTime.utc`, which has no transitions at all.
      //
      // Worth being honest about what these three assertions can and
      // cannot catch: rewriting `addDays` to step a *local* midnight is
      // indistinguishable from the real thing on a host with no DST, and
      // verified to be — the suite passes under that sabotage on an
      // `Asia/Kolkata` host and fails on `TZ=Europe/London`, where the
      // 25th + 1 day returns the 25th again. The step below is the
      // hazardous one, chosen so the test bites wherever a host can tell
      // the difference; `localDayIn` further down pins the half of the
      // hazard that bites on every host.
      expect(addDays('2026-10-25', 1), '2026-10-26');
      expect(addDays('2026-10-24', 1), '2026-10-25');
      expect(daysBetween('2026-10-24', '2026-10-26'), 2);
      expect(daysInRange('2026-10-24', '2026-10-26'), [
        '2026-10-24',
        '2026-10-25',
        '2026-10-26',
      ]);

      final days = metDaysOf({
        '2026-10-24': [
          event(localDay: '2026-10-24', quantity: 5, timezone: 'Europe/London'),
        ],
        '2026-10-25': [
          event(localDay: '2026-10-25', quantity: 5, timezone: 'Europe/London'),
        ],
      }, goal5);

      final streak = computeStreak(days, '2026-10-25');
      expect(streak.current, 2);
      expect(streak.longest, 2);
      expect(streak.lastGoalMetDay, '2026-10-25');
    });

    test('consumes a freeze for exactly one missed day and no more', () {
      // Met Oct 7, 8, _gap Oct 9_, 10, 11. Today is Oct 11.
      final streak = computeStreak([
        '2026-10-07',
        '2026-10-08',
        '2026-10-10',
        '2026-10-11',
      ], '2026-10-11');

      // Four goal-met days. The frozen day BRIDGES but does not COUNT —
      // §6.3 says the same from the other side: a frozen day shows
      // goalMet:false and the streak survives it.
      expect(streak.current, 4);
      // Exactly one freeze, not two, and not one per day of the run.
      expect(streak.freezesLeft, 1);
      expect(streak.freezeResetOn, '2026-11-01');
      expect(streak.lastGoalMetDay, '2026-10-11');
    });

    test(
      'breaks when two consecutive days are missed and one freeze remains',
      () {
        // Oct 02 met, Oct 03 met, Oct 04 MISSED (freeze #1 bridges it),
        // Oct 05 met, Oct 06 met, Oct 07 + Oct 08 MISSED (needs two, one
        // left), Oct 09 met, Oct 10 met. Today is Oct 10.
        final streak = computeStreak([
          '2026-10-02',
          '2026-10-03',
          '2026-10-05',
          '2026-10-06',
          '2026-10-09',
          '2026-10-10',
        ], '2026-10-10');

        // The run Oct 02..Oct 06 is four met days bridged by one freeze. The
        // two-day gap cannot be paid for, so the streak restarts at Oct 09.
        expect(streak.current, 2);
        expect(streak.longest, 4);
        expect(streak.lastGoalMetDay, '2026-10-10');

        // The contrast that proves the freeze count is what broke it: the
        // same day sequence with a full allowance bridges straight through.
        final withBothFreezes = computeStreak([
          '2026-10-05',
          '2026-10-06',
          '2026-10-09',
          '2026-10-10',
        ], '2026-10-10');
        expect(withBothFreezes.current, 4);
        expect(withBothFreezes.freezesLeft, 0);
      },
    );

    test('a failed bridge charges nothing', () {
      // Server-pinned and unstated in the contract. Paying for a gap is
      // all-or-nothing: a freeze spent on a bridge that then fails has
      // bought the user nothing, and charging for it would quietly cost
      // them a freeze they could have used the next day.
      //
      // Oct 02..Oct 06 as above spends ONE freeze on Oct 04. The Oct 07 +
      // Oct 08 gap needs two and cannot be paid; it must leave the count
      // where it was rather than draining the last one.
      expect(
        computeStreak([
          '2026-10-02',
          '2026-10-03',
          '2026-10-05',
          '2026-10-06',
          '2026-10-09',
          '2026-10-10',
        ], '2026-10-10').freezesLeft,
        1,
      );

      // The plainer statement of the same rule: a user who broke their
      // streak on Oct 07 with one freeze left still has it on Oct 10.
      final broken = computeStreak([
        '2026-10-01',
        '2026-10-03', // Oct 02 bridged — one freeze spent
        '2026-10-04',
        '2026-10-05',
        '2026-10-06',
        '2026-10-10', // Oct 07, 08, 09 missed — three days, one freeze
      ], '2026-10-10');
      expect(broken.current, 1); // the run restarted at Oct 10
      expect(broken.longest, 5); // Oct 01 + the bridged Oct 03..06
      expect(broken.freezesLeft, 1); // NOT 0
    });

    test('charges each bridged day to the allowance of its own month', () {
      // Under-specified in §2.6 and resolved server-side: a gap day is
      // charged to the month it falls in. A single running budget would let
      // two freezes bridge arbitrarily long gaps anywhere in history, and
      // streaks would be effectively unbreakable.
      //
      // Sep 29 met, Sep 30 + Oct 01 missed, Oct 02 met: one freeze from
      // each month's allowance, so October still shows one left.
      final streak = computeStreak([
        '2026-09-28',
        '2026-09-29',
        '2026-10-02',
        '2026-10-03',
      ], '2026-10-03');

      expect(streak.current, 4);
      expect(streak.freezesLeft, 1); // October's allowance, not September's
      expect(streak.freezeResetOn, '2026-11-01');

      // The other side of the same rule, and the moment the user actually
      // notices it: September's spending does not follow them into
      // October. Sep 29 met, Sep 30 + Oct 01 missed is one freeze from
      // each — but a gap wholly inside September costs October nothing.
      final septemberOnly = computeStreak([
        '2026-09-26',
        '2026-09-29', // Sep 27 + Sep 28 bridged: both of September's
        '2026-09-30',
        '2026-10-01',
        '2026-10-02',
      ], '2026-10-02');
      expect(septemberOnly.current, 5);
      expect(septemberOnly.freezesLeft, 2); // the allowance came back

      // And the same two-day gap inside one month costs that month both.
      expect(
        computeStreak([
          '2026-10-01',
          '2026-10-04',
          '2026-10-05',
        ], '2026-10-05').freezesLeft,
        0,
      );
    });

    test(
      'reproduces the contract worked example on both sides of the goal',
      () {
        // §2.6's table, which is the test for lazy consumption:
        //   morning of Oct 27, goal not yet met  -> current 25, freezesLeft 2
        //   Oct 27 after the goal is met         -> current 26, freezesLeft 1
        // The eager implementation shows freezesLeft 1 all morning, and §2.7
        // then overrides it on the next sync — the user watches their freeze
        // count change for no reason.
        final oct1to25 = run('2026-10-01', '2026-10-25'); // Oct 26 absent

        final morning = computeStreak(oct1to25, '2026-10-27');
        expect(morning.current, 25);
        expect(morning.freezesLeft, 2);
        expect(morning.lastGoalMetDay, '2026-10-25');

        final evening = computeStreak([
          ...oct1to25,
          '2026-10-27',
        ], '2026-10-27');
        // 25 + today, NOT 27 — Oct 26 bridges, it does not count.
        expect(evening.current, 26);
        expect(evening.freezesLeft, 1);
        expect(evening.lastGoalMetDay, '2026-10-27');
      },
    );

    test('includes today if and only if the goal is met today (§2.5)', () {
      final met = ['2026-10-06', '2026-10-07', '2026-10-08'];

      // Morning of Oct 9, nothing logged yet. The run does not drop to 2.
      expect(computeStreak(met, '2026-10-09').current, 3);
      expect(computeStreak([...met, '2026-10-09'], '2026-10-09').current, 4);
    });

    test(
      'is zero once the last met day is further back than freezes reach',
      () {
        // §2.5's closing sentence. The trailing gap is TESTED for payability
        // but never CHARGED (§2.6) — which is why `freezesLeft` is still 2.
        final met = ['2026-10-01', '2026-10-02', '2026-10-03'];

        // Oct 4 and Oct 5 missed: two freezes would cover them, so alive —
        // and testing that payability must not spend them. An eager
        // implementation reports 0 here and is overridden on the next sync.
        final alive = computeStreak(met, '2026-10-06');
        expect(alive.current, 3);
        expect(alive.freezesLeft, 2);

        // Oct 4, 5 and 6 missed: three days, two freezes. Dead.
        final dead = computeStreak(met, '2026-10-07');
        expect(dead.current, 0);
        expect(dead.longest, 3); // the record survives
        expect(dead.lastGoalMetDay, '2026-10-03'); // still reported
        expect(dead.freezesLeft, 2); // the trailing gap charged nothing

        // And a user who last met their goal in 2024 is not shown a streak.
        final ancient = computeStreak(
          run('2024-01-01', '2024-03-01'),
          '2026-10-09',
        );
        expect(ancient.current, 0);
        expect(ancient.longest, 61);
        expect(ancient.lastGoalMetDay, '2024-03-01');
      },
    );

    test('gives a user with no goal-met days a zero-valued projection', () {
      expect(
        computeStreak(const [], '2026-10-08'),
        const StreakProjection(
          current: 0,
          longest: 0,
          lastGoalMetDay: null,
          freezesLeft: 2,
          freezeResetOn: '2026-11-01',
        ),
      );
    });

    test(
      'ignores met days after today, so a tampered clock cannot anchor it',
      () {
        // §2.2 accepts a self-consistent tampered pair deliberately, so the
        // projection has to be the thing that refuses to count forward.
        final streak = computeStreak([
          '2026-10-07',
          '2026-10-08',
          '2027-05-01',
        ], '2026-10-08');

        expect(streak.current, 2);
        expect(streak.lastGoalMetDay, '2026-10-08');
      },
    );

    test('normalises its input, so duplicate and unsorted days are safe', () {
      // The client assembles met days from two sources — /history for
      // closed days and the local queue for open ones — so the same day can
      // arrive twice and out of order.
      expect(
        computeStreak([
          '2026-10-08',
          '2026-10-06',
          '2026-10-07',
          '2026-10-08',
        ], '2026-10-08'),
        computeStreak(['2026-10-06', '2026-10-07', '2026-10-08'], '2026-10-08'),
      );
    });

    test(
      'longest is the computed run, and the caller owns "never decreases"',
      () {
        // §2.5's "longest never decreases" is `max(computed, persisted)` and
        // belongs to whoever holds the last /today response: a client that
        // has only fetched a 92-day window cannot know about a longer run
        // behind it, so inventing the max here would be a lie.
        final full = run('2026-10-01', '2026-10-05');
        expect(computeStreak(full, '2026-10-05').longest, 5);
        expect(computeStreak(full, '2026-10-02').longest, 2);
      },
    );

    test('freezeResetOn rolls the year over', () {
      expect(
        computeStreak(const ['2026-12-31'], '2026-12-31').freezeResetOn,
        '2027-01-01',
      );
      expect(firstDayOfNextMonth('2026-01-31'), '2026-02-01');
      expect(firstDayOfNextMonth('2026-02-28'), '2026-03-01');
    });
  });

  // ============================================== §5.2  which day is it

  group('localDay derivation (§5.2)', () {
    test('matches Intl.DateTimeFormat semantics, not Date\'s UTC methods', () {
      // The two the server verified. Reading UTC components answers
      // 2026-10-08 for both, which is wrong for half the user base.
      final instant = DateTime.utc(2026, 10, 8, 20, 30);
      expect(localDayIn('Asia/Kolkata', instant), '2026-10-09');
      expect(localDayIn('America/Los_Angeles', instant), '2026-10-08');
      expect(localDayIn('UTC', instant), '2026-10-08');
    });

    test('puts a UTC+14 user a day ahead and a UTC-11 user a day behind', () {
      final instant = DateTime.utc(2026, 10, 8, 12);
      expect(localDayIn('Pacific/Kiritimati', instant), '2026-10-09');
      expect(localDayIn('Pacific/Niue', instant), '2026-10-08');
      expect(
        localDayIn('Pacific/Kiritimati', DateTime.utc(2026, 10, 8, 23)),
        '2026-10-09',
      );
      expect(
        localDayIn('Pacific/Niue', DateTime.utc(2026, 10, 9, 3)),
        '2026-10-08',
      );
    });

    test('follows Europe/London across the end of British Summer Time', () {
      // 23:30Z on Oct 24 is 00:30 on Oct 25 in London, because BST is still
      // in force — the clocks do not go back until 02:00 local on the 25th.
      // A UTC-components implementation answers 2026-10-24 and loses the
      // user a day of their streak. This is the half of the DST hazard a
      // host clock can actually get wrong, and it bites on any host.
      expect(
        localDayIn('Europe/London', DateTime.utc(2026, 10, 24, 23, 30)),
        '2026-10-25',
      );
      // 23:30Z on Oct 25 is 23:30 local — GMT by then, so still Oct 25.
      expect(
        localDayIn('Europe/London', DateTime.utc(2026, 10, 25, 23, 30)),
        '2026-10-25',
      );
      expect(
        localDayIn('Europe/London', DateTime.utc(2026, 10, 26, 0, 30)),
        '2026-10-26',
      );
    });

    test('returns null for a zone the bundled database does not carry', () {
      // `package:timezone` ships the canonical zones but not the backward
      // links, so an Android device reporting `Asia/Calcutta` — which the
      // server accepts, because Intl knows every alias — has no entry. Null
      // rather than a guess: every fallback here is a *wrong day*, and the
      // caller's fallback (the device's own clock, via localDayOf) is right
      // by construction for the only zone that matters on device.
      expect(localDayIn('Asia/Calcutta', DateTime.utc(2026, 10, 8)), isNull);
      expect(localDayIn('Not/AZone', DateTime.utc(2026, 10, 8)), isNull);
      expect(localDayIn('Asia/Kolkata', DateTime.utc(2026, 10, 8)), isNotNull);
    });

    test('localDayOf reads the device\'s own calendar components', () {
      final at = DateTime(2026, 10, 9, 2, 15);
      expect(localDayOf(at), '2026-10-09');
      // Same instant, expressed in UTC: still the device's day, because
      // `toLocal()` undoes the conversion. This is the property that keeps
      // the engine's `today` equal to the `localDay` the recorder stamps.
      expect(localDayOf(at.toUtc()), '2026-10-09');
    });
  });

  // =================================================== calendar arithmetic

  group('day arithmetic', () {
    test('steps across month, year and leap-day boundaries', () {
      expect(addDays('2026-10-31', 1), '2026-11-01');
      expect(addDays('2026-11-01', -1), '2026-10-31');
      expect(addDays('2026-12-31', 1), '2027-01-01');
      expect(addDays('2027-01-01', -1), '2026-12-31');
      expect(addDays('2028-02-28', 1), '2028-02-29'); // 2028 is a leap year
      expect(addDays('2026-02-28', 1), '2026-03-01');
    });

    test('daysBetween is signed and counts calendar days', () {
      expect(daysBetween('2026-10-01', '2026-10-08'), 7);
      expect(daysBetween('2026-10-08', '2026-10-01'), -7);
      expect(daysBetween('2026-09-30', '2026-10-01'), 1);
      expect(daysBetween('2026-10-08', '2026-10-08'), 0);
      expect(daysBetween('2026-01-01', '2027-01-01'), 365);
    });

    test('daysInRange is dense, inclusive and empty when reversed', () {
      expect(daysInRange('2026-10-08', '2026-10-08'), ['2026-10-08']);
      expect(daysInRange('2026-10-09', '2026-10-08'), isEmpty);
      // Distinct as well as dense: local-midnight arithmetic repeats a
      // date on the day a DST zone's clocks go back, which shows up as a
      // duplicate here rather than a short list.
      final year = daysInRange('2026-01-01', '2026-12-31');
      expect(year, hasLength(365));
      expect(year.toSet(), hasLength(365));
      expect(year.last, '2026-12-31');
      expect(daysInRange('2028-01-01', '2028-12-31'), hasLength(366));
    });

    test('monthKey is the allowance key', () {
      expect(monthKey('2026-09-30'), '2026-09');
      expect(monthKey('2026-10-01'), '2026-10');
    });
  });
}
