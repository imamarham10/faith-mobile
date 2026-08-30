import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/dtos/scripture_chapter.dart';
import '../../data/dtos/scripture_text.dart';
import '../../data/hindu_scriptures_repository.dart';

part 'chapter_controller.g.dart';

/// Loads a text's chapter list (for chapter-picker / index UI).
@Riverpod(keepAlive: true)
Future<ScriptureTextDetail> scriptureTextDetail(Ref ref, String slug) async {
  final repo = ref.watch(hinduScripturesRepositoryProvider);
  return repo.getTextDetail(slug);
}

/// Loads a chapter with all its verses. `keepAlive` for the same
/// open→read→back→reopen reasoning as Quran's `surahDetailProvider`.
@Riverpod(keepAlive: true)
Future<ChapterDetail> chapterDetail(
  Ref ref,
  String slug,
  int chapterNumber,
) async {
  final repo = ref.watch(hinduScripturesRepositoryProvider);
  return repo.getChapter(slug, chapterNumber);
}

/// Reader display preferences — mirrors Quran's `ReaderPreferences`.
class ScriptureReaderPreferences {
  const ScriptureReaderPreferences({
    this.sanskritFontSize = 26,
    this.showTranslation = true,
  });

  final double sanskritFontSize;
  final bool showTranslation;

  ScriptureReaderPreferences copyWith({
    double? sanskritFontSize,
    bool? showTranslation,
  }) {
    return ScriptureReaderPreferences(
      sanskritFontSize: sanskritFontSize ?? this.sanskritFontSize,
      showTranslation: showTranslation ?? this.showTranslation,
    );
  }
}

@Riverpod(keepAlive: true)
class ScriptureReaderPreferencesController
    extends _$ScriptureReaderPreferencesController {
  @override
  ScriptureReaderPreferences build() => const ScriptureReaderPreferences();

  void setFontSize(double size) =>
      state = state.copyWith(sanskritFontSize: size.clamp(20, 36));

  void toggleTranslation() =>
      state = state.copyWith(showTranslation: !state.showTranslation);
}
