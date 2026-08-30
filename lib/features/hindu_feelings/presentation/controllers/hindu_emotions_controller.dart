import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/dtos/hindu_emotion.dart';
import '../../data/hindu_feelings_repository.dart';

part 'hindu_emotions_controller.g.dart';

/// All available Hindu emotions. Unlike Islam's `emotionsProvider`, no
/// client-side fallback list — the backend is fully seeded (10 emotions).
@Riverpod(keepAlive: true)
Future<List<HinduEmotion>> hinduEmotions(Ref ref) {
  final repo = ref.watch(hinduFeelingsRepositoryProvider);
  return repo.getEmotions();
}
