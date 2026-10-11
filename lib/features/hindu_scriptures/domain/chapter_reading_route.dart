/// Where the Hindu texts' two readers live, given a [ReadingMode].
///
/// The peer of the Qur'an's `surahReadingRoute`, and deliberately shaped
/// like it: the mode is shared (`shared/reader/reading_mode.dart`), the
/// paths are not. Every entry point to a chapter — the chapter picker,
/// Continue reading, a bookmark, a mood remedy, the daily śloka — resolves
/// through here, so the remembered mode governs all of them and none of
/// them has to know there are two readers.
library;

import '../../../shared/reader/reading_mode.dart';

export '../../../shared/reader/reading_mode.dart';

/// Where a tap on "read this chapter" should land.
///
/// [verse] opens the chapter *at* a verse — the scrolling reader scrolls to
/// it, the pager starts its cursor there. Both readers treat an
/// out-of-range number as "start at the beginning" rather than as an error,
/// so a stale deep link degrades instead of failing.
String chapterReadingRoute(
  String textSlug,
  int chapterNumber, {
  required ReadingMode mode,
  int? verse,
}) {
  final base = '/quran/hindu-scripture/$textSlug/$chapterNumber';
  return switch (mode) {
    ReadingMode.continuous =>
      verse == null || verse <= 1 ? base : '$base?verse=$verse',
    ReadingMode.verseByVerse =>
      verse == null || verse <= 1 ? '$base/verses' : '$base/verses?from=$verse',
  };
}
