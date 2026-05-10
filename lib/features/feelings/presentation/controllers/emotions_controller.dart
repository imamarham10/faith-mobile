import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/dtos/emotion.dart';
import '../../data/feelings_repository.dart';

part 'emotions_controller.g.dart';

/// The 9 default moods we always offer in the chooser sheet.
///
/// Used as a fallback when the API list is empty/unavailable, and as the
/// canonical ordering for the home tab.
const List<({String slug, String name})> kDefaultMoods = [
  (slug: 'anxious', name: 'Anxious'),
  (slug: 'grateful', name: 'Grateful'),
  (slug: 'lonely', name: 'Lonely'),
  (slug: 'hopeful', name: 'Hopeful'),
  (slug: 'lost', name: 'Lost'),
  (slug: 'tested', name: 'Tested'),
  (slug: 'joyful', name: 'Joyful'),
  (slug: 'heavy', name: 'Heavy'),
  (slug: 'searching', name: 'Searching'),
];

/// All available emotions. Falls back to [kDefaultMoods] when the server
/// hasn't seeded the full set.
@Riverpod(keepAlive: true)
Future<List<Emotion>> emotions(Ref ref) async {
  final repo = ref.watch(feelingsRepositoryProvider);
  final list = await repo.getEmotions();
  if (list.isNotEmpty) return list;
  return kDefaultMoods
      .map((m) => Emotion(id: m.slug, name: m.name, slug: m.slug))
      .toList(growable: false);
}
