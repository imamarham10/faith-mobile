import 'package:freezed_annotation/freezed_annotation.dart';

part 'japa_phrase.freezed.dart';
part 'japa_phrase.g.dart';

/// A mantra dictionary entry — `GET /api/v1/hindu/japa/mantras`, public.
///
/// Unlike Dhikr's dictionary entries, the backend doesn't return an `id` or
/// a per-phrase recommended count. [id] is synthesized from
/// [transliteration]. [recommendedCount] defaults to 108 (the traditional
/// japa mala bead count) for server-sourced entries, via `@Default`; the
/// New Counter sheet's custom-entry path overrides it with the user's own
/// typed target instead of leaving it stuck at 108.
@freezed
abstract class JapaPhrase with _$JapaPhrase {
  const factory JapaPhrase({
    required String sanskrit,
    required String transliteration,
    required String english,
    required String category,
    String? deityKey,
    @Default(108) int recommendedCount,
  }) = _JapaPhrase;

  const JapaPhrase._();

  factory JapaPhrase.fromJson(Map<String, dynamic> json) =>
      _$JapaPhraseFromJson(json);

  /// Slugified from [transliteration] — stable across rebuilds since the
  /// dictionary is a fixed, server-curated list.
  String get id =>
      transliteration.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');
}
