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
///
/// [textName] and [chapterVerseCount] are carried for the same reason
/// [LastRead] carries the surah's name and length, and the argument is
/// copied there in full: Today now leads with continue-reading, this
/// pointer is read on the first frame above the habit loop, and resolving
/// the book's name through `scriptureTextDetailProvider` there would put a
/// network read ahead of the loop. Both are nullable; a pointer written
/// before they existed renders "Bhagavad Gita" as its slug-free fallback
/// and no bar, until the next time the reader saves.
class ScriptureLastRead {
  const ScriptureLastRead({
    required this.textSlug,
    required this.chapterNumber,
    required this.verseNumber,
    this.textName,
    this.chapterVerseCount,
  });

  final String textSlug;
  final int chapterNumber;
  final int verseNumber;

  /// The book, as the reader names it — "Bhagavad Gita", not the chapter.
  final String? textName;

  /// Verses in *this chapter*, so a position can be stated as "5 of 20".
  /// Deliberately the chapter's length and not the text's: a Ramayana kanda
  /// runs to thousands of verses and "verse 5 of 3641" tells a reader
  /// nothing about where they are in the sitting they are in.
  final int? chapterVerseCount;
}

@Riverpod(keepAlive: true)
class ScriptureLastReadController extends _$ScriptureLastReadController {
  static const _kSlugKey = 'hinduScriptures.lastRead.slug';
  static const _kChapterKey = 'hinduScriptures.lastRead.chapter';
  static const _kVerseKey = 'hinduScriptures.lastRead.verse';
  static const _kNameKey = 'hinduScriptures.lastRead.textName';
  static const _kCountKey = 'hinduScriptures.lastRead.chapterVerseCount';

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
      textName: prefs.getString(_kNameKey),
      chapterVerseCount: prefs.getInt(_kCountKey),
    );
  }

  /// Absent context is cleared rather than left behind — see
  /// [LastReadController.save] for why stale context is worse than none.
  Future<void> save({
    required String textSlug,
    required int chapterNumber,
    required int verseNumber,
    String? textName,
    int? chapterVerseCount,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kSlugKey, textSlug);
    await prefs.setInt(_kChapterKey, chapterNumber);
    await prefs.setInt(_kVerseKey, verseNumber);
    if (textName == null) {
      await prefs.remove(_kNameKey);
    } else {
      await prefs.setString(_kNameKey, textName);
    }
    if (chapterVerseCount == null) {
      await prefs.remove(_kCountKey);
    } else {
      await prefs.setInt(_kCountKey, chapterVerseCount);
    }
    state = AsyncValue.data(
      ScriptureLastRead(
        textSlug: textSlug,
        chapterNumber: chapterNumber,
        verseNumber: verseNumber,
        textName: textName,
        chapterVerseCount: chapterVerseCount,
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
