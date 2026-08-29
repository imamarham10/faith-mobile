import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/arabic_text.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../data/dtos/verse.dart';

/// Renders a single ayah: Arabic (right-aligned, large), the ayah-number
/// medallion, and (optionally) the English translation.
class AyahView extends ConsumerWidget {
  const AyahView({
    super.key,
    required this.verse,
    required this.arabicFontSize,
    required this.showTranslation,
    required this.isPlaying,
    required this.isBookmarked,
    required this.onTap,
    required this.onLongPress,
  });

  final Verse verse;
  final double arabicFontSize;
  final bool showTranslation;
  final bool isPlaying;
  final bool isBookmarked;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      onLongPress: () {
        HapticFeedback.lightImpact();
        onLongPress();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
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
            Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                verse.textArabic,
                textAlign: TextAlign.right,
                style: arabicTextStyleOf(
                  ref,
                  fontSize: arabicFontSize,
                  height: 2.2,
                  color: cs.onSurface,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                _AyahMedallion(number: verse.verseNumber, isPlaying: isPlaying),
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

class _AyahMedallion extends StatelessWidget {
  const _AyahMedallion({required this.number, required this.isPlaying});

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
        style: theme.textTheme.labelSmall?.copyWith(
          color: fg,
          letterSpacing: 0,
        ),
      ),
    );
  }
}
