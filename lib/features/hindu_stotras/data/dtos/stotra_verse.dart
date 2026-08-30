import 'package:freezed_annotation/freezed_annotation.dart';

import 'stotra_translation.dart';

part 'stotra_verse.freezed.dart';
part 'stotra_verse.g.dart';

/// A single verse of a stotra, nested inside `StotraDetail.verses`.
@freezed
abstract class StotraVerse with _$StotraVerse {
  const factory StotraVerse({
    required String id,
    required String stotraId,
    required int verseNumber,
    required String sanskritText,
    String? transliteration,
    @Default(<StotraTranslation>[]) List<StotraTranslation> translations,
  }) = _StotraVerse;

  factory StotraVerse.fromJson(Map<String, dynamic> json) =>
      _$StotraVerseFromJson(json);
}
