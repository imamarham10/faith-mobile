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

/// A bounded span of one chapter, read one verse at a time.
///
/// The peer of the Qur'an's `surahSpanRoute`, and it takes no [ReadingMode]
/// for the same reason that one does not: the scrolling reader can only be
/// *pointed at* a verse, never fenced to a span, so asking it for Gita
/// 12.1–20 would drop the reader into a chapter with no sign of where the
/// passage ends and an invitation to read on past it. The pager fences
/// exactly, so every ranged destination resolves here whatever the reader's
/// remembered preference says — honouring the preference would honour it
/// into a worse reading.
///
/// A span of one ([from] == [to]) is legal and meaningful: Next is inert on
/// arrival, which is the honest statement that the item *is* that verse.
String chapterSpanRoute(
  String textSlug,
  int chapterNumber, {
  required int from,
  required int to,
}) =>
    '/quran/hindu-scripture/$textSlug/$chapterNumber/verses?from=$from&to=$to';
