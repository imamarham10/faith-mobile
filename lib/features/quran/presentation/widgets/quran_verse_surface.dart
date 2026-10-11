import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/preferences/arabic_script_text.dart';
import '../../../../core/theme/arabic_text.dart';
import '../../../../shared/reader/verse_page.dart';
import '../controllers/surah_controller.dart';

/// One ayah on a page: everything Qur'an-shaped about [VerseSurface],
/// resolved here and handed in.
///
/// Three things live at this seam and nowhere else, because all three are
/// about the Qur'an rather than about reading a verse:
///
/// * **which orthography.** The payload carries up to three spellings and
///   the reader's script preference picks one, falling back to `textArabic`
///   when the preferred text is absent.
/// * **which face and leading.** `arabicTextStyle` chooses both from the
///   script — Indo-Pak's stacked sukuns and Uthmani's superscript alef want
///   different amounts of air, and at display size the difference is no
///   longer academic.
/// * **the reader's own preferences.** Font size and "show translation"
///   come from the Qur'an reader's controller, which the Hindu reader does
///   not have and must not be made to borrow.
class QuranVerseSurface extends ConsumerWidget {
  const QuranVerseSurface({
    super.key,
    required this.positionLine,
    required this.textArabic,
    this.textUthmani,
    this.textIndopak,
    this.translation,
  });

  final String positionLine;
  final String textArabic;
  final String? textUthmani;
  final String? textIndopak;
  final String? translation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(readerPreferencesControllerProvider);
    final script = activeArabicScript(ref);

    return VerseSurface(
      positionLine: positionLine,
      scripture: arabicTextForScript(
        script,
        textArabic: textArabic,
        textIndopak: textIndopak,
        textUthmani: textUthmani,
      ),
      scriptureStyle: arabicTextStyle(
        script,
        fontSize: VerseSurface.displayFontSize(prefs.arabicFontSize),
        color: Theme.of(context).colorScheme.onSurface,
      ),
      scriptureDirection: TextDirection.rtl,
      translation: translation,
      showTranslation: prefs.showTranslation,
    );
  }
}
