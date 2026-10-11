import 'dart:async';

import 'package:faith_mobile/core/preferences/selected_faith.dart';
import 'package:faith_mobile/core/theme/app_theme.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:faith_mobile/features/feelings/data/dtos/emotion.dart';
import 'package:faith_mobile/features/feelings/presentation/controllers/emotions_controller.dart';
import 'package:faith_mobile/features/hadiths/data/dtos/hadith.dart';
import 'package:faith_mobile/features/hadiths/presentation/controllers/daily_hadith_controller.dart';
import 'package:faith_mobile/features/hindu_scriptures/data/dtos/scripture_verse.dart';
import 'package:faith_mobile/features/hindu_scriptures/presentation/controllers/daily_shloka_controller.dart';
import 'package:faith_mobile/features/hindu_stories/data/dtos/hindu_story.dart';
import 'package:faith_mobile/features/hindu_stories/presentation/controllers/daily_katha_controller.dart';
import 'package:faith_mobile/features/practice/presentation/screens/practice_home_screen.dart';
import 'package:faith_mobile/features/quran/data/dtos/surah.dart';
import 'package:faith_mobile/features/quran/presentation/controllers/quran_home_controller.dart';
import 'package:faith_mobile/features/quran/presentation/widgets/often_read_row.dart';
import 'package:faith_mobile/features/today/domain/daily_verse.dart';
import 'package:faith_mobile/features/today/presentation/controllers/daily_verse_controller.dart';
import 'package:faith_mobile/features/today/presentation/controllers/today_dashboard_controller.dart';
import 'package:faith_mobile/features/today/presentation/screens/today_screen.dart';
import 'package:faith_mobile/shared/widgets/colophon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/fake_emotions.dart';
import '../../helpers/fake_selected_faith.dart';
import '../../helpers/fake_today_dashboard.dart';

