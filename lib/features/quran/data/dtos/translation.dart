import 'package:freezed_annotation/freezed_annotation.dart';

part 'translation.freezed.dart';
part 'translation.g.dart';

/// One translation of a verse, returned in the verse payload.
///
/// [isPremium] is on the wire and has to be modelled, not ignored: the
/// public `GET /surah/:id` attaches **every** edition for the language —
/// four of the five English ones are paid — and the readers all render
/// `translations.first`. Which edition that lands on is array order, which
/// is no contract at all. [QuranRepository.getSurah] uses this flag to keep
/// only the free edition, so "first" becomes a decision rather than luck.
@freezed
abstract class Translation with _$Translation {
  const factory Translation({
    required String language,
    required String authorName,
    required String text,
    @Default(false) bool isPremium,
  }) = _Translation;

  factory Translation.fromJson(Map<String, dynamic> json) =>
      _$TranslationFromJson(json);
}
