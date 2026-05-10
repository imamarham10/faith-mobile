import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/arabic_text.dart';
import '../../data/dtos/remedy.dart';

/// Display card for a single remedy — Arabic, divider, translation,
/// optional source. Mirrors the Today screen's `VerseCard` aesthetic so
/// the whole app reads as one document.
class RemedyCard extends ConsumerWidget {
  const RemedyCard({super.key, required this.remedy});

  final Remedy remedy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final hasArabic = remedy.arabicText.trim().isNotEmpty;
    final hasTranslit = (remedy.transliteration ?? '').trim().isNotEmpty;
    final hasSource = (remedy.source ?? '').trim().isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: cs.outline),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasArabic)
            Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                remedy.arabicText,
                textAlign: TextAlign.right,
                style: arabicTextStyleOf(
                  ref,
                  fontSize: 24,
                  height: 2.0,
                  color: cs.onSurface,
                ),
              ),
            ),
          if (hasArabic) const SizedBox(height: 20),
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
          Text(remedy.translation, style: theme.textTheme.bodyLarge),
          if (hasSource) ...[
            const SizedBox(height: 12),
            Text(
              remedy.source!.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(color: cs.secondary),
            ),
          ],
        ],
      ),
    );
  }
}
