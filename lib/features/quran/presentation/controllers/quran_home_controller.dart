import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/dtos/surah.dart';
import '../../data/quran_repository.dart';

part 'quran_home_controller.g.dart';

/// Loads the 114-surah index. Cached for the session via `keepAlive`.
@Riverpod(keepAlive: true)
Future<List<Surah>> surahList(Ref ref) async {
  final repo = ref.watch(quranRepositoryProvider);
  return repo.getSurahs();
}

/// User's last-read surah/ayah. Persisted to `shared_preferences`.
///
/// ## Why the name and the length are stored alongside the address
///
/// [surahId] and [verseNumber] are the pointer; [surahName] and
/// [verseCount] are what it takes to *say* the pointer out loud. They are
/// duplicated out of the surah index deliberately.
///
/// Since the Today screen leads with continue-reading, this pointer is read
/// above the habit loop, on the first frame of the app's home screen.
/// Resolving the name from `surahListProvider` there would put a network
/// read ahead of the two activity reads the loop waits on — the exact
/// pressure `below_fold_gate.dart` exists to relieve — and deferring it
/// behind that gate would leave the largest card on the screen titled
/// "Surah 2" for a second and then rewrite itself.
///
/// The reader already has both values in hand when it saves, so it writes
/// them. Both are nullable because a pointer stored by a build that
/// predates them has neither: the card degrades to "Surah 2 · verse 151"
/// and no progress bar for exactly one reading session, then heals itself
/// the next time the reader persists.
class LastRead {
  const LastRead({
    required this.surahId,
    required this.verseNumber,
    this.surahName,
    this.verseCount,
  });

  final int surahId;
  final int verseNumber;

  /// How the reader titles this surah — `SurahDetail.nameEnglish`, which is
  /// the transliteration ("Al-Baqarah"), not a translation of it.
  final String? surahName;

  /// Verses in the surah, so a position can be stated as "151 of 286"
  /// without the index.
  final int? verseCount;
}

/// Persists / reads the last-read pointer. Updated by the reader on
/// scroll-stop; surfaced on the home screen as a "Continue reading" card.
@Riverpod(keepAlive: true)
class LastReadController extends _$LastReadController {
  static const _kSurahKey = 'quran.lastRead.surah';
  static const _kVerseKey = 'quran.lastRead.verse';
  static const _kNameKey = 'quran.lastRead.surahName';
  static const _kCountKey = 'quran.lastRead.verseCount';

  @override
  Future<LastRead?> build() async {
    final prefs = await SharedPreferences.getInstance();
    final surah = prefs.getInt(_kSurahKey);
    final verse = prefs.getInt(_kVerseKey);
    if (surah == null || verse == null) return null;
    return LastRead(
      surahId: surah,
      verseNumber: verse,
      surahName: prefs.getString(_kNameKey),
      verseCount: prefs.getInt(_kCountKey),
    );
  }

  /// [surahName] and [verseCount] are optional because the save path runs
  /// off a scroll debounce that can fire before the surah payload has
  /// landed. Absent means *absent*, not "keep the old one": they are
  /// cleared rather than left behind, or a jump from Al-Baqarah to
  /// Al-Mulk could leave the card reading "Al-Baqarah, verse 3 of 286"
  /// about a thirty-verse surah.
  Future<void> save({
    required int surahId,
    required int verseNumber,
    String? surahName,
    int? verseCount,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kSurahKey, surahId);
    await prefs.setInt(_kVerseKey, verseNumber);
    if (surahName == null) {
      await prefs.remove(_kNameKey);
    } else {
      await prefs.setString(_kNameKey, surahName);
    }
    if (verseCount == null) {
      await prefs.remove(_kCountKey);
    } else {
      await prefs.setInt(_kCountKey, verseCount);
    }
    state = AsyncValue.data(
      LastRead(
        surahId: surahId,
        verseNumber: verseNumber,
        surahName: surahName,
        verseCount: verseCount,
      ),
    );
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kSurahKey);
    await prefs.remove(_kVerseKey);
    await prefs.remove(_kNameKey);
    await prefs.remove(_kCountKey);
    state = const AsyncValue.data(null);
  }
}

/// Search query state for the home screen list filter.
@riverpod
class SurahSearchQuery extends _$SurahSearchQuery {
  @override
  String build() => '';

  void update(String query) => state = query;
}

/// Filters [surahListProvider] by name / transliteration / number.
@riverpod
List<Surah> filteredSurahs(Ref ref) {
  final query = ref.watch(surahSearchQueryProvider).trim().toLowerCase();
  final all = ref.watch(surahListProvider).valueOrNull ?? const <Surah>[];
  if (query.isEmpty) return all;

  final asNumber = int.tryParse(query);
  return all
      .where((s) {
        if (asNumber != null && s.id == asNumber) return true;
        return s.nameEnglish.toLowerCase().contains(query) ||
            s.nameTransliteration.toLowerCase().contains(query) ||
            s.nameArabic.contains(query);
      })
      .toList(growable: false);
}
