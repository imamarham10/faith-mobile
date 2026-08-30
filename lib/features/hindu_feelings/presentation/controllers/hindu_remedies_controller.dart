import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/dtos/hindu_emotion.dart';
import '../../data/hindu_feelings_repository.dart';

part 'hindu_remedies_controller.g.dart';

/// Loads the emotion detail (with remedies) for a given mood slug. Cached
/// for the session, mirroring `emotionDetailProvider`.
@Riverpod(keepAlive: true)
Future<HinduEmotionDetail> hinduEmotionDetail(Ref ref, String slug) {
  final repo = ref.watch(hinduFeelingsRepositoryProvider);
  return repo.getEmotion(slug);
}
