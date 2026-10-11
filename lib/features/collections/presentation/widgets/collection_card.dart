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
/// Practice. Today uses [CollectionTile] instead, which holds its height
/// however many collections are featured.
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

/// A collection at dashboard size: fixed width, fixed height, one of
/// several in a horizontal rail.
///
/// Fixed dimensions are the point. The rail sits above Today's goal card,
/// so its height must not be a function of how many collections the
/// database features — one or four, the goal card stays where it is and
/// the extras are reached by scrolling sideways.
class CollectionTile extends StatelessWidget {
  const CollectionTile({super.key, required this.collection});

  /// Wide enough for a two-line title, narrow enough that a second tile is
  /// always partly visible — which is what says there are more of them.
  static const double width = 216;

  /// The tile's height at the system text size.
  static const double baseHeight = 100;

  /// Fixed height is the whole point of the rail — the goal card must not
  /// move when a fourth collection is featured — but a height fixed in
  /// *pixels* is a clipped title for anyone who has turned text size up.
  /// So it is fixed per text scale instead: constant for a given reader,
  /// and generous enough for two lines of title plus the count at every
  /// scale up to the cap.
  ///
  /// Capped at 1.4 because beyond that the rail would be taller than the
  /// goal card it sits above; past the cap the title ellipsizes, which is
  /// the honest trade on a dashboard where the card's job is to be
  /// recognised and tapped rather than read in full.
  ///
  /// The scale factor is measured on the tile's **own title size**, not on
  /// the height. Android 14+ font scaling is non-linear — it compresses
  /// larger sizes more — so asking the scaler what it does to 100 logical
  /// pixels would under-report what it does to a 14pt `titleSmall` and
  /// leave the tile short exactly where it matters.
  static double heightOf(BuildContext context) {
    final titleSize = Theme.of(context).textTheme.titleSmall?.fontSize ?? 14;
    final scale = MediaQuery.textScalerOf(context).scale(titleSize) / titleSize;
    return baseHeight * scale.clamp(1.0, 1.4);
  }

  final CuratedCollection collection;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.extension<FaithThemeExtension>()!.palette;

    return Semantics(
      button: true,
      label: '${collection.title}, ${collection.itemCount} readings',
      excludeSemantics: true,
      child: SizedBox(
        width: width,
        height: heightOf(context),
        child: PoppyCard(
          radius: AppRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.md),
          onTap: () {
            HapticFeedback.lightImpact();
            context.push(collectionRoute(collection));
          },
          child: Row(
            children: [
              _IconBadge(occasionType: collection.occasionType, size: 36),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Flexible, not bare Text: a Column hands its children
                    // unbounded height, so a two-line title would render
                    // its full two lines and overflow the fixed tile
                    // rather than ellipsing inside it. This is what makes
                    // the clamp above degrade instead of clip.
                    Flexible(
                      child: Text(
                        collection.title,
                        style: theme.textTheme.titleSmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Flexible(
                      child: Text(
                        '${collection.itemCount} '
                        '${collection.itemCount == 1 ? 'reading' : 'readings'}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: palette.inkMuted,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.occasionType, this.size = 44});

  final String? occasionType;
  final double size;

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
