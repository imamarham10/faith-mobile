import 'package:freezed_annotation/freezed_annotation.dart';

part 'hijri_today.freezed.dart';

/// Response shape for `GET /api/v1/islam/calendar/today`.
@freezed
abstract class HijriToday with _$HijriToday {
  const factory HijriToday({
    required DateTime gregorianDate,
    required int hijriYear,
    required int hijriMonth,
    required int hijriDay,
    required String hijriMonthName,
    String? hijriMonthNameArabic,
  }) = _HijriToday;

  const HijriToday._();

  factory HijriToday.fromJson(Map<String, dynamic> json) {
    final greg =
        (json['gregorian'] as Map?)?.cast<String, dynamic>() ?? const {};
    final hijri = (json['hijri'] as Map?)?.cast<String, dynamic>() ?? const {};

    DateTime parseGreg() {
      final raw = greg['date']?.toString();
      if (raw != null && raw.isNotEmpty) {
        return DateTime.parse(raw);
      }
      return DateTime(
        (greg['year'] as num?)?.toInt() ?? DateTime.now().year,
        (greg['month'] as num?)?.toInt() ?? DateTime.now().month,
        (greg['day'] as num?)?.toInt() ?? DateTime.now().day,
      );
    }

    return HijriToday(
      gregorianDate: parseGreg(),
      hijriYear: (hijri['year'] as num?)?.toInt() ?? 0,
      hijriMonth: (hijri['month'] as num?)?.toInt() ?? 0,
      hijriDay: (hijri['day'] as num?)?.toInt() ?? 0,
      hijriMonthName: hijri['monthName']?.toString() ?? '',
      hijriMonthNameArabic: hijri['monthNameArabic']?.toString(),
    );
  }
}
