import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/dtos/scripture_bookmark.dart';
import '../../data/hindu_scriptures_repository.dart';

part 'scripture_bookmarks_controller.g.dart';

/// Local-mirror bookmark store, keyed by `verseId` (simpler than Quran's
/// `surahId:verseNumber` composite key since the backend keys bookmarks
/// purely off verse id). Server-side bookmarks are best-effort; the local
/// list is canonical so the UI is instant and works offline.
@Riverpod(keepAlive: true)
class ScriptureBookmarksController extends _$ScriptureBookmarksController {
  static const _kBookmarksKey = 'hinduScriptures.bookmarks.v1';

  @override
  Future<List<ScriptureBookmark>> build() async {
    final local = await _readLocal();
    _mergeRemote(local);
    return local;
  }

  Future<List<ScriptureBookmark>> _readLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kBookmarksKey);
    if (raw == null || raw.isEmpty) return const <ScriptureBookmark>[];
    try {
      final list = jsonDecode(raw);
      if (list is! List) return const <ScriptureBookmark>[];
      return list
          .whereType<Map<String, dynamic>>()
          .map(ScriptureBookmark.fromJson)
          .toList(growable: false);
    } on FormatException catch (e, st) {
      developer.log(
        'Failed to parse local scripture bookmarks',
        error: e,
        stackTrace: st,
      );
      return const <ScriptureBookmark>[];
    }
  }

  Future<void> _writeLocal(List<ScriptureBookmark> bookmarks) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(bookmarks.map((b) => b.toJson()).toList());
    await prefs.setString(_kBookmarksKey, raw);
  }

  Future<void> _mergeRemote(List<ScriptureBookmark> local) async {
    try {
      final repo = ref.read(hinduScripturesRepositoryProvider);
      final remote = await repo.getBookmarks();
      if (remote.isEmpty) return;
      final byVerse = <String, ScriptureBookmark>{
        for (final b in local) b.verseId: b,
      };
      for (final r in remote) {
        byVerse.putIfAbsent(r.verseId, () => r);
      }
      final merged = byVerse.values.toList(growable: false);
      await _writeLocal(merged);
      state = AsyncValue.data(merged);
    } on Object catch (e, st) {
      developer.log('Scripture bookmark merge failed', error: e, stackTrace: st);
    }
  }

  bool isBookmarked(String verseId) {
    final list = state.valueOrNull ?? const <ScriptureBookmark>[];
    return list.any((b) => b.verseId == verseId);
  }

  Future<void> toggle({
    required String verseId,
    String? textSlug,
    String? textName,
    int? chapterNumber,
    String? sanskritText,
    int? verseNumber,
    String? translation,
  }) async {
    final current = state.valueOrNull ?? const <ScriptureBookmark>[];
    final existingIndex = current.indexWhere((b) => b.verseId == verseId);
    if (existingIndex >= 0) {
      await remove(current[existingIndex]);
      return;
    }
    await HapticFeedback.mediumImpact();
    final bookmark = ScriptureBookmark(
      id: 'local:$verseId',
      verseId: verseId,
      textSlug: textSlug,
      textName: textName,
      chapterNumber: chapterNumber,
      sanskritText: sanskritText,
      verseNumber: verseNumber,
      translation: translation,
      createdAt: DateTime.now(),
    );
    final next = [bookmark, ...current];
    state = AsyncValue.data(next);
    await _writeLocal(next);
    await ref.read(hinduScripturesRepositoryProvider).addBookmark(verseId);
  }

  Future<void> remove(ScriptureBookmark bookmark) async {
    final current = state.valueOrNull ?? const <ScriptureBookmark>[];
    final next = current
        .where((b) => b.verseId != bookmark.verseId)
        .toList(growable: false);
    state = AsyncValue.data(next);
    await _writeLocal(next);
    await ref
        .read(hinduScripturesRepositoryProvider)
        .removeBookmark(bookmark.verseId);
  }
}
