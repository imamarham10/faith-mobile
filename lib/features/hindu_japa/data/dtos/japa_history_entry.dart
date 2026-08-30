import 'package:freezed_annotation/freezed_annotation.dart';

part 'japa_history_entry.freezed.dart';
part 'japa_history_entry.g.dart';

/// One row of japa history — returned by `GET /api/v1/hindu/japa/history`.
///
/// Unlike Dhikr's history entry (`counterId` + `recordedAt`), this backend
/// keys history by the mantra text itself (`mantra`) and a day-level `date`
/// — there is no counter foreign key stored on history rows.
@freezed
abstract class JapaHistoryEntry with _$JapaHistoryEntry {
  const factory JapaHistoryEntry({
    required String id,
    String? userId,
    required String mantra,
    @Default(0) int count,
    required DateTime date,
    DateTime? createdAt,
  }) = _JapaHistoryEntry;

  factory JapaHistoryEntry.fromJson(Map<String, dynamic> json) =>
      _$JapaHistoryEntryFromJson(json);
}
