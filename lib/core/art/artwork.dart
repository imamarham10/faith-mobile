import '../theme/faith_id.dart';

/// Where an illustration can appear. Slots are *semantic positions*, not
/// per-feature names: `practiceTile1` is "the first tile on the Practice
/// grid", which is Dhikr under Islam and Japa under Hindu. Keeping them
/// positional is what lets [artworkFor] stay a single pure switch instead
/// of growing a faith-shaped branch per feature.
enum ArtSlot {
  practiceHero,
  practiceTile1,
  practiceTile2,
  practiceTile3,
  practiceTile4,
  todayGoal,
  scriptureHeader,
  narrativeHeader,

  // Empty-state families. Deliberately not one generic `empty`: around forty
  // surfaces in this app can be empty, and giving them all the same picture
  // would make the app look like it had one illustration rather than a set.
  // Grouped by what the emptiness *means*, so the motif reinforces the copy.
  emptyBookmarks,
  emptyFavorites,
  emptyHistory,
  emptySearch,
  emptyCollection,
  emptyDormant,
}

/// One public-domain museum piece, already cropped and encoded for a slot.
///
/// Provenance for every entry — object id, collection, licence field and
/// source URL — is recorded in `docs/artwork_provenance.md`. CC0 imposes no
/// attribution requirement, but this app is monetised and the manifest has
/// to be auditable without anyone reconstructing it from memory.
class Artwork {
  const Artwork({
    required this.assetKey,
    required this.semanticLabel,
    required this.aspectRatio,
  });

  /// Asset path as declared in `pubspec.yaml`.
  final String assetKey;

  /// Describes the artwork for screen readers. The imagery is decorative,
  /// but it is also the only non-text content on some cards, so it is
  /// labelled rather than hidden.
  final String semanticLabel;

  /// Width / height of the encoded file. Callers that size by width use it
  /// to reserve the right box *before* the image decodes, so a late decode
  /// can never reflow the card.
  final double aspectRatio;
}

