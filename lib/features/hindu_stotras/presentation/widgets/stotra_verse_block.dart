import 'package:flutter/material.dart';

import '../../../../core/theme/sanskrit_text.dart';
import '../../data/dtos/stotra_verse.dart';

/// A single verse block: Sanskrit (Devanagari, LTR), transliteration, and
/// the first available translation. Mirrors `DuaArabicBlock`'s elevated
/// typography but drops the RTL wrapper — Devanagari reads left-to-right,
/// unlike duas' Arabic body.
class StotraVerseBlock extends StatelessWidget {
  const StotraVerseBlock({super.key, required this.verse, this.fontSize = 26});

  final StotraVerse verse;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final translation = verse.translations.isNotEmpty
        ? verse.translations.first.text
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          verse.sanskritText,
          style: sanskritTextStyle(
            fontSize: fontSize,
            height: 1.9,
            color: cs.onSurface,
          ),
        ),
        if ((verse.transliteration ?? '').isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            verse.transliteration!,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontStyle: FontStyle.italic,
              color: cs.onSurfaceVariant,
            ),
          ),
        ],
        if (translation != null) ...[
          const SizedBox(height: 8),
          Text(translation, style: theme.textTheme.bodyLarge),
        ],
      ],
    );
  }
}
