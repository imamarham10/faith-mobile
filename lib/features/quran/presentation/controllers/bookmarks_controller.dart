import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/dtos/bookmark.dart';
import '../../data/quran_repository.dart';

part 'bookmarks_controller.g.dart';

/// Local-mirror bookmark store.
///
/// Server-side bookmarks are best-effort; the local list is canonical so the
/// UI is always instant and works offline. On launch we hydrate from
/// `shared_preferences` and lazily merge any newer server bookmarks.
@Riverpod(keepAlive: true)
class BookmarksController extends _$BookmarksController {
  static const _kBookmarksKey = 'quran.bookmarks.v1';

  @override
  Future<List<Bookmark>> build() async {
    final local = await _readLocal();
    // Fire-and-forget remote merge; UI shows local immediately.
    _mergeRemote(local);
    return local;
  }

  Future<List<Bookmark>> _readLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kBookmarksKey);
    if (raw == null || raw.isEmpty) return const <Bookmark>[];
    try {
      final list = jsonDecode(raw);
      if (list is! List) return const <Bookmark>[];
      return list
          .whereType<Map<String, dynamic>>()
          .map(Bookmark.fromJson)
          .toList(growable: false);
    } on FormatException catch (e, st) {
      developer.log(
        'Failed to parse local bookmarks',
        error: e,
        stackTrace: st,
      );
      return const <Bookmark>[];
    }
  }

  Future<void> _writeLocal(List<Bookmark> bookmarks) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(bookmarks.map((b) => b.toJson()).toList());
    await prefs.setString(_kBookmarksKey, raw);
  }

  Future<void> _mergeRemote(List<Bookmark> local) async {
    try {
      final repo = ref.read(quranRepositoryProvider);
      final remote = await repo.getBookmarks();
      if (remote.isEmpty) return;
      final byKey = <String, Bookmark>{
        for (final b in local) _key(b.surahId, b.verseNumber): b,
      };
      for (final r in remote) {
        byKey.putIfAbsent(_key(r.surahId, r.verseNumber), () => r);
      }
      final merged = byKey.values.toList(growable: false);
      await _writeLocal(merged);
      state = AsyncValue.data(merged);
    } on Object catch (e, st) {
      developer.log('Bookmark merge failed', error: e, stackTrace: st);
    }
  }

  String _key(int surah, int verse) => '$surah:$verse';

  /// Returns true if a bookmark exists for the given verse.
  bool isBookmarked(int surahId, int verseNumber) {
    final list = state.valueOrNull ?? const <Bookmark>[];
    return list.any(
      (b) => b.surahId == surahId && b.verseNumber == verseNumber,
    );
  }

  Future<void> toggle({
    required int surahId,
    required int verseNumber,
    String? surahName,
    String? textArabic,
    String? translation,
  }) async {
    final current = state.valueOrNull ?? const <Bookmark>[];
    final existingIndex = current.indexWhere(
      (b) => b.surahId == surahId && b.verseNumber == verseNumber,
    );
    if (existingIndex >= 0) {
      await remove(current[existingIndex]);
      return;
    }
    await HapticFeedback.mediumImpact();
    final bookmark = Bookmark(
      id: 'local:$surahId:$verseNumber',
      surahId: surahId,
      verseNumber: verseNumber,
      surahName: surahName,
      textArabic: textArabic,
      translation: translation,
      createdAt: DateTime.now(),
    );
    final next = [bookmark, ...current];
    state = AsyncValue.data(next);
    await _writeLocal(next);
    await ref
        .read(quranRepositoryProvider)
        .addBookmark(surahId: surahId, verseNumber: verseNumber);
  }

  Future<void> remove(Bookmark bookmark) async {
    final current = state.valueOrNull ?? const <Bookmark>[];
    final next = current
        .where(
          (b) =>
              !(b.surahId == bookmark.surahId &&
                  b.verseNumber == bookmark.verseNumber),
        )
        .toList(growable: false);
    state = AsyncValue.data(next);
    await _writeLocal(next);
    if (!bookmark.id.startsWith('local:')) {
      await ref.read(quranRepositoryProvider).removeBookmark(bookmark.id);
    }
  }
}
