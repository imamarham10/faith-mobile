import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/dtos/temple.dart';
import '../../data/hindu_temples_repository.dart';

part 'temple_controller.g.dart';

/// A single temple, by id. `keepAlive` so opening the same temple twice in
/// a session is instant.
@Riverpod(keepAlive: true)
Future<Temple> templeById(Ref ref, String id) {
  final repo = ref.watch(hinduTemplesRepositoryProvider);
  return repo.getTemple(id);
}
