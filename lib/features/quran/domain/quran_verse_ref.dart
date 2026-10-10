/// The one name the app gives a verse of the Qur'an.
///
/// Both readers record `quran_verse` activity, and both must name the same
/// verse identically — in two places at once:
///
/// * as the event's `sourceRef`, contract §1.6's `quran:<surah>:<ayah>`,
///   which Phase 2 derives challenge progress from; and
/// * as the `dedupeKey` the recorder turns into the event's id, which is
///   what makes reading 2:142 in the juz reader and again in the surah
///   reader on the same day **one** verse read rather than two.
///
/// The second of those is why this is a function rather than a format
/// string written out at each call site. Two literals that happen to
/// agree today dedupe correctly today; one that is edited tomorrow splits
/// the key silently, and the symptom — a verse counted twice — appears in
/// a tile on a different screen with nothing to connect it back.
library;

/// `quran:<surahId>:<verseNumber>`, for a verse anywhere in the Qur'an.
///
/// Deliberately takes the verse's position *in its surah* and never its
/// index within a juz or page: those are navigation coordinates that reset
/// at every boundary, and two readers scrolling the same ayah must arrive
/// at the same string.
String quranVerseRef({required int surahId, required int verseNumber}) =>
    'quran:$surahId:$verseNumber';
