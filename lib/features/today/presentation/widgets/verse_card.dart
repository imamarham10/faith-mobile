import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/arabic_text.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../../../shared/widgets/poppy_card.dart';

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
    final accentText = theme
        .extension<FaithThemeExtension>()!
        .palette
        .accentText;
    final content = Column(
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
          style: theme.textTheme.labelSmall?.copyWith(color: accentText),
        ),
      ],
    );

    return PoppyCard(
      padding: const EdgeInsets.all(24),
      onTap: onTap == null
          ? null
          : () {
              HapticFeedback.lightImpact();
              onTap!();
            },
      child: content,
    );
  }
}
