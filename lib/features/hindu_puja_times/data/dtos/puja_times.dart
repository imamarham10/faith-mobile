import 'package:freezed_annotation/freezed_annotation.dart';

part 'puja_times.freezed.dart';
part 'puja_times.g.dart';

/// Re-anchors a backend timestamp's wall-clock digits as local time,
/// discarding its (incorrect) UTC/"Z" tag.
///
/// Confirmed live: this endpoint bakes the requested `?timezone=` into the
/// wall-clock digits themselves (e.g. `solarNoon` reads `"12:21:38Z"` when
/// real local noon is ~12:21 PM IST — a sensible solar noon only if those
/// digits ARE local time), while still suffixing the string with `Z`. A
/// real UTC instant `12:21Z` would be ~5:51 PM IST once converted — a
/// nonsensical "solar noon". Calling `.toLocal()` on the raw parse would
/// apply the device's UTC offset a second time and double-shift every
/// displayed time; reconstructing a plain local `DateTime` from the same
/// numeric fields (not the epoch) is the correct fix.
DateTime _parseWallClockAsLocal(String iso) {
  final parsed = DateTime.parse(iso);
  return DateTime(
    parsed.year,
    parsed.month,
    parsed.day,
    parsed.hour,
    parsed.minute,
    parsed.second,
  );
}

/// A start/end range for one of the three daily sandhya (puja) windows.
@freezed
abstract class TimeBand with _$TimeBand {
  const factory TimeBand({required DateTime start, required DateTime end}) =
      _TimeBand;

  factory TimeBand.fromJson(Map<String, dynamic> json) => TimeBand(
    start: _parseWallClockAsLocal(json['start'] as String),
    end: _parseWallClockAsLocal(json['end'] as String),
  );
}

/// One of the three daily sandhya windows (`pratah`, `madhyahna`, `sayam`) —
/// this backend's equivalent of a single prayer time, except each is a
/// *range* rather than a single instant, and `isCurrent` is computed
/// server-side (given the request's `timezone`) rather than derived
/// client-side.
@freezed
abstract class SandhyaInfo with _$SandhyaInfo {
  const factory SandhyaInfo({
    required String name, // 'pratah' | 'madhyahna' | 'sayam'
    required String nameSanskrit,
    required String nameEnglish,
    required TimeBand band,
    required bool isCurrent,
  }) = _SandhyaInfo;

  factory SandhyaInfo.fromJson(Map<String, dynamic> json) =>
      _$SandhyaInfoFromJson(json);
}

/// The backend's own pre-computed "what's next" pointer — trusted directly
/// rather than re-derived client-side, since "is now inside a band" is
/// nontrivial to replicate correctly (unlike `NextPrayer.from()`, which
/// safely re-derives from single-instant prayer times).
@freezed
abstract class NextSandhya with _$NextSandhya {
  const factory NextSandhya({
    required String sandhya,
    required int startsInSeconds,
  }) = _NextSandhya;

  factory NextSandhya.fromJson(Map<String, dynamic> json) =>
      _$NextSandhyaFromJson(json);
}

/// `GET /today` and `GET /date/:date` — mirrors `PrayerTimes`'s role, but
/// carries three named bands instead of five/six named instants, plus a
/// server-resolved `next` pointer. Unlike prayer times (never sends a
/// timezone param — lat/lng + date is enough), this endpoint's `isCurrent`/
/// `next` computation is timezone-sensitive server-side, so callers MUST
/// pass the device's real IANA zone name, not omit it. See
/// `_parseWallClockAsLocal` for the accompanying timestamp-correction —
/// every `DateTime` field on this class and [TimeBand] needs it.
@freezed
abstract class PujaTimes with _$PujaTimes {
  const factory PujaTimes({
    required String date, // 'yyyy-MM-dd'
    required String timezone,
    required DateTime sunrise,
    required DateTime sunset,
    required DateTime solarNoon,
    @Default(<SandhyaInfo>[]) List<SandhyaInfo> sandhyas,
    NextSandhya? next,
  }) = _PujaTimes;

  factory PujaTimes.fromJson(Map<String, dynamic> json) => PujaTimes(
    date: json['date'] as String,
    timezone: json['timezone'] as String,
    sunrise: _parseWallClockAsLocal(json['sunrise'] as String),
    sunset: _parseWallClockAsLocal(json['sunset'] as String),
    solarNoon: _parseWallClockAsLocal(json['solarNoon'] as String),
    sandhyas: (json['sandhyas'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(SandhyaInfo.fromJson)
        .toList(growable: false),
    next: json['next'] != null
        ? NextSandhya.fromJson(json['next'] as Map<String, dynamic>)
        : null,
  );
}
