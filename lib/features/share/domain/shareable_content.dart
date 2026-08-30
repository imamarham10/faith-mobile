/// Generic shareable surface — verses, hadiths, names, duas, remedies all
/// reduce to the same set of fields. The card widget renders whatever's
/// non-null in a fixed visual hierarchy:
/// `eyebrow → title → arabic → translation → attribution`.
class ShareableContent {
  const ShareableContent({
    this.eyebrow,
    this.title,
    this.arabic,
    this.sanskrit,
    this.translation,
    this.attribution,
  }) : assert(
         arabic == null || sanskrit == null,
         'Pass either arabic or sanskrit, not both — they render with '
         'different direction/font and the card only has room for one '
         'native-script body block.',
       );

  /// Tiny uppercase label above the title (e.g., "Quran", "Hadith").
  final String? eyebrow;

  /// Reference / heading (e.g., "Al-Fatihah · 1:1", "Sahih al-Bukhari #6115").
  final String? title;

  /// Arabic body — rendered RTL with the user's selected Arabic script.
  final String? arabic;

  /// Devanagari/Sanskrit body — rendered LTR with a fixed Devanagari font.
  /// Kept as a separate field from [arabic] rather than reusing it: that
  /// field is hardcoded to RTL direction + the Arabic-script preference
  /// font, which would render Sanskrit backwards in the wrong glyphs.
  final String? sanskrit;

  /// Translated body — English (or whichever the verse/hadith stored).
  final String? translation;

  /// Footer source line (e.g., "— Mishary Rashid Alafasy", "Surah Al-Talaq 65:2").
  final String? attribution;
}
