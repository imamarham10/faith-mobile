import 'dart:async';

import 'package:faith_mobile/core/preferences/selected_faith.dart';
import 'package:faith_mobile/core/theme/app_theme.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:faith_mobile/features/collections/presentation/controllers/collections_controller.dart';
import 'package:faith_mobile/features/collections/presentation/widgets/featured_collection_card.dart';
import 'package:faith_mobile/features/feelings/data/dtos/emotion.dart';
import 'package:faith_mobile/features/feelings/presentation/controllers/emotions_controller.dart';
import 'package:faith_mobile/features/hadiths/data/dtos/hadith.dart';
import 'package:faith_mobile/features/hadiths/presentation/controllers/daily_hadith_controller.dart';
import 'package:faith_mobile/features/hindu_scriptures/data/dtos/scripture_verse.dart';
import 'package:faith_mobile/features/hindu_scriptures/presentation/controllers/daily_shloka_controller.dart';
import 'package:faith_mobile/features/hindu_scriptures/presentation/controllers/hindu_scriptures_home_controller.dart';
import 'package:faith_mobile/features/hindu_stories/data/dtos/hindu_story.dart';
import 'package:faith_mobile/features/hindu_stories/presentation/controllers/daily_katha_controller.dart';
import 'package:faith_mobile/features/quran/presentation/controllers/quran_home_controller.dart';
import 'package:faith_mobile/features/today/domain/daily_verse.dart';
import 'package:faith_mobile/features/today/presentation/controllers/daily_verse_controller.dart';
import 'package:faith_mobile/features/today/presentation/controllers/today_dashboard_controller.dart';
import 'package:faith_mobile/features/today/presentation/screens/today_screen.dart';
import 'package:faith_mobile/features/today/presentation/widgets/continue_reading_card.dart';
import 'package:faith_mobile/features/today/presentation/widgets/goal_card.dart';
import 'package:faith_mobile/features/today/presentation/widgets/week_strip.dart';
import 'package:faith_mobile/shared/widgets/poppy_button.dart';
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

