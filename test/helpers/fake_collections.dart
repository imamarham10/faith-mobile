import 'package:faith_mobile/features/collections/data/dtos/collection_item.dart';
import 'package:faith_mobile/features/collections/data/dtos/curated_collection.dart';

/// Collections shaped like the ones the live API actually serves.
///
/// Built from the real payloads of
/// `GET /api/v1/islam/collections/nightly-recitation` and
/// `GET /api/v1/hindu/collections/gita-daily`, trimmed to the fields this
/// client keeps. `content` is absent here for the same reason it is absent
/// from the DTO: the server sends ~196 KB of resolved scripture per
/// collection and nothing in the app reads a byte of it.
abstract final class FakeCollections {
  /// Islam's seeded set: three Quls ×3, Ayat al-Kursi, the closing two
  /// verses of Al-Baqarah, Al-Mulk.
  static CuratedCollection nightly({bool showOnHome = true, int sortOrder = 10}) {
    return CuratedCollection(
      slug: 'nightly-recitation',
      faithId: 'islam',
      title: 'Nightly Recitation',
      subtitle: 'Before sleep',
      description: 'The set recited before sleeping.',
      occasionType: 'nightly',
      occasionConfig: const {
        'clock': {'from': '20:00', 'to': '03:59'},
      },
      orderSemantics: 'sequence',
      estimatedMinutes: 6,
      showOnHome: showOnHome,
      priority: 10,
      sortOrder: sortOrder,
      itemCount: 6,
      items: const [
        CollectionItem(
          sequence: 1,
          refType: 'surah',
          repeatCount: 3,
          label: 'Al-Ikhlas',
          citation: 'Bukhari 5017',
          grading: 'sahih',
          ref: CollectionRef(surahId: 112),
        ),
        CollectionItem(
          sequence: 2,
          refType: 'surah',
          repeatCount: 3,
          label: 'Al-Falaq',
          citation: 'Bukhari 5017',
          ref: CollectionRef(surahId: 113),
        ),
        CollectionItem(
          sequence: 3,
          refType: 'ayah_range',
          label: 'Ayat al-Kursi',
          citation: 'Quran 2:255',
          ref: CollectionRef(surahId: 2, ayahStart: 255),
        ),
        CollectionItem(
          sequence: 4,
          refType: 'ayah_range',
          label: 'The last two verses of Al-Baqarah',
          citation: 'Quran 2:285-286',
          ref: CollectionRef(surahId: 2, ayahStart: 285, ayahEnd: 286),
        ),
        CollectionItem(
          sequence: 5,
          refType: 'surah',
          label: 'Al-Mulk',
          ref: CollectionRef(surahId: 67),
        ),
      ],
      provenance: const CollectionProvenance(
        provenanceClass: 'transmitted',
        reviewStatus: 'self_reviewed',
        reviewedBy: 'Arham Imam',
      ),
    );
  }

  /// Hindu's seeded set: Bhagavad Gita 12.1-20.
  static CuratedCollection gita({bool showOnHome = true, int sortOrder = 10}) {
    return CuratedCollection(
      slug: 'gita-daily',
      faithId: 'hindu',
      title: 'Daily Gita',
      subtitle: 'Bhakti Yoga — a daily reading',
      description: 'A daily reading from the Bhagavad Gita.',
      occasionType: 'evergreen',
      occasionConfig: const {'always': true},
      orderSemantics: 'sequence',
      estimatedMinutes: 8,
      showOnHome: showOnHome,
      priority: 10,
      sortOrder: sortOrder,
      itemCount: 1,
      items: const [
        CollectionItem(
          sequence: 1,
          refType: 'hindu_verse_range',
          label: 'Bhagavad Gita 12 — Bhakti Yoga',
          citation: 'Bhagavad Gita 12.1-20',
          grading: 'not_applicable',
          ref: CollectionRef(
            hinduTextSlug: 'bhagavad-gita',
            chapterNumber: 12,
            verseStart: 1,
            verseEnd: 20,
          ),
        ),
      ],
      provenance: const CollectionProvenance(
        provenanceClass: 'assembled',
        reviewStatus: 'self_reviewed',
        reviewedBy: 'Arham Imam',
      ),
    );
  }

  /// A filler collection, for the case the API does not serve yet: several
  /// featured at once. `sortOrder` is what the server orders by and what
  /// the client must not second-guess.
  static CuratedCollection extra(
    String slug, {
    required String title,
    required String faithId,
    bool showOnHome = true,
    required int sortOrder,
    int itemCount = 4,
  }) {
    return CuratedCollection(
      slug: slug,
      faithId: faithId,
      title: title,
      occasionType: 'evergreen',
      showOnHome: showOnHome,
      sortOrder: sortOrder,
      itemCount: itemCount,
    );
  }
}
