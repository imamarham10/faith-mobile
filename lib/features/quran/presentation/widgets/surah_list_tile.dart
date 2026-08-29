import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/arabic_text.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../data/dtos/surah.dart';

/// One row in the surah list. Renders the surah number medallion, Arabic
/// name, transliteration + meaning, and a Meccan/Medinan badge.
class SurahListTile extends ConsumerWidget {
  const SurahListTile({super.key, required this.surah, required this.onTap});

  final Surah surah;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isMeccan = surah.revelationPlace.toLowerCase() == 'meccan';

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: cs.outline),
            color: cs.surface,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.base,
            vertical: AppSpacing.base,
          ),
          child: Row(
            children: [
              _NumberMedallion(number: surah.id),
              const SizedBox(width: AppSpacing.base),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surah.nameTransliteration.isNotEmpty
                          ? surah.nameTransliteration
                          : surah.nameEnglish,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        _PlaceBadge(isMeccan: isMeccan),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          '${surah.verseCount} verses',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  surah.nameArabic,
                  textAlign: TextAlign.right,
                  style: arabicTextStyleOf(
                    ref,
                    fontSize: 22,
                    height: 1.4,
                    color: cs.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NumberMedallion extends StatelessWidget {
  const _NumberMedallion({required this.number});

  final int number;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: cs.primaryContainer,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        '$number',
        style: theme.textTheme.labelLarge?.copyWith(color: cs.primary),
      ),
    );
  }
}

class _PlaceBadge extends StatelessWidget {
  const _PlaceBadge({required this.isMeccan});

  final bool isMeccan;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final color = isMeccan ? cs.secondary : cs.primary;
    final textColor = isMeccan
        ? theme.extension<FaithThemeExtension>()!.palette.accentText
        : cs.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        isMeccan ? 'Meccan' : 'Medinan',
        style: theme.textTheme.labelSmall?.copyWith(color: textColor),
      ),
    );
  }
}
