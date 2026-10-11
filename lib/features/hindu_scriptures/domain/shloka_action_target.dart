import '../data/dtos/scripture_verse.dart';

/// Everything the per-verse actions — bookmark, share, narration — need to
/// know about the śloka they are acting on.
///
/// The peer of the Qur'an's `AyahActionTarget`, and it exists for the same
/// reason: the actions are offered from two surfaces (the scrolling
/// reader's sheet and the pager's pinned bar), and a verse alone does not
/// carry enough to label, attribute or bookmark itself. [ScriptureVerse]
/// knows its number and its text but not which chapter of which book it is
/// in — the chapter payload holds that — so the two meet here rather than
/// in four parameters threaded through every call site.
class ShlokaActionTarget {
  const ShlokaActionTarget({
    required this.verseId,
    required this.textSlug,
    required this.textName,
    required this.chapterNumber,
    required this.chapterTitle,
    required this.verseNumber,
    required this.sanskritText,
    this.transliteration,
    this.translation,
  });

  /// From a chapter payload's verse, plus what the enclosing chapter and
  /// text know about themselves.
  factory ShlokaActionTarget.fromVerse(
    ScriptureVerse verse, {
    required String textSlug,
    required String textName,
    required int chapterNumber,
    required String chapterTitle,
  }) => ShlokaActionTarget(
    verseId: verse.id,
    textSlug: textSlug,
    textName: textName,
    chapterNumber: chapterNumber,
    chapterTitle: chapterTitle,
    verseNumber: verse.verseNumber,
    sanskritText: verse.sanskritText,
    transliteration: verse.transliteration,
    translation: verse.translations.isNotEmpty
        ? verse.translations.first.text
        : null,
  );

  /// The server's verse id — what bookmarks are keyed on, here and on the
  /// backend's `(userId, verseId)` upsert.
  final String verseId;

  final String textSlug;

  /// "Bhagavad Gita" — the book, for the label and the share attribution.
  final String textName;

  final int chapterNumber;

  /// "Sankhya Yoga" — the chapter, for the narration the player announces.
  final String chapterTitle;

  final int verseNumber;

  final String sanskritText;
  final String? transliteration;
  final String? translation;

  /// "Bhagavad Gita · 2:47" — the one label every action surface uses.
  String get label => '$textName · $chapterNumber:$verseNumber';

  /// "— Bhagavad Gita 2:47", for the share card's footer.
  String get attribution => '— $textName $chapterNumber:$verseNumber';
}
