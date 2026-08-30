import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/providers.dart';
import 'dtos/puja_log.dart';
import 'dtos/puja_stats.dart';
import 'dtos/puja_times.dart';

part 'hindu_puja_times_repository.g.dart';

/// HTTP boundary for `/api/v1/hindu/puja-times/*`.
///
/// Unlike prayer times (never sends a timezone param), every read here
/// requires the caller's real IANA timezone name — the backend's
/// `isCurrent`/`next` computation is timezone-sensitive (see `PujaTimes`'s
/// doc comment). Callers get this from `tz.local.name` (the `timezone`
/// package, already initialized app-wide by `NotificationService.init()`),
/// not from this repository.
class HinduPujaTimesRepository {
  HinduPujaTimesRepository(this._dio);

  static const String _base = '/api/v1/hindu/puja-times';

  final Dio _dio;

  /// `GET /today?lat&lng&timezone` — today's sandhya windows.
  Future<PujaTimes> getToday({
    required double lat,
    required double lng,
    required String timezone,
  }) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '$_base/today',
        queryParameters: {'lat': lat, 'lng': lng, 'timezone': timezone},
      );
      final data = res.data;
      if (data == null) {
        throw const ApiException(message: 'Empty puja-times response.');
      }
      return PujaTimes.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `GET /date/:date?lat&lng&timezone` — a specific date's windows.
  Future<PujaTimes> getByDate(
    String date, {
    required double lat,
    required double lng,
    required String timezone,
  }) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '$_base/date/$date',
        queryParameters: {'lat': lat, 'lng': lng, 'timezone': timezone},
      );
      final data = res.data;
      if (data == null) {
        throw const ApiException(message: 'Empty puja-times response.');
      }
      return PujaTimes.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `GET /logs?fromDate=&toDate=` — logs within a date range. Passing the
  /// same date for both narrows to a single day.
  Future<List<PujaLog>> getLogs({DateTime? fromDate, DateTime? toDate}) async {
    try {
      final fmt = DateFormat('yyyy-MM-dd');
      final res = await _dio.get<dynamic>(
        '$_base/logs',
        queryParameters: {
          if (fromDate != null) 'fromDate': fmt.format(fromDate),
          if (toDate != null) 'toDate': fmt.format(toDate),
        },
      );
      final data = res.data;
      if (data is! List) return const <PujaLog>[];
      return data
          .whereType<Map<String, dynamic>>()
          .map(PujaLog.fromJson)
          .toList(growable: false);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return const <PujaLog>[];
      throw ApiException.fromDio(e);
    }
  }

  /// `POST /log` — log a sandhya.
  Future<PujaLog> logPuja({
    required String sandhya,
    required PujaStatus status,
    DateTime? date,
  }) async {
    try {
      final dateStr = DateFormat('yyyy-MM-dd').format(date ?? DateTime.now());
      final res = await _dio.post<Map<String, dynamic>>(
        '$_base/log',
        data: {'sandhya': sandhya, 'date': dateStr, 'status': status.apiValue},
      );
      final data = res.data;
      if (data == null) {
        throw const ApiException(message: 'Empty puja-log response.');
      }
      return PujaLog.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `DELETE /log/:id` — remove a log entry.
  Future<void> deleteLog(String id) async {
    try {
      await _dio.delete<dynamic>('$_base/log/$id');
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `GET /stats` — totals, streaks, and completion rate.
  Future<PujaStats> getStats() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('$_base/stats');
      final data = res.data;
      if (data == null) return PujaStats.empty;
      return PujaStats.fromJson(data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return PujaStats.empty;
      throw ApiException.fromDio(e);
    }
  }
}

@Riverpod(keepAlive: true)
HinduPujaTimesRepository hinduPujaTimesRepository(Ref ref) =>
    HinduPujaTimesRepository(ref.watch(dioProvider));
