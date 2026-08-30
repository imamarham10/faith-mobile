import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/dtos/scripture_verse.dart';
import '../../data/hindu_scriptures_repository.dart';

part 'daily_shloka_controller.g.dart';

/// "Shloka for today" — used by the Hindu Today screen card, mirroring
/// `dailyHadithProvider`'s role for Islam.
///
/// Unlike hadiths, the backend has no `/scriptures/daily` endpoint — only
/// `/scriptures/featured`, a curated pool for exactly this kind of surface
/// (each entry is hand-marked `isFeatured` server-side). So the "for today"
/// rotation happens client-side: a stable pick keyed by day-of-year, which
/// changes once a day and is identical for every user on the same day
/// without needing per-user or per-request randomness.
@Riverpod(keepAlive: true)
Future<ScriptureVerse?> dailyShloka(Ref ref) async {
  final repo = ref.watch(hinduScripturesRepositoryProvider);
  final featured = await repo.getFeatured();
  if (featured.isEmpty) return null;
  final now = DateTime.now();
  final dayOfYear = now.difference(DateTime(now.year)).inDays;
  return featured[dayOfYear % featured.length];
}
