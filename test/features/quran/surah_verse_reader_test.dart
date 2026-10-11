import 'package:faith_mobile/core/theme/app_theme.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:faith_mobile/features/quran/data/dtos/translation.dart';
import 'package:faith_mobile/features/quran/data/dtos/verse.dart';
import 'package:faith_mobile/features/quran/presentation/controllers/surah_controller.dart';
import 'package:faith_mobile/features/quran/presentation/screens/surah_verse_reader_screen.dart';
import 'package:faith_mobile/features/quran/presentation/widgets/ayah_actions.dart';
import 'package:faith_mobile/shared/widgets/poppy_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// `/quran/surah/:id/verses` — the surah-scoped half of verse-by-verse
/// reading, and the destination every curated passage resolves to.
///
/// The thing worth testing here is the **fence**. A collection item like
/// "the last two verses of Al-Baqarah" is two verses out of 286, and the
/// claim this screen makes is that Back and Next stop at the ends of the
/// span — which is the whole reason a span does not open in the scrolling
/// reader, where it could not.
void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  SurahDetail surah({int verses = 10}) => SurahDetail(
    id: 2,
    nameArabic: 'البقرة',
    nameEnglish: 'Al-Baqarah',
    verses: [
      for (var i = 1; i <= verses; i++)
        Verse(
          id: '2:$i',
          surahId: 2,
          verseNumber: i,
          textArabic: 'arabic-$i',
          translations: [
            Translation(
              language: 'en',
              authorName: 'Fixture',
              text: 'translation-$i',
            ),
          ],
        ),
    ],
  );

  Future<void> pump(
    WidgetTester tester, {
    int? from,
    int? to,
    int verses = 10,
  }) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          surahDetailProvider(
            2,
          ).overrideWith((ref) async => surah(verses: verses)),
        ],
        child: MaterialApp(
          theme: AppTheme.light(FaithId.islam),
          home: SurahVerseReaderScreen(surahId: 2, from: from, to: to),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
  }

  Future<void> tapNav(WidgetTester tester, String label) async {
    await tester.tap(find.text(label));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
  }

  double opacityOf(WidgetTester tester, String label) => tester
      .widget<Opacity>(
        find
            .ancestor(of: find.text(label), matching: find.byType(Opacity))
            .first,
      )
      .opacity;

  group('the whole surah', () {
    testWidgets('opens on its first verse and counts the rest', (tester) async {
      await pump(tester);

      expect(find.text('2. Al-Baqarah  ·  1/10'), findsOneWidget);
      expect(find.text('arabic-1'), findsOneWidget);
      expect(find.text('Al-Baqarah  ·  9 verses left'), findsOneWidget);
    });

    testWidgets('?from= opens on a verse without fencing the surah', (
      tester,
    ) async {
      await pump(tester, from: 4);

      expect(find.text('arabic-4'), findsOneWidget);
      // Still the whole surah underneath: six after it, and Back works.
      expect(find.text('Al-Baqarah  ·  6 verses left'), findsOneWidget);
      await tapNav(tester, 'Back');
      expect(find.text('arabic-3'), findsOneWidget);
    });
  });

  group('a fenced span', () {
    testWidgets('shows only the span, and says so', (tester) async {
      await pump(tester, from: 5, to: 6);

      expect(find.text('arabic-5'), findsOneWidget);
      expect(find.text('Al-Baqarah  ·  5–6  ·  1 verse left'), findsOneWidget);
    });

    testWidgets('Back is inert at the start of the span, not of the surah', (
      tester,
    ) async {
      await pump(tester, from: 5, to: 6);

      expect(opacityOf(tester, 'Back'), lessThan(1));
      await tapNav(tester, 'Back');
      expect(find.text('arabic-5'), findsOneWidget);
    });

    testWidgets('Next stops at the end of the span, not of the surah', (
      tester,
    ) async {
      await pump(tester, from: 5, to: 6);
      await tapNav(tester, 'Next');

      expect(find.text('arabic-6'), findsOneWidget);
      expect(find.text('Al-Baqarah  ·  5–6  ·  Last verse'), findsOneWidget);
      expect(opacityOf(tester, 'Next'), lessThan(1));

      await tapNav(tester, 'Next');
      expect(find.text('arabic-6'), findsOneWidget);
      expect(find.text('arabic-7'), findsNothing);
    });

    testWidgets('a span of one is the verse and nothing after it', (
      tester,
    ) async {
      // How a single-verse collection item (Ayat al-Kursi) arrives.
      await pump(tester, from: 3, to: 3);

      expect(find.text('arabic-3'), findsOneWidget);
      expect(opacityOf(tester, 'Back'), lessThan(1));
      expect(opacityOf(tester, 'Next'), lessThan(1));
    });

    testWidgets('a span that matches nothing falls back to the surah', (
      tester,
    ) async {
      // A stale or hand-typed link. Better the whole surah than a reader
      // with no verses in it.
      await pump(tester, from: 900, to: 901);

      expect(find.text('arabic-1'), findsOneWidget);
    });
  });

  testWidgets('offers the same verse actions as the juz reader', (
    tester,
  ) async {
    await pump(tester);

    expect(find.byType(AyahActionBar), findsOneWidget);
    final target = tester
        .widget<AyahActionBar>(find.byType(AyahActionBar))
        .target;
    expect(target.surahId, 2);
    expect(target.verseNumber, 1);
    expect(target.totalVerses, 10);
  });

  testWidgets('is a page, not a stack of cards', (tester) async {
    await pump(tester);

    expect(
      find.byType(PoppyCard),
      findsNothing,
      reason: 'same rule as the juz reader — the verse is the page',
    );
  });
}
