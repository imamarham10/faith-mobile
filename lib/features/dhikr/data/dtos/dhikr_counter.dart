import 'package:freezed_annotation/freezed_annotation.dart';

part 'dhikr_counter.freezed.dart';
part 'dhikr_counter.g.dart';

/// A user's dhikr counter as returned by `/api/v1/islam/dhikr/counters`.
///
/// The backend uses inconsistent field names — `name`, `phraseArabic`,
/// `phraseEnglish` — which we surface here. Transliteration and meaning are
/// optional dictionary-style enrichment for UI; the server may not return
/// them and the dictionary fills the gap.
@freezed
abstract class DhikrCounter with _$DhikrCounter {
  const factory DhikrCounter({
    required String id,
    String? userId,
    required String name,
    String? phraseArabic,
    String? phraseEnglish,
    String? phraseTransliteration,
    String? meaning,
    @Default(0) int count,
    @Default(33) int targetCount,
    @Default(true) bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _DhikrCounter;

  factory DhikrCounter.fromJson(Map<String, dynamic> json) =>
      _$DhikrCounterFromJson(json);
}
