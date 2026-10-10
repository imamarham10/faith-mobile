import 'package:faith_mobile/features/quran/data/dtos/juz.dart';
import 'package:faith_mobile/features/quran/data/juz_repository.dart';

/// A run of consecutive verses from one surah inside a juz.
class FakeJuzSegment {
  const FakeJuzSegment({
    required this.surahId,
    required this.surahName,
    required this.firstVerseNumber,
    required this.count,
  });

  final int surahId;
  final String surahName;
  final int firstVerseNumber;
  final int count;
}

/// Builds juz payloads shaped like the ones `GET /juz/:number` returns.
///
/// The default fixture is deliberately the hard case. Its segments put:
///
/// * a **surah boundary inside a page**, at `indexInJuz` 31; and
/// * a **surah boundary that is also a page boundary**, at `indexInJuz` 51
///   — the first verse of page 2.
///
/// Either boundary on its own passes with navigation code that is wrong
/// about the other; only the composition catches a reader that resolves a
/// verse by walking an accumulated list, or that resets its position when a
/// page arrives.
class FakeJuz {
  FakeJuz({
    required this.number,
    required this.segments,
    this.limit = JuzRepository.defaultPageLimit,
    this.translated = true,
    this.long = false,
  });

  /// 120 verses over three surahs and three pages. See the class doc.
  factory FakeJuz.spanningThreeSurahs() => FakeJuz(
    number: 2,
    segments: const [
      FakeJuzSegment(
        surahId: 2,
        surahName: 'Al-Baqarah',
        firstVerseNumber: 253,
        count: 30,
      ),
      FakeJuzSegment(
        surahId: 3,
        surahName: "Ali 'Imran",
        firstVerseNumber: 1,
        count: 20,
      ),
      FakeJuzSegment(
        surahId: 4,
        surahName: 'An-Nisa',
        firstVerseNumber: 1,
        count: 70,
      ),
    ],
  );

