import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/dtos/stotra.dart';
import '../../data/hindu_stotras_repository.dart';

part 'stotra_favorites_controller.g.dart';

/// Local-mirror stotra favorites.
///
/// The local list is canonical so the UI is instant and works offline. On
/// launch we hydrate from `shared_preferences` and lazily merge any remote
/// favorites the server already knows about.
///
/// Unlike Dhikr/Duas (whose favorites are add-only, no DELETE endpoint),
/// this backend exposes `DELETE /favorites/:stotraId`, so [toggle] syncs
/// removal to the server too, not just locally.
@Riverpod(keepAlive: true)
class StotraFavoritesController extends _$StotraFavoritesController {
  static const _kStorageKey = 'stotras.favorites.v1';

  @override
  Future<List<Stotra>> build() async {
    final local = await _readLocal();
    _mergeRemote(local);
    return local;
  }

  Future<List<Stotra>> _readLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kStorageKey);
    if (raw == null || raw.isEmpty) return const <Stotra>[];
    try {
      final list = jsonDecode(raw);
      if (list is! List) return const <Stotra>[];
      return list
          .whereType<Map<String, dynamic>>()
          .map(Stotra.fromJson)
          .toList(growable: false);
    } on FormatException catch (e, st) {
      developer.log(
        'Failed to parse cached stotra favorites',
        error: e,
        stackTrace: st,
      );
      return const <Stotra>[];
    }
  }

  Future<void> _writeLocal(List<Stotra> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _kStorageKey,
      jsonEncode(list.map((s) => s.toJson()).toList()),
    );
  }

  Future<void> _mergeRemote(List<Stotra> local) async {
    try {
      final repo = ref.read(hinduStotrasRepositoryProvider);
      final remote = await repo.getFavorites();
      if (remote.isEmpty) return;
      final byId = <String, Stotra>{for (final s in local) s.id: s};
      for (final s in remote) {
        byId.putIfAbsent(s.id, () => s);
      }
      final merged = byId.values.toList(growable: false);
      await _writeLocal(merged);
      state = AsyncValue.data(merged);
    } on Object catch (e, st) {
      developer.log(
        'Stotra favorites remote merge failed',
        error: e,
        stackTrace: st,
      );
    }
  }

  /// Whether the stotra with the given id is currently favorited.
  bool isFavorite(String id) {
    final list = state.valueOrNull ?? const <Stotra>[];
    return list.any((s) => s.id == id);
  }

  /// Toggles favorite state for a [stotra]. Plays the appropriate haptic.
  Future<void> toggle(Stotra stotra) async {
    final current = state.valueOrNull ?? const <Stotra>[];
    final exists = current.any((s) => s.id == stotra.id);
    if (exists) {
      final next = current
          .where((s) => s.id != stotra.id)
          .toList(growable: false);
      state = AsyncValue.data(next);
      await _writeLocal(next);
      await HapticFeedback.lightImpact();
      await ref.read(hinduStotrasRepositoryProvider).removeFavorite(stotra.id);
      return;
    }
    final next = [stotra, ...current];
    state = AsyncValue.data(next);
    await _writeLocal(next);
    await HapticFeedback.mediumImpact();
    await ref.read(hinduStotrasRepositoryProvider).addFavorite(stotra.id);
  }
}
