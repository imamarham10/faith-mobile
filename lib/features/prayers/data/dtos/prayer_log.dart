import 'package:freezed_annotation/freezed_annotation.dart';

part 'prayer_log.freezed.dart';
part 'prayer_log.g.dart';

/// Prayer log status as accepted by the backend.
///
/// [missed] exists because the server accepts and stores it
/// (`LogPrayerDto`'s enum, and `prayer_logs.status` is a free-text column) —
/// the mobile app never writes it, but a row written by any other client
/// used to make `PrayerLog.fromJson` throw and take the whole read with it.
/// Mapping an unknown value onto a performed status instead would silently
/// inflate a streak, which is the one failure this app cannot afford.
enum PrayerStatus {
  @JsonValue('on_time')
  onTime,
  @JsonValue('late')
  late,
  @JsonValue('qada')
  qada,
  @JsonValue('missed')
  missed,
}

extension PrayerStatusX on PrayerStatus {
  String get apiValue => switch (this) {
    PrayerStatus.onTime => 'on_time',
    PrayerStatus.late => 'late',
    PrayerStatus.qada => 'qada',
    PrayerStatus.missed => 'missed',
  };

  String get label => switch (this) {
    PrayerStatus.onTime => 'On time',
    PrayerStatus.late => 'Late',
    PrayerStatus.qada => 'Qaḍāʾ',
    PrayerStatus.missed => 'Missed',
  };

  /// Whether this status records a prayer actually prayed *for the day it is
  /// logged against*.
  ///
  /// [qada] is excluded deliberately: it records a prayer owed from an
  /// earlier day, and the qaza tracker posts it stamped with today's date,
  /// so counting it would credit today for a debt repaid. [missed] is an
  /// explicit "did not pray". This is the single rule behind both the daily
  /// goal and the streak, and it mirrors the Hindu side's server-side rule
  /// (`puja-log.service.ts` counts any log whose status is not `missed`).
  bool get countsAsPractised =>
      this == PrayerStatus.onTime || this == PrayerStatus.late;
}

/// `POST /api/v1/islam/prayers/log` request + response shape.
@freezed
abstract class PrayerLog with _$PrayerLog {
  const factory PrayerLog({
    String? id,
    String? userId,
    required String prayerName,
    required String date,
    required PrayerStatus status,
    DateTime? loggedAt,
  }) = _PrayerLog;

  factory PrayerLog.fromJson(Map<String, dynamic> json) =>
      _$PrayerLogFromJson(json);
}
