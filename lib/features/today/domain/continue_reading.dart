import '../../hindu_scriptures/domain/chapter_reading_route.dart';
import '../../hindu_scriptures/presentation/controllers/hindu_scriptures_home_controller.dart';
import '../../quran/domain/juz_boundaries.dart';
import '../../quran/domain/reading_mode.dart';
import '../../quran/presentation/controllers/quran_home_controller.dart';

/// Where the reader left off, said in one shape for both faiths.
///
/// The Today screen leads with this, so the card that renders it is the
/// largest and first thing on the screen. Everything it needs is computed
/// here from a stored pointer and a [ReadingMode] — no network, no `ref` —
/// which is what lets the card paint correctly on the first frame, above
/// the habit loop, without adding a request to a cold start.
///
/// ## What is deliberately *not* here
///
/// A completion figure. The obvious thing to show next to a position is how
/// far through the book it is, and it would be a lie: a pointer at
/// Al-Baqarah 151 says the reader is *there*, not that they have read the
/// 150 verses behind it — they may have opened the surah from a collection,
/// a bookmark, a search result or a mood remedy, all of which land mid-text
/// by design. So [progress] is scoped to the passage the reader is actually
/// inside, [positionLine] names both ends of that passage in words, and
/// nothing anywhere states a percentage of the Qur'an or of a text.
///
/// [locatorLine] is a *place name*, not an amount — "Juz 2" is where this
/// verse sits in the muṣḥaf, in the same sense as "Chapter 12", and carries
/// no claim about what has been read.
class ContinueReading {
  const ContinueReading({
    required this.eyebrow,
    required this.title,
    required this.positionLine,
    required this.ctaLabel,
    required this.route,
    required this.semanticLabel,
    this.subtitle,
    this.locatorLine,
    this.progress,
  });

  /// The small label inside the card: whether this is a resumption or an
  /// invitation. Kept inside the card rather than above it so there is no
  /// heading left behind in the states where the card draws nothing.
  final String eyebrow;

  /// The passage — "Al-Baqarah", "Bhagavad Gita".
  final String title;

  /// A second locator under the title where the faith has one — the Hindu
  /// texts' chapter. Null for the Qur'an, whose surah *is* the unit.
  final String? subtitle;

  /// "Verse 151 of 286", or "Verse 151" when the length is not known.
  final String positionLine;

  /// "Juz 2", or null where a faith has no such division.
  final String? locatorLine;

  /// Position within the current surah/chapter, 0–1, or null when the
  /// passage's length is unknown. Never a fraction of the whole book.
  final double? progress;

  /// The pill inside the card. Not its own button — see the card.
  final String ctaLabel;

  /// Honours the reader's remembered [ReadingMode]; every entry point in
  /// the app resolves through the same two route helpers.
  final String route;

  /// One sentence for assistive technology, replacing the card's whole
  /// subtree — six fragments read in sequence is not a usable button label.
  final String semanticLabel;

  static const String resumeEyebrow = 'Continue reading';
  static const String startEyebrow = 'Start reading';
}

/// Al-Fatihah, for a reader who has never opened the Qur'an in this app.
///
/// Offering a start rather than hiding is the point: continue-reading is
/// now the primary element on Today, and a fresh install whose primary
/// element is missing opens on a goal card with nothing to act on. The
/// opening surah is the one passage every reader is expected to know, it is
/// seven verses long, and it needs no network read to name.
const int kQuranStartSurah = 1;
const String _kQuranStartName = 'Al-Fatihah';

/// The Gita, chapter one — the Hindu peer of [kQuranStartSurah], chosen on
/// the same grounds and hardcoded for the same reason.
///
/// The slug is the live API's own (`GET /hindu/scriptures/texts`), and the
/// route it builds resolves without the text list loaded because both Hindu
/// readers take the slug straight from the path. A text the server later
/// renames would send a first-time reader to a chapter that does not load —
/// which is the ordinary stale-deep-link case both readers already handle
/// with an error and a retry, not a crash.
const String kScriptureStartSlug = 'bhagavad-gita';
const int kScriptureStartChapter = 1;
const String _kScriptureStartName = 'Bhagavad Gita';

/// Opening copy shared by both faiths' start cards, so neither drifts.
const String _kStartPosition = 'Begin at the first verse';

