import 'package:faith_mobile/features/today/domain/daily_verse.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('curatedDailyVerses', () {
    test('holds enough entries that the card is not a fixture', () {
      // The bug this replaces: one verse, hardcoded, unchanged since
      // February. Anything under a fortnight of distinct days reads the
      // same way to a daily user.
      expect(curatedDailyVerses.length, greaterThanOrEqualTo(14));
    });

    test('never references Al-Baqarah or Aal-Imran', () {
      // `GET /surah/:id` returns the whole surah: 746KB for Al-Baqarah,
      // 462KB for Aal-Imran. Measured against the live corpus — a reference
      // into either would make the home screen pull that to render one card.
      expect(
        curatedDailyVerses.where((v) => v.surahId == 2 || v.surahId == 3),
        isEmpty,
      );
    });

    test('carries no scripture text, only references', () {
      // VerseRef has exactly two int fields. This test exists so that an
      // attempt to inline Arabic into the table fails here rather than
      // shipping a transcription error.
      expect(curatedDailyVerses.first, isA<VerseRef>());
      expect(curatedDailyVerses.first.toString(), 'VerseRef(94:5)');
    });
  });

  group('verseRefForDay', () {
    test('is stable within a day and changes between days', () {
      final morning = DateTime(2026, 10, 9, 5, 30);
      final night = DateTime(2026, 10, 9, 23, 59);
      final tomorrow = DateTime(2026, 10, 10, 5, 30);

      expect(verseRefForDay(morning), verseRefForDay(night));
      expect(verseRefForDay(tomorrow), isNot(verseRefForDay(morning)));
    });

    test('advances by exactly one across a month boundary', () {
      final before = verseRefForDay(DateTime(2026, 10, 31));
      final after = verseRefForDay(DateTime(2026, 11, 1));
      final expected = curatedDailyVerses[(curatedDailyVerses.indexOf(before) +
              1) %
          curatedDailyVerses.length];
      expect(after, expected);
    });

    test('covers the whole table across a year', () {
      final seen = <VerseRef>{};
      for (var i = 0; i < 366; i++) {
        seen.add(verseRefForDay(DateTime(2026, 1, 1 + i)));
      }
      expect(seen.length, curatedDailyVerses.length);
    });
  });

  group('dayOfYear', () {
    test('counts from one', () {
      expect(dayOfYear(DateTime(2026, 1, 1)), 1);
      expect(dayOfYear(DateTime(2026, 12, 31)), 365);
    });

    test('accounts for a leap day', () {
      expect(dayOfYear(DateTime(2028, 12, 31)), 366);
    });

    test('is unaffected by the time of day', () {
      expect(dayOfYear(DateTime(2026, 3, 29, 0, 1)), dayOfYear(DateTime(2026, 3, 29, 23, 59)));
    });
  });
}
