import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/art/artwork.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/faith_id.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../../../shared/widgets/artwork_panel.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../../../shared/widgets/section_label.dart';
import '../../data/dtos/curated_collection.dart';
import '../controllers/collections_controller.dart';
import 'collection_card.dart';

/// The collection the database has featured, on the Today dashboard — one
/// full-width card with its own artwork, directly below continue-reading.
///
/// Replaces the horizontal rail of compact tiles that used to sit here. The
/// rail's job was to stop the dashboard's height growing with the number of
/// featured collections; this keeps that property by a different means (see
/// "Only the first" below) and spends the reclaimed prominence on the one
/// collection that is actually being promoted.
///
/// ## Only the first
///
/// `showOnHome` flags one collection per faith today and ten more sets are
/// staged, so "several at once" is a near-term certainty rather than a
/// hypothetical. A full-width card cannot become a stack of full-width
/// cards: the habit loop sits directly below it, and three featured sets
/// would push the week strip and the goal card off a phone screen. A
/// promoted shelf that buries the daily goal is not a promotion, it is a
/// regression.
///
/// So the dashboard takes the first collection in the server's own
/// `sortOrder` — the database's answer to "which one matters most" — and
/// the height of this block is the same whether one is featured or eleven.
/// Nothing is lost by it: featuring has always been placement and never
/// availability, and every collection, featured or not, is listed in full
/// on the Qur'an tab, the Scripture tab and Practice.
///
/// ## Every unsettled state renders nothing
///
/// Loading, error and empty all draw [SizedBox.shrink], heading included —
/// no skeleton, no retry banner, no orphaned label. Inherited unchanged
/// from the rail, and the argument is unchanged with it: a verse of the day
/// is always there, so a shimmer is an honest promise; a featured
/// collection may legitimately not exist, so a shimmer would be a lie told
/// in the second-most prominent slot on the screen. An error draws nothing
/// for the same reason and offers no retry — this is a discovery surface
/// nobody asked for, and the retry lives where someone went looking for
/// collections on purpose.
class FeaturedCollectionCard extends ConsumerWidget {
  const FeaturedCollectionCard({super.key, required this.faith});

  final FaithId faith;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collections = ref.watch(homeCollectionsProvider(faith)).valueOrNull;
    if (collections == null || collections.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      // Min, not the default max: a Column takes every pixel its parent
      // offers unless told otherwise, which inside a sliver is invisible
      // and anywhere else swallows the screen.
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel('Collections'),
        const Gap(AppSpacing.md),
        _FeaturedTile(collection: collections.first, faith: faith),
        const Gap(AppSpacing.xl),
      ],
    );
  }
}

/// A collection at dashboard size: full width, artwork band, title, what is
/// in it, and one tap into the set.
///
/// The whole card is the target — a card in this design system is a button,
/// and this one looks more like one than anything else on the screen.
class _FeaturedTile extends StatelessWidget {
  const _FeaturedTile({required this.collection, required this.faith});

  /// Tall enough to read as artwork, short enough that the habit loop below
  /// is still one short scroll away on a 6" phone.
  static const double bandHeight = 88;

  final CuratedCollection collection;
  final FaithId faith;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ext = theme.extension<FaithThemeExtension>()!;
    final palette = ext.palette;
    final hasArt = artworkFor(faith, ArtSlot.scriptureHeader) != null;

    return Semantics(
      button: true,
      label:
          '${collection.title}, ${collection.itemCount} '
          '${collection.itemCount == 1 ? 'reading' : 'readings'}',
      excludeSemantics: true,
      child: PoppyCard(
        radius: AppRadius.xl,
        // Zero, so the artwork can run edge to edge; every inner block
        // carries its own inset instead.
        padding: EdgeInsets.zero,
        onTap: () {
          HapticFeedback.lightImpact();
          context.push(collectionRoute(collection));
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // `scriptureHeader` rather than a slot of its own. `artwork.dart`
            // argues against reusing one picture across surfaces, and that
            // argument is about *families* — forty empty states sharing one
            // motif. This is one card on Today and one header on the
            // Scripture tab, both about the same thing (the book), and they
            // are never on screen together. A slot of its own would mean two
            // more sourced, cropped and provenance-logged assets for a
            // difference nobody can see; add one the day this card and that
            // header stop meaning the same thing.
            //
            // Only drawn when the faith actually has art for the slot: an
            // 88px band of nothing is worse than no band.
            if (hasArt)
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                    AppRadius.xl - ext.cardOutlineWidth,
                  ),
                  topRight: Radius.circular(
                    AppRadius.xl - ext.cardOutlineWidth,
                  ),
                ),
                child: SizedBox(
                  height: bandHeight,
                  width: double.infinity,
                  child: ArtworkPanel(
                    slot: ArtSlot.scriptureHeader,
                    faith: faith,
                    // The band has its own region and no text sits over it,
                    // so a scrim would only desaturate it.
                    scrim: ArtworkScrim.none,
                    // A decode failure leaves a tinted band rather than a
                    // hole in a card whose height is already committed.
                    fallback: ColoredBox(color: cs.primaryContainer),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.base,
                AppSpacing.lg,
                AppSpacing.base,
              ),
              child: Row(
                children: [
                  _IconBadge(occasionType: collection.occasionType),
                  const Gap.h(AppSpacing.base),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          collection.title,
                          style: theme.textTheme.titleLarge,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Gap(2),
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
                  const Gap.h(AppSpacing.sm),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: cs.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The occasion glyph, at dashboard size. A private copy of the badge in
/// `collection_card.dart` rather than an import of it, because that one is
/// file-private there and this one sits on a different ground.
class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.occasionType});

  final String? occasionType;

  static const double _size = 44;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        color: cs.primaryContainer,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(
        collectionIcon(occasionType),
        color: cs.primary,
        size: _size * 0.5,
      ),
    );
  }
}
