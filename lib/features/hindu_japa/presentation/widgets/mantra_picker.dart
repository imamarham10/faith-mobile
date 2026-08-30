import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/sanskrit_text.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../data/dtos/japa_phrase.dart';

/// Compact dictionary entry tile — used by the home screen's Suggested
/// section and the New Counter sheet. Mirrors `DictionaryPicker`.
class MantraPicker extends StatelessWidget {
  const MantraPicker({
    super.key,
    required this.phrase,
    required this.onTap,
    this.trailing,
  });

  final JapaPhrase phrase;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return PoppyCard(
      radius: AppRadius.md,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.base,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
      ),
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  phrase.sanskrit,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: sanskritTextStyle(
                    fontSize: 20,
                    height: 1.4,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  phrase.transliteration,
                  style: theme.textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  phrase.english,
                  style: theme.textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          trailing ??
              Icon(Icons.add_circle_outline, size: 22, color: cs.primary),
        ],
      ),
    );
  }
}
