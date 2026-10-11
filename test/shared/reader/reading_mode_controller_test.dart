import 'package:faith_mobile/features/hindu_scriptures/domain/chapter_reading_route.dart';
import 'package:faith_mobile/features/quran/domain/reading_mode.dart';
import 'package:faith_mobile/shared/reader/reading_mode_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Reading mode is **one** preference across the verticals, because it is
/// how you read and not what you are reading. That makes two things worth
/// pinning: that the choice someone made while only the Qur'an had a pager
/// survives the rename of the key it was stored under, and that both
/// verticals' route helpers answer to the same enum.
void main() {
  Future<ReadingMode> read(ProviderContainer container) =>
      container.read(readingModeControllerProvider.future);

  ProviderContainer makeContainer() {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    return container;
  }

  group('the remembered mode', () {
    test('defaults to scrolling on a fresh install', () async {
      SharedPreferences.setMockInitialValues({});

      expect(await read(makeContainer()), ReadingMode.continuous);
    });

    test('reads what was last set', () async {
      SharedPreferences.setMockInitialValues({
        'reader.readingMode': 'verseByVerse',
      });

      expect(await read(makeContainer()), ReadingMode.verseByVerse);
    });

    test('falls back to scrolling on a value it cannot parse', () async {
      // A downgrade, or a hand-edited preferences file. Better the default
      // than a crash on launch.
      SharedPreferences.setMockInitialValues({
        'reader.readingMode': 'pageByPage',
      });

      expect(await read(makeContainer()), ReadingMode.continuous);
    });

    test('survives a set', () async {
      SharedPreferences.setMockInitialValues({});
      final container = makeContainer();
      await read(container);

      await container
          .read(readingModeControllerProvider.notifier)
          .set(ReadingMode.verseByVerse);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('reader.readingMode'), 'verseByVerse');
      expect(await read(makeContainer()), ReadingMode.verseByVerse);
    });
  });

  group('migrating off the quran-prefixed key', () {
    test('carries forward a choice made before the rename', () async {
      SharedPreferences.setMockInitialValues({
        'quran.readingMode': 'verseByVerse',
      });

      expect(
        await read(makeContainer()),
        ReadingMode.verseByVerse,
        reason:
            'renaming the key must not silently reset a preference someone '
            'actually chose',
      );
    });

    test('writes the choice forward so the old key is read only once',
        () async {
      SharedPreferences.setMockInitialValues({
        'quran.readingMode': 'verseByVerse',
      });
      await read(makeContainer());

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('reader.readingMode'), 'verseByVerse');
    });

    test('the new key wins when both are present', () async {
      SharedPreferences.setMockInitialValues({
        'reader.readingMode': 'continuous',
        'quran.readingMode': 'verseByVerse',
      });

      expect(await read(makeContainer()), ReadingMode.continuous);
    });
  });

  group('the routes each vertical resolves it to', () {
    test('the Qur\'an sends a surah to its two readers', () {
      expect(
        surahReadingRoute(2, mode: ReadingMode.continuous),
        '/quran/surah/2',
      );
      expect(
        surahReadingRoute(2, mode: ReadingMode.verseByVerse, ayah: 255),
        '/quran/surah/2/verses?from=255',
      );
    });

    test('a Hindu text sends a chapter to its two readers', () {
      expect(
        chapterReadingRoute('bhagavad-gita', 2, mode: ReadingMode.continuous),
        '/quran/hindu-scripture/bhagavad-gita/2',
      );
      expect(
        chapterReadingRoute(
          'bhagavad-gita',
          2,
          mode: ReadingMode.verseByVerse,
          verse: 47,
        ),
        '/quran/hindu-scripture/bhagavad-gita/2/verses?from=47',
      );
    });

    test('verse 1 is the start of the passage, not a position in it', () {
      // Every "continue reading" pointer starts life at verse 1, and
      // `?verse=1` / `?from=1` would be noise in the URL for the one case
      // that is already the default.
      expect(
        chapterReadingRoute(
          'bhagavad-gita',
          2,
          mode: ReadingMode.continuous,
          verse: 1,
        ),
        '/quran/hindu-scripture/bhagavad-gita/2',
      );
      expect(
        chapterReadingRoute(
          'bhagavad-gita',
          2,
          mode: ReadingMode.verseByVerse,
          verse: 1,
        ),
        '/quran/hindu-scripture/bhagavad-gita/2/verses',
      );
    });
  });
}
