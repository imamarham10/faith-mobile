import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/dtos/hadith.dart';
import '../../data/hadiths_repository.dart';

part 'hadith_search_controller.g.dart';

/// Server-side search across the free-tier hadith corpus.
///
/// The backend ignores queries shorter than 3 chars (returns `[]`); we mirror
/// that here so we don't fire a request per keystroke during typing.
@riverpod
Future<List<Hadith>> hadithSearch(Ref ref, String query) async {
  final trimmed = query.trim();
  if (trimmed.length < 3) return const <Hadith>[];
  final repo = ref.watch(hadithsRepositoryProvider);
  return repo.search(trimmed);
}
