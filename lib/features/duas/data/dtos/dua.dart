import 'package:freezed_annotation/freezed_annotation.dart';

import 'dua_category.dart';

part 'dua.freezed.dart';
part 'dua.g.dart';

/// A single supplication.
///
/// Field names mirror the backend `duas` Prisma model:
/// `titleArabic`, `titleEnglish`, `textArabic`, `textEnglish`,
/// `textTransliteration` (optional), `reference` (optional).
@freezed
abstract class Dua with _$Dua {
  const factory Dua({
    required String id,
    required String categoryId,
    required String titleArabic,
    required String titleEnglish,
    required String textArabic,
    required String textEnglish,
    String? textTransliteration,
    String? reference,
    String? audioUrl,
    DuaCategory? category,
  }) = _Dua;

  factory Dua.fromJson(Map<String, dynamic> json) => _$DuaFromJson(json);
}
