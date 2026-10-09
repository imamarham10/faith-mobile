/// The three read/write calls the Today screen makes against the retention
/// engine.
///
/// Task 1.12. `POST /events` is deliberately *not* here — it belongs to
/// [ActivityFlusher], which owns the queue semantics §4.8 defines and must
/// be the only caller.
library;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/providers.dart';
import '../../../shared/habit/activity_event.dart';
import '../../../shared/habit/streak_engine.dart';
import 'dtos/activity_snapshot.dart';

part 'activity_repository.g.dart';

/// Reads the activity projections and writes the goal.
class ActivityRepository {
  /// Builds a repository over [dio].
  const ActivityRepository(this._dio);

  /// §6.2 — at most 92 days inclusive per request.
  static const int maxHistoryDays = 92;

  final Dio _dio;

  /// `GET /activity/today` (§5).
  ///
  /// [timezone] is **required** by the contract and is the IANA name from
  /// the device, never an abbreviation or an offset (§1.5). Without it the
  /// server would answer "what day is it?" from its own UTC clock and a
  /// user in Asia/Kolkata at 02:00 would be shown yesterday.
  ///
  /// A brand-new user gets a zero-valued `200`, not a `404` (§5.4), so
  /// there is no empty-state branch here.
  Future<ActivityTodaySnapshot> getToday({
    required ActivityFaith faith,
    required String timezone,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/api/v1/activity/today',
        queryParameters: {'faithId': faith.wireValue, 'timezone': timezone},
      );
      return ActivityTodaySnapshot.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `GET /activity/history` over `[from, to]` inclusive (§6).
  ///
  /// The response is dense — one entry per day, gaps filled by the server —
  /// so the caller can index it without reconstructing missing days.
  ///
  /// Ranges longer than [maxHistoryDays] are rejected as `range_too_large`
  /// rather than truncated, so the window is clamped here instead: a chart
  /// that is absent is better than one that is wrong, but a window that was
  /// simply asked for too wide is a caller bug worth fixing silently.
  Future<List<ActivityHistoryDay>> getHistory({
    required ActivityFaith faith,
    required String from,
    required String to,
  }) async {
    final span = daysBetween(from, to) + 1;
    final clampedFrom = span > maxHistoryDays
        ? addDays(to, -(maxHistoryDays - 1))
        : from;
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/api/v1/activity/history',
        queryParameters: {
          'faithId': faith.wireValue,
          'from': clampedFrom,
          'to': to,
        },
      );
      final days = response.data?['days'];
      if (days is! List) return const <ActivityHistoryDay>[];
      return [
        for (final day in days)
          if (day is Map) ActivityHistoryDay.fromJson(day),
      ];
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `PUT /activity/goal` — set or replace the daily goal (§7).
  ///
  /// The response re-evaluates today against the **new** goal (§7.3), so
  /// the caller updates the card from what comes back and does not need a
  /// follow-up `GET /today`. Changing `goalType` changes which activity is
  /// counted, so `progress` can jump; that is correct, not a bug.
  ///
  /// [timezone] is optional in the contract and sent anyway: its fallbacks
  /// exist for robustness, not for use, and it decides which `localDay` the
  /// new goal takes effect from (§7.4).
  Future<ActivityGoalSnapshot> putGoal({
    required ActivityFaith faith,
    required GoalType goalType,
    required int target,
    required String timezone,
  }) async {
    if (goalType.faith != faith) {
      // The server calls this `goal_type_faith_mismatch`. It is a client
      // bug, and failing here makes the call site's mistake obvious.
      throw ArgumentError.value(
        goalType,
        'goalType',
        'belongs to ${goalType.faith.wireValue}, not ${faith.wireValue}',
      );
    }
    if (target < 1 || target > goalType.maxTarget) {
      throw ArgumentError.value(
        target,
        'target',
        'must be 1…${goalType.maxTarget} for ${goalType.wireValue}',
      );
    }
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        '/api/v1/activity/goal',
        data: {
          'faithId': faith.wireValue,
          'goalType': goalType.wireValue,
          'target': target,
          'timezone': timezone,
        },
      );
      return ActivityGoalSnapshot.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

/// The app's activity repository.
@Riverpod(keepAlive: true)
ActivityRepository activityRepository(Ref ref) =>
    ActivityRepository(ref.watch(dioProvider));
