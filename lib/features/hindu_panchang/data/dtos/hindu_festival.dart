import 'package:freezed_annotation/freezed_annotation.dart';

part 'hindu_festival.freezed.dart';
part 'hindu_festival.g.dart';

/// A festival's static metadata — `GET /festivals` and `GET /festivals/:slug`.
/// The backend's `ruleSpec` (the tithi/paksha/month rule used to resolve
/// which Gregorian date the festival lands on each year) is deliberately
/// not modeled here — resolution already happens server-side, surfaced via
/// [FestivalOccurrence] instead, so the client never needs to parse it.
@freezed
abstract class HinduFestival with _$HinduFestival {
  const factory HinduFestival({
    required String id,
    required String slug,
    required String nameEnglish,
    String? nameSanskrit,
    String? nameHindi,
    String? deityKey,
    @Default(<String>[]) List<String> regions,
    String? description,
    DateTime? createdAt,
  }) = _HinduFestival;

  factory HinduFestival.fromJson(Map<String, dynamic> json) =>
      _$HinduFestivalFromJson(json);
}
