import 'package:faith_mobile/features/hindu_puja_times/data/dtos/puja_log.dart';
import 'package:faith_mobile/features/prayers/data/dtos/prayer_log.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PrayerStatus', () {
    test('parses every status the backend is willing to store', () {
      // `LogPrayerDto` accepts on_time | late | qada | missed and
      // `prayer_logs.status` is an unconstrained text column, so any of the
      // four can come back from `GET /log`.
      for (final raw in ['on_time', 'late', 'qada', 'missed']) {
        final log = PrayerLog.fromJson({
          'prayerName': 'fajr',
          'date': '2026-10-09',
          'status': raw,
        });
        expect(log.status.apiValue, raw);
      }
    });

    test('an unknown status throws rather than resolving to a prayed one', () {
      // Silently coercing an unrecognised value would inflate the streak.
      expect(
        () => PrayerLog.fromJson({
          'prayerName': 'fajr',
          'date': '2026-10-09',
          'status': 'teleported',
        }),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('only on_time and late count as practised', () {
      expect(PrayerStatus.onTime.countsAsPractised, isTrue);
      expect(PrayerStatus.late.countsAsPractised, isTrue);
      expect(PrayerStatus.qada.countsAsPractised, isFalse);
      expect(PrayerStatus.missed.countsAsPractised, isFalse);
    });
  });

  group('PujaStatus', () {
    test('everything but missed counts as practised', () {
      // Matches the server-side rule behind `PujaStats.currentStreak`.
      expect(PujaStatus.onTime.countsAsPractised, isTrue);
      expect(PujaStatus.late_.countsAsPractised, isTrue);
      expect(PujaStatus.missed.countsAsPractised, isFalse);
    });
  });
}
