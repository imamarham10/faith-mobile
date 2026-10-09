import 'package:faith_mobile/core/theme/app_theme.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:faith_mobile/features/today/domain/today_dashboard.dart';
import 'package:faith_mobile/features/today/presentation/controllers/today_dashboard_controller.dart';
import 'package:faith_mobile/features/today/presentation/widgets/practice_checklist.dart';
import 'package:faith_mobile/features/today/presentation/widgets/stat_tile_row.dart';
import 'package:faith_mobile/features/today/presentation/widgets/streak_chip.dart';
import 'package:faith_mobile/features/today/presentation/widgets/today_progress_section.dart';
import 'package:faith_mobile/features/today/presentation/widgets/week_strip.dart';
import 'package:faith_mobile/shared/widgets/milestone_ring.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_today_dashboard.dart';

/// Phone-shaped, and the narrowest width the project supports.
const _phone = Size(390, 844);
const _narrow = Size(320, 640);

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
      expect(find.text('892'), findsOneWidget); // dhikr this week
    });
  });

  group('honesty', () {
    testWidgets('omits the streak tile when there is no streak', (
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

    testWidgets('marks a streak that reaches the edge of known history', (
      tester,
    ) async {
      await pumpSection(
        tester,
        faith: FaithId.islam,
        dashboard: FakeTodayDashboard.flooredStreak(),
      );

      expect(find.text('20+'), findsOneWidget);
      expect(find.text('20'), findsNothing);
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
  });
}
