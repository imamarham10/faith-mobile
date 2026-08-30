import '../data/dtos/puja_times.dart';

/// Pure value class — the puja-times equivalent of `NextPrayer`. Unlike
/// `NextPrayer.from()` (which scans instants and computes a day-progress
/// fraction itself), this trusts the backend's own `next` pointer for
/// *which* sandhya and *how soon*, converting `startsInSeconds` into an
/// absolute target time once at construction so the countdown card doesn't
/// need to track "seconds elapsed since fetch" itself.
class NextPuja {
  const NextPuja({
    required this.sandhyaKey,
    required this.displayName,
    required this.targetTime,
    required this.dayProgress,
  });

  final String sandhyaKey;
  final String displayName;
  final DateTime targetTime;

  /// 0..1 fraction of the day elapsed at construction time — purely for the
  /// countdown card's day-arc decoration, same semantics as `NextPrayer`'s.
  final double dayProgress;

  static NextPuja? from(PujaTimes times, {DateTime? now}) {
    final next = times.next;
    if (next == null) return null;

    final sandhya = times.sandhyas
        .where((s) => s.name == next.sandhya)
        .toList(growable: false);
    final displayName = sandhya.isNotEmpty
        ? sandhya.first.nameEnglish
        : next.sandhya;

    final n = now ?? DateTime.now();
    final startOfDay = DateTime(n.year, n.month, n.day);
    final elapsed = n.difference(startOfDay).inSeconds / Duration.secondsPerDay;

    return NextPuja(
      sandhyaKey: next.sandhya,
      displayName: displayName,
      targetTime: n.add(Duration(seconds: next.startsInSeconds)),
      dayProgress: elapsed.clamp(0.0, 1.0),
    );
  }
}
