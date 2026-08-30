import 'package:freezed_annotation/freezed_annotation.dart';

part 'puja_stats.freezed.dart';
part 'puja_stats.g.dart';

/// `GET /stats` — a fixed, already-implemented shape (unlike Islamic
/// prayers' own stats endpoint, whose shape "isn't fully spec'd" per that
/// module's own comment and needs a tolerant parser) — plain generated
/// `fromJson` is sufficient here.
@freezed
abstract class PujaStats with _$PujaStats {
  const factory PujaStats({
    @Default(0) int total,
    @Default(0) int onTime,
    @Default(0) int late,
    @Default(0) int missed,
    @Default(0) int currentStreak,
    @Default(0) int longestStreak,
    @Default(0) double completionRate,
  }) = _PujaStats;

  const PujaStats._();

  static const empty = PujaStats();

  factory PujaStats.fromJson(Map<String, dynamic> json) =>
      _$PujaStatsFromJson(json);
}
