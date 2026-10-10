import 'package:faith_mobile/features/quran/data/juz_repository.dart';
import 'package:faith_mobile/features/quran/presentation/controllers/juz_reader_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_juz.dart';

/// Navigation inside one juz.
///
/// The thing under test is the claim that a juz reader can step through
/// verses that belong to different surahs and arrive from different server
/// pages without the reader having to know about either. Two boundaries
/// matter, and the fixture puts one of each in the way — see [FakeJuz].
void main() {
  late FakeJuz juz;
  late FakeJuzRepository repo;
  late ProviderContainer container;

  setUp(() {
    juz = FakeJuz.spanningThreeSurahs();
    repo = FakeJuzRepository(juz: juz);
    container = ProviderContainer(
      overrides: [juzRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);
    // The reader is autoDispose — correct in the app, where the screen
    // watches it and its pages are freed on leaving. In a container with no
    // listener, every `read` would build and tear down a fresh notifier, so
    // the test has to hold the subscription a widget otherwise would.
    final sub = container.listen(
      juzReaderControllerProvider(juz.number),
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(sub.close);
  });

  JuzReaderController notifier() =>
      container.read(juzReaderControllerProvider(juz.number).notifier);

  JuzReaderState current() =>
      container.read(juzReaderControllerProvider(juz.number)).requireValue;

  /// Settles the first load plus any prefetches it kicked off.
  Future<void> open() async {
    await container.read(juzReaderControllerProvider(juz.number).future);
    await pumpEventQueue();
  }

  /// Steps forward [times] times, letting each step's prefetch settle.
  Future<void> forward(int times) async {
    for (var i = 0; i < times; i++) {
      notifier().next();
      await pumpEventQueue();
    }
  }

  test('opens on the first verse of the juz', () async {
    await open();

    expect(current().cursor, 1);
    expect(current().currentVerse?.surahName, 'Al-Baqarah');
    expect(current().currentVerse?.verseNumber, 253);
  });

  test('back is disabled on the first verse, forward is not', () async {
    await open();

    expect(current().canGoBack, isFalse);
    expect(current().canGoForward, isTrue);
  });

  test('previous() on the first verse does nothing', () async {
    await open();
    notifier().previous();
    await pumpEventQueue();

    expect(current().cursor, 1);
  });

  test('crosses a surah boundary that sits inside a page', () async {
    await open();
    // Verse 30 is the last of Al-Baqarah; 31 is the first of Ali 'Imran, and
    // both live on page 1.
    await forward(29);
    expect(current().cursor, 30);
    expect(current().currentVerse?.surahName, 'Al-Baqarah');
    expect(current().currentVerse?.verseNumber, 282);

    await forward(1);

    expect(current().cursor, 31);
    expect(current().currentVerse?.surahName, "Ali 'Imran");
    expect(
      current().currentVerse?.verseNumber,
      1,
      reason: 'verse number restarts at the surah, not at the juz',
    );
  });

  test('crosses a surah boundary that is also a page boundary', () async {
    await open();
    await forward(49);
    expect(current().cursor, 50);
    expect(current().currentVerse?.surahName, "Ali 'Imran");
    expect(current().currentVerse?.verseNumber, 20);

    await forward(1);

    expect(current().cursor, 51);
    expect(current().currentVerse?.surahName, 'An-Nisa');
    expect(current().currentVerse?.verseNumber, 1);
  });

  test('steps back across a page boundary', () async {
    await open();
    await forward(50);
    expect(current().cursor, 51);

    notifier().previous();
    await pumpEventQueue();

    expect(current().cursor, 50);
    expect(current().currentVerse?.surahName, "Ali 'Imran");
    expect(current().currentVerse?.verseNumber, 20);
  });

  test('forward is disabled on the last verse of the juz', () async {
    await open();
    await forward(juz.verseCount - 1);

    expect(current().cursor, juz.verseCount);
    expect(current().canGoForward, isFalse);
    expect(current().canGoBack, isTrue);
    expect(current().currentVerse?.verseNumber, 70);
  });

  test('next() on the last verse does nothing', () async {
    await open();
    await forward(juz.verseCount - 1);
    notifier().next();
    await pumpEventQueue();

    expect(current().cursor, juz.verseCount);
  });

  test('verses left counts down across the juz, not the page', () async {
    await open();
    expect(current().versesLeft, juz.verseCount - 1);

    await forward(60);

    // Still counting against the juz even though the cursor is now on the
    // second page and the third surah.
    expect(current().cursor, 61);
    expect(current().versesLeft, juz.verseCount - 61);
  });

  test('the last verse reports nothing left rather than a negative', () async {
    await open();
    await forward(juz.verseCount - 1);

    expect(current().versesLeft, 0);
  });

  group('paging', () {
    test('fetches the next page before anyone has read page one', () async {
      await open();

      expect(
        repo.requestedPages,
        containsAllInOrder(<int>[1, 2]),
        reason: 'page 2 is requested at open, 50 taps before it is needed',
      );
    });

    test('page two is already resident when the cursor reaches it', () async {
      await open();
      await forward(49);

      // Cursor is on verse 50 — still page 1 — and page 2 is already in.
      expect(current().cursor, 50);
      expect(current().pages.containsKey(2), isTrue);
    });

    test(
      'crossing into page two never leaves the reader without a verse',
      () async {
        await open();
        for (var i = 0; i < 55; i++) {
          notifier().next();
          // No event-queue pump between taps: this is a reader pressing Next
          // faster than any network could answer. The verse must still be
          // there, because the page it is on arrived a page ago.
          expect(
            current().currentVerse,
            isNotNull,
            reason: 'a spinner mid-read at cursor ${current().cursor}',
          );
        }
        expect(current().cursor, 56);
        expect(current().currentVerse?.surahName, 'An-Nisa');
      },
    );

    test('each page is fetched once, however often it is crossed', () async {
      await open();
      await forward(55);
      for (var i = 0; i < 10; i++) {
        notifier().previous();
        await pumpEventQueue();
      }
      await forward(10);

      final pageTwoRequests = repo.requestedPages.where((p) => p == 2).length;
      expect(pageTwoRequests, 1);
    });

    test('does not request a page beyond the last one', () async {
      await open();
      await forward(juz.verseCount - 1);

      expect(repo.requestedPages, isNot(contains(juz.totalPages + 1)));
      expect(repo.requestedPages, isNot(contains(0)));
    });
  });

  group('juz 30 — the real worst case', () {
    // 564 verses, 37 surahs, twelve pages. Built in its own container
    // because the shared one is wired to the three-surah fixture.
    late FakeJuz thirty;
    late FakeJuzRepository thirtyRepo;
    late ProviderContainer box;

    setUp(() {
      thirty = FakeJuz.juzThirty();
      thirtyRepo = FakeJuzRepository(juz: thirty);
      box = ProviderContainer(
        overrides: [juzRepositoryProvider.overrideWithValue(thirtyRepo)],
      );
      addTearDown(box.dispose);
      final sub = box.listen(
        juzReaderControllerProvider(30),
        (_, __) {},
        fireImmediately: true,
      );
      addTearDown(sub.close);
    });

    test('is the shape the contract promises', () {
      expect(thirty.verseCount, 564);
      expect(thirty.segments.length, 37);
      expect(thirty.totalPages, 12);
    });

    test('walks end to end without ever losing the verse', () async {
      await box.read(juzReaderControllerProvider(30).future);
      await pumpEventQueue();
      final reader = box.read(juzReaderControllerProvider(30).notifier);
      JuzReaderState now() =>
          box.read(juzReaderControllerProvider(30)).requireValue;

      final surahsSeen = <int>{now().currentVerse!.surahId};
      for (var i = 1; i < thirty.verseCount; i++) {
        reader.next();
        // Pumped only occasionally: between pumps this is someone tapping
        // Next faster than any page could load, which is precisely when a
        // reader that fetches on arrival shows a spinner.
        if (i % 25 == 0) await pumpEventQueue();
        final verse = now().currentVerse;
        expect(verse, isNotNull, reason: 'no verse at indexInJuz $i');
        surahsSeen.add(verse!.surahId);
      }

      expect(now().cursor, 564);
      expect(now().canGoForward, isFalse);
      expect(now().versesLeft, 0);
      expect(surahsSeen.length, 37, reason: 'every surah in the juz was seen');
      expect(now().currentVerse?.surahName, 'An-Nas');
      expect(now().currentVerse?.verseNumber, 6);
    });
  });

  group('translations', () {
    test('a verse with no translation is still a verse', () async {
      final plain = FakeJuz.withoutTranslations();
      final box = ProviderContainer(
        overrides: [
          juzRepositoryProvider.overrideWithValue(
            FakeJuzRepository(juz: plain),
          ),
        ],
      );
      addTearDown(box.dispose);
      final sub = box.listen(
        juzReaderControllerProvider(plain.number),
        (_, __) {},
        fireImmediately: true,
      );
      addTearDown(sub.close);

      await box.read(juzReaderControllerProvider(plain.number).future);
      final verse = box
          .read(juzReaderControllerProvider(plain.number))
          .requireValue
          .currentVerse;

      // The public juz endpoints answer a premium or unknown translation
      // with a null translation rather than a 400, so this is a normal
      // payload, not a failure.
      expect(verse, isNotNull);
      expect(verse!.translation, isNull);
      expect(verse.textArabic, isNotEmpty);
    });
  });
}
