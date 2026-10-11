/// Which juz a verse falls in, resolved locally and instantly.
///
/// ## Why this is a constant and not the `/juz` endpoint
///
/// [JuzRepository.getJuzIndex] serves the same thirty boundaries and is the
/// right source for the juz *chooser*, which lists them, names them and is
/// opened on purpose. This table exists for one job the endpoint cannot
/// do: label the Today screen's continue-reading card on its **first
/// frame**.
///
/// That card sits above the habit loop, and `below_fold_gate.dart` records
/// what adding a request there costs — eight concurrent reads on a
/// `max: 10` serverless pool turned a 0.99s read into 3.49s. A juz label is
/// a secondary line on a card whose primary job is to be tapped; it is not
/// worth a request, and it is certainly not worth one ahead of the loop.
/// Deferring it behind the gate instead would mean the most prominent card
/// on the screen rewrites its own subtitle a second after launch.
///
/// Hardcoding is safe here in a way it would not be for, say, surah names:
/// where the thirty parts divide is a fixed property of the muṣḥaf, settled
/// for centuries and not a row anyone edits. The values below were
/// generated from the live `GET /api/v1/islam/quran/juz` on 2026-10-11 and
/// agree with it exactly; `juz_boundaries_test.dart` pins the invariants
/// (thirty entries, strictly ascending, starting at 1:1) that any future
/// edit would have to break first.
library;

/// The first verse of each juz, ascending, index 0 = juz 1.
///
/// A juz does not line up with surah boundaries — juz 2 opens mid-Baqarah
/// at 2:142 — so each entry carries both halves of the address.
const List<(int surahId, int verseNumber)> kJuzStarts = [
  (1, 1),
  (2, 142),
  (2, 253),
  (3, 93),
  (4, 24),
  (4, 148),
  (5, 82),
  (6, 111),
  (7, 88),
  (8, 41),
  (9, 93),
  (11, 6),
  (12, 53),
  (15, 1),
  (17, 1),
  (18, 75),
  (21, 1),
  (23, 1),
  (25, 21),
  (27, 56),
  (29, 46),
  (33, 31),
  (36, 28),
  (39, 32),
  (41, 47),
  (46, 1),
  (51, 31),
  (58, 1),
  (67, 1),
  (78, 1),
];

/// The juz [verseNumber] of [surahId] falls in, 1–30.
///
/// The last boundary at or before the address, which is the definition of
/// "which part is this in". Returns null only for an address outside the
/// muṣḥaf — a surah id below 1 or above 114 — so a corrupt stored pointer
/// drops the juz line rather than labelling it wrongly or throwing on the
/// first frame of the app's home screen.
///
/// Verse numbers are not range-checked against the surah's own length: a
/// pointer at 2:999 is already nonsense, and reporting the juz its surah
/// *starts* nonsense in is both harmless and what every other consumer of a
/// stale pointer in this app does (both readers treat an out-of-range verse
/// as "start at the beginning" rather than as an error).
int? juzNumberFor({required int surahId, required int verseNumber}) {
  if (surahId < 1 || surahId > 114) return null;

  // Thirty entries, walked backwards: the answer for the overwhelmingly
  // common case — someone reading in the last juz they opened — is found in
  // a handful of comparisons, and a linear walk over a const list of thirty
  // records is not worth a binary search's off-by-one surface.
  for (var i = kJuzStarts.length - 1; i >= 0; i--) {
    final (startSurah, startVerse) = kJuzStarts[i];
    if (surahId > startSurah ||
        (surahId == startSurah && verseNumber >= startVerse)) {
      return i + 1;
    }
  }
  // Unreachable in practice — juz 1 starts at 1:1, so any valid surah id
  // matches the first entry — but a verse number below 1 in Al-Fatihah
  // would fall through, and juz 1 is the honest answer for it.
  return 1;
}
