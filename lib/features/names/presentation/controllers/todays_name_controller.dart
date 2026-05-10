import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/dtos/divine_name.dart';
import '../../data/names_repository.dart';
import '../../domain/names_kind.dart';

part 'todays_name_controller.g.dart';

/// "Name of the day" for the given [kind] — rotates server-side daily.
@Riverpod(keepAlive: true)
Future<DivineName> todaysName(Ref ref, NamesKind kind) {
  final repo = ref.watch(namesRepositoryProvider);
  return repo.getDaily(kind);
}
