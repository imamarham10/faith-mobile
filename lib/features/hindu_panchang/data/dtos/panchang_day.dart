import 'package:freezed_annotation/freezed_annotation.dart';

part 'panchang_day.freezed.dart';
part 'panchang_day.g.dart';

/// A start/end window — used for sunrise/sunset-adjacent muhurta windows.
@freezed
abstract class TimeWindow with _$TimeWindow {
  const factory TimeWindow({required DateTime start, required DateTime end}) =
      _TimeWindow;

  factory TimeWindow.fromJson(Map<String, dynamic> json) =>
      _$TimeWindowFromJson(json);
}

/// Lunar day (1–30), the primary panchang element most festivals key off.
@freezed
abstract class TithiInfo with _$TithiInfo {
  const factory TithiInfo({
    required int number,
    required String name,
    required String nameSanskrit,
    required String paksha, // 'shukla' | 'krishna'
    DateTime? endTime,
  }) = _TithiInfo;

  factory TithiInfo.fromJson(Map<String, dynamic> json) =>
      _$TithiInfoFromJson(json);
}

/// Lunar mansion (1–27).
@freezed
abstract class NakshatraInfo with _$NakshatraInfo {
  const factory NakshatraInfo({
    required int number,
    required String name,
    required String nameSanskrit,
    required String deity,
    DateTime? endTime,
  }) = _NakshatraInfo;

  factory NakshatraInfo.fromJson(Map<String, dynamic> json) =>
      _$NakshatraInfoFromJson(json);
}

@freezed
abstract class YogaInfo with _$YogaInfo {
  const factory YogaInfo({
    required int number,
    required String name,
    required String nameSanskrit,
  }) = _YogaInfo;

  factory YogaInfo.fromJson(Map<String, dynamic> json) =>
      _$YogaInfoFromJson(json);
}

@freezed
abstract class KaranaInfo with _$KaranaInfo {
  const factory KaranaInfo({
    required int number,
    required String name,
    required String nameSanskrit,
    required bool isAuspicious,
  }) = _KaranaInfo;

  factory KaranaInfo.fromJson(Map<String, dynamic> json) =>
      _$KaranaInfoFromJson(json);
}

/// Weekday — `number` is 0-indexed from Sunday, matching `DateTime.weekday %
/// 7` (Dart's `weekday` is 1=Monday..7=Sunday, so `weekday % 7` gives
/// 0=Sunday..6=Saturday, the same convention this field uses).
@freezed
abstract class VaaraInfo with _$VaaraInfo {
  const factory VaaraInfo({
    required int number,
    required String name,
    required String nameSanskrit,
  }) = _VaaraInfo;

  factory VaaraInfo.fromJson(Map<String, dynamic> json) =>
      _$VaaraInfoFromJson(json);
}

/// Auspicious/inauspicious windows for the day. `abhijitMuhurta` is `null`
/// on Wednesdays (Smarta convention — the backend omits it, not a client
/// concern to explain further here).
@freezed
abstract class AuspiciousTimes with _$AuspiciousTimes {
  const factory AuspiciousTimes({
    required TimeWindow brahmaMuhurta,
    TimeWindow? abhijitMuhurta,
    required TimeWindow rahuKaal,
    required TimeWindow yamagandam,
    required TimeWindow gulika,
  }) = _AuspiciousTimes;

  factory AuspiciousTimes.fromJson(Map<String, dynamic> json) =>
      _$AuspiciousTimesFromJson(json);
}

/// Minimal festival reference embedded in a day's `festivals[]` array —
/// already resolved server-side against that specific date, no client-side
/// rule matching needed (unlike Islamic events, which the calendar module
/// matches against the visible month itself).
@freezed
abstract class FestivalSummary with _$FestivalSummary {
  const factory FestivalSummary({
    required String slug,
    required String nameEnglish,
    String? nameSanskrit,
  }) = _FestivalSummary;

  factory FestivalSummary.fromJson(Map<String, dynamic> json) =>
      _$FestivalSummaryFromJson(json);
}

/// One day's full panchang — `GET /today`, `GET /date/:date`, and one entry
/// in `GET /month`'s `days[]`. All timestamps arrive as UTC ISO strings
/// regardless of the request's `?timezone=` param (confirmed live — that
/// param only echoes back in the response, it doesn't shift the computed
/// times), so screens must call `.toLocal()` themselves before formatting.
@freezed
abstract class PanchangDay with _$PanchangDay {
  const factory PanchangDay({
    required String date, // 'yyyy-MM-dd'
    required String timezone,
    required TithiInfo tithi,
    required NakshatraInfo nakshatra,
    required YogaInfo yoga,
    required KaranaInfo karana,
    required VaaraInfo vaara,
    required DateTime sunrise,
    required DateTime sunset,
    DateTime? moonrise,
    DateTime? moonset,
    required AuspiciousTimes auspicious,
    @Default(<FestivalSummary>[]) List<FestivalSummary> festivals,
  }) = _PanchangDay;

  factory PanchangDay.fromJson(Map<String, dynamic> json) =>
      _$PanchangDayFromJson(json);
}
