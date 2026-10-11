import 'dart:async';

import 'package:faith_mobile/core/preferences/selected_faith.dart';
import 'package:faith_mobile/core/theme/app_theme.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:faith_mobile/features/hadiths/data/dtos/hadith.dart';
import 'package:faith_mobile/features/hadiths/presentation/controllers/daily_hadith_controller.dart';
import 'package:faith_mobile/features/hindu_scriptures/data/dtos/scripture_verse.dart';
import 'package:faith_mobile/features/hindu_scriptures/presentation/controllers/daily_shloka_controller.dart';
import 'package:faith_mobile/features/hindu_stories/data/dtos/hindu_story.dart';
import 'package:faith_mobile/features/hindu_stories/presentation/controllers/daily_katha_controller.dart';
import 'package:faith_mobile/features/today/domain/daily_verse.dart';
import 'package:faith_mobile/features/today/presentation/controllers/daily_verse_controller.dart';
import 'package:faith_mobile/features/collections/data/dtos/curated_collection.dart';
import 'package:faith_mobile/features/collections/presentation/controllers/collections_controller.dart';
import 'package:faith_mobile/features/feelings/data/dtos/emotion.dart';
import 'package:faith_mobile/features/feelings/presentation/controllers/emotions_controller.dart';
import 'package:faith_mobile/features/today/presentation/screens/today_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:faith_mobile/features/today/presentation/controllers/today_dashboard_controller.dart';
import 'package:faith_mobile/features/today/presentation/widgets/today_progress_section.dart';

import 'package:go_router/go_router.dart';

