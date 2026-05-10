import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/dtos/hadith.dart';
import '../../data/hadiths_repository.dart';

part 'hadith_detail_controller.g.dart';

/// A single hadith by id. `keepAlive` so back-and-forth navigation is instant.
@Riverpod(keepAlive: true)
Future<Hadith> hadithDetail(Ref ref, String id) {
  final repo = ref.watch(hadithsRepositoryProvider);
  return repo.getHadith(id);
}
