import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../data/dtos/juz.dart';

/// One row in the juz list: the juz number, the surahs it runs between, and
/// how many verses that is.
///
/// A card, with the press shadow, because it is a button — it opens the
/// reader. That is the same reason the decorative parts of this feature are
/// not cards.
class JuzListTile extends StatelessWidget {
  const JuzListTile({super.key, required this.juz, required this.onTap});

  final JuzSummary juz;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PoppyCard(
      radius: AppRadius.lg,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.base,
        vertical: AppSpacing.base,
      ),
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Row(
        children: [
          _JuzMedallion(number: juz.number),
          const SizedBox(width: AppSpacing.base),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Juz ${juz.number}', style: theme.textTheme.titleMedium),
                const SizedBox(height: 2),
                Text(
                  // Both ends name their own surah because a juz rarely
                  // starts or ends on a surah boundary.
                  '${juz.start.surahName} ${juz.start.verseNumber}'
                  '  –  ${juz.end.surahName} ${juz.end.verseNumber}',
                  style: theme.textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            '${juz.verseCount}\nverses',
            textAlign: TextAlign.right,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _JuzMedallion extends StatelessWidget {
  const _JuzMedallion({required this.number});

  final int number;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: cs.secondaryContainer,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        '$number',
        style: theme.textTheme.labelLarge?.copyWith(
          color: cs.onSecondaryContainer,
        ),
      ),
    );
  }
}
