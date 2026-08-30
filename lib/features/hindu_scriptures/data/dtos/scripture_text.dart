import 'package:freezed_annotation/freezed_annotation.dart';

import 'scripture_chapter.dart';

part 'scripture_text.freezed.dart';
part 'scripture_text.g.dart';

/// A scripture text summary — one entry in `GET /texts` (Gita, Ramayana,
/// Sahasranama, Chalisa, Upanishad, Purana, ...). `type` is a free-form
/// backend string, not an enum, so new text types don't require a client
/// update.
@freezed
abstract class ScriptureText with _$ScriptureText {
  const factory ScriptureText({
    required String id,
    required String slug,
    required String nameEnglish,
    required String nameSanskrit,
    required String type,
    required int totalVerses,
    @Default(false) bool isPremium,
    int? chapterCount,
  }) = _ScriptureText;

  factory ScriptureText.fromJson(Map<String, dynamic> json) =>
      _$ScriptureTextFromJson(json);
}

/// A text with its chapter list — `GET /texts/:slug`.
@freezed
abstract class ScriptureTextDetail with _$ScriptureTextDetail {
  const factory ScriptureTextDetail({
    required String id,
    required String slug,
    required String nameEnglish,
    required String nameSanskrit,
    required String type,
    required int totalVerses,
    @Default(false) bool isPremium,
    @Default(<ChapterSummary>[]) List<ChapterSummary> chapters,
  }) = _ScriptureTextDetail;

  factory ScriptureTextDetail.fromJson(Map<String, dynamic> json) =>
      _$ScriptureTextDetailFromJson(json);
}
