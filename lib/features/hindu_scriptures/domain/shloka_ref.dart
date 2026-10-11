/// The one name the app gives a verse of a Hindu text.
///
/// Both readers — the scrolling `ChapterReaderScreen` and the
/// `ChapterVerseReaderScreen` pager — record `gita_shloka` activity, and
/// both must name the same verse identically in two places at once:
///
/// * as the **dedupe key** the recorder turns into the event's id, which is
///   what makes reading 2:47 in the pager and again in the scroll on the
///   same day *one* śloka read rather than two; and
/// * as the event's **`sourceRef`**, contract §1.6's `gita:<chapter>:<verse>`,
///   which Phase 2 derives challenge progress from.
///
/// They are two functions and not one because the two strings genuinely
/// differ — see [shlokaSourceRef]. The Qur'an gets away with one
/// (`quranVerseRef`) because every verse of the Qur'an has an expressible
/// §1.6 reference; not every Hindu verse does.
///
/// Both are functions rather than format strings written out at each call
/// site for the reason `quran_verse_ref.dart` gives: two literals that
/// happen to agree today dedupe correctly today; one that is edited
/// tomorrow splits the key silently, and the symptom — a verse counted
/// twice — appears in a tile on a different screen with nothing to connect
/// it back.
library;

/// Whether [textSlug] names the Bhagavad Gita.
///
/// A substring test rather than an equality one because the slug has been
/// seeded as `bhagavad-gita` and could reasonably arrive as `gita` or
/// `srimad-bhagavad-gita`; the cost of a false negative is a missing
/// `sourceRef`, which §1.6 permits, and there is no other seeded text whose
/// slug contains the word.
bool isGitaSlug(String textSlug) => textSlug.toLowerCase().contains('gita');

/// `hindu:<textSlug>:<chapter>:<verse>` — the once-a-day key for any verse
/// of any Hindu text.
///
/// Always available, which is the whole point: [shlokaSourceRef] is null
/// for everything but the Gita, and a null dedupe key would mean every
/// re-read of a Ramayana verse counted again. The key is not sent anywhere
/// — the recorder hashes it into a UUID v5 — so it is free to carry the
/// text slug that §1.6 has no room for.
///
/// Carries the `hindu:` prefix for legibility in a log line, not for
/// uniqueness: the recorder already folds the activity type into the hash,
/// so this could not collide with a Qur'an key regardless.
String shlokaDedupeKey({
  required String textSlug,
  required int chapterNumber,
  required int verseNumber,
}) => 'hindu:$textSlug:$chapterNumber:$verseNumber';

/// `gita:<chapter>:<verse>`, or **null** for any text that is not the Gita.
///
/// That null is a gap in the frozen contract rather than a choice. §1.6
/// fixes the shape as `gita:<chapter>:<verse>` with no room for *which*
/// text, so a Ramayana verse has no expressible reference. §1.6 permits
/// omitting the field when there is genuinely no reference; inventing a
/// fourth segment would be a silent contract change, and Phase 2 derives
/// challenge progress from these strings by matching that exact shape.
String? shlokaSourceRef({
  required String textSlug,
  required int chapterNumber,
  required int verseNumber,
}) => isGitaSlug(textSlug) ? 'gita:$chapterNumber:$verseNumber' : null;
