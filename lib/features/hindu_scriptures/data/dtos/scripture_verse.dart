import 'package:freezed_annotation/freezed_annotation.dart';

import 'verse_translation.dart';

part 'scripture_verse.freezed.dart';
part 'scripture_verse.g.dart';

/// A single scripture verse (śloka). Returned nested inside chapter-detail
/// payloads (no `chapter`/`text` back-refs there) and standalone from
/// `/featured`, `/search`, `/verses/:id`, and bookmark payloads (with
/// `chapter`/`text` refs present).
@freezed
abstract class ScriptureVerse with _$ScriptureVerse {
  const factory ScriptureVerse({
    required String id,
    required String textId,
    required String chapterId,
    required int verseNumber,
    required String sanskritText,
    String? transliteration,
    @Default(false) bool isFeatured,
    @Default(<VerseTranslation>[]) List<VerseTranslation> translations,
    VerseChapterRef? chapter,
    VerseTextRef? text,
  }) = _ScriptureVerse;

  factory ScriptureVerse.fromJson(Map<String, dynamic> json) =>
      _$ScriptureVerseFromJson(json);
}

/// Minimal chapter reference nested on standalone verse payloads.
@freezed
abstract class VerseChapterRef with _$VerseChapterRef {
  const factory VerseChapterRef({
    required int chapterNumber,
    String? nameEnglish,
  }) = _VerseChapterRef;

  factory VerseChapterRef.fromJson(Map<String, dynamic> json) =>
      _$VerseChapterRefFromJson(json);
}

/// Minimal text reference nested on standalone verse payloads.
@freezed
abstract class VerseTextRef with _$VerseTextRef {
  const factory VerseTextRef({required String slug, String? nameEnglish}) =
      _VerseTextRef;

  factory VerseTextRef.fromJson(Map<String, dynamic> json) =>
      _$VerseTextRefFromJson(json);
}
