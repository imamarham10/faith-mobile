import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../../../core/theme/sanskrit_text.dart';
import '../../data/dtos/scripture_verse.dart';

/// Renders a single verse: Sanskrit (Devanagari, large), a verse-number
/// medallion, and (optionally) the first available translation.
///
/// Deliberately plain — per the same "don't over-decorate reading
/// surfaces" note as Quran's `ayah_view.dart`, this stays a focused
/// reading block rather than a thick-outlined poppy card; the poppy
/// language belongs on the surrounding chrome (top bar, list, mini
/// player), not the verse text itself.
class VerseView extends StatelessWidget {
  const VerseView({
    super.key,
    required this.verse,
    required this.sanskritFontSize,
    required this.showTranslation,
    required this.isPlaying,
    required this.isBookmarked,
    required this.onTap,
    required this.onLongPress,
  });

  final ScriptureVerse verse;
  final double sanskritFontSize;
  final bool showTranslation;
  final bool isPlaying;
  final bool isBookmarked;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final accentText = theme
        .extension<FaithThemeExtension>()!
        .palette
        .accentText;
    final translation = verse.translations.isNotEmpty
        ? verse.translations.first.text
        : null;

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.md),
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.base,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.md),
          color: isPlaying
              ? cs.primaryContainer.withValues(alpha: 0.45)
              : Colors.transparent,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              verse.sanskritText,
              style: sanskritTextStyle(
                fontSize: sanskritFontSize,
                height: sanskritLineHeight,
                color: cs.onSurface,
              ),
            ),
            if ((verse.transliteration ?? '').isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                verse.transliteration!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: cs.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                _VerseMedallion(
                  number: verse.verseNumber,
                  isPlaying: isPlaying,
                ),
                const SizedBox(width: AppSpacing.sm),
                if (isBookmarked)
                  Icon(Icons.bookmark, size: 16, color: accentText),
                const Spacer(),
                if (isPlaying)
                  Icon(Icons.graphic_eq_rounded, size: 18, color: cs.primary),
              ],
            ),
            if (showTranslation && translation != null) ...[
              const SizedBox(height: AppSpacing.md),
              Text(translation, style: theme.textTheme.bodyLarge),
            ],
          ],
        ),
      ),
    );
  }
}

class _VerseMedallion extends StatelessWidget {
  const _VerseMedallion({required this.number, required this.isPlaying});

  final int number;
  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final fg = isPlaying ? cs.primary : cs.onSurfaceVariant;
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: fg.withValues(alpha: 0.4), width: 1.2),
      ),
      alignment: Alignment.center,
      child: Text(
        '$number',
        style: theme.textTheme.labelSmall?.copyWith(color: fg),
      ),
    );
  }
}
