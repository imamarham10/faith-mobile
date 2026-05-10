import 'package:freezed_annotation/freezed_annotation.dart';

part 'translation.freezed.dart';
part 'translation.g.dart';

/// One translation of a verse, returned in the verse payload.
@freezed
abstract class Translation with _$Translation {
  const factory Translation({
    required String language,
    required String authorName,
    required String text,
  }) = _Translation;

  factory Translation.fromJson(Map<String, dynamic> json) =>
      _$TranslationFromJson(json);
}
