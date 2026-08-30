import 'package:freezed_annotation/freezed_annotation.dart';

part 'stotra_translation.freezed.dart';
part 'stotra_translation.g.dart';

/// One verse's translation in a given language. A verse's `translations`
/// array can be empty if no translation exists for the requested `?lang=`.
@freezed
abstract class StotraTranslation with _$StotraTranslation {
  const factory StotraTranslation({
    required String languageCode,
    required String text,
  }) = _StotraTranslation;

  factory StotraTranslation.fromJson(Map<String, dynamic> json) =>
      _$StotraTranslationFromJson(json);
}
