import 'package:freezed_annotation/freezed_annotation.dart';

import 'collection_item.dart';

part 'curated_collection.freezed.dart';
part 'curated_collection.g.dart';

/// A curated reading set, as served by `GET /api/v1/{faith}/collections`
/// and `GET /api/v1/{faith}/collections/:slug`.
///
/// ## One class for both endpoints
///
/// The two payloads differ in exactly one key: the detail endpoint adds
/// `items`, the list endpoint omits it. [items] therefore defaults to empty
/// and a summary parses as a collection with no items — rather than two
/// near-identical classes whose shared twelve fields would have to be kept
/// in step by hand. [itemCount] is served by both, so a card can say "6
/// readings" from the list payload without ever fetching the set.
///
/// ## What the client decides, and what it no longer decides
///
/// Nothing about *when* a collection is shown is computed here. [showOnHome]
/// is the database's answer to "does this belong on Today", and [sortOrder]
/// is its answer to "in what order" — both are obeyed as given. The client
/// used to carry its own clock rule (`isNightlyHour`, 19:00–03:59) deciding
/// when the nightly set appeared on the dashboard; that rule is gone, and
/// deliberately not replaced by a second one layered over the flag. Two
/// rules that can disagree is a bug waiting for a timezone.
///
/// [occasionType] and [occasionConfig] are carried because the server sends
/// them and a later feature may render them ("read before sleep"), but
/// nothing in this app branches on them today.
@freezed
abstract class CuratedCollection with _$CuratedCollection {
  const factory CuratedCollection({
    /// URL segment: `/quran/collection/<slug>`.
    required String slug,

    /// `islam` or `hindu`. The endpoint already pins this; it is kept so a
    /// collection carries its own provenance when passed around.
    required String faithId,

    required String title,

    /// A short line under the title — "Before sleep".
    String? subtitle,

    /// Long-form; shown on the collection screen, never on a card.
    String? description,

    /// Server vocabulary: `nightly`, `morning`, `evening`, `after_prayer`,
    /// `weekday`, `hijri`, `panchang`, `festival`, `situational`,
    /// `evergreen`. Carried, not branched on — see the class doc.
    String? occasionType,

    /// Free-form JSON whose shape depends on [occasionType] (`{clock: {from,
    /// to}}`, `{always: true}`, …). Kept raw: parsing a shape nothing reads
    /// would only create a way to crash on a shape the server adds later.
    Map<String, dynamic>? occasionConfig,

    /// `sequence` or `set`. Order is meaningful either way; `set` only means
    /// the items are not one continuous recitation run.
    String? orderSemantics,

    String? artworkKey,

    /// Roughly how long the set takes to read, in minutes.
    int? estimatedMinutes,

    /// Whether this collection is promoted onto the Today dashboard.
    ///
    /// Placement only — never availability. A collection with this false is
    /// still listed in full on the Qur'an/Scripture tab and on Practice, so
    /// nothing becomes unreachable by not being featured.
    ///
    /// Defaults to false so a server that predates the column serves a
    /// dashboard with no collections on it rather than one with all of them.
    @Default(false) bool showOnHome,

    @Default(0) int priority,

    /// The server's display order, ascending. Obeyed as given — there is no
    /// client-side re-sort anywhere in this feature.
    @Default(0) int sortOrder,

    /// Who curated and reviewed the set. Shown once, at the foot of the
    /// collection screen.
    CollectionProvenance? provenance,

    /// Served by both endpoints, so a card never needs the item list.
    @Default(0) int itemCount,

    /// Served by the detail endpoint only; empty on a summary.
    @Default(<CollectionItem>[]) List<CollectionItem> items,
  }) = _CuratedCollection;

  factory CuratedCollection.fromJson(Map<String, dynamic> json) =>
      _$CuratedCollectionFromJson(json);
}

/// Where a collection came from and who signed it off. The server ships this
/// on the resource rather than behind a second request precisely so it can
/// be shown without one.
@freezed
abstract class CollectionProvenance with _$CollectionProvenance {
  const factory CollectionProvenance({
    /// `transmitted` (the set itself is narrated), `assembled` (canonical
    /// parts, the app's selection), or `thematic`.
    String? provenanceClass,

    /// `self_reviewed` or `scholar_approved` — the server never serves
    /// `draft`, `flagged` or `retired`.
    String? reviewStatus,
    String? curatedBy,
    DateTime? curatedAt,
    String? reviewedBy,
    DateTime? reviewedAt,
  }) = _CollectionProvenance;

  factory CollectionProvenance.fromJson(Map<String, dynamic> json) =>
      _$CollectionProvenanceFromJson(json);
}