/// The Qur'an's continue-reading state, or its invitation when [lastRead]
/// is null.
ContinueReading islamContinueReading({
  required LastRead? lastRead,
  required ReadingMode mode,
}) {
  if (lastRead == null) {
    return ContinueReading(
      eyebrow: ContinueReading.startEyebrow,
      title: _kQuranStartName,
      positionLine: _kStartPosition,
      locatorLine: _juzLine(surahId: kQuranStartSurah, verseNumber: 1),
      ctaLabel: 'Open $_kQuranStartName',
      route: surahReadingRoute(kQuranStartSurah, mode: mode),
      semanticLabel:
          'Start reading. $_kQuranStartName, from the first verse.',
    );
  }

  final name = lastRead.surahName ?? 'Surah ${lastRead.surahId}';
  final total = lastRead.verseCount;
  final position = total == null
      ? 'Verse ${lastRead.verseNumber}'
      : 'Verse ${lastRead.verseNumber} of $total';

  return ContinueReading(
    eyebrow: ContinueReading.resumeEyebrow,
    title: name,
    positionLine: position,
    locatorLine: _juzLine(
      surahId: lastRead.surahId,
      verseNumber: lastRead.verseNumber,
    ),
    progress: _fraction(lastRead.verseNumber, total),
    ctaLabel: 'Pick up in $name',
    route: surahReadingRoute(
      lastRead.surahId,
      mode: mode,
      ayah: lastRead.verseNumber,
    ),
    semanticLabel: 'Continue reading. $name, $position.',
  );
}

/// The Hindu texts' continue-reading state, or its invitation when
/// [lastRead] is null. The twin of [islamContinueReading] in every respect
/// a user can see.
ContinueReading hinduContinueReading({
  required ScriptureLastRead? lastRead,
  required ReadingMode mode,
}) {
  if (lastRead == null) {
    return ContinueReading(
      eyebrow: ContinueReading.startEyebrow,
      title: _kScriptureStartName,
      subtitle: 'Chapter $kScriptureStartChapter',
      positionLine: _kStartPosition,
      ctaLabel: 'Open $_kScriptureStartName',
      route: chapterReadingRoute(
        kScriptureStartSlug,
        kScriptureStartChapter,
        mode: mode,
      ),
      semanticLabel:
          'Start reading. $_kScriptureStartName, chapter '
          '$kScriptureStartChapter, from the first verse.',
    );
  }

  final name = lastRead.textName ?? titleFromSlug(lastRead.textSlug);
  final chapter = 'Chapter ${lastRead.chapterNumber}';
  final total = lastRead.chapterVerseCount;
  final position = total == null
      ? 'Verse ${lastRead.verseNumber}'
      : 'Verse ${lastRead.verseNumber} of $total';

  return ContinueReading(
    eyebrow: ContinueReading.resumeEyebrow,
    title: name,
    subtitle: chapter,
    positionLine: position,
    progress: _fraction(lastRead.verseNumber, total),
    ctaLabel: 'Pick up in $name',
    route: chapterReadingRoute(
      lastRead.textSlug,
      lastRead.chapterNumber,
      mode: mode,
      verse: lastRead.verseNumber,
    ),
    semanticLabel: 'Continue reading. $name, $chapter, $position.',
  );
}

/// A readable book name from a slug, for a pointer stored before the name
/// was persisted beside it. `ramayana-aranya-kanda` →
/// `Ramayana Aranya Kanda`.
///
/// Every Hindu text slug the API serves is a kebab-cased version of its own
/// English name, so this is a good guess rather than a correct answer —
/// which is the right standing for a one-session fallback that the next
/// save replaces with the server's own string.
String titleFromSlug(String slug) => slug
    .split('-')
    .where((part) => part.isNotEmpty)
    .map((part) => part[0].toUpperCase() + part.substring(1))
    .join(' ');

String? _juzLine({required int surahId, required int verseNumber}) {
  final juz = juzNumberFor(surahId: surahId, verseNumber: verseNumber);
  return juz == null ? null : 'Juz $juz';
}

/// Clamped, because a pointer can outlive the passage it addresses — a
/// stored verse past the end of a surah would otherwise overfill the track.
double? _fraction(int verseNumber, int? total) {
  if (total == null || total <= 0) return null;
  return (verseNumber / total).clamp(0.0, 1.0);
}
