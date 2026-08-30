import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../../../shared/widgets/poppy_card.dart';

/// A square-ish card on the stotras home grid. Mirrors duas' `CategoryCard`.
class StotraCategoryCard extends StatelessWidget {
  const StotraCategoryCard({
    super.key,
    required this.name,
    required this.count,
    required this.onTap,
  });

  final String name;
  final int count;
  final VoidCallback onTap;

  String _subtitle() {
    if (count > 0) return count == 1 ? '1 stotra' : '$count stotras';
    return 'Tap to read';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return PoppyCard(
      radius: AppRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.lg),
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            alignment: Alignment.center,
            child: Icon(Icons.temple_hindu, size: 18, color: cs.primary),
          ),
          const Spacer(),
          Text(
            name,
            style: theme.textTheme.titleLarge,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            _subtitle(),
            style: theme.textTheme.bodySmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Pinned trailing card linking to `/practice/stotras/favorites`.
class StotraFavoritesCard extends StatelessWidget {
  const StotraFavoritesCard({
    super.key,
    required this.onTap,
    required this.count,
  });

  final VoidCallback onTap;
  final int count;

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
      color: cs.secondaryContainer,
      padding: const EdgeInsets.all(AppSpacing.lg),
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.favorite, size: 22, color: accentText),
          const Spacer(),
          Text('Favorites', style: theme.textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(
            count == 0
                ? 'Tap any heart to save'
                : count == 1
                ? '1 saved'
                : '$count saved',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
