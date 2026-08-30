import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/dtos/stotra.dart';
import '../../data/hindu_stotras_repository.dart';

part 'stotra_controller.g.dart';

/// A single stotra, by slug. `keepAlive` so opening the same stotra twice
/// in a session is instant.
@Riverpod(keepAlive: true)
Future<StotraDetail> stotraBySlug(Ref ref, String slug) {
  final repo = ref.watch(hinduStotrasRepositoryProvider);
  return repo.getStotraBySlug(slug);
}
