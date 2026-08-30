import 'package:freezed_annotation/freezed_annotation.dart';

part 'puja_log.freezed.dart';
part 'puja_log.g.dart';

/// Unlike Dhikr/prayers' `qada` (a missed-prayer "debt" tracked and made up
/// later, with its own +1 counter UI), this backend's `missed` is just a
/// plain status you log — there is no make-up-later concept, no
/// `incrementQada`-equivalent method, and no qaza tracker screen here.
enum PujaStatus {
  @JsonValue('on_time')
  onTime,
  @JsonValue('late')
  late_, // 'late' collides with the Dart keyword; apiValue/label below map it
  @JsonValue('missed')
  missed,
}

extension PujaStatusX on PujaStatus {
  String get apiValue => switch (this) {
    PujaStatus.onTime => 'on_time',
    PujaStatus.late_ => 'late',
    PujaStatus.missed => 'missed',
  };

  String get label => switch (this) {
    PujaStatus.onTime => 'On time',
    PujaStatus.late_ => 'Late',
    PujaStatus.missed => 'Missed',
  };
}

/// `POST /log` request + response shape, mirrors the `PujaLog` Prisma model.
@freezed
abstract class PujaLog with _$PujaLog {
  const factory PujaLog({
    String? id,
    String? userId,
    required String sandhya,
    required String date, // 'yyyy-MM-dd'
    required PujaStatus status,
    DateTime? createdAt,
  }) = _PujaLog;

  factory PujaLog.fromJson(Map<String, dynamic> json) =>
      _$PujaLogFromJson(json);
}
