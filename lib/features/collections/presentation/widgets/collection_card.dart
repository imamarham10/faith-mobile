import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../data/dtos/curated_collection.dart';

/// Where a collection opens. One definition, so the card, the compact tile
/// and any future entry point cannot disagree about it.
String collectionRoute(CuratedCollection collection) =>
    '/quran/collection/${collection.slug}';

/// A glyph for the kind of occasion a set belongs to.
///
/// Decoration, not logic — nothing branches on `occasionType` to decide
/// *whether* a collection appears (the database does that), and an
/// occasion this build has never heard of simply gets the general icon
/// rather than being treated as a special case.
IconData collectionIcon(String? occasionType) => switch (occasionType) {
  'nightly' => Icons.nightlight_round,
  'morning' => Icons.wb_twilight_rounded,
  'evening' => Icons.wb_sunny_outlined,
  'after_prayer' => Icons.spa_outlined,
  'festival' => Icons.celebration_outlined,
  'situational' => Icons.favorite_outline,
  'hijri' || 'panchang' || 'weekday' => Icons.event_note_outlined,
  _ => Icons.auto_stories_outlined,
};

/// The line under a collection's title: how much there is, and when it is
/// read. Built from the list payload alone — `itemCount` is served without
/// the items, so this never costs a fetch.
String collectionMeta(CuratedCollection collection) {
  final parts = <String>[
    '${collection.itemCount} '
        '${collection.itemCount == 1 ? 'reading' : 'readings'}',
    if (collection.estimatedMinutes != null) '${collection.estimatedMinutes} min',
    if (collection.subtitle != null && collection.subtitle!.isNotEmpty)
      collection.subtitle!,
  ];
  return parts.join('  ·  ');
}

/// A collection as a full-width row: icon, name, what is in it, chevron.
///
/// Used where there is room to browse — the Qur'an and Scripture tabs and
/// Practice. Today uses `FeaturedCollectionCard` instead, which promotes a
/// single set with its own artwork.
///
/// Tapping opens the set's own screen rather than any one item in it,
/// because a set is a thing you work through and the first decision is
/// always *where in it am I tonight*.
class CollectionCard extends StatelessWidget {
  const CollectionCard({super.key, required this.collection});

  final CuratedCollection collection;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final palette = theme.extension<FaithThemeExtension>()!.palette;

    return Semantics(
      button: true,
      label: '${collection.title}, ${collection.itemCount} readings',
      excludeSemantics: true,
      child: PoppyCard(
        radius: AppRadius.xl,
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
        onTap: () {
          HapticFeedback.lightImpact();
          context.push(collectionRoute(collection));
        },
        child: Row(
          children: [
            _IconBadge(occasionType: collection.occasionType),
            const SizedBox(width: AppSpacing.base),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(collection.title, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 2),
                  Text(
                    collectionMeta(collection),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: palette.inkMuted,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: cs.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.occasionType});

  final String? occasionType;

  /// One size, now that the dashboard's compact tile is gone and this
  /// badge has a single caller.
  static const double size = 44;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: cs.primaryContainer,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(
        collectionIcon(occasionType),
        color: cs.primary,
        size: size * 0.5,
      ),
    );
  }
}
