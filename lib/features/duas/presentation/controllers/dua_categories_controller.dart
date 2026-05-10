import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/dtos/dua_category.dart';
import '../../data/duas_repository.dart';

part 'dua_categories_controller.g.dart';

/// All dua categories, alphabetized server-side.
@Riverpod(keepAlive: true)
Future<List<DuaCategory>> duaCategories(Ref ref) {
  final repo = ref.watch(duasRepositoryProvider);
  return repo.getCategories();
}
