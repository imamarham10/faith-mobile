import 'package:faith_mobile/core/preferences/arabic_script.dart';
import 'package:faith_mobile/core/preferences/arabic_script_text.dart';
import 'package:flutter_test/flutter_test.dart';

/// The Indo-Pak text is not renderable as it arrives.
///
/// It carries about 1,383 waqf signs drawn in the Unicode **Private Use
/// Area** — U+E003, U+E004, U+E01A–E01F, U+E021, U+E022 — which the Indo-Pak
/// print tradition uses and Unicode never encoded. Checked against their
/// cmaps, Scheherazade New, Amiri Quran and Noto Naskh Arabic map **none**
/// of them, and the app bundles no font of its own, so shipping the text
/// verbatim would put a tofu box at every one of those places in the
/// mushaf.
///
/// The fixtures below are the real Quran.com Indo-Pak text of 7:10 and 7:29
/// — the second has two of the signs, plus ZWSP, EN SPACE, RLM and a pair
/// of trailing U+FEFF. A test over invented strings would not have caught
/// any of this.
void main() {
  const v710 = 'وَلَقَدۡ مَكَّـنّٰكُمۡ فِى الۡاَرۡضِ وَجَعَلۡنَا لَـكُمۡ فِيۡهَا مَعَايِشَ ؕ قَلِيۡلًا مَّا تَشۡكُرُوۡنَ\uE022\u200F';
  const v729 = 'قُلۡ اَمَرَ رَبِّىۡ بِالۡقِسۡطِ\u200B\uE01E وَاَقِيۡمُوۡا وُجُوۡهَكُمۡ عِنۡدَ كُلِّ مَسۡجِدٍ وَّادۡعُوۡهُ مُخۡلِصِيۡنَ لَـهُ الدِّيۡنَ\uE021 \u200B \u2002 ؕ كَمَا بَدَاَكُمۡ تَعُوۡدُوۡنَؕ\u200F \uFEFF\uFEFF';

  String render(String indopak) => arabicTextForScript(
    ArabicScript.indoPak,
    textArabic: 'uthmani-family fallback',
    textIndopak: indopak,
  );

  bool hasPrivateUse(String s) =>
      s.runes.any((r) => r >= 0xE000 && r <= 0xF8FF);

  group('private-use waqf signs', () {
    test('the fixtures really do carry them — else this file proves nothing', () {
      expect(hasPrivateUse(v710), isTrue);
      expect(hasPrivateUse(v729), isTrue);
    });

    test('none survive to the screen', () {
      expect(hasPrivateUse(render(v710)), isFalse);
      expect(hasPrivateUse(render(v729)), isFalse);
    });

    test('every Arabic letter and mark survives', () {
      // Only the unrenderable characters go. The verse is scripture; this
      // filter is allowed to drop what no font can draw and nothing else.
      final kept = render(v729).runes.where((r) => r >= 0x0600 && r <= 0x06FF);
      final original = v729.runes.where((r) => r >= 0x0600 && r <= 0x06FF);
      expect(kept, orderedEquals(original));
    });

    test('the gap a removed sign leaves does not stay open', () {
      // 7:29 spaces its signs with U+2002; dropping one between two of them
      // would otherwise leave a visible hole mid-verse.
      expect(render(v729), isNot(contains('  ')));
      expect(render(v729), isNot(contains('\u2002\u2002')));
    });

    test('a verse with none of them is returned unchanged but for its edges', () {
      const clean = 'بِسۡمِ اللّٰهِ الرَّحۡمٰنِ الرَّحِيۡمِ';
      expect(render(clean), clean);
    });
  });

  group('what must not be touched', () {
    test('the text is never NFC-normalised', () {
      // NFC changes 5,703 of 6,236 verses, and in 1,242 of them composes
      // alef + maddah into U+0622 — a character the mushaf does not have.
      const decomposed = 'لِلۡمَلٰ\u0653ٮِٕكَةِ';
      final out = render(decomposed);
      expect(out, contains('\u0653'));
      expect(out, isNot(contains('\u0622')));
    });

    test('shaping and direction controls inside the verse are left alone', () {
      // ZWSP and RLM do work here. A mid-string U+FEFF is not a BOM.
      final out = render(v729);
      expect(out, contains('\u200B'));
      expect(out, contains('\u200F'));
    });
  });

  test('the fallback path is unaffected by any of this', () {
    expect(
      arabicTextForScript(
        ArabicScript.indoPak,
        textArabic: 'uthmani-family fallback',
      ),
      'uthmani-family fallback',
    );
  });
}
