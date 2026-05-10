import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/dtos/verse.dart';
import '../../data/quran_repository.dart';

part 'surah_controller.g.dart';

/// Loads a surah with all its verses. `keepAlive` is intentional — the most
/// common navigation pattern is open → read → back → reopen, and we don't
/// want to re-fetch in that window.
@Riverpod(keepAlive: true)
Future<SurahDetail> surahDetail(Ref ref, int surahId) async {
  final repo = ref.watch(quranRepositoryProvider);
  return repo.getSurah(surahId);
}

/// Reader display preferences. Persisted in-memory for now; can be lifted to
/// `shared_preferences` later without changing the call sites.
class ReaderPreferences {
  const ReaderPreferences({
    this.arabicFontSize = 28,
    this.showTranslation = true,
  });

  final double arabicFontSize;
  final bool showTranslation;

  ReaderPreferences copyWith({double? arabicFontSize, bool? showTranslation}) {
    return ReaderPreferences(
      arabicFontSize: arabicFontSize ?? this.arabicFontSize,
      showTranslation: showTranslation ?? this.showTranslation,
    );
  }
}

@Riverpod(keepAlive: true)
class ReaderPreferencesController extends _$ReaderPreferencesController {
  @override
  ReaderPreferences build() => const ReaderPreferences();

  void setFontSize(double size) =>
      state = state.copyWith(arabicFontSize: size.clamp(24, 40));

  void toggleTranslation() =>
      state = state.copyWith(showTranslation: !state.showTranslation);
}
