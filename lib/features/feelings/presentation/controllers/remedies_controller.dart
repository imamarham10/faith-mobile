import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/dtos/remedy.dart';
import '../../data/feelings_repository.dart';

part 'remedies_controller.g.dart';

/// Loads the emotion detail (with remedies) for a given mood slug.
///
/// Cached for the session so re-entering a mood from the journal is instant.
@Riverpod(keepAlive: true)
Future<EmotionDetail> emotionDetail(Ref ref, String slug) async {
  final repo = ref.watch(feelingsRepositoryProvider);
  return repo.getEmotion(slug);
}
