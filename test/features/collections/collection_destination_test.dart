import 'package:faith_mobile/features/collections/data/dtos/collection_item.dart';
import 'package:faith_mobile/features/collections/domain/collection_destination.dart';
import 'package:faith_mobile/shared/reader/reading_mode.dart';
import 'package:flutter_test/flutter_test.dart';

/// The item-type → destination table, which is the whole of what the client
/// does with a collection item.
///
/// A pure function, tested as one. The old sealed-class version of this
/// could only be exercised by building the screen that rendered it; a
/// server-driven `refType` string has far more cases — including ones the
/// seed does not contain yet and one the server could invent tomorrow — and
/// none of them are worth a widget pump.
void main() {
  CollectionItem item(
    String refType, {
    CollectionRef ref = const CollectionRef(),
    CollectionUnresolved? unresolved,
  }) => CollectionItem(
    sequence: 1,
    refType: refType,
    label: 'x',
    ref: ref,
    unresolved: unresolved,
  );

  group('Qur\'an items', () {
    test('a whole surah honours the remembered reader', () {
      final subject = item('surah', ref: const CollectionRef(surahId: 112));

      expect(
        collectionItemRoute(subject, mode: ReadingMode.continuous),
        '/quran/surah/112',
      );
      expect(
        collectionItemRoute(subject, mode: ReadingMode.verseByVerse),
        '/quran/surah/112/verses',
      );
    });

    test('a single verse is a fenced span of one, whatever the preference', () {
      // `ayahEnd: null` is how the server addresses Ayat al-Kursi, and the
      // span must close on 255 rather than running on into 2:256.
      final subject = item(
        'ayah_range',
        ref: const CollectionRef(surahId: 2, ayahStart: 255),
      );

      for (final mode in ReadingMode.values) {
        expect(
          collectionItemRoute(subject, mode: mode),
          '/quran/surah/2/verses?from=255&to=255',
          reason: 'the scrolling reader cannot fence a span',
        );
      }
    });

    test('a run of verses is fenced at both ends', () {
      expect(
        collectionItemRoute(
          item(
            'ayah_range',
            ref: const CollectionRef(surahId: 2, ayahStart: 285, ayahEnd: 286),
          ),
          mode: ReadingMode.continuous,
        ),
        '/quran/surah/2/verses?from=285&to=286',
      );
    });
  });

  group('Hindu items', () {
    test('a verse range opens the pager, fenced', () {
      final subject = item(
        'hindu_verse_range',
        ref: const CollectionRef(
          hinduTextSlug: 'bhagavad-gita',
          chapterNumber: 12,
          verseStart: 1,
          verseEnd: 20,
        ),
      );

      for (final mode in ReadingMode.values) {
        expect(
          collectionItemRoute(subject, mode: mode),
          '/quran/hindu-scripture/bhagavad-gita/12/verses?from=1&to=20',
        );
      }
    });

    test('no verseStart degrades to the whole chapter, not to nothing', () {
      expect(
        collectionItemRoute(
          item(
            'hindu_verse_range',
            ref: const CollectionRef(
              hinduTextSlug: 'bhagavad-gita',
              chapterNumber: 12,
            ),
          ),
          mode: ReadingMode.continuous,
        ),
        '/quran/hindu-scripture/bhagavad-gita/12',
      );
    });
  });

  group('practice items', () {
    test('a dua is addressed by its uuid, not its slug', () {
      expect(
        collectionItemRoute(
          item('dua', ref: const CollectionRef(refId: 'abc-123')),
          mode: ReadingMode.continuous,
        ),
        '/practice/duas/abc-123',
      );
      // `/practice/duas/:id` cannot take a slug, so a slug-only dua leads
      // nowhere rather than to a screen that will not find it.
      expect(
        collectionItemRoute(
          item('dua', ref: const CollectionRef(refSlug: 'dua-before-sleep')),
          mode: ReadingMode.continuous,
        ),
        isNull,
      );
    });

    test('a Name of Allah is addressed by its 1-99 id', () {
      expect(
        collectionItemRoute(
          item('allah_name', ref: const CollectionRef(refId: '42')),
          mode: ReadingMode.continuous,
        ),
        '/practice/names/allah/42',
      );
    });

    test('a stotra is addressed by its slug', () {
      expect(
        collectionItemRoute(
          item('stotra', ref: const CollectionRef(refSlug: 'hanuman-chalisa')),
          mode: ReadingMode.continuous,
        ),
        '/practice/stotras/hanuman-chalisa',
      );
    });
  });

  group('items that lead nowhere', () {
    test('a prose instruction has no destination by design', () {
      expect(
        collectionItemRoute(item('text'), mode: ReadingMode.continuous),
        isNull,
      );
    });

    test('refTypes with no addressable route answer null, not a list screen', () {
      // Landing someone on /practice/dhikr after they tapped a named dhikr
      // is a tap that looks like it worked and did not.
      for (final refType in ['dhikr', 'mantra', 'hadith']) {
        expect(
          collectionItemRoute(
            item(refType, ref: const CollectionRef(refSlug: 'something')),
            mode: ReadingMode.continuous,
          ),
          isNull,
          reason: refType,
        );
      }
    });

    test('a refType this build has never heard of does not throw', () {
      // The server's vocabulary is a list it can extend without asking. A
      // client that crashed, or failed to parse, would turn one new item
      // into a collection that cannot be opened at all.
      expect(
        collectionItemRoute(
          item('kirtan_set', ref: const CollectionRef(refSlug: 'x')),
          mode: ReadingMode.continuous,
        ),
        isNull,
      );
    });

    test('an unresolved ref never routes, whatever its refType says', () {
      expect(
        collectionItemRoute(
          item(
            'surah',
            ref: const CollectionRef(surahId: 112),
            unresolved: const CollectionUnresolved(reason: 'not seeded'),
          ),
          mode: ReadingMode.continuous,
        ),
        isNull,
      );
    });
  });

  group('Begin', () {
    test('skips past items that lead nowhere', () {
      final route = collectionBeginRoute([
        item('text'),
        item('surah', ref: const CollectionRef(surahId: 112)),
      ], mode: ReadingMode.continuous);

      expect(route, '/quran/surah/112');
    });

    test('is null when nothing in the set opens', () {
      expect(
        collectionBeginRoute([item('text')], mode: ReadingMode.continuous),
        isNull,
        reason: 'a Begin button that did nothing is the worst dead click here',
      );
    });
  });
}
