import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/dtos/temple.dart';
import '../../data/hindu_temples_repository.dart';

part 'temple_favorites_controller.g.dart';

/// Local-mirror temple favorites. Mirrors `StotraFavoritesController`/
/// `StoryFavoritesController` — local list is canonical/instant, lazily
/// merged with the server, and removal syncs to a real `DELETE` endpoint.
@Riverpod(keepAlive: true)
class TempleFavoritesController extends _$TempleFavoritesController {
  static const _kStorageKey = 'temples.favorites.v1';

  @override
  Future<List<Temple>> build() async {
    final local = await _readLocal();
    _mergeRemote(local);
    return local;
  }

  Future<List<Temple>> _readLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kStorageKey);
    if (raw == null || raw.isEmpty) return const <Temple>[];
    try {
      final list = jsonDecode(raw);
      if (list is! List) return const <Temple>[];
      return list
          .whereType<Map<String, dynamic>>()
          .map(Temple.fromJson)
          .toList(growable: false);
    } on FormatException catch (e, st) {
      developer.log(
        'Failed to parse cached temple favorites',
        error: e,
        stackTrace: st,
      );
      return const <Temple>[];
    }
  }

  Future<void> _writeLocal(List<Temple> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _kStorageKey,
      jsonEncode(list.map((t) => t.toJson()).toList()),
    );
  }

  Future<void> _mergeRemote(List<Temple> local) async {
    try {
      final repo = ref.read(hinduTemplesRepositoryProvider);
      final remote = await repo.getFavorites();
      if (remote.isEmpty) return;
      final byId = <String, Temple>{for (final t in local) t.id: t};
      for (final t in remote) {
        byId.putIfAbsent(t.id, () => t);
      }
      final merged = byId.values.toList(growable: false);
      await _writeLocal(merged);
      state = AsyncValue.data(merged);
    } on Object catch (e, st) {
      developer.log(
        'Temple favorites remote merge failed',
        error: e,
        stackTrace: st,
      );
    }
  }

  bool isFavorite(String id) {
    final list = state.valueOrNull ?? const <Temple>[];
    return list.any((t) => t.id == id);
  }

  Future<void> toggle(Temple temple) async {
    final current = state.valueOrNull ?? const <Temple>[];
    final exists = current.any((t) => t.id == temple.id);
    if (exists) {
      final next = current
          .where((t) => t.id != temple.id)
          .toList(growable: false);
      state = AsyncValue.data(next);
      await _writeLocal(next);
      await HapticFeedback.lightImpact();
      await ref.read(hinduTemplesRepositoryProvider).removeFavorite(temple.id);
      return;
    }
    final next = [temple, ...current];
    state = AsyncValue.data(next);
    await _writeLocal(next);
    await HapticFeedback.mediumImpact();
    await ref.read(hinduTemplesRepositoryProvider).addFavorite(temple.id);
  }
}
