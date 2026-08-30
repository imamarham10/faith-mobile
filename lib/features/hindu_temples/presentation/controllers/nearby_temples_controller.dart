import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/location/location_service.dart';
import '../../data/dtos/temple.dart';
import '../../data/hindu_temples_repository.dart';

part 'nearby_temples_controller.g.dart';

/// Fetches temples near the device's current location. Mirrors
/// `PanchangTodayController`'s pattern exactly: returns `null` if location
/// is unavailable so the UI can render a permission-CTA fallback, rather
/// than throwing — like prayer times/panchang, "temples near me" is
/// fundamentally location-gated, not location-optional.
@Riverpod(keepAlive: false)
class NearbyTemplesController extends _$NearbyTemplesController {
  @override
  Future<List<Temple>?> build() async {
    final loc = await ref.watch(locationServiceProvider).currentPosition();
    if (loc == null) return null;

    final repo = ref.watch(hinduTemplesRepositoryProvider);
    return repo.getNearby(lat: loc.latitude, lng: loc.longitude);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(build);
  }
}
