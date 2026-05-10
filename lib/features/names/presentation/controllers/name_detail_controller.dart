import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/dtos/divine_name.dart';
import '../../data/names_repository.dart';
import '../../domain/names_kind.dart';

part 'name_detail_controller.g.dart';

/// One name's full detail. Family parameter is `(kind, id)` so Allah and
/// Muhammad detail caches don't collide.
@Riverpod(keepAlive: true)
Future<DivineName> nameDetail(
  Ref ref, {
  required NamesKind kind,
  required int id,
}) {
  final repo = ref.watch(namesRepositoryProvider);
  return repo.getById(kind, id);
}
