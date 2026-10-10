import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/dtos/emotion.dart';
import '../../data/feelings_repository.dart';

part 'emotions_controller.g.dart';

/// Every mood the Islam vertical can actually answer, straight from
/// `GET /api/v1/islam/feelings`.
///
/// There is no client-side fallback list on purpose. A hardcoded slug cannot
/// be known to exist server-side, so a fallback can only ever offer options
/// the detail endpoint will reject — which is precisely how this feature
/// broke: a nine-mood const shipped in the binary overlapped the seeded data
/// in three slugs, and the other six 404'd on tap. An empty chooser with a
/// retry is a better failure than a chooser full of dead ends.
@Riverpod(keepAlive: true)
Future<List<Emotion>> emotions(Ref ref) {
  final repo = ref.watch(feelingsRepositoryProvider);
  return repo.getEmotions();
}
