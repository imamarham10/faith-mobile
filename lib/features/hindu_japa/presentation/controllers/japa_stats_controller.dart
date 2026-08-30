import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/dtos/japa_stats.dart';
import '../../data/hindu_japa_repository.dart';

part 'japa_stats_controller.g.dart';

/// Streaks and averages — no Dhikr equivalent, additive parity with what
/// the backend offers for japa.
@Riverpod(keepAlive: true)
Future<JapaStats> japaStats(Ref ref) async {
  final repo = ref.watch(hinduJapaRepositoryProvider);
  return repo.getStats();
}
