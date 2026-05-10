import 'package:freezed_annotation/freezed_annotation.dart';

part 'prayer_times.freezed.dart';

/// Prayer-time payload from `GET /api/v1/islam/prayers/times`.
///
/// Backend shape (verified):
/// ```
/// {
///   "date": "2026-05-10",
///   "location": { "lat": 12.97, "lng": 77.59 },
///   "method": "mwl",
///   "times": {
///     "fajr": "2026-05-09T23:10:00.000Z",
///     "sunrise": "...", "dhuhr": "...", "asr": "...", "maghrib": "...", "isha": "..."
///   }
/// }
/// ```
///
/// Times come back as UTC ISO-8601; we convert to the device's local zone so
/// the UI never has to think about timezones.
@freezed
abstract class PrayerTimes with _$PrayerTimes {
  const factory PrayerTimes({
    required DateTime date,
    required double latitude,
    required double longitude,
    required DateTime fajr,
    required DateTime sunrise,
    required DateTime dhuhr,
    required DateTime asr,
    required DateTime maghrib,
    required DateTime isha,
  }) = _PrayerTimes;

  const PrayerTimes._();

  factory PrayerTimes.fromJson(Map<String, dynamic> json) {
    final date = DateTime.parse(json['date']?.toString() ?? '');
    final loc = (json['location'] as Map?)?.cast<String, dynamic>();
    // Backend variants: `times` (current) or `prayers` (older); accept both.
    final times =
        (json['times'] as Map?)?.cast<String, dynamic>() ??
        (json['prayers'] as Map?)?.cast<String, dynamic>() ??
        const <String, dynamic>{};

    DateTime parse(String key) {
      final raw = times[key]?.toString() ?? '';
      if (raw.isEmpty) {
        // Last-resort sentinel — should never happen with a real backend.
        return DateTime(date.year, date.month, date.day);
      }
      // Modern shape: ISO-8601 with timezone (UTC). Convert to local.
      final iso = DateTime.tryParse(raw);
      if (iso != null) return iso.toLocal();
      // Legacy shape: bare "HH:mm:ss" anchored to `date`.
      final parts = raw.split(':').map((p) => int.tryParse(p) ?? 0).toList();
      return DateTime(
        date.year,
        date.month,
        date.day,
        parts.isNotEmpty ? parts[0] : 0,
        parts.length > 1 ? parts[1] : 0,
        parts.length > 2 ? parts[2] : 0,
      );
    }

    // Accept lat/lng (current) or latitude/longitude (older).
    double? coord(String a, String b) {
      final v = loc?[a] ?? loc?[b];
      return (v as num?)?.toDouble();
    }

    return PrayerTimes(
      date: date,
      latitude: coord('lat', 'latitude') ?? 0,
      longitude: coord('lng', 'longitude') ?? 0,
      fajr: parse('fajr'),
      sunrise: parse('sunrise'),
      dhuhr: parse('dhuhr'),
      asr: parse('asr'),
      maghrib: parse('maghrib'),
      isha: parse('isha'),
    );
  }

  /// Ordered, named entries — handy for list rendering.
  List<({String key, String displayName, DateTime time, bool isPrayer})>
  get entries => [
    (key: 'fajr', displayName: 'Fajr', time: fajr, isPrayer: true),
    (key: 'sunrise', displayName: 'Sunrise', time: sunrise, isPrayer: false),
    (key: 'dhuhr', displayName: 'Dhuhr', time: dhuhr, isPrayer: true),
    (key: 'asr', displayName: 'ʿAṣr', time: asr, isPrayer: true),
    (key: 'maghrib', displayName: 'Maghrib', time: maghrib, isPrayer: true),
    (key: 'isha', displayName: 'ʿIshā', time: isha, isPrayer: true),
  ];
}
