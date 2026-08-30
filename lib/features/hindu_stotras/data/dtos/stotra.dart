import 'package:freezed_annotation/freezed_annotation.dart';

import 'stotra_category.dart';
import 'stotra_verse.dart';

part 'stotra.freezed.dart';
part 'stotra.g.dart';

/// A stotra list item — `GET /` and `GET /search`. Lighter than
/// [StotraDetail]: no `categoryId`, `createdAt`, or `verses`, but adds a
/// computed `verseCount`.
@freezed
abstract class Stotra with _$Stotra {
  const factory Stotra({
    required String id,
    required String slug,
    required String titleSanskrit,
    required String titleEnglish,
    required String type,
    String? deityKey,
    @Default(false) bool isPremium,
    StotraCategoryRef? category,
    @Default(0) int verseCount,
  }) = _Stotra;

  factory Stotra.fromJson(Map<String, dynamic> json) => _$StotraFromJson(json);
}

/// Full stotra detail — `GET /:slug`.
@freezed
abstract class StotraDetail with _$StotraDetail {
  const factory StotraDetail({
    required String id,
    required String categoryId,
    required String slug,
    required String titleSanskrit,
    required String titleEnglish,
    required String type,
    String? deityKey,
    @Default(false) bool isPremium,
    DateTime? createdAt,
    StotraCategoryRef? category,
    @Default(<StotraVerse>[]) List<StotraVerse> verses,
  }) = _StotraDetail;

  factory StotraDetail.fromJson(Map<String, dynamic> json) =>
      _$StotraDetailFromJson(json);
}
