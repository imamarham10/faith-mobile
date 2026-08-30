import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/location/location_service.dart';
import '../../data/dtos/panchang_day.dart';
import '../../data/hindu_panchang_repository.dart';

part 'panchang_today_controller.g.dart';

/// Fetches today's panchang for the device's current location. Mirrors
/// `PrayerTimesController`'s pattern exactly: returns `null` if location is
/// unavailable so the UI can render a permission-CTA fallback, rather than
/// throwing (unlike Qibla's sentinel-exception pattern) — panchang, like
/// prayer times, is fundamentally location-gated rather than
/// location-optional.
@Riverpod(keepAlive: false)
class PanchangTodayController extends _$PanchangTodayController {
  @override
  Future<PanchangDay?> build() async {
    final loc = await ref.watch(locationServiceProvider).currentPosition();
    if (loc == null) return null;

    final repo = ref.watch(hinduPanchangRepositoryProvider);
    return repo.getToday(lat: loc.latitude, lng: loc.longitude);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(build);
  }
}