/// "Often read" on its three hosts, the nightly card on its two, and the
/// one cost neither is allowed to have.
///
/// The shortcuts came from the Qur'an tab and now also sit on Today and
/// Practice. Two things follow that are easy to get wrong, and both are
/// asserted here: the chips are **Islamic content** and must never reach
/// the Hindu branch of a faith-aware screen, and they must stay **free** —
/// Today's launch latency has been worked on hard, and a shortcut row that
/// pulled `GET /surahs` to spell seven names would undo part of it.
void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  /// Records whether anything asked for the 114-surah index.
  late int surahIndexReads;

  List<Override> commonOverrides(FaithId faith) => [
    selectedFaithProvider.overrideWith(() => FakeSelectedFaith(faith)),
    surahListProvider.overrideWith((ref) async {
      surahIndexReads++;
      return const <Surah>[];
    }),
  ];

  List<Override> todayOverrides(FaithId faith) => [
    ...commonOverrides(faith),
    todayDashboardProvider.overrideWith(
      (ref) async => faith == FaithId.islam
          ? FakeTodayDashboard.islam()
          : FakeTodayDashboard.hindu(),
    ),
    // Pending forever: the content cards sit in their skeletons and
    // nothing reaches the network. See today_screen_test.dart.
    dailyVerseProvider.overrideWith((ref) => Completer<DailyVerse>().future),
    dailyHadithProvider.overrideWith((ref) => Completer<Hadith?>().future),
    dailyShlokaProvider.overrideWith(
      (ref) => Completer<ScriptureVerse?>().future,
    ),
    dailyKathaProvider.overrideWith((ref) => Completer<HinduStory?>().future),
    emotionsProvider.overrideWith(
      (ref) async => const <Emotion>[...FakeEmotions.islam],
    ),
  ];

  late String location;

  Widget host(Widget home, List<Override> overrides, FaithId faith) {
    location = '/';
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp.router(
        theme: AppTheme.light(faith),
        routerConfig: GoRouter(
          initialLocation: '/',
          routes: [
            GoRoute(path: '/', builder: (_, __) => home),
            GoRoute(
              path: '/quran/surah/:id',
              builder: (_, state) {
                location = '/quran/surah/${state.pathParameters['id']}';
                return const Scaffold(body: Text('scroll reader'));
              },
              routes: [
                GoRoute(
                  path: 'verses',
                  builder: (_, state) {
                    location =
                        '/quran/surah/${state.pathParameters['id']}/verses';
                    return const Scaffold(body: Text('verse reader'));
                  },
                ),
              ],
            ),
            GoRoute(
              path: '/quran/collection/:id',
              builder: (_, state) {
                location = '/quran/collection/${state.pathParameters['id']}';
                return const Scaffold(body: Text('collection'));
              },
            ),
          ],
        ),
      ),
    );
  }

  setUp(() => surahIndexReads = 0);

  /// Bounded pumps, not `pumpAndSettle`: several of Today's providers never
  /// resolve in a widget test.
  Future<void> settle(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
  }

  /// Scrolls until [target] has been built, the way today_screen_test does.
  Future<void> scrollTo(WidgetTester tester, Finder target) async {
    for (var i = 0; i < 24 && target.evaluate().isEmpty; i++) {
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -220));
      await tester.pump(const Duration(milliseconds: 20));
    }
    await tester.pump(const Duration(milliseconds: 50));
  }

  group('on the Practice tab', () {
    testWidgets('sits under the grid and above the colophon', (tester) async {
      tester.view.physicalSize = const Size(800, 2000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        host(
          const PracticeHomeScreen(),
          commonOverrides(FaithId.islam),
          FaithId.islam,
        ),
      );
      await settle(tester);

      expect(find.byType(OftenReadRow), findsOneWidget);
      expect(
        tester.getTopLeft(find.byType(OftenReadRow)).dy,
        lessThan(tester.getTopLeft(find.byType(Colophon)).dy),
        reason:
            'the colophon is the deliberate end of the page and stays '
            'the last thing on it',
      );
    });

    testWidgets('never reaches the Hindu branch', (tester) async {
      await tester.pumpWidget(
        host(
          const PracticeHomeScreen(),
          commonOverrides(FaithId.hindu),
          FaithId.hindu,
        ),
      );
      await settle(tester);

      expect(find.byType(OftenReadRow), findsNothing);
      // And the tab itself still rendered, so this is a gate rather than a
      // broken screen.
      expect(find.text('Japa'), findsOneWidget);
    });
  });

  group('on the Today dashboard', () {
    testWidgets('appears with the day\'s readings', (tester) async {
      await tester.pumpWidget(
        host(const TodayScreen(), todayOverrides(FaithId.islam), FaithId.islam),
      );
      await settle(tester);
      await scrollTo(tester, find.byType(OftenReadRow));

      expect(find.byType(OftenReadRow), findsOneWidget);
      expect(find.text('OFTEN READ'), findsOneWidget);
    });

    testWidgets('never reaches the Hindu branch', (tester) async {
      await tester.pumpWidget(
        host(const TodayScreen(), todayOverrides(FaithId.hindu), FaithId.hindu),
      );
      await settle(tester);
      await scrollTo(tester, find.text('Quick'.toUpperCase()));

      expect(find.byType(OftenReadRow), findsNothing);
    });

    testWidgets('costs the cold start nothing — no surah index is read', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(const TodayScreen(), todayOverrides(FaithId.islam), FaithId.islam),
      );
      await settle(tester);
      await scrollTo(tester, find.byType(OftenReadRow));

      expect(
        surahIndexReads,
        0,
        reason:
            'the names are a constant; a shortcut row that pulled '
            'GET /surahs to spell them would add a request to the screen '
            'whose launch latency has been worked on hardest',
      );
    });
  });

  group('which reader a shortcut opens', () {
    Future<void> pumpPractice(WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 2000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        host(
          const PracticeHomeScreen(),
          commonOverrides(FaithId.islam),
          FaithId.islam,
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
    }

    testWidgets('the scrolling reader, for someone who has never chosen', (
      tester,
    ) async {
      await pumpPractice(tester);
      await tester.tap(find.text('Al-Kahf'));
      await tester.pumpAndSettle();

      expect(location, '/quran/surah/18');
    });

    testWidgets('the verse pager, once that is what they last used', (
      tester,
    ) async {
      // Exactly what a reader leaves behind by pressing the switch inside
      // the other reader — there is no separate chooser to set.
      SharedPreferences.setMockInitialValues({
        'quran.readingMode': 'verseByVerse',
      });
      await pumpPractice(tester);
      await tester.tap(find.text('Al-Kahf'));
      await tester.pumpAndSettle();

      expect(location, '/quran/surah/18/verses');
    });
  });

  // The nightly recitation card used to be asserted here: offered at
  // 21:00, absent at midday, opening `/quran/collection/nightly`. That
  // card and its client-side clock (`isNightlyHour`, 19:00-03:59) are
  // gone — `Collection.showOnHome` in the database decides now. Its
  // successor, the collections rail, is covered in
  // `test/features/collections/collections_surfaces_test.dart`, including
  // the inverted form of the two hour assertions: the hour must no longer
  // change what the dashboard shows.
}
