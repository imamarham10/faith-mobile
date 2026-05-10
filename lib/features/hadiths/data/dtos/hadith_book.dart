import 'package:freezed_annotation/freezed_annotation.dart';

part 'hadith_book.freezed.dart';
part 'hadith_book.g.dart';

/// Metadata for a hadith collection (e.g. Sahih al-Bukhari).
///
/// Mirrors the backend `hadith_books` Prisma model. `totalHadiths` is the
/// authoritative count from the seed; the API may also project a slimmer
/// `{ name, nameArabic }` projection in nested `book` fields.
@freezed
abstract class HadithBook with _$HadithBook {
  const factory HadithBook({
    // List endpoints (`/hadiths` paginated feed) embed a slim `{name, nameArabic}`
    // projection without `id` — keep nullable so json_serializable doesn't
    // throw a TypeError on the null cast.
    String? id,
    required String name,
    String? nameArabic,
    String? author,
    String? authorArabic,
    @Default(0) int totalHadiths,
    @Default(false) bool isPremium,
    String? description,
    @Default(0) int sortOrder,
  }) = _HadithBook;

  factory HadithBook.fromJson(Map<String, dynamic> json) =>
      _$HadithBookFromJson(json);
}
