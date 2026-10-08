import 'package:flutter/foundation.dart';

/// A pointer into the app's own Qur'an corpus — surah number and ayah
/// number, nothing else.
@immutable
class VerseRef {
  const VerseRef(this.surahId, this.verseNumber);

  final int surahId;
  final int verseNumber;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VerseRef &&
          surahId == other.surahId &&
          verseNumber == other.verseNumber;

  @override
  int get hashCode => Object.hash(surahId, verseNumber);

  @override
  String toString() => 'VerseRef($surahId:$verseNumber)';
}

/// A resolved verse of the day, ready to render.
@immutable
class DailyVerse {
  const DailyVerse({
    required this.ref,
    required this.arabic,
    required this.translation,
    required this.reference,
  });

  final VerseRef ref;
  final String arabic;
  final String translation;

  /// Human-readable citation, e.g. `Ash-Sharh 94:5`.
  final String reference;
}

/// The verse-of-the-day rotation.
///
/// **References only — never the Arabic text.** The text is fetched at read
/// time from the same corpus the reader renders (`GET /quran/surah/:id`), so
/// the card can never drift from the mushaf the rest of the app shows and no
/// Qur'anic Arabic is ever hand-typed into this repository. Transcription
/// errors in scripture are the highest-severity bug this app can ship; the
/// only way to be sure of not making one is to never type it.
///
/// Every entry is deliberately a *short, self-contained* ayah drawn from a
/// surah whose entire payload is under ~45KB. `GET /surah/:id` returns the
/// whole surah, so a reference into Al-Baqarah would pull 746KB to render
/// one card — measured, not assumed. Each reference below was verified
/// against the live corpus before being added.
///
/// The previous hardcoded card is deliberately *not* carried forward: it
/// showed only the closing clause of At-Talaq 65:2, a 283-character ayah
/// whose body is about the waiting period in divorce. Rendering the whole
/// ayah would be off-message and rendering the clause alone is a quotation
/// out of context, so it is replaced rather than preserved.
const curatedDailyVerses = <VerseRef>[
  VerseRef(94, 5), // Ash-Sharh — with hardship comes ease
  VerseRef(93, 5), // Ad-Duhaa — your Lord will give, and you will be satisfied
  VerseRef(99, 7), // Az-Zalzalah — an atom's weight of good
  VerseRef(112, 1), // Al-Ikhlas — He is Allah, One
  VerseRef(87, 14), // Al-A'la — he has succeeded who purifies himself
  VerseRef(64, 11), // At-Taghabun — no disaster strikes except by His leave
  VerseRef(95, 4), // At-Tin — created in the best of stature
  VerseRef(93, 7), // Ad-Duhaa — He found you lost and guided you
  VerseRef(49, 13), // Al-Hujurat — peoples and tribes, that you may know
  VerseRef(91, 9), // Ash-Shams — he has succeeded who purifies it
  VerseRef(96, 1), // Al-'Alaq — recite in the name of your Lord
  VerseRef(103, 3), // Al-'Asr — save those who believe and do good
  VerseRef(90, 17), // Al-Balad — advised one another to patience
  VerseRef(94, 6), // Ash-Sharh — indeed, with hardship comes ease
  VerseRef(97, 5), // Al-Qadr — peace, until the emergence of dawn
  VerseRef(92, 5), // Al-Layl — as for he who gives and fears Allah
];

/// Which verse [day] shows.
///
/// Rotates by day-of-year so every device showing the same calendar day
/// shows the same verse without a round trip, and the choice is stable
/// across a restart. Uses wall-clock Y/M/D only — never an instant — so a
/// timezone or DST change can never skip or repeat a day.
VerseRef verseRefForDay(DateTime day) {
  final index = dayOfYear(day) % curatedDailyVerses.length;
  return curatedDailyVerses[index];
}

/// 1-based ordinal of [day] within its year, by wall-clock date.
@visibleForTesting
int dayOfYear(DateTime day) {
  final startOfYear = DateTime(day.year);
  final today = DateTime(day.year, day.month, day.day);
  // Both operands are local midnights built the same way, so the difference
  // is a whole number of days even across a DST boundary once rounded.
  return (today.difference(startOfYear).inHours / 24).round() + 1;
}
