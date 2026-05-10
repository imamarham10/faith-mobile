import '../data/dtos/prayer_times.dart';

/// Computed "what's next" view over a [PrayerTimes] schedule.
///
/// Pure value class — no I/O. Holds the upcoming obligatory prayer, the time
/// remaining to it, and a 0..1 progress through the 24-hour cycle for the
/// day-arc rendering.
class NextPrayer {
  const NextPrayer({
    required this.key,
    required this.displayName,
    required this.time,
    required this.remaining,
    required this.dayProgress,
  });

  final String key;
  final String displayName;
  final DateTime time;
  final Duration remaining;

  /// 0..1 fraction of the 24-hour cycle elapsed at "now".
  final double dayProgress;

  /// Resolves the next obligatory prayer (skips Sunrise) at [now].
  /// If all of today's prayers have passed, returns tomorrow's Fajr stub at
  /// the same Fajr clock time + 24h.
  factory NextPrayer.from(PrayerTimes times, {DateTime? now}) {
    final n = now ?? DateTime.now();
    final obligatory = times.entries.where((e) => e.isPrayer).toList();

    final upcoming = obligatory.firstWhere(
      (e) => e.time.isAfter(n),
      orElse: () => (
        key: 'fajr',
        displayName: 'Fajr',
        time: times.fajr.add(const Duration(days: 1)),
        isPrayer: true,
      ),
    );

    final startOfDay = DateTime(n.year, n.month, n.day);
    final elapsed = n.difference(startOfDay).inSeconds;
    const dayLen = Duration.secondsPerHour * 24;

    return NextPrayer(
      key: upcoming.key,
      displayName: upcoming.displayName,
      time: upcoming.time,
      remaining: upcoming.time.difference(n),
      dayProgress: (elapsed / dayLen).clamp(0.0, 1.0),
    );
  }
}
