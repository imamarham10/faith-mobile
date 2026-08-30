import 'package:freezed_annotation/freezed_annotation.dart';

part 'scripture_bookmark.freezed.dart';
part 'scripture_bookmark.g.dart';

/// A bookmarked verse, flattened for local storage — mirrors the Quran
/// module's `Bookmark` shape (local mirror is canonical; server is
/// best-effort). Note the backend's `GET /bookmarks` response nests these
/// fields under a `verse` object (`{ id, note, createdAt, verse: {...} }`);
/// [ScriptureBookmark.fromServerJson] flattens that shape, while the plain
/// [ScriptureBookmark.fromJson]/`toJson` pair (already-flat) is used for the
/// local `shared_preferences` round-trip.
@freezed
abstract class ScriptureBookmark with _$ScriptureBookmark {
  const factory ScriptureBookmark({
    required String id,
    required String verseId,
    String? note,
    String? textSlug,
    String? textName,
    int? chapterNumber,
    String? sanskritText,
    int? verseNumber,
    String? translation,
    DateTime? createdAt,
  }) = _ScriptureBookmark;

  factory ScriptureBookmark.fromJson(Map<String, dynamic> json) =>
      _$ScriptureBookmarkFromJson(json);

  factory ScriptureBookmark.fromServerJson(Map<String, dynamic> json) {
    final verse = json['verse'] as Map<String, dynamic>?;
    final chapter = verse?['chapter'] as Map<String, dynamic>?;
    final text = verse?['text'] as Map<String, dynamic>?;
    final translations = verse?['translations'] as List<dynamic>?;
    final firstTranslation = translations != null && translations.isNotEmpty
        ? translations.first as Map<String, dynamic>?
        : null;
    return ScriptureBookmark(
      id: json['id'] as String,
      verseId: (verse?['id'] as String?) ?? '',
      note: json['note'] as String?,
      textSlug: text?['slug'] as String?,
      textName: text?['nameEnglish'] as String?,
      chapterNumber: chapter?['chapterNumber'] as int?,
      sanskritText: verse?['sanskritText'] as String?,
      verseNumber: verse?['verseNumber'] as int?,
      translation: firstTranslation?['text'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }
}
