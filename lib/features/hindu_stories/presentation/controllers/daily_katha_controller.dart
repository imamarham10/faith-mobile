import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/dtos/hindu_story.dart';
import '../../data/hindu_stories_repository.dart';

part 'daily_katha_controller.g.dart';

/// "Katha for today" — used by the Hindu Today screen card, mirroring
/// `dailyHadithProvider`'s role for Islam.
///
/// The backend has no `/stories/daily` or `/stories/featured` endpoint and
/// no curated flag on the story DTO (unlike scripture verses' `isFeatured`),
/// so this picks a stable day-of-year index into the full, unfiltered
/// story list — small enough (order of tens) to fetch whole. Same rotation
/// rule as `dailyShlokaProvider`: identical for every user on a given day.
@Riverpod(keepAlive: true)
Future<HinduStory?> dailyKatha(Ref ref) async {
  final repo = ref.watch(hinduStoriesRepositoryProvider);
  final stories = await repo.getStories();
  if (stories.isEmpty) return null;
  final now = DateTime.now();
  final dayOfYear = now.difference(DateTime(now.year)).inDays;
  return stories[dayOfYear % stories.length];
}
