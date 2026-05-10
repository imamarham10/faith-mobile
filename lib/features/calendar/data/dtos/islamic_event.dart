import 'package:freezed_annotation/freezed_annotation.dart';

part 'islamic_event.freezed.dart';
part 'islamic_event.g.dart';

/// An entry from `GET /api/v1/islam/calendar/events`.
///
/// Hijri-anchored — the same Hijri (month, day) pair recurs each Hijri year
/// and is mapped to a Gregorian date client-side.
@freezed
abstract class IslamicEvent with _$IslamicEvent {
  const factory IslamicEvent({
    required String id,
    required String name,
    String? nameArabic,
    String? description,
    required int hijriMonth,
    required int hijriDay,
    @Default('regular') String importance,
  }) = _IslamicEvent;

  factory IslamicEvent.fromJson(Map<String, dynamic> json) =>
      _$IslamicEventFromJson(json);
}
