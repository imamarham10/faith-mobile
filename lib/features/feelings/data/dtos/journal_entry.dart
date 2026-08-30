import 'package:freezed_annotation/freezed_annotation.dart';

part 'journal_entry.freezed.dart';
part 'journal_entry.g.dart';

/// Script the remedy snapshot's [JournalRemedySnapshot.primaryText] is
/// written in — picks the font/direction the journal should render it with,
/// since a plain `Text` renders Arabic and Devanagari without the styling
/// the rest of the app uses for scripture.
enum JournalRemedyScript {
  @JsonValue('arabic')
  arabic,
  @JsonValue('sanskrit')
  sanskrit,
}

/// A frozen copy of the remedy shown alongside a reflection at save time —
/// so opening an old journal entry later can still answer "which verse (or
/// dua/hadith) brought me this reflection?" without depending on that
/// content still existing, unchanged, on the server.
@freezed
abstract class JournalRemedySnapshot with _$JournalRemedySnapshot {
  const factory JournalRemedySnapshot({
    required String primaryText,
    JournalRemedyScript? script,
    String? transliteration,
    String? translation,
    String? reference,
    String? note,
    String? deepLink,
  }) = _JournalRemedySnapshot;

  factory JournalRemedySnapshot.fromJson(Map<String, dynamic> json) =>
      _$JournalRemedySnapshotFromJson(json);
}

/// A single reflection journal entry.
///
/// Persisted client-side for now (the backend endpoint isn't documented in
/// APIs.md). Once the server-side resource ships, the same shape maps over
/// directly.
@freezed
abstract class JournalEntry with _$JournalEntry {
  const factory JournalEntry({
    required String id,
    required String mood,
    required String note,
    required DateTime createdAt,
    @Default(<JournalRemedySnapshot>[]) List<JournalRemedySnapshot> remedies,
  }) = _JournalEntry;

  factory JournalEntry.fromJson(Map<String, dynamic> json) =>
      _$JournalEntryFromJson(json);
}
