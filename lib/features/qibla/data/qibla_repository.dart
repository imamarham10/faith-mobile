import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/providers.dart';
import '../domain/qibla_math.dart';
import 'dtos/qibla_data.dart';

part 'qibla_repository.g.dart';

/// Boundary for Qibla calculation.
///
/// Qibla is fundamentally a math problem — the default path computes
/// everything client-side via [QiblaMath]. The remote `GET /api/v1/islam/qibla`
/// is exposed as an optional fallback (e.g. for cross-checking) but the UI
/// never blocks on it.
class QiblaRepository {
  QiblaRepository(this._dio);

  static const String _path = '/api/v1/islam/qibla';

  final Dio _dio;

  /// Computes Qibla bearing + distance entirely on-device.
  ///
  /// Pure: no network, no permissions. Caller is responsible for sourcing
  /// `(lat, lng)` from the shared `LocationService`.
  QiblaData computeLocally({required double lat, required double lng}) {
    final bearing = QiblaMath.bearingToKaaba(lat: lat, lng: lng);
    final distance = QiblaMath.distanceToKaabaKm(lat: lat, lng: lng);
    return QiblaData(
      latitude: lat,
      longitude: lng,
      bearingDegrees: bearing,
      distanceKm: distance,
    );
  }

  /// Optional: fetch direction from the backend.
  ///
  /// Maps the legacy response shape (`direction`, `distance`) to [QiblaData].
  Future<QiblaData> fetchRemote({
    required double lat,
    required double lng,
  }) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        _path,
        queryParameters: {'lat': lat, 'lng': lng},
      );
      final data = res.data;
      if (data == null) {
        throw const ApiException(message: 'Empty Qibla response.');
      }
      return QiblaData(
        latitude: ((data['latitude']) as num?)?.toDouble() ?? lat,
        longitude: ((data['longitude']) as num?)?.toDouble() ?? lng,
        bearingDegrees: ((data['direction']) as num?)?.toDouble() ?? 0,
        distanceKm: ((data['distance']) as num?)?.toDouble() ?? 0,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

@Riverpod(keepAlive: true)
QiblaRepository qiblaRepository(Ref ref) =>
    QiblaRepository(ref.watch(dioProvider));
