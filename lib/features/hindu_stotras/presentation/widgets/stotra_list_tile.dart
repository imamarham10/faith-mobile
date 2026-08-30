import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../../../core/theme/sanskrit_text.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../data/dtos/stotra.dart';

/// Compact row used on category screens and the favorites screen. Mirrors
/// `DuaListTile`; the second line shows the Sanskrit title rather than a
/// text excerpt, since stotra list items carry no verse/translation data.
class StotraListTile extends StatelessWidget {
  const StotraListTile({
    super.key,
    required this.stotra,
    required this.isFavorite,
    required this.onTap,
    required this.onToggleFavorite,
  });

  final Stotra stotra;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final accentText = theme
        .extension<FaithThemeExtension>()!
        .palette
        .accentText;

    return PoppyCard(
      radius: AppRadius.lg,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.base,
        AppSpacing.sm,
        AppSpacing.base,
      ),
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stotra.titleEnglish,
                  style: theme.textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  stotra.titleSanskrit,
                  style: sanskritTextStyle(
                    fontSize: 15,
                    color: cs.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onToggleFavorite,
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_outline,
              color: isFavorite ? accentText : cs.onSurfaceVariant,
              size: 22,
            ),
            tooltip: isFavorite ? 'Remove favorite' : 'Save favorite',
          ),
        ],
      ),
    );
  }
}
