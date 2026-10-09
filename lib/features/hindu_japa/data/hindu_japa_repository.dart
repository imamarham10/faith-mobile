import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/providers.dart';
import 'dtos/japa_counter.dart';
import 'dtos/japa_goal.dart';
import 'dtos/japa_history_entry.dart';
import 'dtos/japa_phrase.dart';
import 'dtos/japa_stats.dart';

part 'hindu_japa_repository.g.dart';

/// HTTP boundary for Hindu japa endpoints under `/api/v1/hindu/japa/*`.
/// Mirrors `dhikr_repository.dart`'s shape, with one key semantic
/// difference: this backend's `PATCH /counters/:id` treats `count` as the
/// **absolute** new value (the server diffs it against the stored value to
/// write a history row), not a delta added server-side like Dhikr's. There
/// is therefore no separate increment-vs-update split here — one
/// `updateCounter` method covers both.
class HinduJapaRepository {
  HinduJapaRepository(this._dio);

  static const String _base = '/api/v1/hindu/japa';

  final Dio _dio;

  // ---- Counters ----

  /// `GET /counters` — user's counters.
  Future<List<JapaCounter>> getCounters() async {
    try {
      final res = await _dio.get<dynamic>('$_base/counters');
      final data = res.data;
      if (data is! List) return const <JapaCounter>[];
      return data
          .whereType<Map<String, dynamic>>()
          .map(JapaCounter.fromJson)
          .toList(growable: false);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `POST /counters` — create a counter.
  Future<JapaCounter> createCounter({
    required String name,
    String? mantraSanskrit,
    String? mantraEnglish,
    int? targetCount,
    String? deityKey,
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '$_base/counters',
        data: {
          'name': name,
          if (mantraSanskrit != null) 'mantraSanskrit': mantraSanskrit,
          if (mantraEnglish != null) 'mantraEnglish': mantraEnglish,
          if (targetCount != null) 'targetCount': targetCount,
          if (deityKey != null) 'deityKey': deityKey,
        },
      );
      final data = res.data;
      if (data == null) {
        throw const ApiException(message: 'Empty counter response.');
      }
      return JapaCounter.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `PATCH /counters/:id` — update name / target / active flag, or set the
  /// count to an absolute value (used for both increments — send
  /// `current + delta` — and resets — send `0`).
  Future<JapaCounter> updateCounter({
    required String id,
    int? count,
    String? name,
    int? targetCount,
    bool? isActive,
  }) async {
    try {
      final res = await _dio.patch<Map<String, dynamic>>(
        '$_base/counters/$id',
        data: {
          if (count != null) 'count': count,
          if (name != null) 'name': name,
          if (targetCount != null) 'targetCount': targetCount,
          if (isActive != null) 'isActive': isActive,
        },
      );
      final data = res.data;
      if (data == null) {
        throw const ApiException(message: 'Empty counter response.');
      }
      return JapaCounter.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `DELETE /counters/:id` — remove a counter.
  Future<void> deleteCounter(String id) async {
    try {
      await _dio.delete<dynamic>('$_base/counters/$id');
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  // ---- Dictionary ----

  /// `GET /mantras?category=&deity=` — public mantra dictionary.
  ///
  /// Unlike Dhikr's dictionary, no built-in fallback list is used here:
  /// hand-transcribing Devanagari from memory risks shipping incorrect
  /// Sanskrit, which is worse than an honest empty/error state.
  Future<List<JapaPhrase>> getMantras({String? category, String? deity}) async {
    try {
      final res = await _dio.get<dynamic>(
        '$_base/mantras',
        queryParameters: {
          if (deity != null)
            'deity': deity
          else if (category != null)
            'category': category,
        },
      );
      final data = res.data;
      if (data is! List) return const <JapaPhrase>[];
      return data
          .whereType<Map<String, dynamic>>()
          .map(JapaPhrase.fromJson)
          .toList(growable: false);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  // ---- Goals ----

  /// `GET /goals` — user's japa goals, server-decorated with progress.
  Future<List<JapaGoal>> getGoals() async {
    try {
      final res = await _dio.get<dynamic>('$_base/goals');
      final data = res.data;
      if (data is! List) return const <JapaGoal>[];
      return data
          .whereType<Map<String, dynamic>>()
          .map(JapaGoal.fromJson)
          .toList(growable: false);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `POST /goals` — create a goal. `startDate`/`endDate` are required by
  /// the backend, unlike Dhikr goals.
  Future<JapaGoal> createGoal({
    required String mantraSanskrit,
    required int targetCount,
    required JapaGoalPeriod period,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '$_base/goals',
        data: {
          'mantraSanskrit': mantraSanskrit,
          'targetCount': targetCount,
          'period': period.apiValue,
          'startDate': _ymd(startDate),
          'endDate': _ymd(endDate),
        },
      );
      final data = res.data;
      if (data == null) {
        throw const ApiException(message: 'Empty goal response.');
      }
      return JapaGoal.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  // ---- History ----

  /// `GET /history` — last 90 rows, most recent first.
  Future<List<JapaHistoryEntry>> getHistory() async {
    try {
      final res = await _dio.get<dynamic>('$_base/history');
      final data = res.data;
      if (data is! List) return const <JapaHistoryEntry>[];
      return data
          .whereType<Map<String, dynamic>>()
          .map(JapaHistoryEntry.fromJson)
          .toList(growable: false);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  // ---- Stats ----

  /// `GET /stats` — streaks and averages. No Dhikr equivalent.
  Future<JapaStats> getStats() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('$_base/stats');
      final data = res.data;
      if (data == null) return const JapaStats();
      return JapaStats.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  static String _ymd(DateTime d) {
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }
}

@Riverpod(keepAlive: true)
HinduJapaRepository hinduJapaRepository(Ref ref) =>
    HinduJapaRepository(ref.watch(dioProvider));
