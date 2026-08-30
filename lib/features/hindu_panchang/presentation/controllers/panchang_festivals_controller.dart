import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/location/location_service.dart';
import '../../data/dtos/festival_occurrence.dart';
import '../../data/dtos/hindu_festival.dart';
import '../../data/hindu_panchang_repository.dart';

part 'panchang_festivals_controller.g.dart';

/// The full festival catalogue, cached for the session. Mirrors
/// `islamicEventsProvider`'s keepAlive rationale.
@Riverpod(keepAlive: true)
Future<List<HinduFestival>> hinduFestivals(Ref ref) {
  final repo = ref.watch(hinduPanchangRepositoryProvider);
  return repo.getFestivals();
}

/// A single festival by slug — a linear scan over the cached catalogue,
/// same pattern as calendar's `islamicEventById` (no extra network round
/// trip for a single-item lookup once the list is already cached).
@riverpod
Future<HinduFestival?> hinduFestivalBySlug(Ref ref, String slug) async {
  final list = await ref.watch(hinduFestivalsProvider.future);
  for (final f in list) {
    if (f.slug == slug) return f;
  }
  return null;
}

/// Festivals resolved to actual upcoming dates — the panchang screen's
/// equivalent of calendar's "Events this month" section, except already
/// resolved server-side (no client-side rule matching needed). Location
/// gated, null-on-unavailable like the other panchang controllers.
@Riverpod(keepAlive: false)
class UpcomingFestivalsController extends _$UpcomingFestivalsController {
  @override
  Future<List<FestivalOccurrence>?> build() async {
    final loc = await ref.watch(locationServiceProvider).currentPosition();
    if (loc == null) return null;

    final repo = ref.watch(hinduPanchangRepositoryProvider);
    return repo.getUpcomingFestivals(lat: loc.latitude, lng: loc.longitude);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(build);
  }
}
