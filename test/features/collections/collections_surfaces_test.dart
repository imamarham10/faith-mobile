import 'dart:async';

import 'package:faith_mobile/core/network/api_exception.dart';
import 'package:faith_mobile/core/preferences/selected_faith.dart';
import 'package:faith_mobile/core/theme/app_theme.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:faith_mobile/features/collections/data/dtos/curated_collection.dart';
import 'package:faith_mobile/features/collections/presentation/controllers/collections_controller.dart';
import 'package:faith_mobile/features/collections/presentation/widgets/collection_card.dart';
import 'package:faith_mobile/features/collections/presentation/widgets/collections_list.dart';
import 'package:faith_mobile/features/collections/presentation/widgets/featured_collection_card.dart';
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
import 'package:faith_mobile/features/today/domain/daily_verse.dart';
import 'package:faith_mobile/features/today/presentation/controllers/daily_verse_controller.dart';
import 'package:faith_mobile/features/today/presentation/controllers/today_dashboard_controller.dart';
import 'package:faith_mobile/features/today/presentation/screens/today_screen.dart';
import 'package:faith_mobile/features/today/presentation/widgets/goal_card.dart';
import 'package:faith_mobile/shared/widgets/poppy_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/fake_collections.dart';
import '../../helpers/fake_emotions.dart';
import '../../helpers/fake_selected_faith.dart';
import '../../helpers/fake_today_dashboard.dart';

