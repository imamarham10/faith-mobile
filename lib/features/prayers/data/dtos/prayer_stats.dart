import 'package:freezed_annotation/freezed_annotation.dart';

part 'prayer_stats.freezed.dart';

/// Per-user qaza counts by prayer.
@freezed
abstract class PrayerStats with _$PrayerStats {
  const factory PrayerStats({
    required int totalQaza,
    required int fajrQaza,
    required int dhuhrQaza,
    required int asrQaza,
    required int maghribQaza,
    required int ishaQaza,
  }) = _PrayerStats;

  const PrayerStats._();

  static const empty = PrayerStats(
    totalQaza: 0,
    fajrQaza: 0,
    dhuhrQaza: 0,
    asrQaza: 0,
    maghribQaza: 0,
    ishaQaza: 0,
  );

  /// Tolerant parser — backend stats endpoint shape isn't fully spec'd in
  /// APIs.md, so we handle both flat counts and nested `byPrayer` objects.
  factory PrayerStats.fromJson(Map<String, dynamic> json) {
    int read(String key) {
      final v = json[key];
      if (v is num) return v.toInt();
      final by = json['byPrayer'];
      if (by is Map && by[key] is num) return (by[key] as num).toInt();
      return 0;
    }

    final fajr = read('fajr');
    final dhuhr = read('dhuhr');
    final asr = read('asr');
    final maghrib = read('maghrib');
    final isha = read('isha');

    final total = json['totalQaza'] is num
        ? (json['totalQaza'] as num).toInt()
        : (json['total'] is num
              ? (json['total'] as num).toInt()
              : fajr + dhuhr + asr + maghrib + isha);

    return PrayerStats(
      totalQaza: total,
      fajrQaza: fajr,
      dhuhrQaza: dhuhr,
      asrQaza: asr,
      maghribQaza: maghrib,
      ishaQaza: isha,
    );
  }

  int countFor(String prayerKey) => switch (prayerKey) {
    'fajr' => fajrQaza,
    'dhuhr' => dhuhrQaza,
    'asr' => asrQaza,
    'maghrib' => maghribQaza,
    'isha' => ishaQaza,
    _ => 0,
  };
}
