import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/sanskrit_text.dart';
import '../../../../shared/reader/verse_page.dart';
import '../controllers/chapter_controller.dart';

/// One śloka on a page: everything Hindu-shaped about [VerseSurface],
/// resolved here and handed in.
///
/// The peer of `QuranVerseSurface`, and the reason both exist: the shared
/// surface draws a verse, and *what a verse is set in* differs per
/// vertical. Three things live at this seam —
///
/// * **the face and leading.** Devanagari hangs mātrās above the śirorekhā
///   and vertical conjuncts below the baseline, so it needs
///   [sanskritLineHeight] and the even leading distribution
///   `sanskritTextStyle` applies — the Devanagari answer to the clipped
///   Arabic marks that put `arabicLineHeight` there.
/// * **direction.** LTR, where the Qur'an surface is RTL.
/// * **the reader's own preferences.** Font size and "show translation"
///   come from [ScriptureReaderPreferencesController] — the same controller
///   the scrolling reader uses, so the slider in its settings sheet governs
///   both readers and a reader who sized the text once has sized it
///   everywhere.
class ShlokaVerseSurface extends ConsumerWidget {
  const ShlokaVerseSurface({
    super.key,
    required this.positionLine,
    required this.sanskritText,
    this.transliteration,
    this.translation,
  });

  final String positionLine;
  final String sanskritText;
  final String? transliteration;
  final String? translation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(scriptureReaderPreferencesControllerProvider);

    return VerseSurface(
      positionLine: positionLine,
      scripture: sanskritText,
      scriptureStyle: sanskritTextStyle(
        fontSize: VerseSurface.displayFontSize(prefs.sanskritFontSize),
        height: sanskritLineHeight,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      transliteration: transliteration,
      translation: translation,
      showTranslation: prefs.showTranslation,
    );
  }
}
