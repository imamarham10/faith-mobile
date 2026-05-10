import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/dtos/hadith.dart';
import '../../data/hadiths_repository.dart';

part 'daily_hadith_controller.g.dart';

/// Hadith of the day — used by the Today screen card and the Hadiths home
/// hero. Cached server-side for 24h, so we keep it alive client-side too.
@Riverpod(keepAlive: true)
Future<Hadith?> dailyHadith(Ref ref) {
  final repo = ref.watch(hadithsRepositoryProvider);
  return repo.getDailyHadith();
}
