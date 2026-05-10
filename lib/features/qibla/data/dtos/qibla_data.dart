import 'package:freezed_annotation/freezed_annotation.dart';

part 'qibla_data.freezed.dart';
part 'qibla_data.g.dart';

/// Qibla direction + distance from a given location.
///
/// We compute this client-side via [QiblaMath] by default — no roundtrip,
/// no auth required. The same shape is used if the backend
/// (`GET /api/v1/islam/qibla?lat=&lng=`) is ever consulted as a sanity
/// check or fallback.
@freezed
abstract class QiblaData with _$QiblaData {
  const factory QiblaData({
    required double latitude,
    required double longitude,

    /// Initial bearing in degrees (0..360) clockwise from true north.
    required double bearingDegrees,

    /// Great-circle distance to Makkah, in kilometres.
    required double distanceKm,
  }) = _QiblaData;

  factory QiblaData.fromJson(Map<String, dynamic> json) =>
      _$QiblaDataFromJson(json);
}
