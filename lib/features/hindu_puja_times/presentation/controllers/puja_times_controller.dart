import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../../core/location/location_service.dart';
import '../../data/dtos/puja_times.dart';
import '../../data/hindu_puja_times_repository.dart';
import '../../domain/next_puja.dart';

part 'puja_times_controller.g.dart';

/// Composite state shipped to the UI — mirrors `PrayerTimesData`.
class PujaTimesData {
  const PujaTimesData({required this.times, required this.next});

  final PujaTimes times;
  final NextPuja? next;
}

/// Fetches today's puja times for the device's current location and real
/// IANA timezone. Mirrors `PrayerTimesController`'s null-on-location-denied
/// pattern exactly. `tz.local.name` is safe to read here without any extra
/// initialization — `NotificationService.init()` already calls
/// `tz.setLocalLocation(...)` once at app start (falling back to UTC if the
/// device's zone abbreviation isn't recognized).
@Riverpod(keepAlive: false)
class PujaTimesController extends _$PujaTimesController {
  @override
  Future<PujaTimesData?> build() async {
    final loc = await ref.watch(locationServiceProvider).currentPosition();
    if (loc == null) return null;

    final repo = ref.watch(hinduPujaTimesRepositoryProvider);
    final times = await repo.getToday(
      lat: loc.latitude,
      lng: loc.longitude,
      timezone: tz.local.name,
    );

    return PujaTimesData(times: times, next: NextPuja.from(times));
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(build);
  }
}
