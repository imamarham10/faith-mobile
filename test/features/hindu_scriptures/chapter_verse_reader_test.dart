import 'package:faith_mobile/core/theme/app_theme.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:faith_mobile/core/theme/sanskrit_text.dart';
import 'package:faith_mobile/features/hindu_scriptures/data/dtos/scripture_chapter.dart';
import 'package:faith_mobile/features/hindu_scriptures/data/dtos/scripture_text.dart';
import 'package:faith_mobile/features/hindu_scriptures/data/dtos/scripture_verse.dart';
import 'package:faith_mobile/features/hindu_scriptures/data/dtos/verse_translation.dart';
import 'package:faith_mobile/features/hindu_scriptures/domain/shloka_ref.dart';
import 'package:faith_mobile/features/hindu_scriptures/presentation/controllers/chapter_controller.dart';
import 'package:faith_mobile/features/hindu_scriptures/presentation/screens/chapter_verse_reader_screen.dart';
import 'package:faith_mobile/features/hindu_scriptures/presentation/widgets/shloka_actions.dart';
import 'package:faith_mobile/shared/habit/activity_event.dart';
import 'package:faith_mobile/shared/reader/verse_page.dart';
import 'package:faith_mobile/shared/widgets/poppy_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// `/quran/hindu-scripture/:slug/:chapter/verses` — the Hindu half of
/// verse-by-verse reading, built to parity with the Qur'an's pagers.
///
/// Three things are worth pinning here, and they are the three the task
/// named: that **Back and Next stop at the ends of the chapter** (a Gita
/// chapter is the unit the reader opened and Next must not wander into the
/// next one); that the **activity key comes from `shloka_ref.dart`** rather
/// than from a string built on this screen, so the pager and the scroll
/// cannot disagree about what 2:47 is called; and that the screen is **not
/// built from cards**, since in this design system a card is a button.
void main() {
  const slug = 'bhagavad-gita';

  setUp(() => SharedPreferences.setMockInitialValues({}));

  ChapterDetail chapter({int verses = 10}) => ChapterDetail(
    id: 'ch-2',
    textId: 'txt-1',
    chapterNumber: 2,
    nameSanskrit: 'सांख्ययोग',
    nameEnglish: 'Sankhya Yoga',
    verses: [
      for (var i = 1; i <= verses; i++)
        ScriptureVerse(
          id: 'v-$i',
          textId: 'txt-1',
          chapterId: 'ch-2',
          verseNumber: i,
          sanskritText: 'संस्कृत-$i',
          transliteration: 'translit-$i',
          translations: [
            VerseTranslation(
              id: 'tr-$i',
              languageCode: 'en',
              authorName: 'Fixture',
              text: 'translation-$i',
            ),
          ],
        ),
    ],
  );

  const textDetail = ScriptureTextDetail(
    id: 'txt-1',
    slug: slug,
    nameEnglish: 'Bhagavad Gita',
    nameSanskrit: 'भगवद्गीता',
    type: 'gita',
    totalVerses: 700,
  );

  Future<void> pump(
    WidgetTester tester, {
    int? from,
    int? to,
    int verses = 10,
    String textSlug = slug,
  }) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          chapterDetailProvider(
            textSlug,
            2,
          ).overrideWith((ref) async => chapter(verses: verses)),
          scriptureTextDetailProvider(
            textSlug,
          ).overrideWith((ref) async => textDetail),
        ],
        child: MaterialApp(
          theme: AppTheme.light(FaithId.hindu),
          home: ChapterVerseReaderScreen(
            textSlug: textSlug,
            chapterNumber: 2,
            from: from,
            to: to,
          ),
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

  group('the whole chapter', () {
    testWidgets('opens on its first verse and counts the rest', (tester) async {
      await pump(tester);

      expect(find.text('Sankhya Yoga  ·  1/10'), findsOneWidget);
      expect(find.text('संस्कृत-1'), findsOneWidget);
      expect(find.text('Sankhya Yoga  ·  9 verses left'), findsOneWidget);
    });

    testWidgets('shows transliteration and translation with the verse', (
      tester,
    ) async {
      await pump(tester);

      expect(find.text('translit-1'), findsOneWidget);
      expect(find.text('translation-1'), findsOneWidget);
    });

    testWidgets('?from= opens on a verse without fencing the chapter', (
      tester,
    ) async {
      await pump(tester, from: 4);

      expect(find.text('संस्कृत-4'), findsOneWidget);
      // Still the whole chapter underneath: six after it, and Back works.
      expect(find.text('Sankhya Yoga  ·  6 verses left'), findsOneWidget);
      await tapNav(tester, 'Back');
      expect(find.text('संस्कृत-3'), findsOneWidget);
    });

    testWidgets('Next steps forward one verse at a time', (tester) async {
      await pump(tester);
      await tapNav(tester, 'Next');

      expect(find.text('संस्कृत-2'), findsOneWidget);
      expect(find.text('संस्कृत-1'), findsNothing);
    });
  });

  group('the chapter boundaries', () {
    testWidgets('Back is inert on the first verse', (tester) async {
      await pump(tester);

      expect(opacityOf(tester, 'Back'), lessThan(1));
      await tapNav(tester, 'Back');
      expect(
        find.text('संस्कृत-1'),
        findsOneWidget,
        reason: 'there is no verse 0 to step back to',
      );
    });

    testWidgets('Next is inert on the last verse — it does not roll into '
        'the next chapter', (tester) async {
      await pump(tester, from: 10);

      expect(find.text('संस्कृत-10'), findsOneWidget);
      expect(find.text('Sankhya Yoga  ·  Last verse'), findsOneWidget);
      expect(opacityOf(tester, 'Next'), lessThan(1));

      await tapNav(tester, 'Next');
      expect(find.text('संस्कृत-10'), findsOneWidget);
    });

    testWidgets('a one-verse chapter disables both ends at once', (
      tester,
    ) async {
      await pump(tester, verses: 1);

      expect(opacityOf(tester, 'Back'), lessThan(1));
      expect(opacityOf(tester, 'Next'), lessThan(1));
      expect(find.text('Sankhya Yoga  ·  Last verse'), findsOneWidget);
    });
  });

  group('a fenced span', () {
    testWidgets('shows only the span, and says so', (tester) async {
      await pump(tester, from: 5, to: 6);

      expect(find.text('संस्कृत-5'), findsOneWidget);
      expect(
        find.text('Sankhya Yoga  ·  5–6  ·  1 verse left'),
        findsOneWidget,
      );
    });

    testWidgets('Back stops at the start of the span, not of the chapter', (
      tester,
    ) async {
      await pump(tester, from: 5, to: 6);

      expect(opacityOf(tester, 'Back'), lessThan(1));
      await tapNav(tester, 'Back');
      expect(find.text('संस्कृत-5'), findsOneWidget);
    });

    testWidgets('Next stops at the end of the span, not of the chapter', (
      tester,
    ) async {
      await pump(tester, from: 5, to: 6);
      await tapNav(tester, 'Next');

      expect(find.text('संस्कृत-6'), findsOneWidget);
      expect(opacityOf(tester, 'Next'), lessThan(1));

      await tapNav(tester, 'Next');
      expect(find.text('संस्कृत-7'), findsNothing);
    });

    testWidgets('a span of one is the verse and nothing after it', (
      tester,
    ) async {
      await pump(tester, from: 3, to: 3);

      expect(find.text('संस्कृत-3'), findsOneWidget);
      expect(
        find.text('Sankhya Yoga  ·  3  ·  Last verse'),
        findsOneWidget,
        reason: '"3–3" reads as a typo; a span of one is just the verse',
      );
    });

    testWidgets('a span that matches nothing falls back to the chapter', (
      tester,
    ) async {
      await pump(tester, from: 900, to: 901);

      expect(find.text('संस्कृत-1'), findsOneWidget);
    });
  });

  group('the activity it records', () {
    testWidgets('names the verse with the shared ref helper, not a literal', (
      tester,
    ) async {
      await pump(tester);

      final recorder = tester.widget<VerseReadRecorder>(
        find.byType(VerseReadRecorder),
      );
      expect(recorder.activityType, ActivityType.gitaShloka);
      expect(
        recorder.dedupeKey,
        shlokaDedupeKey(textSlug: slug, chapterNumber: 2, verseNumber: 1),
      );
      expect(
        recorder.sourceRef,
        shlokaSourceRef(textSlug: slug, chapterNumber: 2, verseNumber: 1),
      );
    });

    testWidgets('re-keys as the cursor moves', (tester) async {
      await pump(tester);
      await tapNav(tester, 'Next');

      final recorder = tester.widget<VerseReadRecorder>(
        find.byType(VerseReadRecorder),
      );
      expect(
        recorder.dedupeKey,
        shlokaDedupeKey(textSlug: slug, chapterNumber: 2, verseNumber: 2),
      );
    });

    testWidgets('still dedupes a text §1.6 cannot reference', (tester) async {
      // A Ramayana verse has no expressible sourceRef, but must still count
      // once a day rather than once per re-read.
      await pump(tester, textSlug: 'ramayana');

      final recorder = tester.widget<VerseReadRecorder>(
        find.byType(VerseReadRecorder),
      );
      expect(recorder.sourceRef, isNull);
      expect(recorder.dedupeKey, isNotNull);
    });
  });

  group('the verse actions', () {
    testWidgets('are pinned on the screen, with the verse in hand', (
      tester,
    ) async {
      await pump(tester);

      expect(find.byType(ShlokaActionBar), findsOneWidget);
      final target = tester
          .widget<ShlokaActionBar>(find.byType(ShlokaActionBar))
          .target;
      expect(target.verseId, 'v-1');
      expect(target.verseNumber, 1);
      expect(target.chapterNumber, 2);
      expect(
        target.textName,
        'Bhagavad Gita',
        reason: 'the book names a share card, not the chapter',
      );
      expect(target.label, 'Bhagavad Gita · 2:1');
    });

    testWidgets('offer no Play, because there is no per-verse narration', (
      tester,
    ) async {
      await pump(tester);

      expect(
        find.text('Play'),
        findsNothing,
        reason:
            'Hindu audio is one file per chapter with no verse offsets; a '
            'Play on a verse would start the chapter from verse 1',
      );
      expect(find.text('Bookmark'), findsOneWidget);
      expect(find.text('Share'), findsOneWidget);
      expect(find.text('More'), findsOneWidget);
    });
  });

  group('the page it draws', () {
    testWidgets('is a page, not a stack of cards', (tester) async {
      await pump(tester);

      expect(
        find.byType(PoppyCard),
        findsNothing,
        reason: 'same rule as the Qur\'an verse readers — the verse is the '
            'page, and a card in this design system is a button',
      );
    });

    testWidgets('sets Devanagari LTR with its own leading', (tester) async {
      await pump(tester);

      final surface = tester.widget<VerseSurface>(find.byType(VerseSurface));
      expect(surface.scriptureDirection, TextDirection.ltr);
      expect(
        surface.scriptureStyle.height,
        sanskritLineHeight,
        reason: 'conjuncts hang below the baseline and mātrās above it',
      );
      expect(
        surface.scriptureStyle.leadingDistribution,
        TextLeadingDistribution.even,
        reason:
            'all leading below the glyphs clips the first line\'s mātrās — '
            'the Devanagari version of the clipped Arabic marks',
      );
    });

    testWidgets('magnifies the reader\'s own font-size preference', (
      tester,
    ) async {
      await pump(tester);

      final surface = tester.widget<VerseSurface>(find.byType(VerseSurface));
      // 26 is the scripture reader's default; the pager is a constant
      // multiple louder rather than a second opinion.
      expect(surface.scriptureStyle.fontSize, VerseSurface.displayFontSize(26));
    });
  });
}
