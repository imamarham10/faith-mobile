import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/dtos/hadith_book.dart';
import '../../data/hadiths_repository.dart';

part 'hadiths_home_controller.g.dart';

/// All hadith collections. Cached for the session — books are static data.
@Riverpod(keepAlive: true)
Future<List<HadithBook>> hadithBooks(Ref ref) {
  final repo = ref.watch(hadithsRepositoryProvider);
  return repo.getBooks();
}
