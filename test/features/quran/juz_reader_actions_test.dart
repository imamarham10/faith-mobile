import 'package:faith_mobile/core/theme/app_theme.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:faith_mobile/features/quran/data/dtos/juz.dart';
import 'package:faith_mobile/features/quran/data/dtos/surah.dart';
import 'package:faith_mobile/features/quran/data/juz_repository.dart';
import 'package:faith_mobile/features/quran/presentation/controllers/quran_home_controller.dart';
import 'package:faith_mobile/features/quran/presentation/screens/juz_reader_screen.dart';
import 'package:faith_mobile/features/quran/presentation/widgets/ayah_action_sheet.dart';
import 'package:faith_mobile/features/quran/presentation/widgets/ayah_actions.dart';
import 'package:faith_mobile/features/quran/presentation/widgets/verse_page.dart';
import 'package:faith_mobile/shared/widgets/poppy_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/fake_juz.dart';

/// A juz that never loads, for the one state in which there is no verse.
class _FailingJuzRepository implements JuzRepository {
  @override
  Future<List<JuzSummary>> getJuzIndex() async => const [];

  @override
  Future<JuzPage> getJuzPage(
    int number, {
    int page = 1,
    int limit = JuzRepository.defaultPageLimit,
    String? translationId,
  }) async => throw StateError('offline');
}

