import 'dart:async';

import 'package:faith_mobile/core/preferences/selected_faith.dart';
import 'package:faith_mobile/core/theme/app_theme.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:faith_mobile/features/collections/data/dtos/curated_collection.dart';
import 'package:faith_mobile/features/collections/presentation/controllers/collections_controller.dart';
import 'package:faith_mobile/features/hadiths/data/dtos/hadith.dart';
import 'package:faith_mobile/features/hadiths/presentation/controllers/daily_hadith_controller.dart';
import 'package:faith_mobile/features/hindu_scriptures/data/dtos/scripture_text.dart';
import 'package:faith_mobile/features/hindu_scriptures/data/dtos/scripture_verse.dart';
import 'package:faith_mobile/features/hindu_scriptures/presentation/controllers/daily_shloka_controller.dart';
import 'package:faith_mobile/features/hindu_scriptures/presentation/controllers/hindu_scriptures_home_controller.dart';
import 'package:faith_mobile/features/hindu_stories/data/dtos/hindu_story.dart';
import 'package:faith_mobile/features/hindu_stories/presentation/controllers/daily_katha_controller.dart';
import 'package:faith_mobile/features/quran/data/dtos/juz.dart';
import 'package:faith_mobile/features/quran/data/dtos/surah.dart';
import 'package:faith_mobile/features/quran/presentation/controllers/juz_controller.dart';
import 'package:faith_mobile/features/quran/presentation/controllers/quran_home_controller.dart';
import 'package:faith_mobile/features/today/domain/daily_verse.dart';
import 'package:faith_mobile/features/today/domain/today_dashboard.dart';
import 'package:faith_mobile/features/today/presentation/controllers/below_fold_gate.dart';
import 'package:faith_mobile/features/today/presentation/controllers/daily_verse_controller.dart';
import 'package:faith_mobile/features/today/presentation/controllers/today_dashboard_controller.dart';
import 'package:faith_mobile/features/today/presentation/screens/today_screen.dart';
import 'package:faith_mobile/features/today/presentation/widgets/today_progress_section.dart';
import 'package:faith_mobile/features/today/presentation/widgets/week_strip_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/fake_selected_faith.dart';
import '../../helpers/fake_today_dashboard.dart';

/// How many times each deferred read was *started*.
///
/// Counting initialisations rather than inspecting the wire is the whole
/// test: a card's fetch begins at the `ref.watch` in its own `build`, so a
/// card that is never built is a request that was never sent, and a
/// provider that was never created is the only observable form of that.
class _Fetches {
  int verse = 0;
  int hadith = 0;
  int shloka = 0;
  int katha = 0;
  int habitLoop = 0;

  /// The curated-collections list. Unlike the four above it is read by a
  /// card that sits *above* the goal card, which is exactly why it is
  /// tracked here: the most visible block on the screen is the one most
  /// likely to be fetched first by someone who forgets the gate.
  int collections = 0;

  /// The three indexes the continue-reading card could plausibly be
  /// rewritten to consult, and must not.
  ///
  /// That card leads the content on Today — only the week strip, which
  /// shares the habit loop's own read, is above it — and is not gated at
  /// all: it renders from `shared_preferences` alone, which is what earns
  /// it that position. Resolving a surah name through `GET /surahs`, a book
  /// name through `GET /texts`, or a juz label through `GET /juz` would put
  /// a request ahead of the two activity reads the habit loop waits on —
  /// the exact pressure this gate exists to relieve — and would do it in
  /// the most prominent widget on the screen.
  ///
  /// Nothing reads these today. They are counted so that the day someone
  /// reaches for the surah index to spell "Al-Baqarah", this file says no.
  int surahIndex = 0;
  int scriptureIndex = 0;
  int juzIndex = 0;
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  // Viewport height decides what this test can even see, so it is pinned to
  // the device the change was measured on rather than left at the 800x600
  // default.
  //
  // A SliverList builds what is on screen plus one cache extent, which
  // means the screen's lower cards were *already* lazily deferred before
  // this change — on a 393x873 viewport exactly one content card per faith
  // is built at cold start (the verse on Islam, the shloka on Hindu); the
  // hadith and katha below them are not. Measured both ways against the
  // pre-change screen.
  //
  // So this gate removes one request per faith from the cold-start burst,
  // not two — but it removes the right one. The verse is a whole-surah
  // read, which `daily_verse_controller.dart` calls the largest single read
  // on this screen. On the shorter default surface nothing would be built
  // at cold start at all and these tests would pass with or without the
  // gate.
  setUp(() {
    final view = TestWidgetsFlutterBinding
        .instance
        .platformDispatcher
        .implicitView!;
    view.devicePixelRatio = 3.0;
    view.physicalSize = const Size(393 * 3, 873 * 3);
  });