import '../../helpers/fake_emotions.dart';
import '../../helpers/fake_selected_faith.dart';
import '../../helpers/fake_today_dashboard.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  // TodayScreen pulls in several network/plugin-backed providers on both
  // branches (Islam: prayer times, daily hadith, last-read, server Hijri
  // date; Hindu: panchang-today, puja-times/sandhya countdown) that never
  // resolve in a widget test — they stay in their loading state (shimmers)
  // or fail over to a local/static fallback, and none of that is asserted
  // on here. So — matching the bounded-pump convention already used in
  // faith_selection_screen_test.dart / onboarding_screen_test.dart — every
  // test below uses a fixed-duration `pump` instead of `pumpAndSettle`,
  // which would never settle while those providers stay pending.
  //
  // The leading bare `pump()` matters: `_FakeSelectedFaith.build()` is async,
  // so the very first frame renders with `selectedFaithProvider` still
  // loading (TodayScreen's `?? FaithId.islam` fallback applies), then a
  // microtask later the override resolves and TodayScreen rebuilds into the
  // *other* branch.
  //
  // The four content providers are stubbed with futures that never
  // complete. They used to be left live, which meant these tests made real
  // dio calls and passed only because the attempts happened early enough to
  // have failed by the time the test ended — so deferring those same cards
  // behind the below-the-fold gate started them a frame later and left
  // dio's connect-timeout timer pending past teardown. That made five tests
  // here fail for a reason that had nothing to do with what they assert.
  // Stubbing is both the fix and what the paragraph above always claimed
  // was happening.
  Future<void> pump(WidgetTester tester, FaithId faith) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          selectedFaithProvider.overrideWith(() => FakeSelectedFaith(faith)),
          // The progress section is the one part of this screen with a
          // deterministic fake, so it is pinned rather than left to fail
          // over to its error card.
          todayDashboardProvider.overrideWith(
            (ref) async => faith == FaithId.islam
                ? FakeTodayDashboard.islam()
                : FakeTodayDashboard.hindu(),
          ),
          // Pending forever: the cards sit in their skeletons, which is
          // the state these tests have always actually rendered, and
          // nothing reaches the network.
          dailyVerseProvider.overrideWith(
            (ref) => Completer<DailyVerse>().future,
          ),
          dailyHadithProvider.overrideWith(
            (ref) => Completer<Hadith?>().future,
          ),
          dailyShlokaProvider.overrideWith(
            (ref) => Completer<ScriptureVerse?>().future,
          ),
          dailyKathaProvider.overrideWith(
            (ref) => Completer<HinduStory?>().future,
          ),
          // Collections are server-driven and gated below the fold, so
          // they would otherwise start a real dio read the moment the
          // habit loop paints. Empty is also what these assertions have
          // always rendered against: this file predates the rail, and an
          // empty list draws nothing at all.
          for (final f in FaithId.values)
            collectionsProvider(f).overrideWith(
              (ref) async => const <CuratedCollection>[],
            ),
          // The mood chooser is server-driven now, so the sheet renders
          // whatever this returns and nothing else.
          emotionsProvider.overrideWith(
            (ref) async => const <Emotion>[...FakeEmotions.islam],
          ),
        ],
        // MaterialApp.router, not a bare MaterialApp: picking a mood now
        // navigates to that mood's remedy, and the remedy lives in the
        // Reflect branch. A home-only harness could not observe the
        // navigation that is the entire point of the card.
        child: MaterialApp.router(
          theme: AppTheme.light(faith),
          routerConfig: GoRouter(
            initialLocation: '/today',
            routes: [
              GoRoute(path: '/today', builder: (_, __) => const TodayScreen()),
              GoRoute(
                path: '/reflect/feelings/:mood',
                builder: (_, state) =>
                    Text('REMEDY:${state.pathParameters['mood']}'),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
  }

  /// Scrolls the Today list until [target] has been built.
  ///
  /// A bounded drag loop rather than `scrollUntilVisible`, for the same
  /// reason the rest of this file uses bounded pumps: several of this
  /// screen's network-backed providers never resolve in a widget test, so
  /// anything that settles or that assumes a single resolvable Scrollable
  /// is unreliable here. Also replaces the fixed `drag(Offset(0, -600))`
  /// offsets this file used to carry, which had to be re-tuned every time
  /// anything above the target changed height — and did, when the progress
  /// section landed at the top of the screen.
  Future<void> scrollTo(WidgetTester tester, Finder target) async {
    for (var i = 0; i < 24 && target.evaluate().isEmpty; i++) {
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -220));
      await tester.pump(const Duration(milliseconds: 20));
    }
    await tester.pump(const Duration(milliseconds: 50));
  }

  group('Islam branch', () {
    testWidgets('shows the Islam greeting and section content', (tester) async {
      await pump(tester, FaithId.islam);

      expect(find.text('As-salāmu ʿalaykum'), findsOneWidget);
      // These sit below the fold now that the progress section leads the
      // screen, and a sliver list only builds what is near the viewport —
      // so each has to be scrolled to rather than assumed built.
      // SectionLabel uppercases its text.
      await scrollTo(tester, find.text('VERSE FOR TODAY'));
      expect(find.text('VERSE FOR TODAY'), findsOneWidget);
      await scrollTo(tester, find.text('HADITH OF THE DAY'));
      expect(find.text('HADITH OF THE DAY'), findsOneWidget);
      // The verse itself is no longer asserted here: it is fetched from the
      // corpus and rotates by day-of-year, so there is no fixed string to
      // match. `daily_verse_test.dart` owns the rotation; re-pinning a
      // literal here would recreate exactly the bug that was just removed.

      // "Quick" + the quick-actions row sit far below the fold now that the
      // progress section leads the screen. scrollUntilVisible rather than a
      // fixed drag offset, which would have to be re-tuned every time
      // anything above them changes height.
      await scrollTo(tester, find.text('QUICK'));
      expect(find.text('QUICK'), findsOneWidget);
      await scrollTo(tester, find.text('How are you feeling?'));
      expect(find.text('How are you feeling?'), findsOneWidget);
    });

    testWidgets('leads with the progress section', (tester) async {
      await pump(tester, FaithId.islam);

      expect(find.byType(TodayProgressSection), findsOneWidget);
      expect(find.text("TODAY'S GOAL"), findsOneWidget);
      expect(find.text('Fajr'), findsOneWidget);
    });

    testWidgets('does not show the Hindu placeholder copy', (tester) async {
      await pump(tester, FaithId.islam);

      expect(find.text('Hindu home is coming soon'), findsNothing);
    });

    testWidgets(
      'MoodPrompt opens the mood sheet, and picking a mood opens its remedy',
      (tester) async {
        await pump(tester, FaithId.islam);

        // MoodPrompt is now a PoppyCard (was Material+InkWell) — confirm the
        // tap-to-open-sheet behavior survived that conversion, and that the
        // mood chips (also converted to PoppyCard) are themselves tappable.
        await scrollTo(tester, find.text('How are you feeling?'));
        expect(find.text('How are you feeling?'), findsOneWidget);

        await tester.tap(find.text('How are you feeling?'));
        await tester.pump(); // start the bottom-sheet route transition
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.text('How are you?'), findsOneWidget);
        expect(find.text('Grateful'), findsOneWidget);

        await tester.tap(find.text('Grateful'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));

        expect(find.text('How are you?'), findsNothing);
        // This card used to await the sheet and discard the result, so every
        // mood on it was a dead end whatever slug it carried.
        expect(find.text('REMEDY:grateful'), findsOneWidget);
      },
    );

    testWidgets('the mood sheet offers no mood the Islam data lacks', (
      tester,
    ) async {
      await pump(tester, FaithId.islam);
      await scrollTo(tester, find.text('How are you feeling?'));
      await tester.tap(find.text('How are you feeling?'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Lonely'), findsNothing);
      expect(find.text('Searching'), findsNothing);
    });
  });

  group('Hindu branch', () {
    testWidgets('shows the Hindu greeting and section content', (tester) async {
      await pump(tester, FaithId.hindu);

      expect(find.text('Namaste'), findsOneWidget);
      // SectionLabel uppercases its text.
      await scrollTo(tester, find.text('SHLOKA FOR TODAY'));
      expect(find.text('SHLOKA FOR TODAY'), findsOneWidget);
      await scrollTo(tester, find.text('KATHA FOR TODAY'));
      expect(find.text('KATHA FOR TODAY'), findsOneWidget);

      await scrollTo(tester, find.text('QUICK'));
      expect(find.text('QUICK'), findsOneWidget);
      expect(find.text('Japa'), findsWidgets);
      expect(find.text('Stotras'), findsOneWidget);
      expect(find.text('Temples'), findsOneWidget);
    });

    testWidgets('leads with the same progress section as Islam', (
      tester,
    ) async {
      await pump(tester, FaithId.hindu);

      // Same widget, Hindu content — three sandhya rather than five prayers.
      expect(find.byType(TodayProgressSection), findsOneWidget);
      expect(find.text("TODAY'S GOAL"), findsOneWidget);
      expect(find.text('Prātaḥ'), findsOneWidget);
      expect(find.text('Fajr'), findsNothing);
    });

    testWidgets('does not reuse any Islam-specific copy or widgets', (
      tester,
    ) async {
      await pump(tester, FaithId.hindu);

      expect(find.text('As-salāmu ʿalaykum'), findsNothing);
      expect(find.text('VERSE FOR TODAY'), findsNothing);
      expect(find.text('HADITH OF THE DAY'), findsNothing);
      expect(find.text('How are you feeling?'), findsNothing);
    });

    testWidgets('still exposes a way back to Settings', (tester) async {
      await pump(tester, FaithId.hindu);

      expect(find.byTooltip('Settings'), findsOneWidget);
    });
  });
}
