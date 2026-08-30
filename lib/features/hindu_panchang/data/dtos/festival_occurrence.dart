import 'package:freezed_annotation/freezed_annotation.dart';

import 'hindu_festival.dart';

part 'festival_occurrence.freezed.dart';
part 'festival_occurrence.g.dart';

/// One resolved occurrence of a festival — an entry in `GET
/// /festivals/upcoming`'s `occurrences[]` array: the festival plus the
/// specific Gregorian date it falls on within the requested window.
@freezed
abstract class FestivalOccurrence with _$FestivalOccurrence {
  const factory FestivalOccurrence({
    required HinduFestival festival,
    required DateTime date,
  }) = _FestivalOccurrence;

  factory FestivalOccurrence.fromJson(Map<String, dynamic> json) =>
      _$FestivalOccurrenceFromJson(json);
}
