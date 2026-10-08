import 'package:adhan/adhan.dart';

/// One day of computed prayer times. Mirrors the server's shape closely
/// enough that the notification scheduler does not care which produced it.
class LocalPrayerDay {
  const LocalPrayerDay({
    required this.date,
    required this.fajr,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  final DateTime date;
  final DateTime fajr, dhuhr, asr, maghrib, isha;

  Map<String, DateTime> get byKey => {
    'fajr': fajr,
    'dhuhr': dhuhr,
    'asr': asr,
    'maghrib': maghrib,
    'isha': isha,
  };
}

/// On-device prayer-time computation.
///
/// The app otherwise reads prayer times from the API, and for display that is
/// correct — the server owns calculation-method semantics. But *notification
/// scheduling* must survive with no network: a reminder that fails to schedule
/// because the user was offline at the wrong moment is indistinguishable from
/// a reminder that does not exist. So the scheduler computes its own window
/// and accepts a possible sub-minute divergence from the server.
class LocalPrayerTimes {
  const LocalPrayerTimes._();

  static List<LocalPrayerDay> forRange({
    required double latitude,
    required double longitude,
    required DateTime from,
    required int days,
    required String method,
    required String madhab,
  }) {
    final coords = Coordinates(latitude, longitude);
    final params = _paramsFor(method)..madhab = _madhabFor(madhab);

    return List.generate(days, (i) {
      // Day-overflow in the constructor rather than `add(Duration(days: i))`:
      // adding a fixed 24h across a DST boundary lands on 23:00 or 01:00 of a
      // neighbouring day, which would shift the whole day's window.
      final day = DateTime(from.year, from.month, from.day + i);
      final t = PrayerTimes(coords, DateComponents.from(day), params);
      return LocalPrayerDay(
        date: day,
        fajr: t.fajr,
        dhuhr: t.dhuhr,
        asr: t.asr,
        maghrib: t.maghrib,
        isha: t.isha,
      );
    }, growable: false);
  }

  /// Maps the app's API calculation-method codes (the `CalcMethod.all` list
  /// the prayer-times controller persists) onto adhan's methods. Unknown codes
  /// fall back to Muslim World League, matching the app's own default.
  static CalculationParameters _paramsFor(String method) =>
      switch (method.toLowerCase()) {
        'isna' => CalculationMethod.north_america.getParameters(),
        'egypt' || 'egyptian' => CalculationMethod.egyptian.getParameters(),
        'makkah' => CalculationMethod.umm_al_qura.getParameters(),
        'karachi' => CalculationMethod.karachi.getParameters(),
        'kuwait' => CalculationMethod.kuwait.getParameters(),
        'qatar' => CalculationMethod.qatar.getParameters(),
        'singapore' => CalculationMethod.singapore.getParameters(),
        _ => CalculationMethod.muslim_world_league.getParameters(),
      };

  static Madhab _madhabFor(String madhab) =>
      madhab.toLowerCase() == 'hanafi' ? Madhab.hanafi : Madhab.shafi;
}
