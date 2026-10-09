import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/providers.dart';
import 'dtos/prayer_log.dart';
import 'dtos/prayer_stats.dart';
import 'dtos/prayer_times.dart';

part 'prayers_repository.g.dart';

/// HTTP boundary for prayer endpoints under `/api/v1/islam/prayers/*`.
class PrayersRepository {
  PrayersRepository(this._dio);

  static const String _base = '/api/v1/islam/prayers';

  /// The server's own `take` on log reads. Mirrored here so callers can
  /// recognise a truncated page without guessing.
  static const int serverLogRowCap = 100;

  final Dio _dio;

  /// `GET /times?lat=&lng=&date=&method=` — today's schedule for a location.
  ///
  /// [method] follows the calculation method codes accepted by the backend
  /// (e.g. MWL, ISNA, EGYPTIAN, MAKKAH, KARACHI, KUWAIT, QATAR, SINGAPORE).
  Future<PrayerTimes> getTimes({
    required double latitude,
    required double longitude,
    DateTime? date,
    String? method,
  }) async {
    try {
      final dateStr = DateFormat('yyyy-MM-dd').format(date ?? DateTime.now());
      final res = await _dio.get<Map<String, dynamic>>(
        '$_base/times',
        queryParameters: {
          'lat': latitude,
          'lng': longitude,
          'date': dateStr,
          if (method != null && method.isNotEmpty) 'method': method,
        },
      );
      final data = res.data;
      if (data == null) {
        throw const ApiException(message: 'Empty prayer-times response.');
      }
      return PrayerTimes.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `GET /log?date=` — list logs for a given date (defaults to today).
  Future<List<PrayerLog>> getLogsForDate({DateTime? date}) async {
    try {
      final dateStr = DateFormat('yyyy-MM-dd').format(date ?? DateTime.now());
      final res = await _dio.get<dynamic>(
        '$_base/log',
        queryParameters: {'date': dateStr},
      );
      final data = res.data;
      if (data is! List) return const <PrayerLog>[];
      return data
          .whereType<Map<String, dynamic>>()
          .map(PrayerLog.fromJson)
          .toList(growable: false);
    } on DioException catch (e) {
      // 404 / not-yet-implemented is non-fatal — return empty.
      if (e.response?.statusCode == 404) return const <PrayerLog>[];
      throw ApiException.fromDio(e);
    }
  }

  /// `GET /log?fromDate=&toDate=` — every log in a date range, newest
  /// first.
  ///
  /// The server caps this at 100 rows ([serverLogRowCap], `take: 100` in
  /// `prayers.service.ts`) ordered by date descending, so a long window
  /// returns the most recent days and silently drops the oldest. Callers
  /// deriving a streak must treat a full page as "history may go back
  /// further than this" rather than as the end of the run.
  Future<List<PrayerLog>> getLogsForRange({
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    try {
      final fmt = DateFormat('yyyy-MM-dd');
      final res = await _dio.get<dynamic>(
        '$_base/log',
        queryParameters: {
          'fromDate': fmt.format(fromDate),
          'toDate': fmt.format(toDate),
        },
      );
      final data = res.data;
      if (data is! List) return const <PrayerLog>[];
      return data
          .whereType<Map<String, dynamic>>()
          .map(PrayerLog.fromJson)
          .toList(growable: false);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return const <PrayerLog>[];
      throw ApiException.fromDio(e);
    }
  }

  /// `POST /log` — log a prayer.
  Future<PrayerLog> logPrayer({
    required String prayerName,
    required PrayerStatus status,
    DateTime? date,
  }) async {
    try {
      final dateStr = DateFormat('yyyy-MM-dd').format(date ?? DateTime.now());
      final res = await _dio.post<Map<String, dynamic>>(
        '$_base/log',
        data: {
          'prayerName': prayerName,
          'date': dateStr,
          'status': status.apiValue,
        },
      );
      final data = res.data;
      if (data == null) {
        throw const ApiException(message: 'Empty prayer-log response.');
      }
      return PrayerLog.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `POST /qada/increment` — add [by] to the standalone qaza tally.
  ///
  /// This is deliberately *not* `POST /log`. The log table is unique on
  /// `(userId, prayerName, date)`, so posting a `qada` status upserts over
  /// whatever that prayer already held for that day: adding a qaza owed for
  /// a past day would flip today's `on_time` row to `qada`, un-tick the
  /// prayer on the Today checklist and drop the daily goal by one.
  /// `PrayerQadaCount` is a separate tally for exactly this reason
  /// (`prayers.service.ts`, `adjustQada`: "a qada owed for a *past* day
  /// must never upsert over today's log row").
  ///
  /// [by] is always sent positive. The server negates it itself on the
  /// decrement route (`-(body.by ?? 1)`), so a negative `by` posted here
  /// would silently decrement — direction is carried by the endpoint, never
  /// by the sign. The server rejects `by` outside ±1…100.
  ///
  /// Returns the refreshed tally the server computed, so callers need no
  /// follow-up read.
  Future<PrayerStats> incrementQada({
    required String prayerName,
    int by = 1,
  }) async {
    if (by <= 0 || by > 100) {
      throw ApiException(
        message: 'Qaza adjustment must be between 1 and 100, got $by.',
      );
    }
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '$_base/qada/increment',
        data: {'prayerName': prayerName, 'by': by},
      );
      final data = res.data;
      if (data == null) {
        throw const ApiException(message: 'Empty qaza-increment response.');
      }
      return PrayerStats.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `GET /stats` — qaza counts by prayer.
  Future<PrayerStats> getStats() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('$_base/stats');
      final data = res.data;
      if (data == null) return PrayerStats.empty;
      return PrayerStats.fromJson(data);
    } on DioException catch (e) {
      // Stats endpoint may be unavailable — surface empty rather than break UX.
      if (e.response?.statusCode == 404) return PrayerStats.empty;
      throw ApiException.fromDio(e);
    }
  }
}

@Riverpod(keepAlive: true)
PrayersRepository prayersRepository(Ref ref) =>
    PrayersRepository(ref.watch(dioProvider));
