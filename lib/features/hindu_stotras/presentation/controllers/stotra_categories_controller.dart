import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/dtos/stotra_category.dart';
import '../../data/hindu_stotras_repository.dart';

part 'stotra_categories_controller.g.dart';

/// All stotra categories, alphabetized server-side.
@Riverpod(keepAlive: true)
Future<List<StotraCategory>> stotraCategories(Ref ref) {
  final repo = ref.watch(hinduStotrasRepositoryProvider);
  return repo.getCategories();
}
