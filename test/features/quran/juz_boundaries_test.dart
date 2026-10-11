import 'package:faith_mobile/features/quran/domain/juz_boundaries.dart';
import 'package:flutter_test/flutter_test.dart';

/// The local juz table, which exists so Today's continue-reading card can
/// name a juz on its first frame without a request.
///
/// A hardcoded copy of server data earns its place only if it cannot drift
/// unnoticed, so the invariants that would have to break first are pinned
/// here: thirty entries, strictly ascending, anchored at 1:1. The spot
/// checks are taken from the live `GET /api/v1/islam/quran/juz` payload.
void main() {
  group('the table', () {
    test('has one entry per juz', () {
      expect(kJuzStarts.length, 30);
    });

    test('starts the muṣḥaf at Al-Fatihah 1', () {
      expect(kJuzStarts.first, (1, 1));
    });

    test('is strictly ascending', () {
      for (var i = 1; i < kJuzStarts.length; i++) {
        final (prevSurah, prevVerse) = kJuzStarts[i - 1];
        final (surah, verse) = kJuzStarts[i];
        final ascends =
            surah > prevSurah || (surah == prevSurah && verse > prevVerse);
        expect(
          ascends,
          isTrue,
          reason: 'juz ${i + 1} starts at $surah:$verse, which is not after '
              'juz $i at $prevSurah:$prevVerse',
        );
      }
    });

    test('stays inside the muṣḥaf', () {
      for (final (surah, verse) in kJuzStarts) {
        expect(surah, inInclusiveRange(1, 114));
        expect(verse, greaterThanOrEqualTo(1));
      }
    });
  });

  group('resolving a verse', () {
    test('opens at juz 1', () {
      expect(juzNumberFor(surahId: 1, verseNumber: 1), 1);
    });

    test('keeps the tail of a juz with the juz it belongs to', () {
      // Juz 1 runs to 2:141; juz 2 opens at 2:142. The boundary falls
      // mid-surah, which is the whole reason this is not `surahId ~/ 4`.
      expect(juzNumberFor(surahId: 2, verseNumber: 141), 1);
      expect(juzNumberFor(surahId: 2, verseNumber: 142), 2);
    });

    test('places the example from the reference screen', () {
      // Al-Baqarah 151 — the position the Today redesign was specified
      // against — is in juz 2.
      expect(juzNumberFor(surahId: 2, verseNumber: 151), 2);
    });

    test('handles a surah that no juz starts in', () {
      // Nothing opens in Yunus (10): juz 11 covers it, having started at
      // 9:93. A table walk has to look *back* past the surah entirely.
      expect(juzNumberFor(surahId: 10, verseNumber: 1), 11);
      expect(juzNumberFor(surahId: 10, verseNumber: 109), 11);
    });

    test('closes the muṣḥaf in juz 30', () {
      expect(juzNumberFor(surahId: 78, verseNumber: 1), 30);
      expect(juzNumberFor(surahId: 114, verseNumber: 6), 30);
    });

    test('declines an address outside the muṣḥaf', () {
      // A corrupt stored pointer drops the juz line rather than labelling
      // it wrongly on the first frame of the home screen.
      expect(juzNumberFor(surahId: 0, verseNumber: 1), isNull);
      expect(juzNumberFor(surahId: 115, verseNumber: 1), isNull);
    });

    test('does not range-check the verse against the surah', () {
      // Already-nonsense input stays harmless: both readers treat an
      // out-of-range verse as "start at the beginning" rather than as an
      // error, and this agrees with them instead of throwing.
      expect(juzNumberFor(surahId: 1, verseNumber: 9999), 1);
      expect(juzNumberFor(surahId: 1, verseNumber: 0), 1);
    });
  });
}
