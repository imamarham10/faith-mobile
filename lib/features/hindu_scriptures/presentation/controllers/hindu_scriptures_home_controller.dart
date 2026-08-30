import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/dtos/scripture_text.dart';
import '../../data/hindu_scriptures_repository.dart';

part 'hindu_scriptures_home_controller.g.dart';

/// Loads all scripture texts. Cached for the session, mirroring
/// `surahListProvider`'s `keepAlive` rationale.
@Riverpod(keepAlive: true)
Future<List<ScriptureText>> scriptureTextList(Ref ref) async {
  final repo = ref.watch(hinduScripturesRepositoryProvider);
  return repo.getTexts();
}

/// User's last-read position. Persisted to `shared_preferences`, keyed by
/// text slug (not a numeric id like Quran's surah, since scripture texts
/// are slug-identified).
class ScriptureLastRead {
  const ScriptureLastRead({
    required this.textSlug,
    required this.chapterNumber,
    required this.verseNumber,
  });

  final String textSlug;
  final int chapterNumber;
  final int verseNumber;
}

@Riverpod(keepAlive: true)
class ScriptureLastReadController extends _$ScriptureLastReadController {
  static const _kSlugKey = 'hinduScriptures.lastRead.slug';
  static const _kChapterKey = 'hinduScriptures.lastRead.chapter';
  static const _kVerseKey = 'hinduScriptures.lastRead.verse';

  @override
  Future<ScriptureLastRead?> build() async {
    final prefs = await SharedPreferences.getInstance();
    final slug = prefs.getString(_kSlugKey);
    final chapter = prefs.getInt(_kChapterKey);
    final verse = prefs.getInt(_kVerseKey);
    if (slug == null || chapter == null || verse == null) return null;
    return ScriptureLastRead(
      textSlug: slug,
      chapterNumber: chapter,
      verseNumber: verse,
    );
  }

  Future<void> save({
    required String textSlug,
    required int chapterNumber,
    required int verseNumber,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kSlugKey, textSlug);
    await prefs.setInt(_kChapterKey, chapterNumber);
    await prefs.setInt(_kVerseKey, verseNumber);
    state = AsyncValue.data(
      ScriptureLastRead(
        textSlug: textSlug,
        chapterNumber: chapterNumber,
        verseNumber: verseNumber,
      ),
    );
  }
}

/// Search query state for the home screen list filter.
@riverpod
class ScriptureSearchQuery extends _$ScriptureSearchQuery {
  @override
  String build() => '';

  void update(String query) => state = query;
}

/// Filters [scriptureTextListProvider] by name.
@riverpod
List<ScriptureText> filteredScriptureTexts(Ref ref) {
  final query = ref.watch(scriptureSearchQueryProvider).trim().toLowerCase();
  final all =
      ref.watch(scriptureTextListProvider).valueOrNull ??
      const <ScriptureText>[];
  if (query.isEmpty) return all;
  return all
      .where(
        (t) =>
            t.nameEnglish.toLowerCase().contains(query) ||
            t.nameSanskrit.toLowerCase().contains(query),
      )
      .toList(growable: false);
}
