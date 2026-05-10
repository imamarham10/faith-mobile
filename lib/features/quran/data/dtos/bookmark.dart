import 'package:freezed_annotation/freezed_annotation.dart';

part 'bookmark.freezed.dart';
part 'bookmark.g.dart';

/// A bookmarked verse. Persisted server-side when the user is authenticated;
/// also mirrored to local `shared_preferences` so the bookmark list works
/// offline and the toggle is instant.
@freezed
abstract class Bookmark with _$Bookmark {
  const factory Bookmark({
    required String id,
    required int surahId,
    required int verseNumber,
    String? surahName,
    String? textArabic,
    String? translation,
    DateTime? createdAt,
  }) = _Bookmark;

  factory Bookmark.fromJson(Map<String, dynamic> json) =>
      _$BookmarkFromJson(json);
}
