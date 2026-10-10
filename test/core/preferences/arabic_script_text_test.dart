import 'package:faith_mobile/core/preferences/arabic_script.dart';
import 'package:faith_mobile/core/preferences/arabic_script_text.dart';
import 'package:flutter_test/flutter_test.dart';

/// The script preference's whole job: it selects a *text*, not a font.
///
/// The strings here are the real 2:142 in each orthography, because the
/// thing under test is that they are different strings — a test with
/// `'a'`/`'b'` would pass just as happily against the bug this replaces.
void main() {
  // `ٱلَّتِى كَانُوا۟` — alef-wasla, dotless ya, small high rounded zero.
  const uthmani =
      'سَيَقُولُ ٱلسُّفَهَآءُ مِنَ ٱلنَّاسِ مَا وَلَّىٰهُمْ عَن قِبْلَتِهِمُ '
      'ٱلَّتِى كَانُوا۟ عَلَيْهَا';
  // `الَّتِیْ كَانُوۡا` — plain alef-lam, explicit sukun, U+0615 waqf mark.
  const indopak =
      'سَیَقُوۡلُ السُّفَهَآءُ مِنَ النَّاسِ مَا وَلّٰىهُمۡ عَنۡ قِبۡلَتِهِمُ '
      'الَّتِیۡ كَانُوۡا عَلَيۡهَاؕ';
  // What every payload carries, and what the app rendered before any of
  // this existed.
  const fallback = 'سَيَقُولُ ٱلسُّفَهَآءُ مِنَ ٱلنَّاسِ';

  String pick(
    ArabicScript script, {
    String? indoPakText,
    String? uthmaniText,
  }) => arabicTextForScript(
    script,
    textArabic: fallback,
    textIndopak: indoPakText,
    textUthmani: uthmaniText,
  );

  group('with every script present', () {
    test('Indo-Pak takes the Indo-Pak text', () {
      expect(
        pick(
          ArabicScript.indoPak,
          indoPakText: indopak,
          uthmaniText: uthmani,
        ),
        indopak,
      );
    });

    test('Uthmani takes the Uthmani text', () {
      expect(
        pick(
          ArabicScript.uthmani,
          indoPakText: indopak,
          uthmaniText: uthmani,
        ),
        uthmani,
      );
    });

    test('Naskh takes the payload text it has always rendered', () {
      expect(
        pick(ArabicScript.naskh, indoPakText: indopak, uthmaniText: uthmani),
        fallback,
      );
    });

    test('the three selections are genuinely different text', () {
      final picked = {
        for (final s in ArabicScript.values)
          pick(s, indoPakText: indopak, uthmaniText: uthmani),
      };
      expect(
        picked,
        hasLength(3),
        reason: 'if two scripts resolve to one string the preference is '
            'back to swapping fonts over fixed Unicode',
      );
    });
  });

  group('falling back', () {
    test('a null textIndopak still renders the verse', () {
      // The live state of the API today: additive field, not yet seeded.
      expect(pick(ArabicScript.indoPak, uthmaniText: uthmani), fallback);
    });

    test('a null textUthmani still renders the verse', () {
      // The live state of the *surah* payload, which carries no Uthmani
      // variant at all.
      expect(pick(ArabicScript.uthmani, indoPakText: indopak), fallback);
    });

    test('an empty string counts as absent, not as an empty verse', () {
      expect(pick(ArabicScript.indoPak, indoPakText: ''), fallback);
      expect(pick(ArabicScript.uthmani, uthmaniText: ''), fallback);
    });

    test('a whitespace-only string counts as absent', () {
      // A half-run seed writes blanks, not nulls.
      expect(pick(ArabicScript.indoPak, indoPakText: '   \n'), fallback);
    });

    test('no script can ever resolve to nothing', () {
      for (final script in ArabicScript.values) {
        expect(pick(script), isNotEmpty, reason: '$script rendered blank');
      }
    });
  });
}
