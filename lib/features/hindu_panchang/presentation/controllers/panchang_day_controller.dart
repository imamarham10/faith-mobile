import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/location/location_service.dart';
import '../../data/dtos/panchang_day.dart';
import '../../data/hindu_panchang_repository.dart';

part 'panchang_day_controller.g.dart';

/// Fetches a specific date's panchang (`yyyy-MM-dd`), for the day-detail
/// screen reached by tapping a grid cell. Same location-gated,
/// null-on-unavailable pattern as [PanchangTodayController]. Not
/// `keepAlive` — an autodispose family per date is fine, since a user opens
/// a handful of day-detail screens per session at most.
@riverpod
Future<PanchangDay?> panchangByDate(Ref ref, String date) async {
  final loc = await ref.watch(locationServiceProvider).currentPosition();
  if (loc == null) return null;

  final repo = ref.watch(hinduPanchangRepositoryProvider);
  return repo.getByDate(date, lat: loc.latitude, lng: loc.longitude);
}
