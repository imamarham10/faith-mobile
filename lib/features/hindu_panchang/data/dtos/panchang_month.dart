import 'package:freezed_annotation/freezed_annotation.dart';

import 'panchang_day.dart';

part 'panchang_month.freezed.dart';
part 'panchang_month.g.dart';

/// `GET /month` — every day of the requested month, in order.
@freezed
abstract class PanchangMonth with _$PanchangMonth {
  const factory PanchangMonth({
    required int year,
    required int month,
    @Default(<PanchangDay>[]) List<PanchangDay> days,
  }) = _PanchangMonth;

  factory PanchangMonth.fromJson(Map<String, dynamic> json) =>
      _$PanchangMonthFromJson(json);
}
