import 'package:freezed_annotation/freezed_annotation.dart';

part 'hindu_remedy.freezed.dart';

/// A single remedy attached to a [HinduEmotion] — a Gita verse (flattened,
/// not a nested `ScriptureVerse`: the remedy payload's `verse` sub-object
/// omits `textId`/`chapterId`/`isFeatured`, which `ScriptureVerse` requires,
/// and its `translations` entries omit `id`, which `VerseTranslation`
/// requires — so reusing either DTO directly would throw on a field that's
/// simply absent here rather than actually missing data) plus a short
/// reflective [note] explaining why this verse was matched to the mood.
///
/// No `fromJson`/`part '.g.dart'` here — parsed via [parse], not
/// json_serializable, mirroring Islam's `Remedy.parse` tolerant-parsing
/// approach for the same reason: the nested shape needs hand-written
/// null-safe digging, not a straight decode.
@freezed
abstract class HinduRemedy with _$HinduRemedy {
  const factory HinduRemedy({
    required String id,
    required String note,
    @Default(0) int sequence,
    required String sanskritText,
    String? transliteration,
    required int verseNumber,
    int? chapterNumber,
    String? textSlug,
    String? textNameEnglish,
    String? translationText,
  }) = _HinduRemedy;

  const HinduRemedy._();

  static HinduRemedy parse(Map<String, dynamic> json) {
    final verse = json['verse'] as Map<String, dynamic>? ?? const {};
    final chapter = verse['chapter'] as Map<String, dynamic>?;
    final text = verse['text'] as Map<String, dynamic>?;
    final translations =
        (verse['translations'] as List?)
            ?.whereType<Map<String, dynamic>>()
            .toList() ??
        const <Map<String, dynamic>>[];

    return HinduRemedy(
      id: json['id'] as String? ?? '',
      note: json['note'] as String? ?? '',
      sequence: json['sequence'] as int? ?? 0,
      sanskritText: verse['sanskritText'] as String? ?? '',
      transliteration: verse['transliteration'] as String?,
      verseNumber: verse['verseNumber'] as int? ?? 0,
      chapterNumber: chapter?['chapterNumber'] as int?,
      textSlug: text?['slug'] as String?,
      textNameEnglish: text?['nameEnglish'] as String?,
      translationText: translations.isNotEmpty
          ? translations.first['text'] as String?
          : null,
    );
  }

  /// `Bhagavad Gita 2.47` — falls back gracefully as fields go missing.
  String get reference {
    final name = textNameEnglish ?? 'Bhagavad Gita';
    if (chapterNumber == null) return name;
    return '$name $chapterNumber.$verseNumber';
  }
}
