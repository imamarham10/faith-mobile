/// How a reader lays a chapter of scripture out.
///
/// Faith-neutral on purpose. The *routes* a mode resolves to are not — a
/// surah and a Gita chapter live at different paths and carry different
/// query parameters — so each vertical keeps its own route helper
/// (`surahReadingRoute`, `chapterReadingRoute`) next to the screens it
/// names. What both verticals share is the question itself, and the answer
/// the user gave to it.
library;

/// The two ways this app reads a passage of scripture.
///
/// Not a display preference like font size: the two modes are different
/// screens with different navigation, so the choice has to resolve to a
/// *route* before anything is opened.
enum ReadingMode {
  /// The whole chapter in one scroll.
  continuous,

  /// One verse at a time, Back and Next.
  verseByVerse;

  String get label => switch (this) {
    ReadingMode.continuous => 'Scrolling',
    ReadingMode.verseByVerse => 'Verse by verse',
  };

  ReadingMode get other => switch (this) {
    ReadingMode.continuous => ReadingMode.verseByVerse,
    ReadingMode.verseByVerse => ReadingMode.continuous,
  };
}
