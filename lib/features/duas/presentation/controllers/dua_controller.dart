import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/dtos/dua.dart';
import '../../data/duas_repository.dart';

part 'dua_controller.g.dart';

/// A single dua, by id. `keepAlive` so opening the same dua twice in a session
/// is instant.
@Riverpod(keepAlive: true)
Future<Dua> duaById(Ref ref, String id) {
  final repo = ref.watch(duasRepositoryProvider);
  return repo.getDua(id);
}
