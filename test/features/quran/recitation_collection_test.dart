import 'package:faith_mobile/features/quran/domain/reading_mode.dart';
import 'package:faith_mobile/features/quran/domain/recitation_collection.dart';
import 'package:flutter_test/flutter_test.dart';

/// The curated-collection model, and the one question the UI ever asks it:
/// **where does this item open?**
///
/// The nightly set mixes a whole surah, a single verse and a span, which is
/// the whole reason the item is a sealed class. Each of the three resolves
/// to a genuinely different destination, and getting any of them wrong is
/// invisible until someone taps "Ayat al-Kursi" and lands at the top of
/// Al-Baqarah.
void main() {
  group('a whole surah', () {
    const item = WholeSurahItem(
      surahId: 67,
      title: 'Al-Mulk',
      subtitle: 'Surah 67',
    );

    test('opens the scrolling reader when that is the reader in use', () {
      expect(item.route(ReadingMode.continuous), '/quran/surah/67');
    });

    test('opens the verse pager when that is the reader in use', () {
      expect(item.route(ReadingMode.verseByVerse), '/quran/surah/67/verses');
    });

    test('names no verse either way — a whole surah starts at its start', () {
      for (final mode in ReadingMode.values) {
        expect(item.route(mode), isNot(contains('from=')));
        expect(item.route(mode), isNot(contains('ayah=')));
      }
    });
  });

  group('a single verse', () {
    const item = SingleVerseItem(
      surahId: 2,
      verseNumber: 255,
      title: 'Ayat al-Kursi',
      subtitle: '2:255',
    );

    test('opens fenced to that one verse', () {
      expect(
        item.route(ReadingMode.continuous),
        '/quran/surah/2/verses?from=255&to=255',
      );
    });

    test('ignores the reading-mode preference', () {
      // The scrolling reader cannot fence a verse: pointed at 2:255 it
      // shows the rest of Al-Baqarah after it, which is not the item the
      // user tapped. So the preference loses here, deliberately.
      expect(
        item.route(ReadingMode.verseByVerse),
        item.route(ReadingMode.continuous),
      );
    });
  });

  group('a verse range', () {
    const item = VerseRangeItem(
      surahId: 2,
      from: 285,
      to: 286,
      title: 'The last two verses of Al-Baqarah',
      subtitle: '2:285–286',
    );

    test('opens fenced to the span', () {
      expect(
        item.route(ReadingMode.continuous),
        '/quran/surah/2/verses?from=285&to=286',
      );
    });

    test('ignores the reading-mode preference, for the same reason', () {
      expect(
        item.route(ReadingMode.verseByVerse),
        item.route(ReadingMode.continuous),
      );
    });

    test('rejects a range that ends before it starts', () {
      expect(
        () => VerseRangeItem(
          surahId: 2,
          from: 286,
          to: 285,
          title: 'backwards',
          subtitle: '',
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('the nightly set', () {
    test('is the six readings the brief named, in reciting order', () {
      expect(kNightlyRecitation.items.map((i) => i.subtitle).toList(), [
        'Surah 112',
        'Surah 113',
        'Surah 114',
        '2:255',
        '2:285–286',
        'Surah 67',
      ]);
    });

    test('uses all three item shapes', () {
      final shapes = kNightlyRecitation.items.map((i) => i.runtimeType).toSet();
      expect(shapes, {WholeSurahItem, SingleVerseItem, VerseRangeItem});
    });

    test('every item resolves to a route the Quran tab actually serves', () {
      for (final mode in ReadingMode.values) {
        for (final item in kNightlyRecitation.items) {
          expect(
            item.route(mode),
            startsWith('/quran/surah/'),
            reason: '${item.title} must open in a reader',
          );
        }
      }
    });

    test('is reachable by its own route, and by id from the registry', () {
      expect(kNightlyRecitation.route, '/quran/collection/nightly');
      expect(kRecitationCollections['nightly'], same(kNightlyRecitation));
    });

    test('an unknown id is a miss, not a crash', () {
      expect(kRecitationCollections['morning'], isNull);
    });
  });

  group('when the nightly set is promoted onto Today', () {
    test('through the evening and the small hours', () {
      for (final hour in [19, 21, 23, 0, 3]) {
        expect(isNightlyHour(hour), isTrue, reason: '$hour:00');
      }
    });

    test('not during the day', () {
      for (final hour in [4, 9, 12, 17, 18]) {
        expect(isNightlyHour(hour), isFalse, reason: '$hour:00');
      }
    });
  });

  group('reading-mode routes', () {
    test('open a surah at a verse in either reader', () {
      expect(
        surahReadingRoute(2, mode: ReadingMode.continuous, ayah: 255),
        '/quran/surah/2?ayah=255',
      );
      expect(
        surahReadingRoute(2, mode: ReadingMode.verseByVerse, ayah: 255),
        '/quran/surah/2/verses?from=255',
      );
    });

    test('each mode names the other, so a reader can offer the switch', () {
      expect(ReadingMode.continuous.other, ReadingMode.verseByVerse);
      expect(ReadingMode.verseByVerse.other, ReadingMode.continuous);
    });
  });
}
