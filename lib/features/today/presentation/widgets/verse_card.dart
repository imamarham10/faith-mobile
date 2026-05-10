import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/arabic_text.dart';

/// Quran verse card — Arabic, divider, English translation, reference.
class VerseCard extends ConsumerWidget {
  const VerseCard({
    super.key,
    required this.arabic,
    required this.translation,
    required this.reference,
    this.onTap,
  });

  final String arabic;
  final String translation;
  final String reference;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final content = Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              arabic,
              textAlign: TextAlign.right,
              style: arabicTextStyleOf(
                ref,
                fontSize: 26,
                height: 2.0,
                color: cs.onSurface,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 40,
            height: 1,
            color: cs.secondary.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          Text(translation, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 12),
          Text(
            reference.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(color: cs.secondary),
          ),
        ],
      ),
    );

    final decoration = BoxDecoration(
      color: cs.surface,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      border: Border.all(color: cs.outline),
    );

    if (onTap == null) {
      return Container(decoration: decoration, child: content);
    }
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: () {
          HapticFeedback.lightImpact();
          onTap!();
        },
        child: Ink(decoration: decoration, child: content),
      ),
    );
  }
}
