import 'package:freezed_annotation/freezed_annotation.dart';

part 'collection_item.freezed.dart';
part 'collection_item.g.dart';

/// One entry in a curated collection, as served by
/// `GET /api/v1/{faith}/collections/:slug`.
///
/// ## Why `content` is not modelled
///
/// The server resolves every item's scripture inline: the nightly set's six
/// items arrive carrying ~500 verse objects, each with Arabic, Indo-Pak
/// script, a `sourceRef` and six translations — 196 KB for a six-item
/// collection. None of it is drawn here. Tapping an item opens the surah or
/// chapter reader, and those screens fetch their own text through their own
/// repositories, with their own script and language preferences and their
/// own audio. Parsing the tree into DTOs would build a second copy of the
/// Qur'an's data model that nothing renders.
///
/// What the client actually needs from an item is on the item itself:
/// [label] and [citation] to name it, [repeatCount] to say it is read three
/// times, and [ref] to work out where it opens. `content` is therefore
/// dropped on the floor by `json_serializable` — unknown keys are ignored —
/// and `?lang=`/`?script=` are not sent, because nothing we keep varies
/// with them. Both change together the day an item grows a preview line.
@freezed
abstract class CollectionItem with _$CollectionItem {
  const factory CollectionItem({
    /// Position in the reading order. Semantic, not cosmetic: the server
    /// orders by it and the spec says the order *is* the recitation.
    required int sequence,

    /// One of the server's `REF_TYPES`: `surah`, `ayah_range`, `dua`,
    /// `dhikr`, `allah_name`, `hadith`, `hindu_verse_range`, `stotra`,
    /// `mantra`, `text`. Kept as a `String` rather than an enum so a
    /// vocabulary the server adds cannot crash a client that predates it;
    /// `collectionItemRoute` is the one place that switches on it, and it
    /// answers `null` for anything it does not know.
    required String refType,

    /// How many times the item is recited — the ×3 on each of the three
    /// Quls. Defaults to 1 so an item that omits it reads as "once".
    @Default(1) int repeatCount,

    /// What the item is called, in the words the tradition uses.
    required String label,

    /// A curator's note: why this item, or which form of it. Long-form —
    /// shown on the collection screen, never on a card.
    String? note,

    /// The warrant, e.g. "Bukhari 5017" or "Bhagavad Gita 12.1–20".
    String? citation,

    /// `sahih`, `hasan`, `daif`, `customary`, `not_applicable`, or absent.
    /// Only `daif` is surfaced, and then only as a disclosure.
    String? grading,

    /// Items a reader may skip without breaking the set.
    @Default(false) bool isOptional,

    /// The addressing columns. Which of them are populated is a function of
    /// [refType] — see `collectionItemRoute`.
    @Default(CollectionRef()) CollectionRef ref,

    /// Non-null when the server could not resolve the reference to real
    /// content. Such an item is listed (so the count still matches) but
    /// never offered as a destination.
    CollectionUnresolved? unresolved,
  }) = _CollectionItem;

  factory CollectionItem.fromJson(Map<String, dynamic> json) =>
      _$CollectionItemFromJson(json);
}

/// The nine addressing columns every item carries, all nullable. A `surah`
/// item fills [surahId]; an `ayah_range` adds [ayahStart]/[ayahEnd]; a
/// `hindu_verse_range` fills the Hindu trio; everything else is addressed
/// by [refSlug] or [refId].
@freezed
abstract class CollectionRef with _$CollectionRef {
  const factory CollectionRef({
    int? surahId,
    int? ayahStart,
    int? ayahEnd,
    String? hinduTextSlug,
    int? chapterNumber,
    int? verseStart,
    int? verseEnd,
    String? refSlug,
    String? refId,
  }) = _CollectionRef;

  factory CollectionRef.fromJson(Map<String, dynamic> json) =>
      _$CollectionRefFromJson(json);
}

/// Why an item has no content. A data problem, surfaced rather than hidden
/// — the server's own comment says an unresolved ref must never render as a
/// silently empty row.
@freezed
abstract class CollectionUnresolved with _$CollectionUnresolved {
  const factory CollectionUnresolved({required String reason}) =
      _CollectionUnresolved;

  factory CollectionUnresolved.fromJson(Map<String, dynamic> json) =>
      _$CollectionUnresolvedFromJson(json);
}
