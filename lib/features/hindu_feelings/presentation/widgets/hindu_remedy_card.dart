import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../../../core/theme/sanskrit_text.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../data/dtos/hindu_remedy.dart';

/// Display card for a single Hindu remedy — the matched verse's Sanskrit,
/// transliteration, and translation, led by its short reflective [note]
/// (the whole reason this specific verse was picked for the mood — unlike
/// Islam's `RemedyCard`, which has no per-remedy commentary to show).
/// Mirrors `DailyShlokaCard`'s Sanskrit/LTR styling and its tap-through to
/// the real chapter reader.
class HinduRemedyCard extends StatelessWidget {
  const HinduRemedyCard({super.key, required this.remedy});

  final HinduRemedy remedy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final accentText = theme
        .extension<FaithThemeExtension>()!
        .palette
        .accentText;
    final hasTranslit = (remedy.transliteration ?? '').trim().isNotEmpty;
    final canNavigate = remedy.textSlug != null && remedy.chapterNumber != null;

    return PoppyCard(
      radius: AppRadius.lg,
      padding: const EdgeInsets.all(24),
      onTap: canNavigate
          ? () {
              HapticFeedback.lightImpact();
              context.push(
                '/quran/hindu-scripture/${remedy.textSlug}/'
                '${remedy.chapterNumber}?verse=${remedy.verseNumber}',
              );
            }
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (remedy.note.trim().isNotEmpty) ...[
            Text(
              remedy.note,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 16),
          ],
          Text(
            remedy.sanskritText,
            style: sanskritTextStyle(
              fontSize: 20,
              height: 1.7,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 40,
            height: 1,
            color: cs.secondary.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          if (hasTranslit) ...[
            Text(
              remedy.transliteration!,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 12),
          ],
          if ((remedy.translationText ?? '').isNotEmpty)
            Text(remedy.translationText!, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 12),
          Text(
            remedy.reference.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(color: accentText),
          ),
        ],
      ),
    );
  }
}
