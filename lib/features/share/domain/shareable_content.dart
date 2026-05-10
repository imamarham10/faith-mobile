/// Generic shareable surface — verses, hadiths, names, duas, remedies all
/// reduce to the same set of fields. The card widget renders whatever's
/// non-null in a fixed visual hierarchy:
/// `eyebrow → title → arabic → translation → attribution`.
class ShareableContent {
  const ShareableContent({
    this.eyebrow,
    this.title,
    this.arabic,
    this.translation,
    this.attribution,
  });

  /// Tiny uppercase label above the title (e.g., "Quran", "Hadith").
  final String? eyebrow;

  /// Reference / heading (e.g., "Al-Fatihah · 1:1", "Sahih al-Bukhari #6115").
  final String? title;

  /// Arabic body — rendered RTL with the user's selected Arabic script.
  final String? arabic;

  /// Translated body — English (or whichever the verse/hadith stored).
  final String? translation;

  /// Footer source line (e.g., "— Mishary Rashid Alafasy", "Surah Al-Talaq 65:2").
  final String? attribution;
}
