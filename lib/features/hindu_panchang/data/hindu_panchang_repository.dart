import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/providers.dart';
import 'dtos/festival_occurrence.dart';
import 'dtos/hindu_festival.dart';
import 'dtos/panchang_day.dart';
import 'dtos/panchang_month.dart';

part 'hindu_panchang_repository.g.dart';

/// HTTP boundary for `/api/v1/hindu/panchang/*`.
///
/// Unlike Islamic calendar (a single `calendarAdjust` correction constant
/// sent on every call), there's no client-side correction knob here — every
/// value is computed live server-side from `lat`/`lng`. The `timezone` param
/// is accepted but, per live verification, only echoed back in the
/// response — it does not shift the returned timestamps, which are always
/// UTC ISO strings. Callers convert with `.toLocal()` at render time
/// instead of relying on this param.
class HinduPanchangRepository {
  HinduPanchangRepository(this._dio);

  static const String _base = '/api/v1/hindu/panchang';

  final Dio _dio;

  /// `GET /today?lat&lng` — today's panchang for a location.
  Future<PanchangDay> getToday({
    required double lat,
    required double lng,
  }) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '$_base/today',
        queryParameters: {'lat': lat, 'lng': lng},
      );
      final data = res.data;
      if (data == null) {
        throw const ApiException(message: 'Empty panchang response.');
      }
      return PanchangDay.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `GET /date/:date?lat&lng` — panchang for a specific date (`yyyy-MM-dd`).
  Future<PanchangDay> getByDate(
    String date, {
    required double lat,
    required double lng,
  }) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '$_base/date/$date',
        queryParameters: {'lat': lat, 'lng': lng},
      );
      final data = res.data;
      if (data == null) {
        throw const ApiException(message: 'Empty panchang response.');
      }
      return PanchangDay.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `GET /month?year&month&lat&lng` — every day of the month.
  Future<PanchangMonth> getMonth(
    int year,
    int month, {
    required double lat,
    required double lng,
  }) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '$_base/month',
        queryParameters: {'year': year, 'month': month, 'lat': lat, 'lng': lng},
      );
      final data = res.data;
      if (data == null) {
        throw const ApiException(message: 'Empty panchang month response.');
      }
      return PanchangMonth.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `GET /festivals` — the full festival catalogue (static metadata, not
  /// year-resolved).
  Future<List<HinduFestival>> getFestivals() async {
    try {
      final res = await _dio.get<dynamic>('$_base/festivals');
      final data = res.data;
      if (data is! List) return const <HinduFestival>[];
      return data
          .whereType<Map<String, dynamic>>()
          .map(HinduFestival.fromJson)
          .toList(growable: false);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `GET /festivals/upcoming?lat&lng&days` — festivals resolved to actual
  /// dates within the next [days] days (backend default/clamp: 1–365).
  Future<List<FestivalOccurrence>> getUpcomingFestivals({
    required double lat,
    required double lng,
    int days = 90,
  }) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '$_base/festivals/upcoming',
        queryParameters: {'lat': lat, 'lng': lng, 'days': days},
      );
      final data = res.data;
      final occurrences = data?['occurrences'];
      if (occurrences is! List) return const <FestivalOccurrence>[];
      return occurrences
          .whereType<Map<String, dynamic>>()
          .map(FestivalOccurrence.fromJson)
          .toList(growable: false);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

@Riverpod(keepAlive: true)
HinduPanchangRepository hinduPanchangRepository(Ref ref) =>
    HinduPanchangRepository(ref.watch(dioProvider));
