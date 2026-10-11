/// Where the Qur'an's two readers live, given a [ReadingMode].
///
/// The mode itself is faith-neutral and lives in `shared/reader` with the
/// controller that remembers it — a reader who wants one verse to a page
/// wants that for a śloka too. What is Qur'an-shaped is only the *routes*:
/// `/quran/surah/:id` and `/quran/surah/:id/verses`, and the `ayah`/`from`
/// query parameters they take. Re-exported so a caller that needs both the
/// enum and a route still needs one import.
library;

import '../../../shared/reader/reading_mode.dart';

export '../../../shared/reader/reading_mode.dart';

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