/// Resolves a slot for a faith, or null when that faith has no artwork for
/// that position.
///
/// Returning null is a supported, routine answer — not an error. Every
/// caller goes through `ArtworkPanel`, which renders its fallback for null
/// exactly as it does for an asset that fails to decode, so adding a slot
/// here is purely additive and removing one degrades to the pre-artwork
/// layout rather than to a broken screen.
Artwork? artworkFor(FaithId faith, ArtSlot slot) => switch ((faith, slot)) {
  // ---- Islam ------------------------------------------------------------
  (FaithId.islam, ArtSlot.practiceHero) => const Artwork(
    assetKey: 'assets/art/islam/illumination_band.webp',
    semanticLabel: 'Illuminated frontispiece from a 1514 Bustan of Saʿdi',
    aspectRatio: 900 / 418,
  ),
  (FaithId.islam, ArtSlot.practiceTile1) => const Artwork(
    assetKey: 'assets/art/islam/star_tile.webp',
    semanticLabel: 'Star-shaped lustreware tile, 13th–14th century Iran',
    aspectRatio: 360 / 168,
  ),
  (FaithId.islam, ArtSlot.practiceTile2) => const Artwork(
    assetKey: 'assets/art/islam/illumination_corner.webp',
    semanticLabel: 'Gold and lapis illumination border',
    aspectRatio: 360 / 168,
  ),
  (FaithId.islam, ArtSlot.practiceTile3) => const Artwork(
    assetKey: 'assets/art/islam/lamp_enamel.webp',
    semanticLabel: 'Enamelled and gilded mosque lamp, 14th century',
    aspectRatio: 360 / 168,
  ),
  (FaithId.islam, ArtSlot.practiceTile4) => const Artwork(
    assetKey: 'assets/art/islam/tile_interlace.webp',
    semanticLabel: 'Lustreware tile with floral interlace',
    aspectRatio: 360 / 168,
  ),
  (FaithId.islam, ArtSlot.todayGoal) => const Artwork(
    assetKey: 'assets/art/islam/illumination_corner.webp',
    semanticLabel: 'Gold and lapis illumination border',
    aspectRatio: 360 / 168,
  ),
  (FaithId.islam, ArtSlot.scriptureHeader) => const Artwork(
    assetKey: 'assets/art/islam/illumination_band.webp',
    semanticLabel: 'Illuminated frontispiece from a 1514 Bustan of Saʿdi',
    aspectRatio: 900 / 418,
  ),
  (FaithId.islam, ArtSlot.narrativeHeader) => const Artwork(
    assetKey: 'assets/art/islam/lamp_band.webp',
    semanticLabel: 'Calligraphic band from an enamelled mosque lamp',
    aspectRatio: 900 / 418,
  ),
  // PROVISIONAL: these six share four files until the expanded set lands.
  (FaithId.islam, ArtSlot.emptyBookmarks) => const Artwork(
    assetKey: 'assets/art/islam/star_tile.webp',
    semanticLabel: 'Star-shaped lustreware tile, 13th–14th century Iran',
    aspectRatio: 360 / 168,
  ),
  (FaithId.islam, ArtSlot.emptyFavorites) => const Artwork(
    assetKey: 'assets/art/islam/tile_interlace.webp',
    semanticLabel: 'Lustreware tile with floral interlace',
    aspectRatio: 360 / 168,
  ),
  (FaithId.islam, ArtSlot.emptyHistory) => const Artwork(
    assetKey: 'assets/art/islam/illumination_corner.webp',
    semanticLabel: 'Gold and lapis illumination border',
    aspectRatio: 360 / 168,
  ),
  (FaithId.islam, ArtSlot.emptySearch) => const Artwork(
    assetKey: 'assets/art/islam/lamp_enamel.webp',
    semanticLabel: 'Enamelled and gilded mosque lamp, 14th century',
    aspectRatio: 360 / 168,
  ),
  (FaithId.islam, ArtSlot.emptyCollection) => const Artwork(
    assetKey: 'assets/art/islam/star_tile.webp',
    semanticLabel: 'Star-shaped lustreware tile, 13th–14th century Iran',
    aspectRatio: 360 / 168,
  ),
  (FaithId.islam, ArtSlot.emptyDormant) => const Artwork(
    assetKey: 'assets/art/islam/illumination_corner.webp',
    semanticLabel: 'Gold and lapis illumination border',
    aspectRatio: 360 / 168,
  ),

  // ---- Hindu ------------------------------------------------------------
  (FaithId.hindu, ArtSlot.practiceHero) => const Artwork(
    assetKey: 'assets/art/hindu/tent_panel_band.webp',
    semanticLabel: 'Gold-embroidered floral arcade from an Indian tent panel',
    aspectRatio: 900 / 418,
  ),
  (FaithId.hindu, ArtSlot.practiceTile1) => const Artwork(
    assetKey: 'assets/art/hindu/floral_arch.webp',
    semanticLabel: 'Floral arch from a gold-embroidered Indian tent panel',
    aspectRatio: 360 / 168,
  ),
  (FaithId.hindu, ArtSlot.practiceTile2) => const Artwork(
    assetKey: 'assets/art/hindu/sari_border.webp',
    semanticLabel: 'Floral border band from an Indian sari',
    aspectRatio: 360 / 168,
  ),
  (FaithId.hindu, ArtSlot.practiceTile3) => const Artwork(
    assetKey: 'assets/art/hindu/jali_lattice.webp',
    semanticLabel: 'Pierced sandstone jali window screen, India',
    aspectRatio: 360 / 168,
  ),
  (FaithId.hindu, ArtSlot.practiceTile4) => const Artwork(
    assetKey: 'assets/art/hindu/patola_ikat.webp',
    semanticLabel: 'Patola double-ikat silk, Gujarat',
    aspectRatio: 360 / 168,
  ),
  (FaithId.hindu, ArtSlot.todayGoal) => const Artwork(
    assetKey: 'assets/art/hindu/floral_arch.webp',
    semanticLabel: 'Floral arch from a gold-embroidered Indian tent panel',
    aspectRatio: 360 / 168,
  ),
  (FaithId.hindu, ArtSlot.scriptureHeader) => const Artwork(
    assetKey: 'assets/art/hindu/tent_panel_band.webp',
    semanticLabel: 'Gold-embroidered floral arcade from an Indian tent panel',
    aspectRatio: 900 / 418,
  ),
  (FaithId.hindu, ArtSlot.narrativeHeader) => const Artwork(
    assetKey: 'assets/art/hindu/shawl_paisley_band.webp',
    semanticLabel: 'Painted Kashmir shawl paisley motif',
    aspectRatio: 900 / 418,
  ),
  (FaithId.hindu, ArtSlot.emptyBookmarks) => const Artwork(
    assetKey: 'assets/art/hindu/floral_arch.webp',
    semanticLabel: 'Floral arch from a gold-embroidered Indian tent panel',
    aspectRatio: 360 / 168,
  ),
  (FaithId.hindu, ArtSlot.emptyFavorites) => const Artwork(
    assetKey: 'assets/art/hindu/sari_border.webp',
    semanticLabel: 'Floral border band from an Indian sari',
    aspectRatio: 360 / 168,
  ),
  (FaithId.hindu, ArtSlot.emptyHistory) => const Artwork(
    assetKey: 'assets/art/hindu/patola_ikat.webp',
    semanticLabel: 'Patola double-ikat silk, Gujarat',
    aspectRatio: 360 / 168,
  ),
  (FaithId.hindu, ArtSlot.emptySearch) => const Artwork(
    assetKey: 'assets/art/hindu/jali_lattice.webp',
    semanticLabel: 'Pierced sandstone jali window screen, India',
    aspectRatio: 360 / 168,
  ),
  (FaithId.hindu, ArtSlot.emptyCollection) => const Artwork(
    assetKey: 'assets/art/hindu/floral_arch.webp',
    semanticLabel: 'Floral arch from a gold-embroidered Indian tent panel',
    aspectRatio: 360 / 168,
  ),
  (FaithId.hindu, ArtSlot.emptyDormant) => const Artwork(
    assetKey: 'assets/art/hindu/patola_ikat.webp',
    semanticLabel: 'Patola double-ikat silk, Gujarat',
    aspectRatio: 360 / 168,
  ),
};
