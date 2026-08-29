import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/providers.dart';
import 'dtos/hijri_day.dart';
import 'dtos/hijri_today.dart';
import 'dtos/islamic_event.dart';

part 'calendar_repository.g.dart';

/// Regional Hijri correction sent as `calendarAdjust` on every calendar call.
///
/// 0=Gulf/standard, 1=India/Pakistan/Bangladesh — matches the backend's own
/// documented convention exactly (see `calendar.service.ts`). Verified
/// 2026-08-29 against a real-world reference: 12 Rabi' al-Awwal 1448
/// (Mawlid/Barawafat) lands on Aug 26, 2026 at adjust=1, matching observed
/// South Asian practice.
///
/// Getting here took two backend fixes, not just this constant — worth
/// knowing if this ever needs recalibrating: (1) `hijriToGregorian()` used
/// to prefer the Aladhan API while `gregorianToHijri()` used a different
/// local library, so the two weren't inverses of each other; both now use
/// the same local `@tabby_ai/hijri-converter` consistently. (2)
/// `hijriToGregorian()` built its result as a *local*-midnight `Date` then
/// serialized via `.toISOString()`, which silently rolls back a day on any
/// server running in a positive-UTC-offset timezone (the backend runs in
/// Asia/Calcutta, UTC+5:30) — fixed to build UTC-midnight instead. Only
/// after both were fixed did the standard adjust=1 convention land on the
/// correct real-world date; before that, compensating for the timezone bug
/// looked like it needed adjust=2. If this drifts again, re-verify BOTH
/// backend directions are still true inverses of each other at adjust=0
/// before assuming the regional constant itself needs to change.
const kCalendarAdjust = 1;

/// HTTP boundary for calendar endpoints under `/api/v1/islam/calendar/*`.
class CalendarRepository {
  CalendarRepository(this._dio);

  static const String _base = '/api/v1/islam/calendar';

  final Dio _dio;

  /// `GET /today` — server-side Hijri today, calendarAdjust-corrected.
  Future<HijriToday> getToday() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '$_base/today',
        queryParameters: {'calendarAdjust': kCalendarAdjust},
      );
      final data = res.data;
      if (data == null) {
        throw const ApiException(message: 'Empty calendar/today response.');
      }
      return HijriToday.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `GET /gregorian-month` — a full Gregorian month's calendarAdjust-
  /// corrected Hijri info, one entry per day. Used to label the calendar
  /// grid's cells regardless of which mode (Hijri/Gregorian) is browsed —
  /// the grid itself is always Gregorian-day-indexed.
  Future<List<HijriDay>> getGregorianMonth(int year, int month) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '$_base/gregorian-month',
        queryParameters: {
          'year': year,
          'month': month,
          'calendarAdjust': kCalendarAdjust,
        },
      );
      final days = res.data?['days'];
      if (days is! List) return const <HijriDay>[];
      return days
          .whereType<Map<String, dynamic>>()
          .map(HijriDay.fromJson)
          .toList(growable: false);
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
