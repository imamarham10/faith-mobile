import 'package:faith_mobile/core/theme/app_theme.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:faith_mobile/features/quran/data/dtos/surah.dart';
import 'package:faith_mobile/features/quran/data/juz_repository.dart';
import 'package:faith_mobile/features/quran/presentation/controllers/quran_home_controller.dart';
import 'package:faith_mobile/features/quran/presentation/screens/juz_reader_screen.dart';
import 'package:faith_mobile/shared/widgets/poppy_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/fake_juz.dart';

/// The juz reader's screen-level behaviour: what it shows, what the two
/// buttons do, and what it must not be made of.
void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  /// Surah lengths for the denominator in "253/286". The juz payload names
  /// the surah but never says how long it is — see [_VerseSurface].
  const surahs = [
    Surah(
      id: 2,
      nameArabic: 'البقرة',
      nameEnglish: 'The Cow',
      nameTransliteration: 'Al-Baqarah',
      revelationPlace: 'medinan',
      verseCount: 286,
    ),
    Surah(
      id: 3,
      nameArabic: 'آل عمران',
      nameEnglish: 'Family of Imran',
      nameTransliteration: "Ali 'Imran",
      revelationPlace: 'medinan',
      verseCount: 200,
    ),
    Surah(
      id: 114,
      nameArabic: 'الناس',
      nameEnglish: 'Mankind',
      nameTransliteration: 'An-Nas',
      revelationPlace: 'meccan',
      verseCount: 6,
    ),
  ];

  Future<void> pump(WidgetTester tester, FakeJuz juz) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          juzRepositoryProvider.overrideWithValue(FakeJuzRepository(juz: juz)),
          surahListProvider.overrideWith((ref) async => surahs),
        ],
        child: MaterialApp(
          theme: AppTheme.light(FaithId.islam),
          home: JuzReaderScreen(juzNumber: juz.number),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
  }

  /// The wrapper a nav button dims itself with when it has nothing to do.
  double opacityOf(WidgetTester tester, String label) => tester
      .widget<Opacity>(
        find
            .ancestor(of: find.text(label), matching: find.byType(Opacity))
            .first,
      )
      .opacity;

  Future<void> tapNav(WidgetTester tester, String label) async {
    await tester.tap(find.text(label));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
  }

  testWidgets('opens on the first verse, named and positioned', (tester) async {
    await pump(tester, FakeJuz.spanningThreeSurahs());

    expect(find.text('2. Al-Baqarah  ·  253/286'), findsOneWidget);
    expect(find.text('arabic-1'), findsOneWidget);
    expect(find.text('translation-1'), findsOneWidget);
  });

  testWidgets('counts verses left against the whole juz', (tester) async {
    await pump(tester, FakeJuz.spanningThreeSurahs());

    // 120 verses, sitting on the first.
    expect(find.text('Juz 2  ·  119 verses left'), findsOneWidget);
  });

  testWidgets('forward carries the reader into the next surah', (tester) async {
    final juz = FakeJuz.spanningThreeSurahs();
    await pump(tester, juz);
    for (var i = 0; i < 30; i++) {
      await tapNav(tester, 'Next');
    }

    expect(find.text("3. Ali 'Imran  ·  1/200"), findsOneWidget);
  });

  testWidgets('back is dimmed and inert on the first verse', (tester) async {
    await pump(tester, FakeJuz.spanningThreeSurahs());

    expect(opacityOf(tester, 'Back'), lessThan(1));
    expect(opacityOf(tester, 'Next'), 1);

    await tapNav(tester, 'Back');

    expect(
      find.text('2. Al-Baqarah  ·  253/286'),
      findsOneWidget,
      reason: 'tapping a disabled Back must not move the cursor',
    );
  });

  testWidgets('forward is dimmed and inert on the last verse', (tester) async {
    await pump(tester, FakeJuz.twoVerses());
    await tapNav(tester, 'Next');

    expect(find.text('114. An-Nas  ·  1/6'), findsOneWidget);
    expect(find.text('Juz 30  ·  Last verse'), findsOneWidget);
    expect(opacityOf(tester, 'Next'), lessThan(1));
    expect(opacityOf(tester, 'Back'), 1);

    await tapNav(tester, 'Next');

    expect(find.text('114. An-Nas  ·  1/6'), findsOneWidget);
  });

  testWidgets('back returns to the previous verse', (tester) async {
    await pump(tester, FakeJuz.twoVerses());
    await tapNav(tester, 'Next');
    await tapNav(tester, 'Back');

    expect(find.text('113. Al-Falaq  ·  5/6'), findsNothing);
    // Al-Falaq is absent from the surah fixture on purpose: the position
    // degrades to a bare verse number rather than holding up the verse.
    expect(find.text('113. Al-Falaq  ·  Verse 5'), findsOneWidget);
  });

  testWidgets('is not built from cards', (tester) async {
    await pump(tester, FakeJuz.spanningThreeSurahs());

    expect(
      find.byType(PoppyCard),
      findsNothing,
      reason:
          'the verse, its position and the juz progress are reading '
          'matter — a card here reads as pressable, which is the bug '
          'PageMasthead and Colophon were written to fix',
    );
  });

  testWidgets('renders Arabic alone when the edition has no translation', (
    tester,
  ) async {
    await pump(tester, FakeJuz.withoutTranslations());

    expect(find.text('arabic-1'), findsOneWidget);
    expect(
      find.byType(Divider),
      findsNothing,
      reason: 'the rule above the translation has nothing to separate',
    );
  });
}
