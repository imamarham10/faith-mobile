import 'package:faith_mobile/core/network/api_exception.dart';
import 'package:faith_mobile/features/hadiths/data/hadiths_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/stub_http.dart';

/// The wire. These are the live shapes `GET /hadiths/*` returns today —
/// [kBooksPayload] is the real `/books` response trimmed to five rows, two
/// of them paid, and [kForbiddenBody] is verbatim what the server answers
/// when a paid `bookId` is requested without an entitlement.
const String kFreeBookId = '6e204f58-658c-4c2f-94e6-f947bfc71ab4';
const String kPremiumBookId = '8934bd51-306d-482d-8dee-33b861c98386';

final List<Map<String, dynamic>> kBooksPayload = [
  {
    'id': kFreeBookId,
    'name': 'Sahih al-Bukhari',
    'totalHadiths': 7589,
    'isPremium': false,
    'sortOrder': 1,
  },
  {
    'id': kPremiumBookId,
    'name': 'Sahih Muslim',
    'totalHadiths': 7563,
    'isPremium': true,
    'sortOrder': 2,
  },
  {
    'id': 'aee8c884-a5e0-4ce2-afa4-e9a5412826e7',
    'name': 'Sunan Abu Dawud',
    'totalHadiths': 5274,
    'isPremium': true,
    'sortOrder': 3,
  },
  {
    'id': '63eff656-b957-41ca-b9e0-5867d47c6525',
    'name': '40 Hadith Nawawi',
    'totalHadiths': 42,
    'isPremium': false,
    'sortOrder': 8,
  },
  {
    'id': '8e19a287-ebb1-4b2e-a2a1-115981439543',
    'name': '40 Hadith Qudsi',
    'totalHadiths': 40,
    'isPremium': false,
    'sortOrder': 9,
  },
];

/// The server's own sales copy. It must never reach a widget.
const Map<String, dynamic> kForbiddenBody = {
  'message': 'This collection requires a premium subscription',
  'error': 'Forbidden',
  'statusCode': 403,
};

Map<String, dynamic> hadithJson({required Map<String, dynamic> book}) => {
  'id': 'h-1',
  'bookId': book['id'],
  'hadithNumber': 1,
  'textArabic': 'نص',
  'textEnglish': 'Actions are judged by intentions.',
  'book': book,
};

HadithsRepository repoWith(StubHttpAdapter adapter) =>
    HadithsRepository(adapter.dio());

void main() {
  group('GET /books', () {
    test(
      'drops every paid collection before anything downstream sees it',
      () async {
        final adapter = StubHttpAdapter({
          '/hadiths/books': (200, kBooksPayload),
        });

        final books = await repoWith(adapter).getBooks();

        expect(books.map((b) => b.name), [
          'Sahih al-Bukhari',
          '40 Hadith Nawawi',
          '40 Hadith Qudsi',
        ]);
        // Not "none are flagged premium" — none are *present*. A caller cannot
        // reinstate a row it was never handed.
        expect(books.any((b) => b.isPremium), isFalse);
        expect(books.map((b) => b.id), isNot(contains(kPremiumBookId)));
      },
    );

    test(
      'the corpus count a reader is promised only counts what they can open',
      () async {
        final adapter = StubHttpAdapter({
          '/hadiths/books': (200, kBooksPayload),
        });

        final total = (await repoWith(
          adapter,
        ).getBooks()).fold<int>(0, (sum, b) => sum + b.totalHadiths);

        // 7589 + 42 + 40. Not 20_508, which would include the two paid books.
        expect(total, 7671);
      },
    );
  });

  group('GET /hadiths?bookId=', () {
    test('never surfaces the server\'s upgrade copy on a 403', () async {
      final adapter = StubHttpAdapter({
        '/islam/hadiths': (403, kForbiddenBody),
      });

      await expectLater(
        repoWith(adapter).getHadithsByBook(bookId: kPremiumBookId),
        throwsA(
          isA<ApiException>()
              .having((e) => e.message, 'message', isNot(contains('premium')))
              .having(
                (e) => e.message.toLowerCase(),
                'message',
                isNot(contains('subscri')),
              ),
        ),
      );
    });

    test('other failures keep their own message', () async {
      final adapter = StubHttpAdapter({
        '/islam/hadiths': (
          500,
          {'message': 'Database is on fire', 'statusCode': 500},
        ),
      });

      await expectLater(
        repoWith(adapter).getHadithsByBook(bookId: kFreeBookId),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 500)),
      );
    });
  });

  group('GET /hadiths/:id', () {
    test('reports a hadith from a paid collection as missing', () async {
      // The endpoint has no entitlement check of its own — this is the only
      // thing standing between a shared link and the full text.
      final adapter = StubHttpAdapter({
        '/islam/hadiths/h-1': (200, hadithJson(book: kBooksPayload[1])),
      });

      await expectLater(
        repoWith(adapter).getHadith('h-1'),
        throwsA(
          isA<ApiException>()
              .having((e) => e.statusCode, 'status', 404)
              .having((e) => e.message, 'message', isNot(contains('premium'))),
        ),
      );
    });

    test('serves a hadith from a free collection', () async {
      final adapter = StubHttpAdapter({
        '/islam/hadiths/h-1': (200, hadithJson(book: kBooksPayload[0])),
      });

      final hadith = await repoWith(adapter).getHadith('h-1');

      expect(hadith.book?.name, 'Sahih al-Bukhari');
      expect(hadith.textEnglish, startsWith('Actions are judged'));
    });
  });
}
