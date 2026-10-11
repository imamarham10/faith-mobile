import 'package:faith_mobile/features/quran/data/dtos/verse.dart';
import 'package:faith_mobile/features/quran/data/quran_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/stub_http.dart';

/// `GET /surah/:id` is public and attaches **every** English edition it has
/// — one free, four paid — in whatever order the database returns them. The
/// readers all render `translations.first`. These tests pin the repository
/// as the place that decision is made.
void main() {
  /// Shape copied from the live response for Al-Fatihah.
  Map<String, dynamic> translation(String author, {required bool premium}) => {
    'language': 'en',
    'authorName': author,
    'text': 'In the name of Allah, by $author.',
    'isPremium': premium,
  };

  Map<String, dynamic> surahPayload(List<Map<String, dynamic>> translations) =>
      {
        'id': 1,
        'nameArabic': 'الفاتحة',
        'nameEnglish': 'Al-Fatihah',
        'verses': [
          {
            'id': 'v-1',
            'surahId': 1,
            'verseNumber': 1,
            'textArabic': 'بِسْمِ اللَّهِ',
            'translations': translations,
          },
        ],
      };

  Future<SurahDetail> fetch(List<Map<String, dynamic>> translations) {
    final adapter = StubHttpAdapter({
      '/quran/surah/1': (200, surahPayload(translations)),
    });
    return QuranRepository(adapter.dio()).getSurah(1);
  }

  test('keeps only the free edition', () async {
    final surah = await fetch([
      translation('Saheeh International', premium: false),
      translation('Pickthall', premium: true),
      translation('Yusuf Ali', premium: true),
      translation('Muhsin Khan', premium: true),
      translation('Dr. Mustafa Khattab', premium: true),
    ]);

    expect(surah.verses.single.translations.map((t) => t.authorName), [
      'Saheeh International',
    ]);
  });

  test(
    '"first" no longer depends on the order the server happened to use',
    () async {
      // The same payload with the free edition last. Before the filter this
      // handed the reader Pickthall.
      final surah = await fetch([
        translation('Pickthall', premium: true),
        translation('Yusuf Ali', premium: true),
        translation('Saheeh International', premium: false),
      ]);

      expect(
        surah.verses.single.translations.first.authorName,
        'Saheeh International',
      );
    },
  );

  test('a verse with nothing free falls back to Arabic alone', () async {
    // Which is exactly how the juz reader already degrades when the server
    // answers `translation: null`, so the two readers behave the same.
    final surah = await fetch([translation('Pickthall', premium: true)]);

    expect(surah.verses.single.translations, isEmpty);
    expect(surah.verses.single.textArabic, isNotEmpty);
  });

  test('an edition that omits the flag is treated as free', () async {
    // Defensive: the field is additive and any endpoint that predates it
    // must keep working rather than blanking the translation.
    final adapter = StubHttpAdapter({
      '/quran/surah/1': (
        200,
        surahPayload([
          {
            'language': 'en',
            'authorName': 'Saheeh International',
            'text': 'In the name of Allah.',
          },
        ]),
      ),
    });

    final surah = await QuranRepository(adapter.dio()).getSurah(1);

    expect(surah.verses.single.translations, hasLength(1));
  });
}
