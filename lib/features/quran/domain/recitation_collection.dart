import 'reading_mode.dart';

/// A curated reading set: a named sequence of things to recite, in order.
///
/// ## Why the item is a sealed class and not a surah id
///
/// The nightly set below is the shape every curated collection turns out to
/// have: it mixes **a whole surah** (Al-Mulk), **a single verse** (Ayat
/// al-Kursi, 2:255) and **a span of verses** (Al-Baqarah 285–286). A model
/// that held surah ids could not express two of the three, and one that
/// held `(surah, from, to)` triples would make "the whole of Al-Ikhlas"
/// into `112:1–4` — a number the client would have to know, and would have
/// to keep in step with the mushaf, for no gain.
///
/// So the three are three variants, and the only thing the UI ever asks of
/// them is [RecitationItem.route] — which is where the differences actually
/// live, because the three open in genuinely different ways. See that
/// method.
///
/// The base therefore holds **only** a title, a subtitle and a destination,
/// and nothing Qur'an-shaped: `surahId` lives on the three variants that
/// have one. That is not generality built for its own sake, it is the
/// absence of a Qur'an assumption in the one place it would have to be
/// unpicked later — a dua or a Name of Allah is a title, a subtitle and a
/// route too, and would arrive as another variant rather than as a rewrite.
/// Nothing beyond the three Qur'an shapes is built here, and nothing should
/// be until a collection actually needs it.
///
/// ## Why this is a constant and not an endpoint
///
/// Nothing here changes per user or per day, the whole corpus is six lines
/// long, and a collection that arrives over the network is a collection
/// that is blank on a cold start — on exactly the screens where this is
/// meant to be the thing you reach for without thinking. More collections
/// are coming; when enough of them exist to need curation out of band, this
/// constant becomes the fallback the fetched list is merged over, and
/// nothing above it changes.
sealed class RecitationItem {
  const RecitationItem({required this.title, required this.subtitle});

  /// What the row is called — the name a reader would use out loud.
  final String title;

  /// The reference, spelled the way the tradition spells it: "Surah 112",
  /// "2:255", "2:285–286".
  final String subtitle;

  /// Where tapping this item lands.
  ///
  /// [mode] is the reader's remembered preference and is honoured for a
  /// whole surah, which is the only variant both readers can show properly.
  ///
  /// A single verse and a span are **always** opened in the verse pager,
  /// whatever the preference says, because the scrolling reader has no way
  /// to fence a span: pointed at 2:285 it shows the surah from there on,
  /// with no sign that the passage is two verses long. Honouring the
  /// preference there would honour it into a worse reading.
  String route(ReadingMode mode);
}

/// A surah in full — "Surah Al-Mulk".
final class WholeSurahItem extends RecitationItem {
  const WholeSurahItem({
    required this.surahId,
    required super.title,
    required super.subtitle,
  });

  final int surahId;

  @override
  String route(ReadingMode mode) => surahReadingRoute(surahId, mode: mode);
}

/// One verse on its own — "Ayat al-Kursi".
final class SingleVerseItem extends RecitationItem {
  const SingleVerseItem({
    required this.surahId,
    required this.verseNumber,
    required super.title,
    required super.subtitle,
  });

  final int surahId;
  final int verseNumber;

  /// A span of one. Fencing it means Next is inert on arrival, which is the
  /// honest statement that this item *is* the verse — where pointing the
  /// scrolling reader at it would invite the reader on into 2:256.
  @override
  String route(ReadingMode mode) =>
      surahSpanRoute(surahId, from: verseNumber, to: verseNumber);
}

/// A run of consecutive verses — "Al-Baqarah 285–286".
final class VerseRangeItem extends RecitationItem {
  const VerseRangeItem({
    required this.surahId,
    required this.from,
    required this.to,
    required super.title,
    required super.subtitle,
  }) : assert(from <= to, 'a range ends at or after it starts');

  final int surahId;
  final int from;
  final int to;

  @override
  String route(ReadingMode mode) => surahSpanRoute(surahId, from: from, to: to);
}

/// A named sequence of [items], read in the order they are listed.
class RecitationCollection {
  const RecitationCollection({
    required this.id,
    required this.title,
    required this.blurb,
    required this.items,
  });

  /// URL segment: `/quran/collection/<id>`.
  final String id;

  final String title;

  /// A short line saying when this set is read. Shown under the title on
  /// the card and at the head of the collection screen, so it has to read
  /// well in both — which means short.
  final String blurb;

  final List<RecitationItem> items;

  /// Where the collection opens when tapped as a whole.
  String get route => '/quran/collection/$id';
}

/// The nightly set: the three Quls, Ayat al-Kursi, the closing two verses of
/// Al-Baqarah, and Al-Mulk.
///
/// The order is the order it is recited in, not the order of the mushaf —
/// the Mu'awwidhat come first because they are the ones blown into the
/// hands, and Al-Mulk is last because it is the one you fall asleep during.
const kNightlyRecitation = RecitationCollection(
  id: 'nightly',
  title: 'Nightly recitation',
  blurb: 'Read before sleep.',
  items: <RecitationItem>[
    WholeSurahItem(surahId: 112, title: 'Al-Ikhlas', subtitle: 'Surah 112'),
    WholeSurahItem(surahId: 113, title: 'Al-Falaq', subtitle: 'Surah 113'),
    WholeSurahItem(surahId: 114, title: 'An-Nas', subtitle: 'Surah 114'),
    SingleVerseItem(
      surahId: 2,
      verseNumber: 255,
      title: 'Ayat al-Kursi',
      subtitle: '2:255',
    ),
    VerseRangeItem(
      surahId: 2,
      from: 285,
      to: 286,
      title: 'The last two verses of Al-Baqarah',
      subtitle: '2:285–286',
    ),
    WholeSurahItem(surahId: 67, title: 'Al-Mulk', subtitle: 'Surah 67'),
  ],
);

/// Every collection the app ships, by [RecitationCollection.id].
///
/// The router resolves `/quran/collection/:id` through this, so an id that
/// no longer exists is a miss rather than a crash.
const kRecitationCollections = <String, RecitationCollection>{
  'nightly': kNightlyRecitation,
};

/// The hours — local, 24h — during which the nightly set is promoted onto
/// the Today dashboard.
///
/// From 19:00 to 03:59: after Isha at any latitude this app has users in,
/// through to the small hours for whoever is up late. Outside that window
/// the card is not *gone* — it keeps its permanent slot on the Qur'an tab,
/// which is the one place it can always be found. Only the dashboard
/// promotion is time-bound, because a dashboard is a claim about now.
bool isNightlyHour(int hour) => hour >= 19 || hour < 4;
