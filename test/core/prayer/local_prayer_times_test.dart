import 'package:faith_mobile/core/prayer/local_prayer_times.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('computes a 7-day window starting from the given date', () {
    final days = LocalPrayerTimes.forRange(
      latitude: 12.9716,
      longitude: 77.5946,
      from: DateTime(2026, 10, 8),
      days: 7,
      method: 'MWL',
      madhab: 'shafi',
    );

    expect(days, hasLength(7));
    expect(days.first.date, DateTime(2026, 10, 8));
    expect(days.last.date, DateTime(2026, 10, 14));
    for (final d in days) {
      expect(d.fajr.year, d.date.year);
      expect(d.fajr.month, d.date.month);
      expect(d.fajr.day, d.date.day,
          reason: 'each day must be computed for its own date');
    }
  });

  test('every day carries all five prayers in chronological order', () {
    final day = LocalPrayerTimes.forRange(
      latitude: 12.9716, longitude: 77.5946,
      from: DateTime(2026, 10, 8), days: 1,
      method: 'MWL', madhab: 'shafi',
    ).single;

    final ordered = [day.fajr, day.dhuhr, day.asr, day.maghrib, day.isha];
    for (var i = 1; i < ordered.length; i++) {
      expect(ordered[i].isAfter(ordered[i - 1]), isTrue,
          reason: 'prayer $i is not after prayer ${i - 1}');
    }
  });
}
