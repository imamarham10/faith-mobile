import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/dtos/dua.dart';
import '../../data/duas_repository.dart';

part 'duas_by_category_controller.g.dart';

/// All duas inside a specific category. Cached so back-nav is instant.
@Riverpod(keepAlive: true)
Future<List<Dua>> duasByCategory(Ref ref, String categoryId) {
  final repo = ref.watch(duasRepositoryProvider);
  return repo.getDuasByCategory(categoryId);
}

/// Server-side search across all duas. Used by the global search field on the
/// Duas home screen.
@riverpod
Future<List<Dua>> duasSearch(Ref ref, String query) async {
  final trimmed = query.trim();
  if (trimmed.length < 2) return const <Dua>[];
  final repo = ref.watch(duasRepositoryProvider);
  return repo.search(trimmed);
}
