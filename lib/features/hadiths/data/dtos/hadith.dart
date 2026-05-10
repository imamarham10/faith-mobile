import 'package:freezed_annotation/freezed_annotation.dart';

import 'hadith_book.dart';

part 'hadith.freezed.dart';
part 'hadith.g.dart';

/// A single hadith narration.
///
/// Mirrors the backend `hadiths` Prisma model. The optional [book] field is
/// the joined `HadithBook` projection that list endpoints include
/// (`{ name, nameArabic }`); detail responses include the full book.
@freezed
abstract class Hadith with _$Hadith {
  const factory Hadith({
    required String id,
    required String bookId,
    required int hadithNumber,
    required String textArabic,
    required String textEnglish,
    String? chapterTitle,
    String? chapterTitleArabic,
    String? narratorChain,
    String? narratorChainArabic,
    String? grade,
    String? reference,
    HadithBook? book,
  }) = _Hadith;

  factory Hadith.fromJson(Map<String, dynamic> json) => _$HadithFromJson(json);
}