  tearDown(() {
    final view = TestWidgetsFlutterBinding
        .instance
        .platformDispatcher
        .implicitView!;
    view.resetDevicePixelRatio();
    view.resetPhysicalSize();
  });

  /// Pumps the real Today screen with the habit loop under test control.
  ///
  /// Every deferred provider is overridden with a future that never
  /// completes: the cards stay in their skeletons and nothing touches the
  /// network, while [_Fetches] still records that the read was started.
  Future<_Fetches> pump(
    WidgetTester tester, {
    required Completer<TodayDashboard> habitLoop,
    FaithId faith = FaithId.islam,
  }) async {
    final fetches = _Fetches();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          selectedFaithProvider.overrideWith(() => FakeSelectedFaith(faith)),
          todayDashboardProvider.overrideWith((ref) {
            fetches.habitLoop++;
            return habitLoop.future;
          }),
          dailyVerseProvider.overrideWith((ref) {
            fetches.verse++;
            return Completer<DailyVerse>().future;
          }),
          dailyHadithProvider.overrideWith((ref) {
            fetches.hadith++;
            return Completer<Hadith?>().future;
          }),
          dailyShlokaProvider.overrideWith((ref) {
            fetches.shloka++;
            return Completer<ScriptureVerse?>().future;
          }),
          dailyKathaProvider.overrideWith((ref) {
            fetches.katha++;
            return Completer<HinduStory?>().future;
          }),
          for (final f in FaithId.values)
            collectionsProvider(f).overrideWith((ref) async {
              fetches.collections++;
              return const <CuratedCollection>[];
            }),
          surahListProvider.overrideWith((ref) async {
            fetches.surahIndex++;
            return const <Surah>[];
          }),
          scriptureTextListProvider.overrideWith((ref) async {
            fetches.scriptureIndex++;
            return const <ScriptureText>[];
          }),
          juzIndexProvider.overrideWith((ref) async {
            fetches.juzIndex++;
            return const <JuzSummary>[];
          }),
        ],
        child: MaterialApp(
          theme: AppTheme.light(faith),
          home: const TodayScreen(),
        ),
      ),
    );
    // Two frames: FakeSelectedFaith resolves asynchronously, so the first
    // frame renders the Islam fallback branch and the second renders the
    // branch actually under test.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    return fetches;
  }

  /// Settles the habit loop and lets the post-frame release run.
  ///
  /// Two frames, and both are load-bearing: the first paints the loop and
  /// schedules the release, the second rebuilds the cards the release
  /// unblocked.
  Future<void> settle(WidgetTester tester) async {
    await tester.pump();
    await tester.pump();
  }

  bool gateOf(WidgetTester tester) => ProviderScope.containerOf(
    tester.element(find.byType(TodayScreen)),
  ).read(belowFoldGateProvider);

  /// Drags the Today list until [target] has been built, or gives up.
  ///
  /// A bounded loop rather than `scrollUntilVisible`, matching the
  /// convention in `today_screen_test.dart`: several of this screen's
  /// providers never resolve in a widget test, so anything that settles is
  /// unreliable here.
  Future<void> scrollTo(WidgetTester tester, Finder target) async {
    for (var i = 0; i < 24 && target.evaluate().isEmpty; i++) {
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -220));
      await tester.pump(const Duration(milliseconds: 20));
    }
    await tester.pump(const Duration(milliseconds: 50));
  }

  group('while the habit loop is still loading', () {
    testWidgets('no Islam content read has started', (tester) async {
      final habitLoop = Completer<TodayDashboard>();
      final fetches = await pump(tester, habitLoop: habitLoop);

      // The reads that gate the habit loop get the pool to themselves.
      // This is the whole point of the change.
      expect(gateOf(tester), isFalse);
      expect(fetches.verse, 0);
      expect(fetches.hadith, 0);
      expect(
        fetches.collections,
        0,
        reason:
            'the featured collection sits above the goal card, and is '
            'still not allowed ahead of the habit loop',
      );
      expect(
        fetches.surahIndex,
        0,
        reason:
            'continue-reading leads this screen and is ungated — it pays '
            'for that by reading prefs and nothing else',
      );
      expect(fetches.juzIndex, 0);

      habitLoop.complete(FakeTodayDashboard.islam());
      await settle(tester);
    });

    testWidgets('no Hindu content read has started', (tester) async {
      final habitLoop = Completer<TodayDashboard>();
      final fetches = await pump(
        tester,
        habitLoop: habitLoop,
        faith: FaithId.hindu,
      );

      expect(gateOf(tester), isFalse);
      expect(fetches.shloka, 0);
      expect(fetches.katha, 0);
      expect(fetches.collections, 0);
      expect(
        fetches.scriptureIndex,
        0,
        reason: 'the Hindu continue-reading card reads prefs and nothing '
            'else, exactly as its Islam twin does',
      );

      habitLoop.complete(FakeTodayDashboard.hindu());
      await settle(tester);
    });

    testWidgets('the habit loop itself is not delayed by the gate', (
      tester,
    ) async {
      // The thing being optimised for must not pay for the optimisation:
      // its read still starts on the first frame, exactly as before.
      //
      // Two widgets watch `todayDashboardProvider` now that the week strip
      // leads the screen — the strip at the top and the goal section
      // further down. That must stay *one* read: a second `GET
      // /activity/today` and `GET /activity/history` on the critical path
      // would double exactly the burst this gate exists to thin out.
      final habitLoop = Completer<TodayDashboard>();
      final fetches = await pump(tester, habitLoop: habitLoop);

      expect(fetches.habitLoop, 1);

      habitLoop.complete(FakeTodayDashboard.islam());
      await settle(tester);
    });
  });

  group('who holds the gate open', () {
    testWidgets('the strip is built at cold start; the section may not be', (
      tester,
    ) async {
      // This is the reason the release moved. `WeekStripSection` is pinned
      // above the fold and is built on the first frame under any viewport
      // the app supports. `TodayProgressSection` now sits below
      // continue-reading and a full-width featured collection, so whether
      // it is built at cold start is a question about the sliver's cache
      // extent — and a gate owned by a widget that can fall out of the
      // build range is a gate that can only open on its five-second
      // deadline.
      //
      // This asserts the half that must hold. If the section happens to be
      // in range on this viewport today, that is luck, not a guarantee, and
      // it is not asserted either way.
      final habitLoop = Completer<TodayDashboard>();
      await pump(tester, habitLoop: habitLoop);

      expect(find.byType(WeekStripSection), findsOneWidget);

      habitLoop.complete(FakeTodayDashboard.islam());
      await settle(tester);
    });

    testWidgets('the section no longer releases the gate on its own', (
      tester,
    ) async {
      // Exactly one releaser. With the strip's section absent, a settled
      // dashboard must leave the gate shut until the deadline — if this
      // ever goes green early, something below has quietly taken the
      // release back and there are two things able to open it.
      final container = ProviderContainer(
        overrides: [
          todayDashboardProvider.overrideWith(
            (ref) async => FakeTodayDashboard.islam(),
          ),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.light(FaithId.islam),
            home: const Scaffold(
              body: SingleChildScrollView(child: TodayProgressSection()),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(container.read(belowFoldGateProvider), isFalse);

      // Drain the gate's own backstop so the binding is not left with a
      // pending timer.
      await tester.pump(kBelowFoldDeadline);
    });
  });

  group('the gate always opens', () {
    testWidgets('when the habit loop renders', (tester) async {
      final habitLoop = Completer<TodayDashboard>();
      await pump(tester, habitLoop: habitLoop);
      expect(gateOf(tester), isFalse);

      habitLoop.complete(FakeTodayDashboard.islam());
      await settle(tester);

      expect(gateOf(tester), isTrue);
    });

    testWidgets('when the habit loop fails', (tester) async {
      // The nastiest failure available here: the loop errors, the cards
      // below it wait forever on a signal that is never coming, and an
      // offline launch shows a screen of skeletons that never resolve into
      // anything — not even error cards with a retry. A settled error is
      // as final as data, so it releases them too.
      final habitLoop = Completer<TodayDashboard>();
      final fetches = await pump(tester, habitLoop: habitLoop);

      habitLoop.completeError(Exception('offline'), StackTrace.empty);
      await settle(tester);

      expect(gateOf(tester), isTrue);
      expect(fetches.verse, 1);
      expect(
        fetches.collections,
        1,
        reason: 'a deferral that never fires is worse than the request it saved',
      );
    });

    testWidgets('on the deadline, when the loop never settles at all', (
      tester,
    ) async {
      // The backstop. A hung socket, or a provider that fails in a way
      // nobody anticipated, must not leave the cards blank for the rest of
      // the session.
      final habitLoop = Completer<TodayDashboard>();
      final fetches = await pump(tester, habitLoop: habitLoop);
      expect(gateOf(tester), isFalse);

      await tester.pump(kBelowFoldDeadline);
      await tester.pump();

      expect(gateOf(tester), isTrue);
      expect(fetches.verse, 1);

      habitLoop.complete(FakeTodayDashboard.islam());
      await settle(tester);
    });
  });

  group('nothing is left permanently unfetched', () {
    testWidgets('the Islam verse fetches the moment the gate opens', (
      tester,
    ) async {
      final habitLoop = Completer<TodayDashboard>();
      final fetches = await pump(tester, habitLoop: habitLoop);
      expect(fetches.verse, 0);

      habitLoop.complete(FakeTodayDashboard.islam());
      await settle(tester);

      expect(fetches.verse, 1);
    });

    testWidgets('the Hindu shloka fetches the moment the gate opens', (
      tester,
    ) async {
      final habitLoop = Completer<TodayDashboard>();
      final fetches = await pump(
        tester,
        habitLoop: habitLoop,
        faith: FaithId.hindu,
      );
      expect(fetches.shloka, 0);

      habitLoop.complete(FakeTodayDashboard.hindu());
      await settle(tester);

      expect(fetches.shloka, 1);
    });

    testWidgets('a card below the cache extent fetches when scrolled to', (
      tester,
    ) async {
      // The hadith card is not built at cold start even without the gate —
      // it is past the sliver's cache extent — so the risk it carries is
      // the opposite one: that wrapping it leaves it permanently dark,
      // deferred by a gate and then never rebuilt. It must still load on
      // the one event that was always going to build it.
      final habitLoop = Completer<TodayDashboard>();
      final fetches = await pump(tester, habitLoop: habitLoop);

      habitLoop.complete(FakeTodayDashboard.islam());
      await settle(tester);
      expect(fetches.hadith, 0);

      await scrollTo(tester, find.text('HADITH OF THE DAY'));

      expect(fetches.hadith, 1);
    });

    testWidgets('the Hindu katha likewise fetches when scrolled to', (
      tester,
    ) async {
      final habitLoop = Completer<TodayDashboard>();
      final fetches = await pump(
        tester,
        habitLoop: habitLoop,
        faith: FaithId.hindu,
      );

      habitLoop.complete(FakeTodayDashboard.hindu());
      await settle(tester);

      await scrollTo(tester, find.text('KATHA FOR TODAY'));

      expect(fetches.katha, 1);
    });
  });

  group('the gate is a cold-start measure only', () {
    testWidgets('it stays open once the habit loop has rendered', (
      tester,
    ) async {
      // Session-scoped and one-way, so a later rebuild — a tab switch back
      // to Today, a faith change, a recorded act — never re-defers content
      // the user has already been shown.
      final habitLoop = Completer<TodayDashboard>();
      await pump(tester, habitLoop: habitLoop);

      habitLoop.complete(FakeTodayDashboard.islam());
      await settle(tester);
      expect(gateOf(tester), isTrue);

      await tester.pump(const Duration(seconds: 1));
      expect(gateOf(tester), isTrue);
    });
  });
}
