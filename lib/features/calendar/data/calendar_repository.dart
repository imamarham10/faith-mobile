import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/providers.dart';
import 'dtos/hijri_today.dart';
import 'dtos/islamic_event.dart';

part 'calendar_repository.g.dart';

/// HTTP boundary for calendar endpoints under `/api/v1/islam/calendar/*`.
class CalendarRepository {
  CalendarRepository(this._dio);

  static const String _base = '/api/v1/islam/calendar';

  final Dio _dio;

  /// `GET /today` — server-side Hijri today.
  Future<HijriToday> getToday() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('$_base/today');
      final data = res.data;
      if (data == null) {
        throw const ApiException(message: 'Empty calendar/today response.');
      }
      return HijriToday.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `GET /events` — all Islamic events for the year.
  Future<List<IslamicEvent>> getEvents() async {
    try {
      final res = await _dio.get<dynamic>('$_base/events');
      final data = res.data;
      if (data is! List) return const <IslamicEvent>[];
      return data
          .whereType<Map<String, dynamic>>()
          .map(IslamicEvent.fromJson)
          .toList(growable: false);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

@Riverpod(keepAlive: true)
CalendarRepository calendarRepository(Ref ref) =>
    CalendarRepository(ref.watch(dioProvider));
