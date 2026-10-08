import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/api_exception.dart';
import '../../../quran/data/dtos/verse.dart';
import '../../../quran/data/quran_repository.dart';
import '../../domain/daily_verse.dart';

part 'daily_verse_controller.g.dart';

/// The free translation shipped with every verse. The other four in the
/// corpus are flagged `isPremium`, so naming this one explicitly keeps the
/// card both consistent in voice and inside the entitlement.
const _preferredTranslator = 'Saheeh International';

/// Verse of the day — mirrors [dailyHadith]'s shape so the two Today cards
/// behave identically (same four states, same keep-alive).
///
/// Resolves today's curated [VerseRef] against the live corpus. Kept alive
/// because the answer is stable for the whole calendar day and the surah
/// payload is the largest single read on this screen.
@Riverpod(keepAlive: true)
Future<DailyVerse> dailyVerse(Ref ref) async {
  final repo = ref.watch(quranRepositoryProvider);
  final verseRef = verseRefForDay(DateTime.now());
  final surah = await repo.getSurah(verseRef.surahId);

  final verse = surah.verses
      .where((v) => v.verseNumber == verseRef.verseNumber)
      .firstOrNull;
  if (verse == null) {
    // Surfacing the card's error state is the honest outcome — far better
    // than falling back to some other verse and captioning it with this
    // one's reference.
    throw ApiException(
      message:
          'Verse ${verseRef.surahId}:${verseRef.verseNumber} is missing from '
          'the corpus.',
    );
  }

  return DailyVerse(
    ref: verseRef,
    arabic: verse.textArabic,
    translation: _translationOf(verse),
    reference:
        '${surah.nameEnglish} ${verseRef.surahId}:${verseRef.verseNumber}',
  );
}

String _translationOf(Verse verse) {
  final preferred = verse.translations
      .where((t) => t.authorName == _preferredTranslator)
      .firstOrNull;
  return (preferred ?? verse.translations.firstOrNull)?.text ?? '';
}
