import 'dart:async';

import 'package:faith_mobile/core/theme/app_theme.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:faith_mobile/features/today/domain/today_dashboard.dart';
import 'package:faith_mobile/features/today/presentation/controllers/below_fold_gate.dart';
import 'package:faith_mobile/features/today/presentation/controllers/today_dashboard_controller.dart';
import 'package:faith_mobile/features/today/presentation/widgets/week_strip.dart';
import 'package:faith_mobile/features/today/presentation/widgets/week_strip_section.dart';
import 'package:faith_mobile/shared/widgets/milestone_ring.dart';
import 'package:faith_mobile/shared/widgets/poppy_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_today_dashboard.dart';

/// The week strip after it was lifted out of `TodayProgressSection` to the
/// top of Today.
///
/// Three things are being guarded here, and only the first is cosmetic:
///
///  1. the strip still renders seven rings, for both faiths, at the
///     narrowest supported width;
///  2. it is **not a card** — in this design system a card is a button,
///     and the strip offers nothing to press (see
///     `non_interactive_chrome_test.dart` for the rule);
///  3. it, and nothing else, releases the below-the-fold gate.
///
/// Plus the state this widget did not have when it lived mid-screen: what
/// it looks like before the dashboard has answered, now that it is the
/// first thing on the screen.
const _phone = Size(390, 844);
const _narrow = Size(320, 640);

