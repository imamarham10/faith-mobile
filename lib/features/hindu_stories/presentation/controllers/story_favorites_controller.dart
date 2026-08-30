import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/dtos/hindu_story.dart';
import '../../data/hindu_stories_repository.dart';

part 'story_favorites_controller.g.dart';

/// Local-mirror story favorites. Mirrors `StotraFavoritesController` —
/// local list is canonical/instant, lazily merged with the server, and
/// removal syncs to a real `DELETE` endpoint (unlike hadiths, which skips
/// favorites in v1 entirely).
@Riverpod(keepAlive: true)
class StoryFavoritesController extends _$StoryFavoritesController {
  static const _kStorageKey = 'stories.favorites.v1';

  @override
  Future<List<HinduStory>> build() async {
    final local = await _readLocal();
    _mergeRemote(local);
    return local;
  }

  Future<List<HinduStory>> _readLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kStorageKey);
    if (raw == null || raw.isEmpty) return const <HinduStory>[];
    try {
      final list = jsonDecode(raw);
      if (list is! List) return const <HinduStory>[];
      return list
          .whereType<Map<String, dynamic>>()
          .map(HinduStory.fromJson)
          .toList(growable: false);
    } on FormatException catch (e, st) {
      developer.log(
        'Failed to parse cached story favorites',
        error: e,
        stackTrace: st,
      );
      return const <HinduStory>[];
    }
  }

  Future<void> _writeLocal(List<HinduStory> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _kStorageKey,
      jsonEncode(list.map((s) => s.toJson()).toList()),
    );
  }

  Future<void> _mergeRemote(List<HinduStory> local) async {
    try {
      final repo = ref.read(hinduStoriesRepositoryProvider);
      final remote = await repo.getFavorites();
      if (remote.isEmpty) return;
      final byId = <String, HinduStory>{for (final s in local) s.id: s};
      for (final s in remote) {
        byId.putIfAbsent(s.id, () => s);
      }
      final merged = byId.values.toList(growable: false);
      await _writeLocal(merged);
      state = AsyncValue.data(merged);
    } on Object catch (e, st) {
      developer.log(
        'Story favorites remote merge failed',
        error: e,
        stackTrace: st,
      );
    }
  }

  bool isFavorite(String id) {
    final list = state.valueOrNull ?? const <HinduStory>[];
    return list.any((s) => s.id == id);
  }

  Future<void> toggle(HinduStory story) async {
    final current = state.valueOrNull ?? const <HinduStory>[];
    final exists = current.any((s) => s.id == story.id);
    if (exists) {
      final next = current
          .where((s) => s.id != story.id)
          .toList(growable: false);
      state = AsyncValue.data(next);
      await _writeLocal(next);
      await HapticFeedback.lightImpact();
      await ref.read(hinduStoriesRepositoryProvider).removeFavorite(story.id);
      return;
    }
    final next = [story, ...current];
    state = AsyncValue.data(next);
    await _writeLocal(next);
    await HapticFeedback.mediumImpact();
    await ref.read(hinduStoriesRepositoryProvider).addFavorite(story.id);
  }
}
