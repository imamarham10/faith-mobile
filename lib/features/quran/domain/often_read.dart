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

  /// The line under the name — the reason this surah earned a slot.
  ///
  /// Two kinds of line, and the difference is deliberate (see the list
  /// below): a **named time** for the entries whose cadence rests on
  /// authentic narrations, and the plain descriptive "Widely read" for the
  /// entries that are simply among the most-opened. Never an instruction
  /// the app is not in a position to give.
  final String occasion;
}

/// The surahs people actually open, with a line saying why each is here.
///
/// ## Two kinds of line, and why they differ
///
/// Some entries carry a **named time** — "Fridays", "Before sleep". Those
/// are the ones whose cadence is well established and uncontested, and the
/// label simply reports it.
///
/// The rest carry **"Widely read"**. These surahs are genuinely among the
/// most-opened in the app's audience, which is the whole point of the row,
/// but the reports behind the specific schedules often attached to them are
/// not of the same standing — and a chip is three words with no room to
/// qualify anything. Rendering a contested practice as a flat instruction
/// ("Mornings") makes the app the authority on a question it is in no
/// position to settle.
///
/// So the rule this list follows: **the row describes what people read, it
/// does not prescribe when.** A named time is only used where naming it is
/// uncontroversial. This is not an inconsistency to be tidied away — do not
/// "fix" the plainer labels by giving them confident schedules. If a line
/// is in doubt, "Widely read" is the safe form, and the app loses nothing
/// by using it: the chip's job is to save a reader four taps, not to teach
/// them a practice.
///
/// **Al-Fatihah is deliberately absent.** It is the most *recited* surah in
/// existence and for precisely that reason among the least *opened*: it is
/// in every rak'ah of every prayer and every Muslim has it by heart. A
/// shortcut to it saves nobody anything, and it would push a surah people
/// genuinely do open out of the row.
///
/// Al-Ikhlas is the one short entry — short enough to be read from memory
/// rather than from the page. It stays because it is the entry point to the
/// Mu'awwidhat, which sit immediately after it in the mushaf, so arriving
/// there is how you read all three.
///
/// Ordered by surah number, which is the order a reader already knows.
const List<OftenReadSurah> kOftenReadSurahs = <OftenReadSurah>[
  OftenReadSurah(id: 2, name: 'Al-Baqarah', occasion: 'Nightly'),
  OftenReadSurah(id: 18, name: 'Al-Kahf', occasion: 'Fridays'),
  OftenReadSurah(id: 36, name: 'Ya-Sin', occasion: 'Widely read'),
  OftenReadSurah(id: 55, name: 'Ar-Rahman', occasion: 'Widely read'),
  OftenReadSurah(id: 56, name: "Al-Waqi'ah", occasion: 'Widely read'),
  OftenReadSurah(id: 67, name: 'Al-Mulk', occasion: 'Before sleep'),
  OftenReadSurah(id: 112, name: 'Al-Ikhlas', occasion: 'Daily'),
];
