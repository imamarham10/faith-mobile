import 'package:freezed_annotation/freezed_annotation.dart';

part 'prayer_log.freezed.dart';
part 'prayer_log.g.dart';

/// Prayer log status as accepted by the backend.
enum PrayerStatus {
  @JsonValue('on_time')
  onTime,
  @JsonValue('late')
  late,
  @JsonValue('qada')
  qada,
}

extension PrayerStatusX on PrayerStatus {
  String get apiValue => switch (this) {
    PrayerStatus.onTime => 'on_time',
    PrayerStatus.late => 'late',
    PrayerStatus.qada => 'qada',
  };

  String get label => switch (this) {
    PrayerStatus.onTime => 'On time',
    PrayerStatus.late => 'Late',
    PrayerStatus.qada => 'Qaḍāʾ',
  };
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