  /// Juz 30 as it really is: 564 verses across 37 surahs, 78 through 114.
  ///
  /// The confirmed worst case for this reader — the most surah boundaries
  /// any juz contains, and twelve server pages at the default limit, so a
  /// walk from end to end crosses both kinds of boundary dozens of times.
  /// Segment lengths are the real surah lengths.
  factory FakeJuz.juzThirty() => FakeJuz(
    number: 30,
    segments: const [
      FakeJuzSegment(
        surahId: 78,
        surahName: 'An-Naba',
        firstVerseNumber: 1,
        count: 40,
      ),
      FakeJuzSegment(
        surahId: 79,
        surahName: 'An-Nazi\'at',
        firstVerseNumber: 1,
        count: 46,
      ),
      FakeJuzSegment(
        surahId: 80,
        surahName: '\'Abasa',
        firstVerseNumber: 1,
        count: 42,
      ),
      FakeJuzSegment(
        surahId: 81,
        surahName: 'At-Takwir',
        firstVerseNumber: 1,
        count: 29,
      ),
      FakeJuzSegment(
        surahId: 82,
        surahName: 'Al-Infitar',
        firstVerseNumber: 1,
        count: 19,
      ),
      FakeJuzSegment(
        surahId: 83,
        surahName: 'Al-Mutaffifin',
        firstVerseNumber: 1,
        count: 36,
      ),
      FakeJuzSegment(
        surahId: 84,
        surahName: 'Al-Inshiqaq',
        firstVerseNumber: 1,
        count: 25,
      ),
      FakeJuzSegment(
        surahId: 85,
        surahName: 'Al-Buruj',
        firstVerseNumber: 1,
        count: 22,
      ),
      FakeJuzSegment(
        surahId: 86,
        surahName: 'At-Tariq',
        firstVerseNumber: 1,
        count: 17,
      ),
      FakeJuzSegment(
        surahId: 87,
        surahName: 'Al-A\'la',
        firstVerseNumber: 1,
        count: 19,
      ),
      FakeJuzSegment(
        surahId: 88,
        surahName: 'Al-Ghashiyah',
        firstVerseNumber: 1,
        count: 26,
      ),
      FakeJuzSegment(
        surahId: 89,
        surahName: 'Al-Fajr',
        firstVerseNumber: 1,
        count: 30,
      ),
      FakeJuzSegment(
        surahId: 90,
        surahName: 'Al-Balad',
        firstVerseNumber: 1,
        count: 20,
      ),
      FakeJuzSegment(
        surahId: 91,
        surahName: 'Ash-Shams',
        firstVerseNumber: 1,
        count: 15,
      ),
      FakeJuzSegment(
        surahId: 92,
        surahName: 'Al-Layl',
        firstVerseNumber: 1,
        count: 21,
      ),
      FakeJuzSegment(
        surahId: 93,
        surahName: 'Ad-Duhaa',
        firstVerseNumber: 1,
        count: 11,
      ),
      FakeJuzSegment(
        surahId: 94,
        surahName: 'Ash-Sharh',
        firstVerseNumber: 1,
        count: 8,
      ),
      FakeJuzSegment(
        surahId: 95,
        surahName: 'At-Tin',
        firstVerseNumber: 1,
        count: 8,
      ),
      FakeJuzSegment(
        surahId: 96,
        surahName: 'Al-\'Alaq',
        firstVerseNumber: 1,
        count: 19,
      ),
      FakeJuzSegment(
        surahId: 97,
        surahName: 'Al-Qadr',
        firstVerseNumber: 1,
        count: 5,
      ),
      FakeJuzSegment(
        surahId: 98,
        surahName: 'Al-Bayyinah',
        firstVerseNumber: 1,
        count: 8,
      ),
      FakeJuzSegment(
        surahId: 99,
        surahName: 'Az-Zalzalah',
        firstVerseNumber: 1,
        count: 8,
      ),
      FakeJuzSegment(
        surahId: 100,
        surahName: 'Al-\'Adiyat',
        firstVerseNumber: 1,
        count: 11,
      ),
      FakeJuzSegment(
        surahId: 101,
        surahName: 'Al-Qari\'ah',
        firstVerseNumber: 1,
        count: 11,
      ),
      FakeJuzSegment(
        surahId: 102,
        surahName: 'At-Takathur',
        firstVerseNumber: 1,
        count: 8,
      ),
      FakeJuzSegment(
        surahId: 103,
        surahName: 'Al-\'Asr',
        firstVerseNumber: 1,
        count: 3,
      ),
      FakeJuzSegment(
        surahId: 104,
        surahName: 'Al-Humazah',
        firstVerseNumber: 1,
        count: 9,
      ),
      FakeJuzSegment(
        surahId: 105,
        surahName: 'Al-Fil',
        firstVerseNumber: 1,
        count: 5,
      ),
      FakeJuzSegment(
        surahId: 106,
        surahName: 'Quraysh',
        firstVerseNumber: 1,
        count: 4,
      ),
      FakeJuzSegment(
        surahId: 107,
        surahName: 'Al-Ma\'un',
        firstVerseNumber: 1,
        count: 7,
      ),
      FakeJuzSegment(
        surahId: 108,
        surahName: 'Al-Kawthar',
        firstVerseNumber: 1,
        count: 3,
      ),
      FakeJuzSegment(
        surahId: 109,
        surahName: 'Al-Kafirun',
        firstVerseNumber: 1,
        count: 6,
      ),
      FakeJuzSegment(
        surahId: 110,
        surahName: 'An-Nasr',
        firstVerseNumber: 1,
        count: 3,
      ),
      FakeJuzSegment(
        surahId: 111,
        surahName: 'Al-Masad',
        firstVerseNumber: 1,
        count: 5,
      ),
      FakeJuzSegment(
        surahId: 112,
        surahName: 'Al-Ikhlas',
        firstVerseNumber: 1,
        count: 4,
      ),
      FakeJuzSegment(
        surahId: 113,
        surahName: 'Al-Falaq',
        firstVerseNumber: 1,
        count: 5,
      ),
      FakeJuzSegment(
        surahId: 114,
        surahName: 'An-Nas',
        firstVerseNumber: 1,
        count: 6,
      ),
    ],
  );

