import 'package:freezed_annotation/freezed_annotation.dart';

part 'verse_translation.freezed.dart';
part 'verse_translation.g.dart';

/// One translation of a scripture verse. Verses carry an array of these
/// (server-side filtered by the `lang` query param), unlike the Quran
/// module's single-translation-per-verse shape.
@freezed
abstract class VerseTranslation with _$VerseTranslation {
  const factory VerseTranslation({
    required String id,
    required String languageCode,
    required String authorName,
    required String text,
  }) = _VerseTranslation;

  factory VerseTranslation.fromJson(Map<String, dynamic> json) =>
      _$VerseTranslationFromJson(json);
}
