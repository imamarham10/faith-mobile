import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/providers.dart';
import 'dtos/audio_track.dart';
import 'dtos/scripture_bookmark.dart';
import 'dtos/scripture_chapter.dart';
import 'dtos/scripture_text.dart';
import 'dtos/scripture_verse.dart';

part 'hindu_scriptures_repository.g.dart';

/// HTTP boundary for Hindu scripture endpoints under
/// `/api/v1/hindu/scriptures/*`. Mirrors `quran_repository.dart`'s shape —
/// same try/catch, same [ApiException] surfacing, same
/// `@Riverpod(keepAlive: true)` provider pattern.
class HinduScripturesRepository {
  HinduScripturesRepository(this._dio);

  static const String _base = '/api/v1/hindu/scriptures';

  final Dio _dio;

  /// `GET /texts` — list of all scripture texts (Gita, Ramayana, ...).
  Future<List<ScriptureText>> getTexts() async {
    try {
      final res = await _dio.get<dynamic>('$_base/texts');
      final data = res.data;
      if (data is! List) {
        throw const ApiException(
          message: 'Unexpected response shape from /texts.',
        );
      }
      return data
          .whereType<Map<String, dynamic>>()
          .map(ScriptureText.fromJson)
          .toList(growable: false);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `GET /texts/:slug` — a text with its chapter list.
  Future<ScriptureTextDetail> getTextDetail(String slug) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('$_base/texts/$slug');
      final data = res.data;
      if (data == null) {
        throw const ApiException(message: 'Empty text response. Try again.');
      }
      return ScriptureTextDetail.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `GET /texts/:slug/chapters/:chapterNumber?lang=` — chapter with verses.
  Future<ChapterDetail> getChapter(
    String slug,
    int chapterNumber, {
    String lang = 'en',
  }) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '$_base/texts/$slug/chapters/$chapterNumber',
        queryParameters: {'lang': lang},
      );
      final data = res.data;
      if (data == null) {
        throw const ApiException(message: 'Empty chapter response. Try again.');
      }
      return ChapterDetail.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `GET /texts/:slug/chapters/:chapterNumber/audio` — available narrations.
  Future<List<AudioTrack>> getChapterAudio(
    String slug,
    int chapterNumber,
  ) async {
    try {
      final res = await _dio.get<dynamic>(
        '$_base/texts/$slug/chapters/$chapterNumber/audio',
      );
      final data = res.data;
      if (data is! List) return const <AudioTrack>[];
      return data
          .whereType<Map<String, dynamic>>()
          .map(AudioTrack.fromJson)
          .toList(growable: false);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `GET /featured?lang=&slug=` — curated verses for a "verse of the day"
  /// style surface. [slug] filters to a single text when provided.
  Future<List<ScriptureVerse>> getFeatured({
    String lang = 'en',
    String? slug,
  }) async {
    try {
      final res = await _dio.get<dynamic>(
        '$_base/featured',
        queryParameters: {'lang': lang, if (slug != null) 'slug': slug},
      );
      final data = res.data;
      if (data is! List) return const <ScriptureVerse>[];
      return data
          .whereType<Map<String, dynamic>>()
          .map(ScriptureVerse.fromJson)
          .toList(growable: false);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `GET /search?q=&lang=` — verse search across all texts.
  Future<List<ScriptureVerse>> search(
    String query, {
    String lang = 'en',
  }) async {
    try {
      final res = await _dio.get<dynamic>(
        '$_base/search',
        queryParameters: {'q': query, 'lang': lang},
      );
      final data = res.data;
      if (data is! List) return const <ScriptureVerse>[];
      return data
          .whereType<Map<String, dynamic>>()
          .map(ScriptureVerse.fromJson)
          .toList(growable: false);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `GET /verses/:id?lang=` — a single verse (e.g. from a deep link or
  /// bookmark tap).
  Future<ScriptureVerse> getVerse(String id, {String lang = 'en'}) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '$_base/verses/$id',
        queryParameters: {'lang': lang},
      );
      final data = res.data;
      if (data == null) {
        throw const ApiException(message: 'Empty verse response. Try again.');
      }
      return ScriptureVerse.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `GET /bookmarks` — server-side bookmarks for the signed-in user.
  ///
  /// Returns an empty list on any failure; UI falls back to local
  /// bookmarks transparently, same defensive pattern as Quran.
  Future<List<ScriptureBookmark>> getBookmarks() async {
    try {
      final res = await _dio.get<dynamic>('$_base/bookmarks');
      final data = res.data;
      if (data is! List) return const <ScriptureBookmark>[];
      return data
          .whereType<Map<String, dynamic>>()
          .map(ScriptureBookmark.fromServerJson)
          .toList(growable: false);
    } on DioException {
      return const <ScriptureBookmark>[];
    }
  }

  /// `POST /bookmarks` — upserts on `(userId, verseId)` server-side.
  /// Best-effort: the local mirror is the source of truth.
  Future<void> addBookmark(String verseId, {String? note}) async {
    try {
      await _dio.post<dynamic>(
        '$_base/bookmarks',
        data: {'verseId': verseId, if (note != null) 'note': note},
      );
    } on DioException {
      // Best effort.
    }
  }

  /// `DELETE /bookmarks/:verseId` — path param is the verse id, not a
  /// bookmark id (per the backend's own contract).
  Future<void> removeBookmark(String verseId) async {
    try {
      await _dio.delete<dynamic>('$_base/bookmarks/$verseId');
    } on DioException {
      // Best effort.
    }
  }
}

@Riverpod(keepAlive: true)
HinduScripturesRepository hinduScripturesRepository(Ref ref) =>
    HinduScripturesRepository(ref.watch(dioProvider));
