import 'package:faith_mobile/features/hindu_scriptures/domain/shloka_ref.dart';
import 'package:flutter_test/flutter_test.dart';

/// The two readers must name a śloka identically or a verse read in both on
/// one day is counted twice — see `shloka_ref.dart`. The only way to test
/// "two call sites cannot disagree" is to assert there is one function and
/// that it is deterministic; the structural half of the guarantee is that
/// `chapter_reader_screen.dart` and `chapter_verse_reader_screen.dart` both
/// call it, which `chapter_verse_reader_test.dart` pins from the widget
/// tree.
void main() {
  group('shlokaDedupeKey', () {
    test('is deterministic for the same verse', () {
      String key() => shlokaDedupeKey(
        textSlug: 'bhagavad-gita',
        chapterNumber: 2,
        verseNumber: 47,
      );

      expect(key(), key());
      expect(key(), 'hindu:bhagavad-gita:2:47');
    });

    test('separates verses, chapters and texts', () {
      final gita = shlokaDedupeKey(
        textSlug: 'bhagavad-gita',
        chapterNumber: 2,
        verseNumber: 47,
      );

      final nextVerse = shlokaDedupeKey(
        textSlug: 'bhagavad-gita',
        chapterNumber: 2,
        verseNumber: 48,
      );
      final nextChapter = shlokaDedupeKey(
        textSlug: 'bhagavad-gita',
        chapterNumber: 3,
        verseNumber: 47,
      );
      final otherText = shlokaDedupeKey(
        textSlug: 'ramayana',
        chapterNumber: 2,
        verseNumber: 47,
      );

      expect(gita, isNot(equals(nextVerse)));
      expect(gita, isNot(equals(nextChapter)));
      expect(
        gita,
        isNot(equals(otherText)),
        reason:
            'two texts share chapter and verse numbers; the key must not '
            'collapse 2:47 of the Ramayana into 2:47 of the Gita',
      );
    });

    test('exists for every text, not only the Gita', () {
      // The whole reason this is a separate function from the sourceRef: a
      // null key would mean every re-read of a Ramayana verse counted again.
      expect(
        shlokaDedupeKey(
          textSlug: 'ramayana',
          chapterNumber: 1,
          verseNumber: 1,
        ),
        isNotEmpty,
      );
    });
  });

  group('shlokaSourceRef', () {
    test('is contract §1.6 shape for the Gita', () {
      expect(
        shlokaSourceRef(
          textSlug: 'bhagavad-gita',
          chapterNumber: 2,
          verseNumber: 47,
        ),
        'gita:2:47',
      );
    });

    test('is null for a text §1.6 has no shape for', () {
      // Omitting the field is what §1.6 permits; inventing a fourth segment
      // would be a silent contract change.
      expect(
        shlokaSourceRef(
          textSlug: 'ramayana',
          chapterNumber: 2,
          verseNumber: 47,
        ),
        isNull,
      );
    });

    test('never exceeds the 128-character sourceRef limit', () {
      final ref = shlokaSourceRef(
        textSlug: 'bhagavad-gita',
        chapterNumber: 999,
        verseNumber: 999,
      );
      expect(ref!.length, lessThanOrEqualTo(128));
    });
  });

  group('isGitaSlug', () {
    test('recognises the seeded slug and its plausible variants', () {
      expect(isGitaSlug('bhagavad-gita'), isTrue);
      expect(isGitaSlug('gita'), isTrue);
      expect(isGitaSlug('Bhagavad-Gita'), isTrue);
      expect(isGitaSlug('ramayana'), isFalse);
      expect(isGitaSlug('vishnu-sahasranama'), isFalse);
    });
  });
}
