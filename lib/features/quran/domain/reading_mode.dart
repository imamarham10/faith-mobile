/// How the reader lays a surah out, and the routes that follow from it.
library;

/// The two ways this app reads the Qur'an.
///
/// Not a display preference like font size: the two modes are different
/// screens with different navigation, so the choice has to resolve to a
/// *route* before anything is opened. That is what [surahReadingRoute]
/// below is for, and why the enum lives in `domain` next to it rather than
/// beside the controller that persists it.
enum ReadingMode {
  /// `/quran/surah/:id` — the whole surah in one scroll.
  continuous,

  /// `/quran/surah/:id/verses` — one verse at a time, Back and Next.
  verseByVerse;

  String get label => switch (this) {
    ReadingMode.continuous => 'Scrolling',
    ReadingMode.verseByVerse => 'Verse by verse',
  };

  ReadingMode get other => switch (this) {
    ReadingMode.continuous => ReadingMode.verseByVerse,
    ReadingMode.verseByVerse => ReadingMode.continuous,
  };
}

/// Where a tap on "read this surah" should land.
///
/// [ayah] opens the surah *at* a verse — the scrolling reader scrolls to it
/// and highlights it, the verse reader starts its cursor there. Both
/// readers treat an out-of-range number as "start at the beginning" rather
/// than as an error, so a stale deep link degrades instead of failing.
String surahReadingRoute(int surahId, {required ReadingMode mode, int? ayah}) =>
    switch (mode) {
      ReadingMode.continuous =>
        ayah == null
            ? '/quran/surah/$surahId'
            : '/quran/surah/$surahId?ayah=$ayah',
      ReadingMode.verseByVerse =>
        ayah == null
            ? '/quran/surah/$surahId/verses'
            : '/quran/surah/$surahId/verses?from=$ayah',
    };

/// A bounded span of one surah, read one verse at a time.
///
/// There is no continuous-mode equivalent and deliberately so: the
/// scrolling reader can only be *pointed at* a verse, never fenced to a
/// span, so asking it for 2:285–286 would drop the reader into the middle
/// of the longest surah in the Qur'an with 284 verses above them and no
/// sign of where the passage ends. The verse pager fences exactly, which is
/// why every ranged destination in the app resolves here.
String surahSpanRoute(int surahId, {required int from, required int to}) =>
    '/quran/surah/$surahId/verses?from=$from&to=$to';
