import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../data/dtos/temple.dart';

/// Compact row used on nearby/state/deity/search/favorites lists. Shows
/// name, city/state, and — when present (only the `/nearby` endpoint
/// populates it) — distance in km.
class TempleListTile extends StatelessWidget {
  const TempleListTile({
    super.key,
    required this.temple,
    required this.onTap,
    this.isFavorite = false,
    this.onToggleFavorite,
  });

  final Temple temple;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback? onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final accentText = theme
        .extension<FaithThemeExtension>()!
        .palette
        .accentText;
    final locationLabel = [
      temple.city,
      temple.state,
    ].where((s) => (s ?? '').isNotEmpty).join(', ');

    return PoppyCard(
      radius: AppRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.base),
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            alignment: Alignment.center,
            child: Icon(Icons.temple_hindu, size: 20, color: cs.primary),
          ),
          const SizedBox(width: AppSpacing.base),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  temple.name,
                  style: theme.textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (locationLabel.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    locationLabel,
                    style: theme.textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          if (temple.distanceKm != null) ...[
            const SizedBox(width: AppSpacing.sm),
            Text(
              '${temple.distanceKm!.toStringAsFixed(1)} km',
              style: theme.textTheme.labelMedium?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ],
          if (onToggleFavorite != null)
            IconButton(
              onPressed: onToggleFavorite,
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_outline,
                color: isFavorite ? accentText : cs.onSurfaceVariant,
                size: 20,
              ),
            ),
        ],
      ),
    );
  }
}
