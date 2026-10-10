import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/dtos/juz.dart';
import '../../data/dtos/surah.dart';
import '../../data/juz_repository.dart';
import 'quran_home_controller.dart';

part 'juz_controller.g.dart';

/// Which of the two indexes the Qur'an home screen is showing.
enum QuranBrowseMode {
  surah('Surah'),
  juz('Juz');

  const QuranBrowseMode(this.label);

  final String label;
}

/// The Surah | Juz segmented control's selection.
///
/// Not persisted: the surah index is the right thing to land on when you
/// open the tab cold, and a sticky Juz segment would mean someone who read
/// one juz last week opens the tab to a list of 30 numbers.
@riverpod
class QuranBrowseModeController extends _$QuranBrowseModeController {
  @override
  QuranBrowseMode build() => QuranBrowseMode.surah;

  void select(QuranBrowseMode mode) => state = mode;
}

/// Loads the 30-juz chooser.
///
/// **Lazy on purpose.** Riverpod only runs this when something first
/// watches it, and the only thing that does is the Juz segment's list. Open
/// the Qur'an tab and stay on Surah and `GET /juz` is never called — this
/// adds no request to tab open and none at all to app start.
@Riverpod(keepAlive: true)
Future<List<JuzSummary>> juzIndex(Ref ref) async {
  final repo = ref.watch(juzRepositoryProvider);
  return repo.getJuzIndex();
}

/// Filters [juzIndexProvider] by the shared search box.
///
/// Shares [surahSearchQueryProvider] with the surah list rather than keeping
/// a second query, so switching segments mid-search keeps what you typed and
/// shows you the other index's answer to it.
///
/// Matches, in order of what people actually type:
/// * the juz number itself ("18");
/// * either end's surah name, which the chooser payload already carries;
/// * any surah in the juz's span, which needs the 114-surah index — so this
///   widening only applies when that list happens to be loaded already. It
///   is never fetched for the sake of search.
@riverpod
List<JuzSummary> filteredJuz(Ref ref) {
  final query = ref.watch(surahSearchQueryProvider).trim().toLowerCase();
  final all = ref.watch(juzIndexProvider).valueOrNull ?? const <JuzSummary>[];
  if (query.isEmpty) return all;

  final asNumber = int.tryParse(query);
  final surahs = ref.watch(surahListProvider).valueOrNull;
  final namesById = <int, List<String>>{
    for (final Surah s in surahs ?? const <Surah>[])
      s.id: [s.nameTransliteration.toLowerCase(), s.nameEnglish.toLowerCase()],
  };

  bool spansAMatchingSurah(JuzSummary j) => j.surahIds.any(
    (id) => namesById[id]?.any((name) => name.contains(query)) ?? false,
  );

  return all
      .where((j) {
        if (asNumber != null && j.number == asNumber) return true;
        if (j.start.surahName.toLowerCase().contains(query)) return true;
        if (j.end.surahName.toLowerCase().contains(query)) return true;
        return spansAMatchingSurah(j);
      })
      .toList(growable: false);
}
