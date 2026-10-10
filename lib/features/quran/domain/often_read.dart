/// A surah offered as a one-tap shortcut on the Qur'an home screen.
class OftenReadSurah {
  const OftenReadSurah({
    required this.id,
    required this.name,
    required this.occasion,
  });

  final int id;

  /// Transliterated name, held as a constant rather than looked up from
  /// `GET /surahs` so the row paints with the first frame of the tab instead
  /// of after a network round trip. The names of the 114 surahs are not
  /// going to change.
  final String name;

  /// When this surah is read — the reason it earned a slot. Shown under the
  /// name so the row teaches rather than just lists.
  final String occasion;
}

/// Surahs that have a **named devotional cadence** — a day or a time people
/// return to them on — rather than surahs that are merely well known.
///
/// That is the whole selection rule, and it is why e.g. Yusuf and Ar-Ra'd
/// are absent despite being widely loved: nothing schedules them. Each entry
/// below is read on a recurring occasion:
///
/// * **Al-Baqarah** — the last two verses nightly; the surah itself over
///   several nights as the "do not make your houses graveyards" practice.
///   Also where Ayat al-Kursi (2:255) lives, which is a daily recitation in
///   its own right.
/// * **Al-Kahf** — Fridays. The single most schedule-bound surah in the
///   Qur'an, and the one the user named for exactly this reason.
/// * **Ya-Sin** — mornings, and at the bedside of the sick and dying.
/// * **Ar-Rahman** — a standing weekly recitation in most communities,
///   commonly Friday.
/// * **Al-Waqi'ah** — nightly.
/// * **Al-Mulk** — nightly, before sleep. The best-attested bedtime surah.
/// * **Al-Ikhlas** — three times each morning and evening and before sleep,
///   with Al-Falaq and An-Nas.
///
/// **Al-Fatihah is deliberately absent.** It is the most *recited* surah in
/// existence and for precisely that reason among the least *opened*: it is
/// in every rak'ah of every prayer and every Muslim has it by heart. A
/// shortcut to it saves nobody anything, and it would push a surah people
/// genuinely do open out of the row.
///
/// Al-Ikhlas is the one entry where the companion test — *long enough that
/// you read it from the page rather than from memory* — does not hold. It
/// stays because its cadence is the strongest daily one on the list and
/// because it is the entry point to the Mu'awwidhat, which sit immediately
/// after it in the mushaf, so arriving there is how you read all three.
///
/// Ordered by surah number, which is the order a reader already knows.
const List<OftenReadSurah> kOftenReadSurahs = <OftenReadSurah>[
  OftenReadSurah(id: 2, name: 'Al-Baqarah', occasion: 'Nightly'),
  OftenReadSurah(id: 18, name: 'Al-Kahf', occasion: 'Fridays'),
  OftenReadSurah(id: 36, name: 'Ya-Sin', occasion: 'Mornings'),
  OftenReadSurah(id: 55, name: 'Ar-Rahman', occasion: 'Weekly'),
  OftenReadSurah(id: 56, name: "Al-Waqi'ah", occasion: 'Nightly'),
  OftenReadSurah(id: 67, name: 'Al-Mulk', occasion: 'Before sleep'),
  OftenReadSurah(id: 112, name: 'Al-Ikhlas', occasion: 'Daily'),
];
