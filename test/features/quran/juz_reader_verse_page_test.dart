import 'package:faith_mobile/core/theme/app_theme.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:faith_mobile/features/quran/data/juz_repository.dart';
import 'package:faith_mobile/features/quran/presentation/controllers/quran_home_controller.dart';
import 'package:faith_mobile/features/quran/presentation/screens/juz_reader_screen.dart';
import 'package:faith_mobile/shared/widgets/poppy_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/fake_juz.dart';

/// Two things the redesigned verse surface has to keep being:
///
/// 1. **the right text.** The Arabic-script preference selects an
///    orthography, not a typeface, so a reader set to Indo-Pak must be
///    handed `textIndopak` — and, when that is null (which is every verse
///    until the backend seed runs), must still show the verse.
/// 2. **a page, not a button.** It is the one surface on this screen you
///    cannot press, and the Practice tab's dead-click reports are what
///    happens when a read-only surface wears a card's traits.
void main() {
  Future<void> pump(
    WidgetTester tester,
    FakeJuz juz, {
    String? script,
  }) async {
    SharedPreferences.setMockInitialValues({
      if (script != null) 'arabic_script': script,
    });
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          juzRepositoryProvider.overrideWithValue(FakeJuzRepository(juz: juz)),
          surahListProvider.overrideWith((ref) async => const []),
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

  group('which text the script preference selects', () {
    testWidgets('Indo-Pak — the default — renders the Indo-Pak text', (
      tester,
    ) async {
      await pump(tester, FakeJuz.inEveryScript());

      expect(find.text('indopak-1'), findsOneWidget);
      expect(find.text('arabic-1'), findsNothing);
      expect(find.text('uthmani-1'), findsNothing);
    });

    testWidgets('Uthmani renders the Uthmani text', (tester) async {
      await pump(tester, FakeJuz.inEveryScript(), script: 'uthmani');

      expect(find.text('uthmani-1'), findsOneWidget);
      expect(find.text('indopak-1'), findsNothing);
    });

    testWidgets('Naskh renders the payload text', (tester) async {
      await pump(tester, FakeJuz.inEveryScript(), script: 'naskh');

      expect(find.text('arabic-1'), findsOneWidget);
      expect(find.text('indopak-1'), findsNothing);
    });

    testWidgets('the selection follows the reader across a verse step', (
      tester,
    ) async {
      await pump(tester, FakeJuz.inEveryScript(), script: 'uthmani');
      await tester.tap(find.text('Next'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('uthmani-2'), findsOneWidget);
    });
  });

  group('falling back when textIndopak is null', () {
    // This is the path that is live *now* — the field is additive and
    // arrives only with the backend seed — so it is the one that must not
    // be able to break.
    testWidgets('shows the verse rather than an empty page', (tester) async {
      await pump(tester, FakeJuz.spanningThreeSurahs());

      expect(find.text('arabic-1'), findsOneWidget);
    });

    testWidgets('keeps navigating normally on the fallback text', (
      tester,
    ) async {
      await pump(tester, FakeJuz.spanningThreeSurahs());
      await tester.tap(find.text('Next'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('arabic-2'), findsOneWidget);
    });

    testWidgets('falls back for Uthmani too when the verse carries none', (
      tester,
    ) async {
      // The shape of the surah payload, which has only `textArabic`.
      final juz = FakeJuz(
        number: 30,
        segments: const [
          FakeJuzSegment(
            surahId: 112,
            surahName: 'Al-Ikhlas',
            firstVerseNumber: 1,
            count: 1,
          ),
        ],
        uthmani: false,
      );
      expect(juz.allVerses.first.textUthmani, isNull);

      await pump(tester, juz, script: 'uthmani');

      expect(find.text('arabic-1'), findsOneWidget);
    });
  });

  group('the verse surface is a page, not a button', () {
    testWidgets('is not a card, and holds nothing to press', (tester) async {
      await pump(tester, FakeJuz.inEveryScript());

      final arabic = find.text('indopak-1');
      expect(arabic, findsOneWidget);

      expect(
        find.ancestor(of: arabic, matching: find.byType(PoppyCard)),
        findsNothing,
        reason: 'a card in this design system is a button',
      );
      for (final tappable in [
        find.byType(InkWell),
        find.byType(GestureDetector),
      ]) {
        expect(
          find.ancestor(of: arabic, matching: tappable),
          findsNothing,
          reason: 'nothing between the page and the verse may take a tap',
        );
      }
    });

    testWidgets('wears none of the card signature: no outline, no corner, '
        'no shadow', (tester) async {
      await pump(tester, FakeJuz.inEveryScript());

      final decoration =
          tester
                  .widget<DecoratedBox>(
                    find
                        .ancestor(
                          of: find.text('indopak-1'),
                          matching: find.byType(DecoratedBox),
                        )
                        .first,
                  )
                  .decoration
              as BoxDecoration;

      // Removing only the shadow is what failed on the Practice masthead:
      // fill, outline and corner were still the card's. Here the fill is
      // the only trait shared, and it is the one a page needs.
      expect(decoration.boxShadow ?? const [], isEmpty);
      expect(decoration.borderRadius, isNull);
      expect(
        decoration.border,
        isNot(isA<Border>().having((b) => b.isUniform, 'isUniform', true)),
        reason: 'a uniform border on a filled rect is the card signature; '
            'this page is fenced top and bottom only',
      );
    });

    testWidgets('reaches both screen edges, which no card ever does', (
      tester,
    ) async {
      await pump(tester, FakeJuz.inEveryScript());

      final page = find
          .ancestor(
            of: find.text('indopak-1'),
            matching: find.byType(DecoratedBox),
          )
          .first;
      final rect = tester.getRect(page);
      final screen = tester.view.physicalSize.width / tester.view.devicePixelRatio;

      expect(rect.left, 0);
      expect(rect.right, screen);
    });

    testWidgets('sets the Arabic far larger than the continuous reader', (
      tester,
    ) async {
      await pump(tester, FakeJuz.inEveryScript());

      final arabic = tester.widget<Text>(find.text('indopak-1'));
      // The surah reader renders at the raw preference, 28 by default.
      expect(arabic.style!.fontSize, greaterThan(28 * 1.3));
      expect(
        arabic.style!.height,
        greaterThanOrEqualTo(2.0),
        reason: 'diacritic-dense script at display size needs the leading',
      );
      expect(
        arabic.style!.leadingDistribution,
        TextLeadingDistribution.even,
        reason: 'all the leading below the line crops the marks above the '
            'first one',
      );
    });
  });
}
