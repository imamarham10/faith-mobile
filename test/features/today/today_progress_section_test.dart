import 'package:faith_mobile/core/theme/app_theme.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:faith_mobile/features/hindu/habit_pack.dart';
import 'package:faith_mobile/features/today/domain/today_dashboard.dart';
import 'package:faith_mobile/features/today/presentation/controllers/today_dashboard_controller.dart';
import 'package:faith_mobile/features/today/presentation/widgets/practice_checklist.dart';
import 'package:faith_mobile/features/today/presentation/widgets/stat_tile_row.dart';
import 'package:faith_mobile/features/today/presentation/widgets/streak_chip.dart';
import 'package:faith_mobile/features/today/presentation/widgets/today_progress_section.dart';
import 'package:faith_mobile/features/today/presentation/widgets/week_strip.dart';
import 'package:faith_mobile/shared/widgets/mascot_view.dart';
import 'package:faith_mobile/shared/widgets/milestone_ring.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_today_dashboard.dart';

/// Phone-shaped, and the narrowest width the project supports.
const _phone = Size(390, 844);
const _narrow = Size(320, 640);

/// Any day that is not today, for the pure [DayProgress] assertions.
final _aClosedDay = DateTime(2026, 10, 5);

void main() {
  /// Pins the viewport so a golden is a layout assertion rather than a
  /// record of whatever surface the test host happens to have.
  void useViewport(WidgetTester tester, Size size) {
    tester.view.physicalSize = size * 3;
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
  }

  Future<void> pumpSection(
    WidgetTester tester, {
    required FaithId faith,
    required TodayDashboard dashboard,
    Size size = _phone,
    Brightness brightness = Brightness.light,
  }) async {
    useViewport(tester, size);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          todayDashboardProvider.overrideWith((ref) async => dashboard),
        ],
        child: MaterialApp(
          theme: brightness == Brightness.light
              ? AppTheme.light(faith)
              : AppTheme.dark(faith),
          home: const Scaffold(
            body: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: TodayProgressSection(),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('content', () {
    testWidgets('Islam renders five checklist rows and seven day rings', (
      tester,
    ) async {
      await pumpSection(
        tester,
        faith: FaithId.islam,
        dashboard: FakeTodayDashboard.islam(),
      );

      expect(find.byType(WeekStrip), findsOneWidget);
      expect(find.byType(MilestoneRing), findsNWidgets(7));
      expect(find.text('Fajr'), findsOneWidget);
      expect(find.text('Isha'), findsOneWidget);
      expect(find.text("TODAY'S GOAL"), findsOneWidget);
      expect(find.text('4'), findsWidgets);
      expect(find.text(' / 5 prayers'), findsNothing); // part of a TextSpan
    });

    testWidgets('Hindu renders three sandhya rows against the same skeleton', (
      tester,
    ) async {
      await pumpSection(
        tester,
        faith: FaithId.hindu,
        dashboard: FakeTodayDashboard.hindu(),
      );

      expect(find.byType(WeekStrip), findsOneWidget);
      expect(find.byType(MilestoneRing), findsNWidgets(7));
      expect(find.byType(PracticeChecklist), findsOneWidget);
      expect(find.text('Prātaḥ'), findsOneWidget);
      expect(find.text('Sāyaṁ'), findsOneWidget);
      // Parity: the same widgets, different content.
      expect(find.text('Fajr'), findsNothing);
      expect(find.text('Sandhya'), findsOneWidget);
      expect(find.text('Japa'), findsOneWidget);
    });

    testWidgets('never labels anything "points"', (tester) async {
      // Standing decision: the UI shows real units only. Points exist so a
      // cross-activity leaderboard is possible; they are never shown.
      for (final (faith, dashboard) in [
        (FaithId.islam, FakeTodayDashboard.islam()),
        (FaithId.hindu, FakeTodayDashboard.hindu()),
      ]) {
        await pumpSection(tester, faith: faith, dashboard: dashboard);
        expect(find.textContaining('oint'), findsNothing);
      }
    });

    testWidgets('the window selector swaps the tile values', (tester) async {
      await pumpSection(
        tester,
        faith: FaithId.islam,
        dashboard: FakeTodayDashboard.islam(),
      );

      expect(find.text('4'), findsWidgets); // prayers today
      expect(find.text('31'), findsNothing);

      await tester.tap(find.text('Week'));
      await tester.pumpAndSettle();

      expect(find.text('31'), findsOneWidget); // prayers this week
      expect(find.text('64'), findsOneWidget); // verses this week
      expect(find.text('892'), findsOneWidget); // dhikr this week
    });
  });

  group('honesty', () {
    testWidgets('the stat row never carries a streak tile at all', (
      tester,
    ) async {
      await pumpSection(
        tester,
        faith: FaithId.islam,
        dashboard: FakeTodayDashboard.empty(),
      );

      expect(find.byType(StatTileRow), findsOneWidget);
      expect(find.text('Day streak'), findsNothing);
      // ...and the one tile that *is* honest still renders.
      expect(find.text('Prayers'), findsOneWidget);
    });

    testWidgets('renders the server streak exactly, never a floor', (
      tester,
    ) async {
      // The old local derivation could only see its query window and so
      // reported `20+`. `/today`'s `streak.current` is exact however few
      // days of history the client fetched, and §6.2 caps that at 92 — so
      // a 200-day run must render as `200` beside a seven-ring strip, and
      // the `+` suffix is gone with the derivation that needed it.
      await pumpSection(
        tester,
        faith: FaithId.islam,
        dashboard: FakeTodayDashboard.longServerStreak(),
      );

      expect(find.byType(MilestoneRing), findsNWidgets(7));
      expect(find.textContaining('+'), findsNothing);
    });

    testWidgets('puts exactly one streak number on the screen', (tester) async {
      // The regression this guards is the reason `deriveStreak` and the
      // Hindu `PujaStats.currentStreak` read were retired in the same
      // change that wired the engine. Two sources with two definitions put
      // two different numbers in front of the user, which does not read as
      // a discrepancy — it reads as the app not knowing.
      for (final (faith, dashboard) in [
        (FaithId.islam, FakeTodayDashboard.islam()),
        (FaithId.hindu, FakeTodayDashboard.hindu()),
      ]) {
        useViewport(tester, _phone);
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              todayDashboardProvider.overrideWith((ref) async => dashboard),
            ],
            child: MaterialApp(
              theme: AppTheme.light(faith),
              home: const Scaffold(
                body: SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [StreakChip(), TodayProgressSection()],
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // The streak appears once, in the chip, and the stat row carries
        // no streak tile to contradict it.
        expect(find.byIcon(Icons.local_fire_department), findsOneWidget);
        expect(find.text('Day streak'), findsNothing);
        expect(
          find.descendant(
            of: find.byType(StreakChip),
            matching: find.text('12'),
          ),
          findsOneWidget,
        );
        expect(find.text('12'), findsOneWidget);
      }
    });

    testWidgets('a never-set goal prompts instead of showing 0 / 0', (
      tester,
    ) async {
      // §5.4 — `goal: null` is "never set one", and is categorically not a
      // goal sitting at zero. Every user passes through this state exactly
      // once, on the screen that forms their first impression, and until
      // they leave it §7.4 means no day can ever be met.
      await pumpSection(
        tester,
        faith: FaithId.islam,
        dashboard: FakeTodayDashboard.noGoal(),
      );

      expect(find.text('Set a goal'), findsOneWidget);
      expect(find.textContaining('/ 0'), findsNothing);
    });

    testWidgets('the goal prompt is there for Hindu too', (tester) async {
      await pumpSection(
        tester,
        faith: FaithId.hindu,
        dashboard: FakeTodayDashboard.noGoal(pack: hinduHabitPack),
      );

      expect(find.text('Set a goal'), findsOneWidget);
    });

    testWidgets('a closed day fills from goalMet, not from done/target', (
      tester,
    ) async {
      // §6.3 — the strip reads `goalMet`; it does not re-derive one. A
      // closed day scored against the goal in force *then* can legitimately
      // be met on 2 of a target that now reads 5, and re-deriving would
      // both contradict the server and backdate a goal change (§7.4).
      final closed = DayProgress(
        day: _aClosedDay,
        done: 2,
        target: 5,
        goalMet: true,
        isToday: false,
      );
      expect(closed.fraction, 1.0);
      expect(closed.isComplete, isTrue);

      // ...and the open day is the one day that may show a fraction,
      // because it is the one day §7.4 re-evaluates.
      final open = DayProgress(
        day: _aClosedDay,
        done: 2,
        target: 5,
        goalMet: false,
        isToday: true,
      );
      expect(open.fraction, closeTo(0.4, 0.001));
      expect(open.isComplete, isFalse);
    });

    testWidgets('the chip draws nothing without a streak', (tester) async {
      useViewport(tester, _phone);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            todayDashboardProvider.overrideWith(
              (ref) async => FakeTodayDashboard.empty(),
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.light(FaithId.islam),
            home: const Scaffold(body: StreakChip()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.local_fire_department), findsNothing);
    });
  });

  group('320px', () {
    testWidgets('lays out without overflowing at the narrowest width', (
      tester,
    ) async {
      // The week strip and a five-cell checklist in 280 logical pixels is
      // exactly the thing that breaks here, so this is a regression test
      // rather than a one-off screenshot. A RenderFlex overflow would fail
      // the test through the framework's own error reporting.
      await pumpSection(
        tester,
        faith: FaithId.islam,
        dashboard: FakeTodayDashboard.islam(),
        size: _narrow,
      );

      expect(tester.takeException(), isNull);
      expect(find.byType(MilestoneRing), findsNWidgets(7));
      expect(find.text('Maghrib'), findsOneWidget);
    });

    testWidgets('holds for Hindu too', (tester) async {
      await pumpSection(
        tester,
        faith: FaithId.hindu,
        dashboard: FakeTodayDashboard.hindu(),
        size: _narrow,
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Mādhyāhna'), findsOneWidget);
    });
  });

  group('goldens', () {
    // Machine-local: `flutter_test_config.dart` disables google_fonts'
    // runtime fetching, so text renders in the test host's fallback face.
    // These assert layout — box positions and sizes — not glyph shapes, and
    // are regenerated with `flutter test --update-goldens`.
    testWidgets('islam', (tester) async {
      await pumpSection(
        tester,
        faith: FaithId.islam,
        dashboard: FakeTodayDashboard.islam(),
      );
      await expectLater(
        find.byType(TodayProgressSection),
        matchesGoldenFile('goldens/today_progress_islam.png'),
      );
    });

    testWidgets('hindu', (tester) async {
      await pumpSection(
        tester,
        faith: FaithId.hindu,
        dashboard: FakeTodayDashboard.hindu(),
      );
      await expectLater(
        find.byType(TodayProgressSection),
        matchesGoldenFile('goldens/today_progress_hindu.png'),
      );
    });

    testWidgets('islam dark', (tester) async {
      await pumpSection(
        tester,
        faith: FaithId.islam,
        dashboard: FakeTodayDashboard.islam(),
        brightness: Brightness.dark,
      );
      await expectLater(
        find.byType(TodayProgressSection),
        matchesGoldenFile('goldens/today_progress_islam_dark.png'),
      );
    });

    testWidgets('hindu dark', (tester) async {
      await pumpSection(
        tester,
        faith: FaithId.hindu,
        dashboard: FakeTodayDashboard.hindu(),
        brightness: Brightness.dark,
      );
      await expectLater(
        find.byType(TodayProgressSection),
        matchesGoldenFile('goldens/today_progress_hindu_dark.png'),
      );
    });

    testWidgets('islam at 320px', (tester) async {
      await pumpSection(
        tester,
        faith: FaithId.islam,
        dashboard: FakeTodayDashboard.islam(),
        size: _narrow,
      );
      await expectLater(
        find.byType(TodayProgressSection),
        matchesGoldenFile('goldens/today_progress_islam_320.png'),
      );
    });

    testWidgets('hindu at 320px', (tester) async {
      await pumpSection(
        tester,
        faith: FaithId.hindu,
        dashboard: FakeTodayDashboard.hindu(),
        size: _narrow,
      );
      await expectLater(
        find.byType(TodayProgressSection),
        matchesGoldenFile('goldens/today_progress_hindu_320.png'),
      );
    });

    // The never-set-a-goal card, which is the only place `MascotState.sleep`
    // ships. It had no golden and no reachable device state, so without
    // these the one state the illustration pass set out to render was the
    // one nobody had looked at.
    //
    // `sleep` is also the only MascotState safe in this file: `idle` and
    // `encourage` call `.animate(onPlay: (c) => c.repeat(...))`, and an
    // endlessly repeating animation hangs `pumpAndSettle` forever.
    testWidgets('islam with no goal set', (tester) async {
      await pumpSection(
        tester,
        faith: FaithId.islam,
        dashboard: FakeTodayDashboard.noGoal(),
      );
      expect(find.byType(MascotView), findsOneWidget);
      await expectLater(
        find.byType(TodayProgressSection),
        matchesGoldenFile('goldens/today_progress_islam_nogoal.png'),
      );
    });

    testWidgets('hindu with no goal set', (tester) async {
      await pumpSection(
        tester,
        faith: FaithId.hindu,
        dashboard: FakeTodayDashboard.noGoal(pack: hinduHabitPack),
      );
      expect(find.byType(MascotView), findsOneWidget);
      await expectLater(
        find.byType(TodayProgressSection),
        matchesGoldenFile('goldens/today_progress_hindu_nogoal.png'),
      );
    });

    testWidgets('islam with no goal set, dark', (tester) async {
      await pumpSection(
        tester,
        faith: FaithId.islam,
        dashboard: FakeTodayDashboard.noGoal(),
        brightness: Brightness.dark,
      );
      await expectLater(
        find.byType(TodayProgressSection),
        matchesGoldenFile('goldens/today_progress_islam_nogoal_dark.png'),
      );
    });

    testWidgets('hindu with no goal set, dark', (tester) async {
      await pumpSection(
        tester,
        faith: FaithId.hindu,
        dashboard: FakeTodayDashboard.noGoal(pack: hinduHabitPack),
        brightness: Brightness.dark,
      );
      await expectLater(
        find.byType(TodayProgressSection),
        matchesGoldenFile('goldens/today_progress_hindu_nogoal_dark.png'),
      );
    });
  });
}
