import 'package:freezed_annotation/freezed_annotation.dart';

part 'dhikr_history_entry.freezed.dart';
part 'dhikr_history_entry.g.dart';

/// One row of dhikr history — a record of a session/increment burst.
/// Returned by `GET /api/v1/islam/dhikr/history?from=&to=`.
@freezed
abstract class DhikrHistoryEntry with _$DhikrHistoryEntry {
  const factory DhikrHistoryEntry({
    required String id,
    String? counterId,
    String? phraseArabic,
    String? phraseEnglish,
    @Default(0) int count,
    DateTime? recordedAt,
  }) = _DhikrHistoryEntry;

  factory DhikrHistoryEntry.fromJson(Map<String, dynamic> json) =>
      _$DhikrHistoryEntryFromJson(json);
}