  /// Verses long enough to overflow any phone viewport — 2:282's role, the
  /// longest verse in the Qur'an, which sits in juz 3.
  factory FakeJuz.withLongVerses() => FakeJuz(
    number: 3,
    segments: const [
      FakeJuzSegment(
        surahId: 2,
        surahName: 'Al-Baqarah',
        firstVerseNumber: 282,
        count: 3,
      ),
    ],
    long: true,
  );

  /// Verses with no translation at all — what the public juz endpoints
  /// return when the requested edition is premium or unknown. The server
  /// does not 400 for that, so the reader must render the Arabic alone.
  factory FakeJuz.withoutTranslations() => FakeJuz(
    number: 29,
    segments: const [
      FakeJuzSegment(
        surahId: 67,
        surahName: 'Al-Mulk',
        firstVerseNumber: 1,
        count: 3,
      ),
    ],
    translated: false,
  );

  /// The shortest juz the reader can be asked to render: two verses, so both
  /// ends of it are one tap apart.
  factory FakeJuz.twoVerses() => FakeJuz(
    number: 30,
    segments: const [
      FakeJuzSegment(
        surahId: 113,
        surahName: 'Al-Falaq',
        firstVerseNumber: 5,
        count: 1,
      ),
      FakeJuzSegment(
        surahId: 114,
        surahName: 'An-Nas',
        firstVerseNumber: 1,
        count: 1,
      ),
    ],
  );

  final int number;
  final List<FakeJuzSegment> segments;
  final int limit;

  /// When false every verse comes back with `translation: null`.
  final bool translated;

  /// When true each verse carries enough text to overflow the viewport.
  final bool long;

  int get verseCount => segments.fold<int>(0, (total, s) => total + s.count);

  int get totalPages => (verseCount / limit).ceil();

  late final List<JuzVerse> allVerses = _buildVerses();

  List<JuzVerse> _buildVerses() {
    final verses = <JuzVerse>[];
    var index = 1;
    for (final segment in segments) {
      for (var i = 0; i < segment.count; i++) {
        final verseNumber = segment.firstVerseNumber + i;
        verses.add(
          JuzVerse(
            id: '${segment.surahId}:$verseNumber',
            surahId: segment.surahId,
            surahName: segment.surahName,
            verseNumber: verseNumber,
            indexInJuz: index,
            textArabic: long
                ? 'arabic-$index ${'word ' * 300}'
                : 'arabic-$index',
            textUthmani: 'uthmani-$index',
            translation: translated ? 'translation-$index' : null,
          ),
        );
        index++;
      }
    }
    return verses;
  }

  JuzVerse verseAt(int indexInJuz) => allVerses[indexInJuz - 1];

  JuzPage pageAt(int page) => JuzPage(
    number: number,
    verseCount: verseCount,
    page: page,
    limit: limit,
    totalPages: totalPages,
    verses: allVerses.skip((page - 1) * limit).take(limit).toList(),
  );

  JuzSummary get summary => JuzSummary(
    number: number,
    start: JuzBoundary(
      surahId: segments.first.surahId,
      surahName: segments.first.surahName,
      verseNumber: segments.first.firstVerseNumber,
    ),
    end: JuzBoundary(
      surahId: segments.last.surahId,
      surahName: segments.last.surahName,
      verseNumber: segments.last.firstVerseNumber + segments.last.count - 1,
    ),
    verseCount: verseCount,
    surahIds: segments.map((s) => s.surahId).toList(growable: false),
  );
}

/// Stands in for [JuzRepository] and records which pages were asked for, so
/// a test can assert that a page was prefetched *before* the reader got to
/// it rather than fetched on arrival.
class FakeJuzRepository implements JuzRepository {
  FakeJuzRepository({required this.juz, this.index = const []});

  final FakeJuz juz;
  final List<JuzSummary> index;

  /// Every `page` argument passed to [getJuzPage], in order.
  final List<int> requestedPages = <int>[];

  int indexCalls = 0;

  @override
  Future<List<JuzSummary>> getJuzIndex() async {
    indexCalls++;
    return index;
  }

  @override
  Future<JuzPage> getJuzPage(
    int number, {
    int page = 1,
    int limit = JuzRepository.defaultPageLimit,
    String? translationId,
  }) async {
    requestedPages.add(page);
    return juz.pageAt(page);
  }
}
