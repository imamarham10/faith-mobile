import 'package:freezed_annotation/freezed_annotation.dart';

part 'hijri_day.freezed.dart';
part 'hijri_day.g.dart';

/// One entry from `GET /api/v1/islam/calendar/{gregorian,hijri}-month`
/// (the `days` array) — the server-computed, calendarAdjust-aware Hijri
/// info for a single Gregorian date. Distinct from [HijriToday] (which
/// wraps the nested `{gregorian:{}, hijri:{}}` shape of `/today`); this
/// mirrors the flatter `HijriDateInfo` shape the month endpoints return.
@freezed
abstract class HijriDay with _$HijriDay {
  const factory HijriDay({
    required int hijriDay,
    required int hijriMonth,
    required int hijriYear,
    required String hijriMonthName,
    required String gregorianDate,
    required String dayOfWeek,
  }) = _HijriDay;

  factory HijriDay.fromJson(Map<String, dynamic> json) =>
      _$HijriDayFromJson(json);
}
