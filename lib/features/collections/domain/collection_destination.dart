// Both of these re-export `ReadingMode` from `shared/reader`, which is
// where the faith-neutral enum lives; the route helpers either side of
// it are the faith-shaped half.
import '../../hindu_scriptures/domain/chapter_reading_route.dart';
import '../../quran/domain/reading_mode.dart';
import '../data/dtos/collection_item.dart';

/// Where tapping a collection item lands — or `null` when it lands nowhere.
///
/// ## Why this is a function and not a method on a sealed class
///
/// It replaces `RecitationItem.route`, which was a method on three sealed
/// variants of a hand-written constant. The server does not send variants;
/// it sends a `refType` string out of a vocabulary it can extend without
/// asking, plus nine nullable addressing columns. A sealed hierarchy over
/// that would have to parse into a variant before it could be rendered, and
/// an unknown `refType` would then be a parse failure — a collection that
/// gained one new item would fail to open at all. Keeping it a `String` and
/// answering `null` here makes the same case a row that is listed and not
/// tappable, which is what it actually is.
///
/// ## Why `null` matters more than it looks
///
/// In this design system a card *is* a button, so a destination of `null`
/// must not produce a card. The caller renders those items as plain,
/// unpressable rows — no `PoppyCard`, no `GestureDetector`. Dead clicks are
/// the single most-reported complaint in this project, and the row types
/// that answer `null` here (`text`, and anything the server could not
/// resolve) are exactly the ones a naive renderer would make pressable.
///
/// ## What is deliberately not mapped
///
/// `dhikr` and `mantra` address a counter by `refSlug`, but the only
/// addressable counter routes are `/practice/dhikr/counter/:id` and
/// `/practice/japa/counter/:id` — keyed by a counter id, not by the slug
/// the collection carries. `hadith` carries `<book>:<number>`, which no
/// client route accepts. Sending any of those to its *list* screen would be
/// a tap that looks like it worked and did not, so they answer `null` until
/// the route exists. None of the three is seeded today.
String? collectionItemRoute(CollectionItem item, {required ReadingMode mode}) {
  // An item the server could not resolve has no content behind it, whatever
  // its ref says. Checked before the switch so no refType can route past it.
  if (item.unresolved != null) return null;

  final ref = item.ref;

  switch (item.refType) {
    // A surah in full. The only variant both Qur'an readers can show
    // properly, so it is the only one that honours the remembered mode.
    case 'surah':
      final surahId = ref.surahId;
      if (surahId == null) return null;
      return surahReadingRoute(surahId, mode: mode);

    // One verse or a run of them. `ayahEnd` is null for a single verse —
    // the server's own resolver reads it as `ayahEnd ?? ayahStart`, and a
    // span of one is how Ayat al-Kursi is addressed.
    case 'ayah_range':
      final surahId = ref.surahId;
      final from = ref.ayahStart;
      if (surahId == null || from == null) return null;
      return surahSpanRoute(surahId, from: from, to: ref.ayahEnd ?? from);

    // The Hindu peer of `ayah_range`. `verseStart` is required by the
    // server's own field contract, so a missing one is a seed bug rather
    // than "the whole chapter" — but treating it as the whole chapter
    // degrades better than refusing to open anything.
    case 'hindu_verse_range':
      final slug = ref.hinduTextSlug;
      final chapter = ref.chapterNumber;
      if (slug == null || chapter == null) return null;
      final from = ref.verseStart;
      if (from == null) return chapterReadingRoute(slug, chapter, mode: mode);
      return chapterSpanRoute(
        slug,
        chapter,
        from: from,
        to: ref.verseEnd ?? from,
      );

    // `/practice/duas/:id` takes the dua's uuid, which is what `refId`
    // holds. `refSlug` alone cannot address the detail screen.
    case 'dua':
      final id = ref.refId;
      return (id == null || id.isEmpty) ? null : '/practice/duas/$id';

    // `/practice/names/allah/:id` parses an int; the server documents
    // `AllahName.id` as 1..99 carried in `refId` as text.
    case 'allah_name':
      final id = int.tryParse(ref.refId ?? ref.refSlug ?? '');
      return id == null ? null : '/practice/names/allah/$id';

    // `/practice/stotras/:slug` takes the slug directly.
    case 'stotra':
      final slug = ref.refSlug;
      return (slug == null || slug.isEmpty) ? null : '/practice/stotras/$slug';

    // `text` is a prose instruction — "cup your hands and blow into them".
    // It has no destination by design, not for want of a route.
    case 'text':
      return null;

    // `dhikr`, `mantra`, `hadith`, and anything the server's vocabulary
    // grows after this build ships. See the class doc.
    default:
      return null;
  }
}

/// Where the collection's "Begin" button lands: the first item that leads
/// anywhere.
///
/// Not simply `items.first` — a set may open on a `text` instruction, and a
/// Begin button that did nothing would be the worst dead click on the
/// screen. `null` when no item in the set resolves, which is what hides the
/// button entirely.
String? collectionBeginRoute(
  List<CollectionItem> items, {
  required ReadingMode mode,
}) {
  for (final item in items) {
    final route = collectionItemRoute(item, mode: mode);
    if (route != null) return route;
  }
  return null;
}
