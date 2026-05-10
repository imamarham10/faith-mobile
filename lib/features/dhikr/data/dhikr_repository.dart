import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/providers.dart';
import 'dtos/dhikr_counter.dart';
import 'dtos/dhikr_goal.dart';
import 'dtos/dhikr_history_entry.dart';
import 'dtos/dhikr_phrase.dart';

part 'dhikr_repository.g.dart';

/// HTTP boundary for Dhikr endpoints under `/api/v1/islam/dhikr/*`.
///
/// Translates Dio failures into [ApiException]; never lets transport errors
/// bubble into widgets. For best-effort writes (increment / delete) we
/// swallow errors silently — the local optimistic state is canonical and we
/// log failures via dart:developer for diagnostics.
class DhikrRepository {
  DhikrRepository(this._dio);

  static const String _base = '/api/v1/islam/dhikr';

  final Dio _dio;

  // ---- Counters ----

  /// `GET /counters` — user's counters.
  Future<List<DhikrCounter>> getCounters() async {
    try {
      final res = await _dio.get<dynamic>('$_base/counters');
      final data = res.data;
      if (data is! List) return const <DhikrCounter>[];
      return data
          .whereType<Map<String, dynamic>>()
          .map(DhikrCounter.fromJson)
          .toList(growable: false);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `POST /counters` — create a counter.
  Future<DhikrCounter> createCounter({
    required String name,
    required String phrase,
    String? phraseArabic,
    int targetCount = 33,
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '$_base/counters',
        data: {
          'name': name,
          'phrase': phrase,
          if (phraseArabic != null) 'phraseArabic': phraseArabic,
          'targetCount': targetCount,
        },
      );
      final data = res.data;
      if (data == null) {
        throw const ApiException(message: 'Empty counter response.');
      }
      return DhikrCounter.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `PATCH /counters/:id` — update or increment a counter.
  ///
  /// Backend semantics (per APIs.md): the body's `count` is added to the
  /// stored count. We send the delta from optimistic UI; on success the
  /// server returns the new total.
  Future<DhikrCounter> incrementCounter({
    required String id,
    int by = 1,
  }) async {
    try {
      final res = await _dio.patch<Map<String, dynamic>>(
        '$_base/counters/$id',
        data: {'count': by},
      );
      final data = res.data;
      if (data == null) {
        throw const ApiException(message: 'Empty counter response.');
      }
      return DhikrCounter.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `PATCH /counters/:id` — update phrase / target / set count absolute.
  ///
  /// Used for "change goal" and "reset". The same route also handles
  /// increments; the backend partitions by field, so absolute updates use
  /// `setCount`/`targetCount`/`name` and never the delta `count` field.
  Future<DhikrCounter> updateCounter({
    required String id,
    String? name,
    int? targetCount,
    int? setCount,
  }) async {
    try {
      final res = await _dio.patch<Map<String, dynamic>>(
        '$_base/counters/$id',
        data: {
          if (name != null) 'name': name,
          if (targetCount != null) 'targetCount': targetCount,
          if (setCount != null) 'setCount': setCount,
        },
      );
      final data = res.data;
      if (data == null) {
        throw const ApiException(message: 'Empty counter response.');
      }
      return DhikrCounter.fromJson(data);
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

  /// `GET /dictionary` — predefined phrases the user can pick from.
  ///
  /// Falls back to a built-in list if the endpoint is missing or fails;
  /// the New Counter sheet always shows useful suggestions.
  Future<List<DhikrPhrase>> getDictionary() async {
    try {
      final res = await _dio.get<dynamic>('$_base/dictionary');
      final data = res.data;
      if (data is! List) return _fallbackDictionary;
      final parsed = data
          .whereType<Map<String, dynamic>>()
          .map(DhikrPhrase.fromJson)
          .toList(growable: false);
      return parsed.isEmpty ? _fallbackDictionary : parsed;
    } on DioException {
      return _fallbackDictionary;
    }
  }

  // ---- Goals ----

  /// `GET /goals` — user's dhikr goals.
  Future<List<DhikrGoal>> getGoals() async {
    try {
      final res = await _dio.get<dynamic>('$_base/goals');
      final data = res.data;
      if (data is! List) return const <DhikrGoal>[];
      return data
          .whereType<Map<String, dynamic>>()
          .map(DhikrGoal.fromJson)
          .toList(growable: false);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `POST /goals` — create a goal.
  Future<DhikrGoal> createGoal({
    required String phrase,
    required int targetCount,
    required DhikrGoalPeriod period,
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '$_base/goals',
        data: {
          'phrase': phrase,
          'targetCount': targetCount,
          'period': period.apiValue,
        },
      );
      final data = res.data;
      if (data == null) {
        throw const ApiException(message: 'Empty goal response.');
      }
      return DhikrGoal.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  // ---- History ----

  /// `GET /history?from=&to=` — session history.
  Future<List<DhikrHistoryEntry>> getHistory({
    DateTime? from,
    DateTime? to,
  }) async {
    try {
      final res = await _dio.get<dynamic>(
        '$_base/history',
        queryParameters: {
          if (from != null) 'from': _ymd(from),
          if (to != null) 'to': _ymd(to),
        },
      );
      final data = res.data;
      if (data is! List) return const <DhikrHistoryEntry>[];
      return data
          .whereType<Map<String, dynamic>>()
          .map(DhikrHistoryEntry.fromJson)
          .toList(growable: false);
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

  /// Built-in dhikr dictionary used as a backstop. The four pillars of
  /// post-prayer dhikr plus a couple staples.
  static const List<DhikrPhrase> _fallbackDictionary = [
    DhikrPhrase(
      id: 'subhan-allah',
      phraseArabic: 'سُبْحَانَ اللَّهِ',
      phraseTransliteration: 'SubḥānAllāh',
      meaning: 'Glory be to Allah',
      recommendedCount: 33,
    ),
    DhikrPhrase(
      id: 'alhamdulillah',
      phraseArabic: 'الْحَمْدُ لِلَّهِ',
      phraseTransliteration: 'Alḥamdulillāh',
      meaning: 'All praise is due to Allah',
      recommendedCount: 33,
    ),
    DhikrPhrase(
      id: 'allahu-akbar',
      phraseArabic: 'اللَّهُ أَكْبَرُ',
      phraseTransliteration: 'Allāhu Akbar',
      meaning: 'Allah is the Greatest',
      recommendedCount: 34,
    ),
    DhikrPhrase(
      id: 'la-ilaha-illallah',
      phraseArabic: 'لَا إِلَٰهَ إِلَّا اللَّهُ',
      phraseTransliteration: 'Lā ilāha illa-llāh',
      meaning: 'There is no god but Allah',
      recommendedCount: 100,
    ),
    DhikrPhrase(
      id: 'astaghfirullah',
      phraseArabic: 'أَسْتَغْفِرُ اللَّهَ',
      phraseTransliteration: 'Astaghfirullāh',
      meaning: 'I seek forgiveness from Allah',
      recommendedCount: 100,
    ),
    DhikrPhrase(
      id: 'la-hawla',
      phraseArabic: 'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
      phraseTransliteration: 'Lā ḥawla wa lā quwwata illā billāh',
      meaning: 'There is no power nor might except with Allah',
      recommendedCount: 33,
    ),
    DhikrPhrase(
      id: 'salawat',
      phraseArabic: 'اللَّهُمَّ صَلِّ عَلَىٰ مُحَمَّدٍ',
      phraseTransliteration: 'Allāhumma ṣalli ʿalā Muḥammad',
      meaning: 'O Allah, send blessings upon Muhammad',
      recommendedCount: 100,
    ),
  ];
}

@Riverpod(keepAlive: true)
DhikrRepository dhikrRepository(Ref ref) =>
    DhikrRepository(ref.watch(dioProvider));
