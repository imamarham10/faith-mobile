import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/dtos/divine_name.dart';
import '../../data/names_repository.dart';
import '../../domain/names_kind.dart';

part 'muhammad_names_controller.g.dart';

/// All 99 Names of Muhammad ﷺ.
@Riverpod(keepAlive: true)
Future<List<DivineName>> muhammadNames(Ref ref) {
  final repo = ref.watch(namesRepositoryProvider);
  return repo.getAll(NamesKind.muhammad);
}