/// Today's primary element: continue reading, in both faiths.
///
/// Three things are asserted here that the project has paid for before:
///
/// * **It is never empty and never broken.** A reader with no stored
///   position gets an invitation, not a hole where the biggest card on the
///   screen should be — and the invitation says "start", not "continue".
/// * **The whole card is the target.** A card in this design system is a
///   button. The large call to action inside it is painted, not wired, so
///   there is exactly one live region and it is the card.
/// * **Both faiths, identically.** Same position, same anatomy, same
///   copy shapes, through the same widget.
void main() {
  late String location;

  /// Pins a stored Qur'an position, with or without the display context
  /// the readers persist beside it.
  void storeIslamPointer({
    int surah = 2,
    int verse = 151,
    String? name = 'Al-Baqarah',
    int? count = 286,
    String mode = 'continuous',
  }) {
    SharedPreferences.setMockInitialValues({
      'quran.lastRead.surah': surah,
      'quran.lastRead.verse': verse,
      if (name != null) 'quran.lastRead.surahName': name,
      if (count != null) 'quran.lastRead.verseCount': count,
      'reader.readingMode': mode,
    });
  }

  void storeHinduPointer({
    String slug = 'bhagavad-gita',
    int chapter = 12,
    int verse = 5,
    String? name = 'Bhagavad Gita',
    int? count = 20,
    String mode = 'continuous',
  }) {
    SharedPreferences.setMockInitialValues({
      'hinduScriptures.lastRead.slug': slug,
      'hinduScriptures.lastRead.chapter': chapter,
      'hinduScriptures.lastRead.verse': verse,
      if (name != null) 'hinduScriptures.lastRead.textName': name,
      if (count != null) 'hinduScriptures.lastRead.chapterVerseCount': count,
      'reader.readingMode': mode,
    });
  }

  /// A router that records where a tap landed. Every reader path this card
  /// can produce is registered, so a wrong destination fails as a wrong
  /// `location` rather than as a router exception.
  Widget host(Widget home, FaithId faith, {List<Override> overrides = const []}) {
    location = '/';
    GoRoute recorder(String path) => GoRoute(
      path: path,
      builder: (_, state) {
        final query = state.uri.query;
        location = query.isEmpty
            ? state.uri.path
            : '${state.uri.path}?$query';
        return const Scaffold(body: Text('reader'));
      },
    );

    return ProviderScope(
      overrides: overrides,
      child: MaterialApp.router(
        theme: AppTheme.light(faith),
        routerConfig: GoRouter(
          initialLocation: '/',
          routes: [
            GoRoute(path: '/', builder: (_, __) => home),
            recorder('/quran/surah/:id'),
            recorder('/quran/surah/:id/verses'),
            recorder('/quran/hindu-scripture/:slug/:chapter'),
            recorder('/quran/hindu-scripture/:slug/:chapter/verses'),
            recorder('/quran/collection/:slug'),
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

  /// The card on its own, which is where its copy and its routing live.
  Future<void> pumpCard(
    WidgetTester tester,
    FaithId faith, {
    List<Override> overrides = const [],
  }) async {
    await tester.pumpWidget(
      host(
        Scaffold(
          body: Align(
            alignment: Alignment.topLeft,
            child: ContinueReadingCard(faith: faith),
          ),
        ),
        faith,
        overrides: overrides,
      ),
    );
    await settle(tester);
  }

  /// The whole screen, for the questions only the screen can answer.
  List<Override> todayOverrides(FaithId faith) => [
    selectedFaithProvider.overrideWith(() => FakeSelectedFaith(faith)),
    todayDashboardProvider.overrideWith(
      (ref) async => faith == FaithId.islam
          ? FakeTodayDashboard.islam()
          : FakeTodayDashboard.hindu(),
    ),
    dailyVerseProvider.overrideWith((ref) => Completer<DailyVerse>().future),
    dailyHadithProvider.overrideWith((ref) => Completer<Hadith?>().future),
    dailyShlokaProvider.overrideWith(
      (ref) => Completer<ScriptureVerse?>().future,
    ),
    dailyKathaProvider.overrideWith((ref) => Completer<HinduStory?>().future),
    collectionsProvider(FaithId.islam).overrideWith(
      (ref) async => [FakeCollections.nightly()],
    ),
    collectionsProvider(FaithId.hindu).overrideWith(
      (ref) async => [FakeCollections.gita()],
    ),
    emotionsProvider.overrideWith(
      (ref) async => const <Emotion>[...FakeEmotions.islam],
    ),
  ];

  Future<void> pumpScreen(WidgetTester tester, FaithId faith) async {
    tester.view.physicalSize = const Size(1000, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      host(const TodayScreen(), faith, overrides: todayOverrides(faith)),
    );
    await settle(tester);
  }

  group('Islam, picking a reading up', () {
    setUp(storeIslamPointer);

    testWidgets('names the passage and the position in it', (tester) async {
      await pumpCard(tester, FaithId.islam);

      expect(find.text('CONTINUE READING'), findsOneWidget);
      expect(find.text('Al-Baqarah'), findsOneWidget);
      // Position inside the surah, and the place the surah sits in — never
      // a share of the Qur'an. A pointer says where the reader *is*, not
      // that they have read everything behind it.
      expect(find.text('Verse 151 of 286  ·  Juz 2'), findsOneWidget);
    });

    testWidgets('claims no completion anywhere on the card', (tester) async {
      await pumpCard(tester, FaithId.islam);

      expect(find.textContaining('%'), findsNothing);
      expect(find.textContaining('of 30'), findsNothing);
      expect(find.textContaining('complete'), findsNothing);
    });

    testWidgets('lands on the verse that was left off', (tester) async {
      await pumpCard(tester, FaithId.islam);
      await tester.tap(find.byType(PoppyCard));
      await tester.pumpAndSettle();

      expect(location, '/quran/surah/2?ayah=151');
    });

    testWidgets('honours the remembered verse-by-verse preference', (
      tester,
    ) async {
      // The reading-mode preference governs every entry point in the app.
      // The Qur'an tab's own continue-reading card hardcodes the scrolling
      // reader's path; this one must not copy that.
      storeIslamPointer(mode: 'verseByVerse');
      await pumpCard(tester, FaithId.islam);
      await tester.tap(find.byType(PoppyCard));
      await tester.pumpAndSettle();

      expect(location, '/quran/surah/2/verses?from=151');
    });

    testWidgets('degrades to the bare address for a pointer with no context', (
      tester,
    ) async {
      // What a pointer stored by a build that predates the persisted name
      // and length looks like. It must still be a usable card, not a
      // broken one — and it heals on the next save.
      storeIslamPointer(name: null, count: null);
      await pumpCard(tester, FaithId.islam);

      expect(find.text('Surah 2'), findsOneWidget);
      expect(find.text('Verse 151  ·  Juz 2'), findsOneWidget);
      expect(
        find.textContaining(' of '),
        findsNothing,
        reason: 'a length nobody stored must not be invented',
      );
    });
  });

  group('Islam, with nothing read yet', () {
    setUp(() => SharedPreferences.setMockInitialValues({}));

    testWidgets('offers a start rather than drawing nothing', (tester) async {
      await pumpCard(tester, FaithId.islam);

      expect(find.text('START READING'), findsOneWidget);
      expect(find.text('Al-Fatihah'), findsOneWidget);
      expect(find.text('Begin at the first verse  ·  Juz 1'), findsOneWidget);
      expect(find.text('CONTINUE READING'), findsNothing);
    });

    testWidgets('opens Al-Fatihah at the top', (tester) async {
      await pumpCard(tester, FaithId.islam);
      await tester.tap(find.byType(PoppyCard));
      await tester.pumpAndSettle();

      expect(location, '/quran/surah/1');
    });
  });

  group('Hindu, picking a reading up', () {
    setUp(storeHinduPointer);

    testWidgets('names the book, the chapter and the position', (tester) async {
      await pumpCard(tester, FaithId.hindu);

      expect(find.text('CONTINUE READING'), findsOneWidget);
      expect(find.text('Bhagavad Gita'), findsOneWidget);
      expect(find.text('Chapter 12'), findsOneWidget);
      // The chapter's length, not the book's: "verse 5 of 700" would tell
      // a reader nothing about the sitting they are in.
      expect(find.text('Verse 5 of 20'), findsOneWidget);
    });

    testWidgets('lands on the verse that was left off', (tester) async {
      await pumpCard(tester, FaithId.hindu);
      await tester.tap(find.byType(PoppyCard));
      await tester.pumpAndSettle();

      expect(location, '/quran/hindu-scripture/bhagavad-gita/12?verse=5');
    });

    testWidgets('honours the remembered verse-by-verse preference', (
      tester,
    ) async {
      storeHinduPointer(mode: 'verseByVerse');
      await pumpCard(tester, FaithId.hindu);
      await tester.tap(find.byType(PoppyCard));
      await tester.pumpAndSettle();

      expect(location, '/quran/hindu-scripture/bhagavad-gita/12/verses?from=5');
    });

    testWidgets('falls back to the slug when no name was stored', (
      tester,
    ) async {
      storeHinduPointer(
        slug: 'ramayana-aranya-kanda',
        chapter: 3,
        verse: 2,
        name: null,
        count: null,
      );
      await pumpCard(tester, FaithId.hindu);

      expect(find.text('Ramayana Aranya Kanda'), findsOneWidget);
      expect(find.text('Verse 2'), findsOneWidget);
    });
  });

  group('Hindu, with nothing read yet', () {
    setUp(() => SharedPreferences.setMockInitialValues({}));

    testWidgets('offers the same start its Islam twin does', (tester) async {
      // Islam-first has been a repeated failure in this project. A fresh
      // install must get an invitation on either side, not a card on one
      // and a hole on the other.
      await pumpCard(tester, FaithId.hindu);

      expect(find.text('START READING'), findsOneWidget);
      expect(find.text('Bhagavad Gita'), findsOneWidget);
      expect(find.text('Chapter 1'), findsOneWidget);
      expect(find.text('Begin at the first verse'), findsOneWidget);
    });

    testWidgets('opens the Gita at chapter one', (tester) async {
      await pumpCard(tester, FaithId.hindu);
      await tester.tap(find.byType(PoppyCard));
      await tester.pumpAndSettle();

      expect(location, '/quran/hindu-scripture/bhagavad-gita/1');
    });
  });

  group('while the stored position is still being read', () {
    setUp(() => SharedPreferences.setMockInitialValues({}));

    testWidgets('draws nothing rather than guessing', (tester) async {
      // `null` from this pointer means *either* "prefs not read yet" or
      // "nothing stored". Treating the first as the second would paint
      // "Start reading · Al-Fatihah" for a frame on every cold start and
      // then rewrite the biggest card on the screen.
      await pumpCard(
        tester,
        FaithId.islam,
        overrides: [
          lastReadControllerProvider.overrideWith(_PendingLastRead.new),
        ],
      );

      expect(find.byType(PoppyCard), findsNothing);
      expect(find.text('START READING'), findsNothing);
      expect(
        tester.getSize(find.byType(ContinueReadingCard)).height,
        0,
        reason: 'no skeleton either — and no reserved gap below it',
      );
    });

    testWidgets('draws nothing on the Hindu side too', (tester) async {
      await pumpCard(
        tester,
        FaithId.hindu,
        overrides: [
          scriptureLastReadControllerProvider.overrideWith(
            _PendingScriptureLastRead.new,
          ),
        ],
      );

      expect(tester.getSize(find.byType(ContinueReadingCard)).height, 0);
    });
  });

  group('the card is the button', () {
    setUp(storeIslamPointer);

    testWidgets('the card itself carries the tap', (tester) async {
      await pumpCard(tester, FaithId.islam);

      final card = tester.widget<PoppyCard>(find.byType(PoppyCard));
      expect(
        card.onTap,
        isNotNull,
        reason: 'a card that looks pressable must be pressable — this '
            'project\'s most-repeated complaint',
      );
    });

    testWidgets('the call to action is painted, not a second target', (
      tester,
    ) async {
      await pumpCard(tester, FaithId.islam);

      expect(
        find.descendant(
          of: find.byType(ContinueReadingCard),
          matching: find.byType(PoppyButton),
        ),
        findsNothing,
        reason:
            'a button inside the card would make the card a button-shaped '
            'thing whose only live region is the pill in its lower third',
      );
      // Exactly one gesture detector in the subtree: the card's own.
      expect(
        find.descendant(
          of: find.byType(ContinueReadingCard),
          matching: find.byType(GestureDetector),
        ),
        findsOneWidget,
      );
    });

    testWidgets('tapping the call to action works, because the card does', (
      tester,
    ) async {
      await pumpCard(tester, FaithId.islam);
      await tester.tap(find.text('Pick up in Al-Baqarah'));
      await tester.pumpAndSettle();

      expect(location, '/quran/surah/2?ayah=151');
    });
  });

  group('the Today hierarchy', () {
    testWidgets('Islam leads with reading, then the featured collection', (
      tester,
    ) async {
      storeIslamPointer();
      await pumpScreen(tester, FaithId.islam);

      final reading = tester.getTopLeft(find.byType(ContinueReadingCard)).dy;
      final collection = tester
          .getTopLeft(find.byType(FeaturedCollectionCard))
          .dy;
      final strip = tester.getTopLeft(find.byType(WeekStrip)).dy;
      final goal = tester.getTopLeft(find.byType(GoalCard)).dy;

      expect(reading, lessThan(collection));
      expect(collection, lessThan(strip));
      expect(
        strip,
        lessThan(goal),
        reason: 'the habit loop moved down whole — strip, goal, checklist '
            'and tiles are one unit and were not split apart',
      );
    });

    testWidgets('Hindu has the identical order', (tester) async {
      storeHinduPointer();
      await pumpScreen(tester, FaithId.hindu);

      final reading = tester.getTopLeft(find.byType(ContinueReadingCard)).dy;
      final collection = tester
          .getTopLeft(find.byType(FeaturedCollectionCard))
          .dy;
      final strip = tester.getTopLeft(find.byType(WeekStrip)).dy;

      expect(reading, lessThan(collection));
      expect(collection, lessThan(strip));
      expect(find.text('Bhagavad Gita'), findsOneWidget);
      expect(find.text('Daily Gita'), findsOneWidget);
    });

    testWidgets('a fresh install still leads with a readable card', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({});
      await pumpScreen(tester, FaithId.islam);

      expect(find.text('START READING'), findsOneWidget);
      expect(
        tester.getTopLeft(find.byType(ContinueReadingCard)).dy,
        lessThan(tester.getTopLeft(find.byType(WeekStrip)).dy),
      );
    });
  });
}

/// A last-read pointer that never resolves, standing in for the frames
/// between app start and the first `shared_preferences` read.
class _PendingLastRead extends LastReadController {
  @override
  Future<LastRead?> build() => Completer<LastRead?>().future;
}

class _PendingScriptureLastRead extends ScriptureLastReadController {
  @override
  Future<ScriptureLastRead?> build() =>
      Completer<ScriptureLastRead?>().future;
}
