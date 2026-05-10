import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/dtos/divine_name.dart';
import '../../data/names_repository.dart';
import '../../domain/names_kind.dart';

part 'name_favorites_controller.g.dart';

/// Local-mirror favorites store, parameterized by [NamesKind] so Allah and
/// Muhammad favorites stay independent.
///
/// The local list is canonical so the UI is instant and works offline. On
/// build we hydrate from `shared_preferences` and lazily merge any remote
/// favorites the server already knows about.
@Riverpod(keepAlive: true)
class NameFavoritesController extends _$NameFavoritesController {
  String get _storageKey => 'names.${kind.slug}.favorites.v1';

  @override
  Future<List<DivineName>> build(NamesKind kind) async {
    final local = await _readLocal();
    _mergeRemote(local);
    return local;
  }

  Future<List<DivineName>> _readLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return const <DivineName>[];
    try {
      final list = jsonDecode(raw);
      if (list is! List) return const <DivineName>[];
      return list
          .whereType<Map<String, dynamic>>()
          .map(DivineName.fromJson)
          .toList(growable: false);
    } on FormatException catch (e, st) {
      developer.log(
        'Failed to parse cached name favorites',
        error: e,
        stackTrace: st,
      );
      return const <DivineName>[];
    }
  }

  Future<void> _writeLocal(List<DivineName> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _storageKey,
      jsonEncode(list.map((n) => n.toJson()).toList()),
    );
  }

  Future<void> _mergeRemote(List<DivineName> local) async {
    try {
      final repo = ref.read(namesRepositoryProvider);
      final remote = await repo.getFavorites(kind);
      if (remote.isEmpty) return;
      final byId = <int, DivineName>{for (final n in local) n.id: n};
      for (final r in remote) {
        byId.putIfAbsent(r.id, () => r);
      }
      final merged = byId.values.toList(growable: false);
      await _writeLocal(merged);
      state = AsyncValue.data(merged);
    } on Object catch (e, st) {
      developer.log(
        'Name favorites remote merge failed',
        error: e,
        stackTrace: st,
      );
    }
  }

  /// Whether the name is already favorited.
  bool isFavorite(int id) {
    final list = state.valueOrNull ?? const <DivineName>[];
    return list.any((n) => n.id == id);
  }

  /// Toggle favorite state and play the appropriate haptic.
  Future<void> toggle(DivineName name) async {
    final current = state.valueOrNull ?? const <DivineName>[];
    final exists = current.any((n) => n.id == name.id);
    if (exists) {
      final next = current
          .where((n) => n.id != name.id)
          .toList(growable: false);
      state = AsyncValue.data(next);
      await _writeLocal(next);
      await HapticFeedback.lightImpact();
      await ref.read(namesRepositoryProvider).removeFavorite(kind, name.id);
      return;
    }
    final next = [name, ...current];
    state = AsyncValue.data(next);
    await _writeLocal(next);
    await HapticFeedback.mediumImpact();
    await ref.read(namesRepositoryProvider).addFavorite(kind, name.id);
  }
}
