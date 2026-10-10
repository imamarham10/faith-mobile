import 'package:faith_mobile/core/theme/app_theme.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:faith_mobile/features/quran/data/dtos/juz.dart';
import 'package:faith_mobile/features/quran/data/dtos/surah.dart';
import 'package:faith_mobile/features/quran/data/juz_repository.dart';
import 'package:faith_mobile/features/quran/domain/often_read.dart';
import 'package:faith_mobile/features/quran/presentation/controllers/quran_home_controller.dart';
import 'package:faith_mobile/features/quran/presentation/screens/quran_home_screen.dart';
import 'package:faith_mobile/features/quran/presentation/widgets/juz_list_tile.dart';
import 'package:faith_mobile/features/quran/presentation/widgets/surah_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/fake_juz.dart';

/// The Qur'an tab's two indexes, the shortcut row above them, and the one
/// request that must not happen.
void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  Surah surah(int id, String name) => Surah(
    id: id,
    nameArabic: 'ا',
    nameEnglish: name,
    nameTransliteration: name,
    revelationPlace: 'meccan',
    verseCount: 10,
  );

  final surahs = [
    surah(1, 'Al-Fatihah'),
    surah(2, 'Al-Baqarah'),
    surah(3, "Ali 'Imran"),
  ];

  JuzSummary juzSummary(int number, String startSurah, String endSurah) =>
      JuzSummary(
        number: number,
        start: JuzBoundary(surahId: 1, surahName: startSurah, verseNumber: 1),
        end: JuzBoundary(surahId: 2, surahName: endSurah, verseNumber: 141),
        verseCount: 148,
        surahIds: const [1, 2],
      );

  late FakeJuzRepository repo;
  late String location;

  Future<void> pump(WidgetTester tester) async {
    // Taller than the 800x600 default: this screen stacks a masthead, a
    // search box, a shortcut row, a segmented control and a list, and at
    // 600pt the list rows are off-screen and unhittable. The width is left
    // at 800 deliberately — the test font is far wider per glyph than the
    // real one, so narrowing to a phone width overflows rows that are fine
    // on a device.
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    repo = FakeJuzRepository(
      juz: FakeJuz.spanningThreeSurahs(),
      index: [
        juzSummary(1, 'Al-Fatihah', 'Al-Baqarah'),
        juzSummary(2, 'Al-Baqarah', 'Al-Baqarah'),
        juzSummary(3, 'Al-Baqarah', "Ali 'Imran"),
      ],
    );
    final router = GoRouter(
      initialLocation: '/quran',
      routes: [
        GoRoute(path: '/quran', builder: (_, __) => const QuranHomeScreen()),
        GoRoute(
          path: '/quran/surah/:id',
          builder: (_, state) {
            location = '/quran/surah/${state.pathParameters['id']}';
            return const Scaffold(body: Text('surah stub'));
          },
        ),
        GoRoute(
          path: '/quran/juz/:number',
          builder: (_, state) {
            location = '/quran/juz/${state.pathParameters['number']}';
            return const Scaffold(body: Text('juz stub'));
          },
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          surahListProvider.overrideWith((ref) async => surahs),
          juzRepositoryProvider.overrideWithValue(repo),
        ],
        child: MaterialApp.router(
          theme: AppTheme.light(FaithId.islam),
          routerConfig: router,
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
  }

  Future<void> selectJuz(WidgetTester tester) async {
    await tester.tap(find.text('Juz'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
  }

  Future<void> type(WidgetTester tester, String query) async {
    await tester.enterText(find.byType(TextField), query);
    // The search box debounces at 220ms.
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump();
  }

  group('Often read', () {
    // The row's contents are a product decision, not a rendering one, so
    // they are pinned here rather than by scrolling a horizontal list.
    test('holds every surah the brief named', () {
      final ids = kOftenReadSurahs.map((s) => s.id).toSet();

      // Al-Kahf, Ya-Sin, Ar-Rahman, Al-Waqi'ah, Al-Mulk.
      expect(ids, containsAll(<int>[18, 36, 55, 56, 67]));
    });

    test('every entry carries the occasion that earned it a slot', () {
      for (final s in kOftenReadSurahs) {
        expect(s.occasion, isNotEmpty, reason: '${s.name} has no cadence');
      }
    });

    test('leaves out Al-Fatihah', () {
      // The most recited surah there is, and for that reason the least
      // opened: everyone has it by heart and it is in every rak'ah. See
      // kOftenReadSurahs' doc.
      expect(kOftenReadSurahs.map((s) => s.id), isNot(contains(1)));
    });

    testWidgets('appears above the index', (tester) async {
      await pump(tester);

      expect(find.text('OFTEN READ'), findsOneWidget);
      expect(find.text('Al-Kahf'), findsOneWidget);
      expect(find.text('Fridays'), findsOneWidget);
    });

    testWidgets('a shortcut opens that surah', (tester) async {
      await pump(tester);
      await tester.tap(find.text('Al-Kahf'));
      await tester.pumpAndSettle();

      expect(location, '/quran/surah/18');
    });

    testWidgets('steps aside once the reader is searching', (tester) async {
      await pump(tester);
      await type(tester, 'baqarah');

      expect(find.text('OFTEN READ'), findsNothing);
    });
  });

  group('Surah | Juz', () {
    testWidgets('lands on the surah index', (tester) async {
      await pump(tester);

      expect(find.byType(SurahListTile), findsWidgets);
      expect(find.byType(JuzListTile), findsNothing);
    });

    testWidgets('asks for no juz data until the Juz segment is chosen', (
      tester,
    ) async {
      await pump(tester);

      expect(
        repo.indexCalls,
        0,
        reason: 'GET /juz must not be on the Quran tab\'s cold open',
      );

      await selectJuz(tester);

      expect(repo.indexCalls, 1);
    });

    testWidgets('the Juz segment lists all the juz it is given', (
      tester,
    ) async {
      await pump(tester);
      await selectJuz(tester);

      expect(find.byType(JuzListTile), findsNWidgets(3));
      expect(find.byType(SurahListTile), findsNothing);
      expect(find.text('Juz 1'), findsOneWidget);
    });

    testWidgets('a juz row opens the reader', (tester) async {
      await pump(tester);
      await selectJuz(tester);
      await tester.tap(find.text('Juz 2'));
      await tester.pumpAndSettle();

      expect(location, '/quran/juz/2');
    });
  });

  group('search', () {
    testWidgets('filters the juz list by number', (tester) async {
      await pump(tester);
      await selectJuz(tester);
      await type(tester, '3');

      expect(find.byType(JuzListTile), findsOneWidget);
      expect(find.text('Juz 3'), findsOneWidget);
    });

    testWidgets('filters the juz list by the surahs it spans', (tester) async {
      await pump(tester);
      await selectJuz(tester);
      await type(tester, "ali 'imran");

      expect(find.byType(JuzListTile), findsOneWidget);
      expect(find.text('Juz 3'), findsOneWidget);
    });

    testWidgets('a query survives the switch between segments', (tester) async {
      await pump(tester);
      await type(tester, 'baqarah');
      expect(find.byType(SurahListTile), findsOneWidget);

      await selectJuz(tester);

      expect(
        find.byType(JuzListTile),
        findsNWidgets(3),
        reason: 'every fixture juz touches Al-Baqarah',
      );
    });
  });
}
