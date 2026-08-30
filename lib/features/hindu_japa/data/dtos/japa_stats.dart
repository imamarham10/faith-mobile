import 'package:freezed_annotation/freezed_annotation.dart';

part 'japa_stats.freezed.dart';
part 'japa_stats.g.dart';

/// `GET /api/v1/hindu/japa/stats` — computed, not a stored model. No Dhikr
/// equivalent exists; this is additive parity with what the backend offers.
@freezed
abstract class JapaStats with _$JapaStats {
  const factory JapaStats({
    @Default(0) int totalCount,
    @Default(0) double dailyAverage,
    @Default(0) int currentStreak,
    @Default(0) int longestStreak,
    String? mostRecitedPhrase,
  }) = _JapaStats;

  factory JapaStats.fromJson(Map<String, dynamic> json) =>
      _$JapaStatsFromJson(json);
}
