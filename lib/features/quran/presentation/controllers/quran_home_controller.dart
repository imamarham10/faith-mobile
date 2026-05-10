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
class LastRead {
  const LastRead({required this.surahId, required this.verseNumber});

  final int surahId;
  final int verseNumber;
}

/// Persists / reads the last-read pointer. Updated by the reader on
/// scroll-stop; surfaced on the home screen as a "Continue reading" card.
@Riverpod(keepAlive: true)
class LastReadController extends _$LastReadController {
  static const _kSurahKey = 'quran.lastRead.surah';
  static const _kVerseKey = 'quran.lastRead.verse';

  @override
  Future<LastRead?> build() async {
    final prefs = await SharedPreferences.getInstance();
    final surah = prefs.getInt(_kSurahKey);
    final verse = prefs.getInt(_kVerseKey);
    if (surah == null || verse == null) return null;
    return LastRead(surahId: surah, verseNumber: verse);
  }

  Future<void> save({required int surahId, required int verseNumber}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kSurahKey, surahId);
    await prefs.setInt(_kVerseKey, verseNumber);
    state = AsyncValue.data(
      LastRead(surahId: surahId, verseNumber: verseNumber),
    );
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kSurahKey);
    await prefs.remove(_kVerseKey);
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