void main() {
  void useViewport(WidgetTester tester, Size size) {
    tester.view.physicalSize = size * 3;
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
  }

  Widget host({
    required FaithId faith,
    required Override dashboard,
    Brightness brightness = Brightness.light,
  }) => ProviderScope(
    overrides: [dashboard],
    child: MaterialApp(
      theme: brightness == Brightness.light
          ? AppTheme.light(faith)
          : AppTheme.dark(faith),
      home: const Scaffold(
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Align(
            alignment: Alignment.topCenter,
            child: WeekStripSection(),
          ),
        ),
      ),
    ),
  );

  Future<void> pumpLoaded(
    WidgetTester tester, {
    required FaithId faith,
    required TodayDashboard dashboard,
    Size size = _phone,
    Brightness brightness = Brightness.light,
  }) async {
    useViewport(tester, size);
    await tester.pumpWidget(
      host(
        faith: faith,
        brightness: brightness,
        dashboard: todayDashboardProvider.overrideWith((ref) async => dashboard),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// Pumps the strip against a dashboard that never answers, and hands back
  /// the completer so the test can decide when — or whether — it does.
  Future<Completer<TodayDashboard>> pumpPending(
    WidgetTester tester, {
    FaithId faith = FaithId.islam,
    Size size = _phone,
  }) async {
    useViewport(tester, size);
    final pending = Completer<TodayDashboard>();
    await tester.pumpWidget(
      host(
        faith: faith,
        dashboard: todayDashboardProvider.overrideWith((ref) => pending.future),
      ),
    );
    await tester.pump();
    return pending;
  }

  bool gateOf(WidgetTester tester) => ProviderScope.containerOf(
    tester.element(find.byType(WeekStripSection)),
  ).read(belowFoldGateProvider);

  group('loaded', () {
    testWidgets('renders seven rings for Islam', (tester) async {
      await pumpLoaded(
        tester,
        faith: FaithId.islam,
        dashboard: FakeTodayDashboard.islam(),
      );

      expect(find.byType(WeekStrip), findsOneWidget);
      expect(find.byType(MilestoneRing), findsNWidgets(7));
    });

    testWidgets('and seven for Hindu, through the same widget', (tester) async {
      await pumpLoaded(
        tester,
        faith: FaithId.hindu,
        dashboard: FakeTodayDashboard.hindu(),
      );

      expect(find.byType(WeekStrip), findsOneWidget);
      expect(find.byType(MilestoneRing), findsNWidgets(7));
    });

    testWidgets('survives 280 logical pixels of usable width', (tester) async {
      // Seven rings across a 320px screen minus two 20px margins. A
      // RenderFlex overflow fails this through the framework's own error
      // reporting.
      await pumpLoaded(
        tester,
        faith: FaithId.islam,
        dashboard: FakeTodayDashboard.islam(),
        size: _narrow,
      );

      expect(tester.takeException(), isNull);
      expect(find.byType(MilestoneRing), findsNWidgets(7));
    });

    testWidgets('marks today, and only today', (tester) async {
      await pumpLoaded(
        tester,
        faith: FaithId.islam,
        dashboard: FakeTodayDashboard.islam(),
      );

      expect(
        find.bySemanticsLabel(RegExp(r'^Today, ')),
        findsOneWidget,
        reason: 'the rolling window ends on today and nowhere else',
      );
    });
  });

  group('it is a readout, not a control', () {
    // The standing rule: in this design system a card *is* a button. The
    // strip reports; it has nothing to press, so it must not look pressable
    // and must not offer a hit target that does nothing.
    testWidgets('is not built from a card', (tester) async {
      await pumpLoaded(
        tester,
        faith: FaithId.islam,
        dashboard: FakeTodayDashboard.islam(),
      );

      expect(find.byType(PoppyCard), findsNothing);
    });

    testWidgets('offers nothing to tap', (tester) async {
      await pumpLoaded(
        tester,
        faith: FaithId.islam,
        dashboard: FakeTodayDashboard.islam(),
      );

      expect(find.byType(InkWell), findsNothing);
      expect(find.byType(GestureDetector), findsNothing);
    });
  });

  group('before the dashboard answers', () {
    testWidgets('it draws the week anyway, at the same size', (tester) async {
      // The point of the whole `WeekStrip.unknown` branch: this block is
      // above the fold now, and `activitySnapshotCache` is in memory only,
      // so a cold start has nothing here for seconds. Reserving the exact
      // final geometry is what stops the screen reflowing underneath the
      // user when the numbers land.
      final pending = await pumpPending(tester);

      expect(find.byType(MilestoneRing), findsNWidgets(7));
      final pendingSize = tester.getSize(find.byType(WeekStrip));

      pending.complete(FakeTodayDashboard.islam());
      await tester.pumpAndSettle();

      expect(
        tester.getSize(find.byType(WeekStrip)),
        pendingSize,
        reason: 'the loaded strip must occupy exactly the pending one',
      );
    });

    testWidgets('it says the progress is unknown rather than zero', (
      tester,
    ) async {
      // `MilestoneRing` paints no arc for `progress <= 0`, so an unknown
      // ring and a genuine zero-day ring are pixel-identical. Anything
      // that claimed "0 of 0" here would be telling a user who practised
      // all week that they had done nothing.
      await pumpPending(tester);

      expect(
        find.bySemanticsLabel(RegExp('progress not loaded yet')),
        findsNWidgets(7),
      );
      expect(find.textContaining('0 of 0'), findsNothing);
    });

    testWidgets('it is dimmed, and comes up to full strength on data', (
      tester,
    ) async {
      final pending = await pumpPending(tester);

      double opacity() => tester
          .widget<AnimatedOpacity>(
            find.descendant(
              of: find.byType(WeekStrip),
              matching: find.byType(AnimatedOpacity),
            ),
          )
          .opacity;

      expect(opacity(), lessThan(1));

      pending.complete(FakeTodayDashboard.islam());
      await tester.pumpAndSettle();

      expect(opacity(), 1);
    });

    testWidgets('a failed dashboard leaves the strip, not a second error', (
      tester,
    ) async {
      // `TodayProgressSection`'s error card is the one retry affordance for
      // this read. A second one at the top of the screen — or an error
      // where the week should be — would make one failure look like two.
      final pending = await pumpPending(tester);

      pending.completeError(Exception('offline'), StackTrace.empty);
      await tester.pumpAndSettle();

      expect(find.byType(MilestoneRing), findsNWidgets(7));
      expect(find.textContaining('Try again'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  });

  group('the below-the-fold gate', () {
    testWidgets('stays shut while the dashboard is in flight', (tester) async {
      await pumpPending(tester);

      expect(gateOf(tester), isFalse);
    });

    testWidgets('opens once the strip has painted real data', (tester) async {
      final pending = await pumpPending(tester);
      expect(gateOf(tester), isFalse);

      pending.complete(FakeTodayDashboard.islam());
      await tester.pump();
      await tester.pump();

      expect(gateOf(tester), isTrue);
    });

    testWidgets('opens on a failed dashboard too', (tester) async {
      // A settled error is as final as data: the loop is done asking, so
      // there is nothing left for the cards below to yield to.
      final pending = await pumpPending(tester);

      pending.completeError(Exception('offline'), StackTrace.empty);
      await tester.pump();
      await tester.pump();

      expect(gateOf(tester), isTrue);
      await tester.pumpAndSettle();
    });
  });

  group('goldens', () {
    // Machine-local, like the progress section's: these assert layout, not
    // glyph shapes, and are regenerated with `flutter test
    // --update-goldens`.
    testWidgets('islam', (tester) async {
      await pumpLoaded(
        tester,
        faith: FaithId.islam,
        dashboard: FakeTodayDashboard.islam(),
      );
      await expectLater(
        find.byType(WeekStrip),
        matchesGoldenFile('goldens/week_strip_islam.png'),
      );
    });

    testWidgets('hindu', (tester) async {
      await pumpLoaded(
        tester,
        faith: FaithId.hindu,
        dashboard: FakeTodayDashboard.hindu(),
      );
      await expectLater(
        find.byType(WeekStrip),
        matchesGoldenFile('goldens/week_strip_hindu.png'),
      );
    });

    testWidgets('islam dark', (tester) async {
      await pumpLoaded(
        tester,
        faith: FaithId.islam,
        dashboard: FakeTodayDashboard.islam(),
        brightness: Brightness.dark,
      );
      await expectLater(
        find.byType(WeekStrip),
        matchesGoldenFile('goldens/week_strip_islam_dark.png'),
      );
    });

    // The state nobody had looked at before the strip moved above the
    // fold, and the one a cold start now opens on.
    testWidgets('unknown', (tester) async {
      useViewport(tester, _phone);
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(FaithId.islam),
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.topCenter,
                // Pinned to the fixture's anchor week so the weekday
                // letters do not depend on the day the suite runs.
                child: WeekStrip.unknown(today: FakeTodayDashboard.anchor),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(WeekStrip),
        matchesGoldenFile('goldens/week_strip_unknown.png'),
      );
    });
  });
}
