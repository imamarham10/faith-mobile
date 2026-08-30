import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/dtos/stotra.dart';
import '../../data/hindu_stotras_repository.dart';

part 'stotras_by_category_controller.g.dart';

/// All stotras inside a specific category (by slug). Cached so back-nav is
/// instant.
@Riverpod(keepAlive: true)
Future<List<Stotra>> stotrasByCategory(Ref ref, String categorySlug) {
  final repo = ref.watch(hinduStotrasRepositoryProvider);
  return repo.getStotras(category: categorySlug);
}

/// Server-side search across all stotras. Used by the global search field
/// on the Stotras home screen. Not `keepAlive` — per-query results aren't
/// worth caching indefinitely.
@riverpod
Future<List<Stotra>> stotrasSearch(Ref ref, String query) async {
  final trimmed = query.trim();
  if (trimmed.length < 2) return const <Stotra>[];
  final repo = ref.watch(hinduStotrasRepositoryProvider);
  return repo.search(trimmed);
}
