import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/sanskrit_text.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../data/dtos/scripture_text.dart';

/// One row in the scripture text list. Number-free (unlike Quran's 114
/// numbered surahs, there are only a handful of named texts), so this
/// leads with the Sanskrit name medallion instead of an index number.
class TextCard extends StatelessWidget {
  const TextCard({super.key, required this.text, required this.onTap});

  final ScriptureText text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

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
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              text.nameEnglish.isNotEmpty ? text.nameEnglish[0] : '?',
              style: theme.textTheme.titleLarge?.copyWith(color: cs.primary),
            ),
          ),
          const SizedBox(width: AppSpacing.base),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text.nameEnglish, style: theme.textTheme.titleMedium),
                const SizedBox(height: 2),
                Text(
                  '${text.totalVerses} verses',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            text.nameSanskrit,
            style: sanskritTextStyle(fontSize: 22, color: cs.onSurface),
          ),
        ],
      ),
    );
  }
}
