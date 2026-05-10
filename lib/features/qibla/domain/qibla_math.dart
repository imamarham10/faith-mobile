import 'dart:math' as math;

/// Pure great-circle helpers for Qibla direction.
///
/// All inputs are in degrees; outputs are degrees (bearing) or kilometres
/// (distance). Implementations are intentionally framework-free so they're
/// trivially testable.
class QiblaMath {
  const QiblaMath._();

  /// Coordinates of the Kaaba in Makkah (Masjid al-Haram).
  static const double kaabaLatitude = 21.4225;
  static const double kaabaLongitude = 39.8262;

  /// Earth's mean radius in kilometres — used for haversine distance.
  static const double _earthRadiusKm = 6371.0088;

  /// Initial great-circle bearing from `(lat1, lng1)` to `(lat2, lng2)`,
  /// expressed as degrees clockwise from true north (0..360).
  static double bearing({
    required double lat1,
    required double lng1,
    required double lat2,
    required double lng2,
  }) {
    final phi1 = _toRad(lat1);
    final phi2 = _toRad(lat2);
    final deltaLambda = _toRad(lng2 - lng1);

    final y = math.sin(deltaLambda) * math.cos(phi2);
    final x =
        math.cos(phi1) * math.sin(phi2) -
        math.sin(phi1) * math.cos(phi2) * math.cos(deltaLambda);

    final theta = math.atan2(y, x);
    return (_toDeg(theta) + 360) % 360;
  }

  /// Bearing from `(lat, lng)` to the Kaaba.
  static double bearingToKaaba({required double lat, required double lng}) =>
      bearing(lat1: lat, lng1: lng, lat2: kaabaLatitude, lng2: kaabaLongitude);

  /// Haversine distance between two points in kilometres.
  static double distanceKm({
    required double lat1,
    required double lng1,
    required double lat2,
    required double lng2,
  }) {
    final phi1 = _toRad(lat1);
    final phi2 = _toRad(lat2);
    final dPhi = _toRad(lat2 - lat1);
    final dLambda = _toRad(lng2 - lng1);

    final a =
        math.sin(dPhi / 2) * math.sin(dPhi / 2) +
        math.cos(phi1) *
            math.cos(phi2) *
            math.sin(dLambda / 2) *
            math.sin(dLambda / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return _earthRadiusKm * c;
  }

  /// Distance from `(lat, lng)` to the Kaaba in kilometres.
  static double distanceToKaabaKm({required double lat, required double lng}) =>
      distanceKm(
        lat1: lat,
        lng1: lng,
        lat2: kaabaLatitude,
        lng2: kaabaLongitude,
      );

  /// Smallest signed difference between two bearings, in (-180, 180].
  ///
  /// Useful for "are we within Nº of Qibla" checks without worrying about
  /// the 0/360 wraparound.
  static double bearingDelta(double a, double b) {
    var diff = (a - b) % 360;
    if (diff > 180) diff -= 360;
    if (diff < -180) diff += 360;
    return diff;
  }

  static double _toRad(double deg) => deg * math.pi / 180;
  static double _toDeg(double rad) => rad * 180 / math.pi;
}
