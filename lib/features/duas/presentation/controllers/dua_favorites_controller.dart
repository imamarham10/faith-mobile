import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/dtos/dua.dart';
import '../../data/duas_repository.dart';

part 'dua_favorites_controller.g.dart';

/// Local-mirror dua favorites.
///
/// The local list is canonical so the UI is instant and works offline. On
/// launch we hydrate from `shared_preferences` and lazily merge any remote
/// favorites the server already knows about.
///
/// Backend currently only exposes `POST /favorites` (no DELETE), so removal
/// is local-only — adequate for Phase 1.
@Riverpod(keepAlive: true)
class DuaFavoritesController extends _$DuaFavoritesController {
  static const _kStorageKey = 'duas.favorites.v1';

  @override
  Future<List<Dua>> build() async {
    final local = await _readLocal();
    // Fire-and-forget remote merge.
    _mergeRemote(local);
    return local;
  }

  Future<List<Dua>> _readLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kStorageKey);
    if (raw == null || raw.isEmpty) return const <Dua>[];
    try {
      final list = jsonDecode(raw);
      if (list is! List) return const <Dua>[];
      return list
          .whereType<Map<String, dynamic>>()
          .map(Dua.fromJson)
          .toList(growable: false);
    } on FormatException catch (e, st) {
      developer.log(
        'Failed to parse cached dua favorites',
        error: e,
        stackTrace: st,
      );
      return const <Dua>[];
    }
  }

  Future<void> _writeLocal(List<Dua> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _kStorageKey,
      jsonEncode(list.map((d) => d.toJson()).toList()),
    );
  }

  Future<void> _mergeRemote(List<Dua> local) async {
    try {
      final repo = ref.read(duasRepositoryProvider);
      final remote = await repo.getFavorites();
      if (remote.isEmpty) return;
      final byId = <String, Dua>{for (final d in local) d.id: d};
      for (final d in remote) {
        byId.putIfAbsent(d.id, () => d);
      }
      final merged = byId.values.toList(growable: false);
      await _writeLocal(merged);
      state = AsyncValue.data(merged);
    } on Object catch (e, st) {
      developer.log(
        'Dua favorites remote merge failed',
        error: e,
        stackTrace: st,
      );
    }
  }

  /// Whether the dua with the given id is currently favorited.
  bool isFavorite(String id) {
    final list = state.valueOrNull ?? const <Dua>[];
    return list.any((d) => d.id == id);
  }

  /// Toggles favorite state for a [dua]. Plays the appropriate haptic.
  Future<void> toggle(Dua dua) async {
    final current = state.valueOrNull ?? const <Dua>[];
    final exists = current.any((d) => d.id == dua.id);
    if (exists) {
      final next = current.where((d) => d.id != dua.id).toList(growable: false);
      state = AsyncValue.data(next);
      await _writeLocal(next);
      await HapticFeedback.lightImpact();
      return;
    }
    final next = [dua, ...current];
    state = AsyncValue.data(next);
    await _writeLocal(next);
    await HapticFeedback.mediumImpact();
    await ref.read(duasRepositoryProvider).addFavorite(dua.id);
  }
}
