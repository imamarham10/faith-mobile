import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/dtos/temple.dart';
import '../../data/hindu_temples_repository.dart';

part 'temples_browse_controller.g.dart';

/// The full unfiltered temple list. Used both as its own "browse all" view
/// and as the source for deriving distinct deity keys client-side — there's
/// no `/deities` endpoint the way `/states` exists.
@Riverpod(keepAlive: true)
Future<List<Temple>> allTemples(Ref ref) {
  final repo = ref.watch(hinduTemplesRepositoryProvider);
  return repo.getTemples();
}

/// Distinct deity keys observed across the loaded temple list, sorted.
/// Not exhaustive by design — the backend has no fixed deity taxonomy, so
/// "browse by deity" can only ever offer what's actually present in data.
@riverpod
List<String> templeDeityKeys(Ref ref) {
  final temples = ref.watch(allTemplesProvider).valueOrNull ?? const <Temple>[];
  final keys = temples
      .map((t) => t.deityKey)
      .whereType<String>()
      .toSet()
      .toList();
  keys.sort();
  return keys;
}

/// All states with at least one temple, alphabetized server-side.
@Riverpod(keepAlive: true)
Future<List<String>> templeStates(Ref ref) {
  final repo = ref.watch(hinduTemplesRepositoryProvider);
  return repo.getStates();
}

/// Temples in a specific state. Cached so back-nav is instant.
///
/// Named `stateName`, not `state` — the generated `Ref` for a family
/// provider already exposes a `state` getter (the provider's own
/// `AsyncValue`), so a parameter literally named `state` collides with it
/// and fails to compile.
@Riverpod(keepAlive: true)
Future<List<Temple>> templesByState(Ref ref, String stateName) {
  final repo = ref.watch(hinduTemplesRepositoryProvider);
  return repo.getTemples(state: stateName);
}

/// Temples matching a specific deity key. Cached so back-nav is instant.
@Riverpod(keepAlive: true)
Future<List<Temple>> templesByDeity(Ref ref, String deity) {
  final repo = ref.watch(hinduTemplesRepositoryProvider);
  return repo.getTemples(deity: deity);
}

/// Server-side name search. Not `keepAlive` — per-query results aren't
/// worth caching indefinitely.
@riverpod
Future<List<Temple>> templesSearch(Ref ref, String query) async {
  final trimmed = query.trim();
  if (trimmed.length < 2) return const <Temple>[];
  final repo = ref.watch(hinduTemplesRepositoryProvider);
  return repo.getTemples(q: trimmed);
}