/// Curated collections on the surfaces that carry them, in both faiths.
///
/// Two rules are asserted over and over here because both have cost this
/// project real bugs:
///
/// * **Nothing is nothing.** An unfeatured, empty or failed list on the
///   dashboard draws zero pixels — no card, no skeleton, no heading left
///   over above an empty list.
/// * **The database decides.** The dashboard renders what `showOnHome`
///   says, in `sortOrder`, at any hour. The client's old 19:00–03:59 rule
///   is gone and nothing re-sorts or re-filters behind the server's back.
void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  late String location;

  List<Override> collectionOverrides(
    FaithId faith,
    FutureOr<List<CuratedCollection>> Function() build,
  ) => [collectionsProvider(faith).overrideWith((ref) async => build())];

  /// Today's other providers, all pinned so nothing but collections moves.
  List<Override> todayOverrides(FaithId faith) => [
    selectedFaithProvider.overrideWith(() => FakeSelectedFaith(faith)),
    surahListProvider.overrideWith((ref) async => const <Surah>[]),
    todayDashboardProvider.overrideWith(
      (ref) async => faith == FaithId.islam
          ? FakeTodayDashboard.islam()
          : FakeTodayDashboard.hindu(),
    ),
    // Pending forever: the content cards sit in their skeletons and
    // nothing reaches the network.
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
              path: '/quran/collection/:slug',
              builder: (_, state) {
                location = '/quran/collection/${state.pathParameters['slug']}';
                return const Scaffold(body: Text('collection'));
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Bounded pumps, not `pumpAndSettle`: several of Today's providers never
  /// resolve in a widget test.
  Future<void> settle(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 50));
  }

  void tallScreen(WidgetTester tester) {
    tester.view.physicalSize = const Size(1000, 2200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  group('the Today dashboard', () {
    testWidgets('Islam shows the collection the database featured', (
      tester,
    ) async {
      tallScreen(tester);
      await tester.pumpWidget(
        host(
          const TodayScreen(),
          [
            ...todayOverrides(FaithId.islam),
            ...collectionOverrides(
              FaithId.islam,
              () => [FakeCollections.nightly()],
            ),
          ],
          FaithId.islam,
        ),
      );
      await settle(tester);

      expect(find.byType(FeaturedCollectionCard), findsOneWidget);
      expect(find.text('Nightly Recitation'), findsOneWidget);
      expect(find.text('COLLECTIONS'), findsOneWidget);
    });

    testWidgets('Hindu shows its own, through the same widget', (tester) async {
      tallScreen(tester);
      await tester.pumpWidget(
        host(
          const TodayScreen(),
          [
            ...todayOverrides(FaithId.hindu),
            ...collectionOverrides(
              FaithId.hindu,
              () => [FakeCollections.gita()],
            ),
          ],
          FaithId.hindu,
        ),
      );
      await settle(tester);

      expect(find.byType(FeaturedCollectionCard), findsOneWidget);
      expect(find.text('Daily Gita'), findsOneWidget);
      // The full-width card has room for the whole meta line, where the
      // old compact tile only had room for the count.
      expect(find.textContaining('1 reading'), findsOneWidget);
    });

    testWidgets('sits above the goal card', (tester) async {
      tallScreen(tester);
      await tester.pumpWidget(
        host(
          const TodayScreen(),
          [
            ...todayOverrides(FaithId.islam),
            ...collectionOverrides(
              FaithId.islam,
              () => [FakeCollections.nightly()],
            ),
          ],
          FaithId.islam,
        ),
      );
      await settle(tester);

      expect(
        tester.getTopLeft(find.byType(FeaturedCollectionCard)).dy,
        lessThan(tester.getTopLeft(find.byType(GoalCard)).dy),
      );
    });

    testWidgets('four featured collections still cost one card', (
      tester,
    ) async {
      // The dashboard promotes one set, whatever the database flags. The
      // old horizontal rail held its height by scrolling sideways; the
      // full-width card holds it by showing the first in `sortOrder` and
      // leaving the rest to the browsing surfaces. Either way the goal
      // card must not move when an eleventh collection is featured — ten
      // more are staged, so this is near-term, not hypothetical.
      tallScreen(tester);
      await tester.pumpWidget(
        host(
          const TodayScreen(),
          [
            ...todayOverrides(FaithId.islam),
            ...collectionOverrides(FaithId.islam, () => [
              FakeCollections.nightly(sortOrder: 10),
              FakeCollections.extra(
                'morning-adhkar',
                title: 'Morning Adhkar',
                faithId: 'islam',
                sortOrder: 20,
              ),
              FakeCollections.extra(
                'friday-sunnah',
                title: 'Friday Sunnah',
                faithId: 'islam',
                sortOrder: 30,
              ),
              FakeCollections.extra(
                'travel-duas',
                title: 'Travel Duas',
                faithId: 'islam',
                sortOrder: 40,
              ),
            ]),
          ],
          FaithId.islam,
        ),
      );
      await settle(tester);

      final goalTop = tester.getTopLeft(find.byType(GoalCard)).dy;
      expect(
        goalTop,
        lessThan(tester.view.physicalSize.height),
        reason: 'the goal card must survive a fully featured database',
      );
      // One card, the first in the server's order. The other three are
      // not on the dashboard and are not meant to be.
      expect(find.byType(FeaturedCollectionCard), findsOneWidget);
      expect(find.text('Nightly Recitation'), findsOneWidget);
      expect(find.text('Morning Adhkar'), findsNothing);
      expect(find.text('Friday Sunnah'), findsNothing);
      expect(find.text('Travel Duas'), findsNothing);
    });

    testWidgets('renders the server order, not an order of its own', (
      tester,
    ) async {
      tallScreen(tester);
      await tester.pumpWidget(
        host(
          const TodayScreen(),
          [
            ...todayOverrides(FaithId.islam),
            // Deliberately not alphabetical: "Zuhr Set" sorts first.
            ...collectionOverrides(FaithId.islam, () => [
              FakeCollections.extra(
                'zuhr-set',
                title: 'Zuhr Set',
                faithId: 'islam',
                sortOrder: 10,
              ),
              FakeCollections.extra(
                'adhkar',
                title: 'Adhkar',
                faithId: 'islam',
                sortOrder: 20,
              ),
            ]),
          ],
          FaithId.islam,
        ),
      );
      await settle(tester);

      // With one slot, "the server's order" means "the server picks which
      // one". Nothing here sorts alphabetically, by title, or by anything
      // else: `sortOrder` 10 wins because the database said so.
      expect(find.text('Zuhr Set'), findsOneWidget);
      expect(
        find.text('Adhkar'),
        findsNothing,
        reason: 'sortOrder is the server\'s call and is obeyed as given',
      );
    });

    testWidgets('an unfeatured collection is not on the dashboard', (
      tester,
    ) async {
      tallScreen(tester);
      await tester.pumpWidget(
        host(
          const TodayScreen(),
          [
            ...todayOverrides(FaithId.islam),
            ...collectionOverrides(
              FaithId.islam,
              () => [FakeCollections.nightly(showOnHome: false)],
            ),
          ],
          FaithId.islam,
        ),
      );
      await settle(tester);

      expect(find.text('Nightly Recitation'), findsNothing);
      expect(
        find.text('COLLECTIONS'),
        findsNothing,
        reason: 'no heading may outlive the list under it',
      );
      expect(
        tester.getSize(find.byType(FeaturedCollectionCard)).height,
        0,
      );
    });

    testWidgets('an empty list renders nothing at all, not an empty box', (
      tester,
    ) async {
      tallScreen(tester);
      await tester.pumpWidget(
        host(
          const TodayScreen(),
          [
            ...todayOverrides(FaithId.islam),
            ...collectionOverrides(
              FaithId.islam,
              () => const <CuratedCollection>[],
            ),
          ],
          FaithId.islam,
        ),
      );
      await settle(tester);

      expect(find.text('COLLECTIONS'), findsNothing);
      expect(find.text('Nightly Recitation'), findsNothing);
      // The widget is in the tree and occupies no pixels — nothing is
      // drawn, nothing is reserved, and the habit loop below sits exactly
      // where it would if collections did not exist. (It used to be absent
      // from the tree entirely, because a `SliverList` collects a *leading*
      // child of zero extent and this block used to be the leading child.
      // Continue-reading leads now, so the collapse is observable as zero
      // height rather than as absence.)
      expect(
        tester.getSize(find.byType(FeaturedCollectionCard)).height,
        0,
      );
    });

    testWidgets('a failed list renders nothing, and no error chrome', (
      tester,
    ) async {
      tallScreen(tester);
      await tester.pumpWidget(
        host(
          const TodayScreen(),
          [
            ...todayOverrides(FaithId.islam),
            collectionsProvider(FaithId.islam).overrideWith(
              (ref) async =>
                  throw const ApiException(message: 'Could not reach'),
            ),
          ],
          FaithId.islam,
        ),
      );
      await settle(tester);

      expect(find.text('COLLECTIONS'), findsNothing);
      expect(
        tester.getSize(find.byType(FeaturedCollectionCard)).height,
        0,
      );
      expect(
        find.text('Retry'),
        findsNothing,
        reason:
            'a banner above the goal card is noise about a request the '
            'user never made; the retry lives where they went looking',
      );
    });

    testWidgets('opens the collection, not any one reading in it', (
      tester,
    ) async {
      tallScreen(tester);
      await tester.pumpWidget(
        host(
          const TodayScreen(),
          [
            ...todayOverrides(FaithId.islam),
            ...collectionOverrides(
              FaithId.islam,
              () => [FakeCollections.nightly()],
            ),
          ],
          FaithId.islam,
        ),
      );
      await settle(tester);
      await tester.tap(find.text('Nightly Recitation'));
      await tester.pumpAndSettle();

      expect(location, '/quran/collection/nightly-recitation');
    });
  });

  /// The dashboard card's own contract, outside any sliver.
  ///
  /// The dashboard tests above prove it is not *seen*; these prove it costs
  /// nothing, which is the part that keeps the goal card where it is. A
  /// `SliverList` collects a leading child of zero extent, so the two have
  /// to be asserted separately — inside a sliver "absent" and "zero height"
  /// are indistinguishable.
  group('the dashboard card on its own', () {
    Widget bare(List<Override> overrides) => ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        theme: AppTheme.light(FaithId.islam),
        home: const Scaffold(
          body: Align(
            alignment: Alignment.topLeft,
            child: FeaturedCollectionCard(faith: FaithId.islam),
          ),
        ),
      ),
    );

    testWidgets('an empty list is zero pixels tall', (tester) async {
      await tester.pumpWidget(
        bare(collectionOverrides(FaithId.islam, () => const [])),
      );
      await settle(tester);

      expect(tester.getSize(find.byType(FeaturedCollectionCard)).height, 0);
    });

    testWidgets('a failed list is zero pixels tall', (tester) async {
      await tester.pumpWidget(
        bare([
          collectionsProvider(FaithId.islam).overrideWith(
            (ref) async => throw const ApiException(message: 'Could not reach'),
          ),
        ]),
      );
      await settle(tester);

      expect(tester.getSize(find.byType(FeaturedCollectionCard)).height, 0);
    });

    testWidgets('a list still loading is zero pixels tall — no skeleton', (
      tester,
    ) async {
      // The deliberate divergence from Today's other cards. A silhouette
      // that may resolve to nothing would reserve space above the goal
      // card for something that never arrives.
      await tester.pumpWidget(
        bare([
          collectionsProvider(FaithId.islam).overrideWith(
            (ref) => Completer<List<CuratedCollection>>().future,
          ),
        ]),
      );
      await settle(tester);

      expect(tester.getSize(find.byType(FeaturedCollectionCard)).height, 0);
    });

    testWidgets('three featured collections are exactly as tall as one', (
      tester,
    ) async {
      Future<double> heightWith(List<CuratedCollection> featured) async {
        await tester.pumpWidget(
          bare(collectionOverrides(FaithId.islam, () => featured)),
        );
        await settle(tester);
        return tester.getSize(find.byType(FeaturedCollectionCard)).height;
      }

      final one = await heightWith([FakeCollections.nightly(sortOrder: 10)]);
      final three = await heightWith([
        FakeCollections.nightly(sortOrder: 10),
        FakeCollections.extra(
          'morning-adhkar',
          title: 'Morning Adhkar',
          faithId: 'islam',
          sortOrder: 20,
        ),
        FakeCollections.extra(
          'friday-sunnah',
          title: 'Friday Sunnah',
          faithId: 'islam',
          sortOrder: 30,
        ),
      ]);

      expect(one, greaterThan(0));
      expect(
        three,
        one,
        reason:
            'the goal card below must not move when the database features '
            'a second or a tenth collection',
      );
    });
  });

  group('the Practice tab', () {
    testWidgets('Islam lists its collections', (tester) async {
      tallScreen(tester);
      await tester.pumpWidget(
        host(
          const PracticeHomeScreen(),
          [
            selectedFaithProvider.overrideWith(
              () => FakeSelectedFaith(FaithId.islam),
            ),
            surahListProvider.overrideWith((ref) async => const <Surah>[]),
            ...collectionOverrides(
              FaithId.islam,
              () => [FakeCollections.nightly()],
            ),
          ],
          FaithId.islam,
        ),
      );
      await settle(tester);

      expect(find.byType(CollectionsList), findsOneWidget);
      expect(find.text('Nightly Recitation'), findsOneWidget);
    });

    testWidgets('Hindu lists its own — the gap this feature was asked for', (
      tester,
    ) async {
      tallScreen(tester);
      await tester.pumpWidget(
        host(
          const PracticeHomeScreen(),
          [
            selectedFaithProvider.overrideWith(
              () => FakeSelectedFaith(FaithId.hindu),
            ),
            surahListProvider.overrideWith((ref) async => const <Surah>[]),
            ...collectionOverrides(
              FaithId.hindu,
              () => [FakeCollections.gita()],
            ),
          ],
          FaithId.hindu,
        ),
      );
      await settle(tester);

      expect(find.text('Daily Gita'), findsOneWidget);
    });

    testWidgets('lists a collection the dashboard does not feature', (
      tester,
    ) async {
      // Featuring is placement, never availability. A collection with
      // showOnHome false has to stay findable, or turning a flag off would
      // delete a set from the app.
      tallScreen(tester);
      await tester.pumpWidget(
        host(
          const PracticeHomeScreen(),
          [
            selectedFaithProvider.overrideWith(
              () => FakeSelectedFaith(FaithId.islam),
            ),
            surahListProvider.overrideWith((ref) async => const <Surah>[]),
            ...collectionOverrides(
              FaithId.islam,
              () => [FakeCollections.nightly(showOnHome: false)],
            ),
          ],
          FaithId.islam,
        ),
      );
      await settle(tester);

      expect(find.text('Nightly Recitation'), findsOneWidget);
    });

    testWidgets('offers a retry when the list fails, and it is not a card', (
      tester,
    ) async {
      tallScreen(tester);
      await tester.pumpWidget(
        host(
          const PracticeHomeScreen(),
          [
            selectedFaithProvider.overrideWith(
              () => FakeSelectedFaith(FaithId.hindu),
            ),
            surahListProvider.overrideWith((ref) async => const <Surah>[]),
            collectionsProvider(FaithId.hindu).overrideWith(
              (ref) async =>
                  throw const ApiException(message: 'Could not reach'),
            ),
          ],
          FaithId.hindu,
        ),
      );
      await settle(tester);

      expect(find.text('Retry'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(CollectionsList),
          matching: find.byType(PoppyCard),
        ),
        findsNothing,
        reason:
            'a card here would be a button-shaped thing whose only live '
            'target is the small button inside it — the dead-click anatomy',
      );
    });

    testWidgets('draws nothing when the faith has no collections', (
      tester,
    ) async {
      tallScreen(tester);
      await tester.pumpWidget(
        host(
          const PracticeHomeScreen(),
          [
            selectedFaithProvider.overrideWith(
              () => FakeSelectedFaith(FaithId.hindu),
            ),
            surahListProvider.overrideWith((ref) async => const <Surah>[]),
            ...collectionOverrides(
              FaithId.hindu,
              () => const <CuratedCollection>[],
            ),
          ],
          FaithId.hindu,
        ),
      );
      await settle(tester);

      expect(find.text('COLLECTIONS'), findsNothing);
      expect(find.byType(CollectionCard), findsNothing);
      // And the tab itself still rendered, so this is an absent section
      // rather than a broken screen.
      expect(find.text('Japa'), findsOneWidget);
    });
  });
}
