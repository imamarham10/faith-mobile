import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/providers.dart';
import 'dtos/hindu_story.dart';
import 'dtos/story_collection.dart';

part 'hindu_stories_repository.g.dart';

/// HTTP boundary for `/api/v1/hindu/stories/*` (backend controller class is
/// `SacredStoriesController`). Mirrors `hadiths_repository.dart`'s shape.
/// Unlike hadiths, this backend has no `/daily` endpoint — there's no
/// server-side "story of the day" rotation, so no daily-hero equivalent
/// exists in this module. Unlike hadiths (favorites deliberately skipped —
/// "API is premium-gated, upgrade flow isn't built"), stories' favorites
/// endpoints are live and JWT-gated with a real DELETE, same shape as
/// hindu_stotras' favorites.
class HinduStoriesRepository {
  HinduStoriesRepository(this._dio);

  static const String _base = '/api/v1/hindu/stories';

  final Dio _dio;

  /// `GET /collections` — all story collections, alphabetized server-side.
  Future<List<StoryCollection>> getCollections() async {
    try {
      final res = await _dio.get<dynamic>('$_base/collections');
      final data = res.data;
      if (data is! List) {
        throw const ApiException(
          message: 'Unexpected response shape from /stories/collections.',
        );
      }
      return data
          .whereType<Map<String, dynamic>>()
          .map(StoryCollection.fromJson)
          .toList(growable: false);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `GET ?collection=&deity=` — stories filtered by collection slug and/or
  /// deity key.
  Future<List<HinduStory>> getStories({String? collection, String? deity}) async {
    try {
      final res = await _dio.get<dynamic>(
        _base,
        queryParameters: {
          if (collection != null) 'collection': collection,
          if (deity != null) 'deity': deity,
        },
      );
      final data = res.data;
      if (data is! List) return const <HinduStory>[];
      return data
          .whereType<Map<String, dynamic>>()
          .map(HinduStory.fromJson)
          .toList(growable: false);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `GET /:id` — full story, addressed by UUID (not slug).
  Future<HinduStoryDetail> getStory(String id) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('$_base/$id');
      final data = res.data;
      if (data == null) {
        throw const ApiException(message: 'Empty story response.');
      }
      return HinduStoryDetail.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `GET /search?q=` — title+summary search. No server-side minimum
  /// query length (unlike hadiths' implicit 3-char convention), but the
  /// search screen still debounces and gates client-side for consistency.
  Future<List<HinduStory>> search(String query) async {
    try {
      final res = await _dio.get<dynamic>(
        '$_base/search',
        queryParameters: {'q': query},
      );
      final data = res.data;
      if (data is! List) return const <HinduStory>[];
      return data
          .whereType<Map<String, dynamic>>()
          .map(HinduStory.fromJson)
          .toList(growable: false);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `GET /favorites` — current user's favorited stories. Auth required;
  /// returns empty on any failure. Unwraps the backend's `{id, createdAt,
  /// story}[]` wrapper shape.
  Future<List<HinduStory>> getFavorites() async {
    try {
      final res = await _dio.get<dynamic>('$_base/favorites');
      final data = res.data;
      if (data is! List) return const <HinduStory>[];
      return data
          .whereType<Map<String, dynamic>>()
          .map((row) => row['story'])
          .whereType<Map<String, dynamic>>()
          .map(HinduStory.fromJson)
          .toList(growable: false);
    } on DioException {
      return const <HinduStory>[];
    }
  }

  /// `POST /favorites` — add a story to favorites server-side. Best-effort.
  Future<void> addFavorite(String storyId) async {
    try {
      await _dio.post<dynamic>('$_base/favorites', data: {'storyId': storyId});
    } on DioException {
      // Local mirror remains canonical.
    }
  }

  /// `DELETE /favorites/:storyId` — remove a favorite server-side.
  Future<void> removeFavorite(String storyId) async {
    try {
      await _dio.delete<dynamic>('$_base/favorites/$storyId');
    } on DioException {
      // Local mirror remains canonical.
    }
  }
}

@Riverpod(keepAlive: true)
HinduStoriesRepository hinduStoriesRepository(Ref ref) =>
    HinduStoriesRepository(ref.watch(dioProvider));
