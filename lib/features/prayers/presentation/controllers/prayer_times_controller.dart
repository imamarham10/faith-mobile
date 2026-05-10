import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/location/location_service.dart';
import '../../data/dtos/prayer_times.dart';
import '../../data/prayers_repository.dart';
import '../../domain/next_prayer.dart';

part 'prayer_times_controller.g.dart';

/// Display label + API code for a prayer-times calculation method.
class CalcMethod {
  const CalcMethod({required this.code, required this.label});

  final String code;
  final String label;

  static const List<CalcMethod> all = [
    CalcMethod(code: 'MWL', label: 'Muslim World League'),
    CalcMethod(code: 'ISNA', label: 'ISNA (North America)'),
    CalcMethod(code: 'EGYPTIAN', label: 'Egyptian General Authority'),
    CalcMethod(code: 'MAKKAH', label: 'Umm al-Qura (Makkah)'),
    CalcMethod(code: 'KARACHI', label: 'University of Karachi'),
    CalcMethod(code: 'KUWAIT', label: 'Kuwait'),
    CalcMethod(code: 'QATAR', label: 'Qatar'),
    CalcMethod(code: 'SINGAPORE', label: 'Singapore'),
  ];

  static const String fallbackCode = 'MWL';

  static CalcMethod byCode(String code) =>
      all.firstWhere((m) => m.code == code, orElse: () => all.first);
}

const String _kPrefKey = 'prayer_calc_method';

/// Persisted calculation-method code (defaults to MWL on first run).
@Riverpod(keepAlive: true)
class CalcMethodPref extends _$CalcMethodPref {
  @override
  Future<String> build() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kPrefKey) ?? CalcMethod.fallbackCode;
  }

  Future<void> set(String code) async {
    state = AsyncValue.data(code);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kPrefKey, code);
    ref.invalidate(prayerTimesControllerProvider);
  }
}

/// Composite state shipped to the UI.
class PrayerTimesData {
  const PrayerTimesData({
    required this.times,
    required this.next,
    required this.locationAvailable,
  });

  final PrayerTimes times;
  final NextPrayer next;
  final bool locationAvailable;
}

/// Fetches today's prayer times for the device's current location and the
/// user's saved calculation method, then derives [NextPrayer] from them.
///
/// Returns `null` for [PrayerTimesData] if location is unavailable so the UI
/// can render a permission-CTA fallback. Repository errors propagate as
/// [AsyncError].
@Riverpod(keepAlive: false)
class PrayerTimesController extends _$PrayerTimesController {
  @override
  Future<PrayerTimesData?> build() async {
    final loc = await ref.watch(locationServiceProvider).currentPosition();
    if (loc == null) return null;

    final code = await ref.watch(calcMethodPrefProvider.future);
    final repo = ref.watch(prayersRepositoryProvider);
    final times = await repo.getTimes(
      latitude: loc.latitude,
      longitude: loc.longitude,
      method: code,
    );

    return PrayerTimesData(
      times: times,
      next: NextPrayer.from(times),
      locationAvailable: true,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(build);
  }
}
