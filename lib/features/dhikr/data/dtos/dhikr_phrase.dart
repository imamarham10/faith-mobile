import 'package:freezed_annotation/freezed_annotation.dart';

part 'dhikr_phrase.freezed.dart';
part 'dhikr_phrase.g.dart';

/// A dictionary entry — predefined dhikr phrase the user can spin up a
/// counter for in one tap. Returned by `/api/v1/islam/dhikr/dictionary`.
///
/// When the endpoint is unavailable we fall back to a small built-in list
/// so the New Counter sheet always has Suggested entries.
@freezed
abstract class DhikrPhrase with _$DhikrPhrase {
  const factory DhikrPhrase({
    required String id,
    required String phraseArabic,
    required String phraseTransliteration,
    required String meaning,
    @Default(33) int recommendedCount,
  }) = _DhikrPhrase;

  factory DhikrPhrase.fromJson(Map<String, dynamic> json) =>
      _$DhikrPhraseFromJson(json);
}
