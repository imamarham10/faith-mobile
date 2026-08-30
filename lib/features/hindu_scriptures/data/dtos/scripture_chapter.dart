import 'package:freezed_annotation/freezed_annotation.dart';

import 'scripture_verse.dart';

part 'scripture_chapter.freezed.dart';
part 'scripture_chapter.g.dart';

/// Chapter summary — one entry in `GET /texts/:slug`'s `chapters` array.
/// No verses here; use [ChapterDetail] (from the dedicated chapter
/// endpoint) once the reader opens a specific chapter.
@freezed
abstract class ChapterSummary with _$ChapterSummary {
  const factory ChapterSummary({
    required String id,
    required String textId,
    required int chapterNumber,
    String? nameSanskrit,
    String? nameEnglish,
    required int verseCount,
  }) = _ChapterSummary;

  factory ChapterSummary.fromJson(Map<String, dynamic> json) =>
      _$ChapterSummaryFromJson(json);
}

/// A chapter with all its verses — `GET /texts/:slug/chapters/:n`.
@freezed
abstract class ChapterDetail with _$ChapterDetail {
  const factory ChapterDetail({
    required String id,
    required String textId,
    required int chapterNumber,
    String? nameSanskrit,
    String? nameEnglish,
    @Default(<ScriptureVerse>[]) List<ScriptureVerse> verses,
  }) = _ChapterDetail;

  factory ChapterDetail.fromJson(Map<String, dynamic> json) =>
      _$ChapterDetailFromJson(json);
}