/// The juz reader's per-verse actions — the parity it was missing with the
/// scrolling reader.
///
/// Two things are being asserted, and the second is the one with history:
///
/// 1. the actions are **there, and visible**, rather than hidden behind a
///    long-press on a screen that holds exactly one verse; and
/// 2. offering them did **not** turn the reading surface into something
///    pressable. The Practice tab's dead-click reports are what happens
///    when a read-only surface wears a card's traits, and this screen's
///    whole visual argument is that the verse is page and only the
///    controls sit on it.
void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  const surahs = [
    Surah(
      id: 2,
      nameArabic: 'البقرة',
      nameEnglish: 'The Cow',
      nameTransliteration: 'Al-Baqarah',
      revelationPlace: 'medinan',
      verseCount: 286,
    ),
  ];

  late String location;

  Future<void> pump(WidgetTester tester, FakeJuz juz) async {
    // Taller than the default: the action row sits under the verse, and at
    // 600pt it is off-screen and unhittable.
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    location = '/quran/juz/${juz.number}';
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          juzRepositoryProvider.overrideWithValue(FakeJuzRepository(juz: juz)),
          surahListProvider.overrideWith((ref) async => surahs),
        ],
        child: MaterialApp.router(
          theme: AppTheme.light(FaithId.islam),
          routerConfig: GoRouter(
            initialLocation: '/quran/juz/${juz.number}',
            routes: [
              GoRoute(
                path: '/quran/juz/:number',
                builder: (_, state) => JuzReaderScreen(
                  juzNumber: int.parse(state.pathParameters['number']!),
                ),
              ),
              GoRoute(
                path: '/share',
                builder: (_, __) {
                  location = '/share';
                  return const Scaffold(body: Text('share stub'));
                },
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
  }

  group('the actions are offered without a hidden gesture', () {
    testWidgets('all four sit on the verse page, visibly', (tester) async {
      await pump(tester, FakeJuz.spanningThreeSurahs());

      expect(find.byType(AyahActionBar), findsOneWidget);
      for (final label in ['Play', 'Bookmark', 'Share', 'More']) {
        expect(find.text(label), findsOneWidget, reason: '$label is missing');
      }
    });

    testWidgets('the row names the verse the reader is actually on', (
      tester,
    ) async {
      await pump(tester, FakeJuz.spanningThreeSurahs());
      final before = tester
          .widget<AyahActionBar>(find.byType(AyahActionBar))
          .target;
      expect(before.surahId, 2);
      expect(before.verseNumber, 253);
      expect(
        before.totalVerses,
        286,
        reason:
            'from the surah index — the juz payload never says how long '
            'a surah is, and playback stops at its end',
      );

      await tester.tap(find.text('Next'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      final after = tester
          .widget<AyahActionBar>(find.byType(AyahActionBar))
          .target;
      expect(after.verseNumber, 254);
    });

    testWidgets('More opens the same sheet the scrolling reader uses', (
      tester,
    ) async {
      await pump(tester, FakeJuz.spanningThreeSurahs());
      await tester.tap(find.text('More'));
      await tester.pumpAndSettle();

      expect(find.byType(AyahActionSheet), findsOneWidget);
      // Including the long tail, which is why the sheet still exists.
      expect(find.text('Tafsir'), findsOneWidget);
      expect(find.text('Coming soon'), findsOneWidget);
      expect(find.text('Al-Baqarah · 2:253'), findsOneWidget);
    });

    testWidgets('Bookmark reads the verse\'s saved state, not a default', (
      tester,
    ) async {
      // Seeded through the store the controller actually hydrates from, so
      // this exercises the same binding the tap path ends in — without
      // reaching the network write that follows it, which never resolves
      // in a widget test.
      SharedPreferences.setMockInitialValues({
        'quran.bookmarks.v1':
            '[{"id":"local:2:253","surahId":2,"verseNumber":253,'
            '"surahName":"Al-Baqarah","createdAt":"2026-01-01T00:00:00.000Z"}]',
      });
      await pump(tester, FakeJuz.spanningThreeSurahs());

      expect(find.text('Saved'), findsOneWidget);
      expect(find.text('Bookmark'), findsNothing);

      // And the verse *after* it is not, so the row is reading this verse
      // rather than showing one state for the whole screen.
      await tester.tap(find.text('Next'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Bookmark'), findsOneWidget);
      expect(find.text('Saved'), findsNothing);
    });

    testWidgets('Share hands the verse to the share screen', (tester) async {
      await pump(tester, FakeJuz.spanningThreeSurahs());
      await tester.tap(find.text('Share'));
      await tester.pumpAndSettle();

      expect(location, '/share');
    });
  });

  group('offering them did not make the page pressable', () {
    testWidgets('the screen is still built from no cards at all', (
      tester,
    ) async {
      await pump(tester, FakeJuz.spanningThreeSurahs());

      expect(
        find.byType(PoppyCard),
        findsNothing,
        reason:
            'a card in this design system is a button; the action row '
            'must read as a toolbar, not as four tiles',
      );
    });

    testWidgets('nothing between the page and the verse takes a tap', (
      tester,
    ) async {
      await pump(tester, FakeJuz.spanningThreeSurahs());

      final arabic = find.text('arabic-1');
      expect(arabic, findsOneWidget);
      for (final tappable in [
        find.byType(InkWell),
        find.byType(GestureDetector),
      ]) {
        expect(
          find.ancestor(of: arabic, matching: tappable),
          findsNothing,
          reason: 'the verse surface promises nothing',
        );
      }
    });

    testWidgets('the action row is a sibling of the verse, never a child', (
      tester,
    ) async {
      await pump(tester, FakeJuz.spanningThreeSurahs());

      expect(
        find.descendant(
          of: find.byType(VerseSurface),
          matching: find.byType(AyahActionBar),
        ),
        findsNothing,
      );
    });

    testWidgets('every action clears the 48dp minimum touch target', (
      tester,
    ) async {
      await pump(tester, FakeJuz.spanningThreeSurahs());

      for (final label in ['Play', 'Bookmark', 'Share', 'More']) {
        final target = find
            .ancestor(of: find.text(label), matching: find.byType(InkWell))
            .first;
        final size = tester.getSize(target);
        expect(size.width, greaterThanOrEqualTo(48), reason: '$label width');
        expect(size.height, greaterThanOrEqualTo(48), reason: '$label height');
      }
    });
  });

  testWidgets('the actions wait for a verse rather than acting on none', (
    tester,
  ) async {
    // The error branch renders no verse, so there is nothing to act on and
    // the row must not be there offering to act on it.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          juzRepositoryProvider.overrideWithValue(_FailingJuzRepository()),
          surahListProvider.overrideWith((ref) async => surahs),
        ],
        child: MaterialApp(
          theme: AppTheme.light(FaithId.islam),
          home: const JuzReaderScreen(juzNumber: 30),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(AyahActionBar), findsNothing);
  });
}
