import 'package:freezed_annotation/freezed_annotation.dart';

part 'japa_counter.freezed.dart';
part 'japa_counter.g.dart';

/// A user's japa counter as returned by `/api/v1/hindu/japa/counters`.
///
/// Unlike Dhikr's counter (inconsistent `phraseArabic`/`phraseEnglish`
/// naming), this backend's field names are already consistent:
/// `mantraSanskrit`/`mantraEnglish`. There is no separate transliteration
/// field stored on the counter itself — only the dictionary entry
/// (`JapaPhrase`) carries one, at creation time.
@freezed
abstract class JapaCounter with _$JapaCounter {
  const factory JapaCounter({
    required String id,
    String? userId,
    required String name,
    String? mantraSanskrit,
    String? mantraEnglish,
    @Default(0) int count,
    int? targetCount,
    String? deityKey,
    @Default(true) bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _JapaCounter;

  factory JapaCounter.fromJson(Map<String, dynamic> json) =>
      _$JapaCounterFromJson(json);
}
