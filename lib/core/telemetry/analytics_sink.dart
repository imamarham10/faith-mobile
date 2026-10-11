/// The one and only door between Siraat and Google Analytics.
///
/// `FirebaseAnalytics` is imported in exactly one place in this app — the
/// [FirebaseAnalyticsSink] below — and `test/core/telemetry/
/// forbidden_data_test.dart` asserts that stays true. Everything else in
/// `lib/` talks to [SiraatAnalytics], whose API cannot express a free-form
/// string.
///
/// Note what this interface does **not** have: there is no method for user
/// properties, no `setUserId`, and no default-parameter bag. That absence
/// is load-bearing. The privacy line forbids tagging a user as Islam or
/// Hindu inside Google's systems, and the most durable way to prevent a
/// `setUserProperty(name: 'faith', …)` from ever being written is for the
/// capability not to exist. Per-faith numbers come from a query against
/// our own database, where they already live, and where they are governed
/// by our own deletion path (`LocalDataPurge` + account deletion) rather
/// than Google's retention settings.
library;

import 'dart:developer' as developer;

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

import 'telemetry_vocabulary.dart';

/// Where an analytics event goes once [SiraatAnalytics] has typed it.
abstract interface class AnalyticsSink {
  /// Logs one event. [params] has already been validated by the caller's
  /// types; [encodeAnalyticsParams] is the last line of defence.
  Future<void> logEvent(
    AnalyticsEvent event, [
    Map<AnalyticsParam, Object> params,
  ]);

  /// Logs a manual `screen_view`. The name can only be an allowlisted
  /// constant — there is no string overload.
  Future<void> logScreen(AnalyticsScreen screen);
}

/// Turns a typed parameter map into the `Map<String, Object>` Firebase
/// wants, dropping anything that is not provably from the vocabulary.
///
/// The drop is the point. Dart's `Object` value type means a caller *can*
/// pass a `String` and still compile:
///
/// ```dart
/// sink.logEvent(AnalyticsEvent.feelingsOpened,
///     {AnalyticsParam.reason: emotion.slug});  // compiles…
/// ```
///
/// …and this function is what makes it harmless: `slug` is neither an
/// `int` nor an [AnalyticsVocabulary], so it is dropped and never reaches
/// the wire. In debug it is also logged loudly so the mistake surfaces
/// during development rather than in a Play Data Safety review.
///
/// There is no branch here that forwards a `String` through. That is the
/// property `forbidden_data_test.dart` asserts directly.
Map<String, Object> encodeAnalyticsParams(Map<AnalyticsParam, Object> params) {
  final out = <String, Object>{};
  for (final entry in params.entries) {
    final value = entry.value;
    if (value is int) {
      out[entry.key.wire] = value;
    } else if (value is AnalyticsVocabulary) {
      out[entry.key.wire] = value.wire;
    } else if (kDebugMode) {
      developer.log(
        'dropped a non-vocabulary analytics value for '
        '"${entry.key.wire}" (${value.runtimeType}). Parameter values must '
        'be an int or an AnalyticsVocabulary enum — free text can carry '
        'an emotion slug, a journal line or a faith, none of which may '
        'leave the device.',
        name: 'telemetry',
      );
    }
  }
  return out;
}

/// Sends nothing. The sink every build gets until Firebase is both
/// configured and switched on — which is to say: all debug builds, all
/// tests, every build with no `google-services.json`, and every user who
/// has turned collection off.
class NoopAnalyticsSink implements AnalyticsSink {
  const NoopAnalyticsSink();

  @override
  Future<void> logEvent(
    AnalyticsEvent event, [
    Map<AnalyticsParam, Object> params = const {},
  ]) async {}

  @override
  Future<void> logScreen(AnalyticsScreen screen) async {}
}

/// The real sink, and the only place in the app that holds a
/// [FirebaseAnalytics].
///
/// Construction and the collection switch both live here so that
/// `firebase_analytics` is imported by this file and no other — which is
/// what `forbidden_data_test.dart` asserts, and what makes "there is one
/// door" a fact rather than a style note.
class FirebaseAnalyticsSink implements AnalyticsSink {
  FirebaseAnalyticsSink._(this._analytics);

  /// Binds to the default Firebase app. Only valid once
  /// `Firebase.initializeApp()` has succeeded.
  factory FirebaseAnalyticsSink.live() =>
      FirebaseAnalyticsSink._(FirebaseAnalytics.instance);

  final FirebaseAnalytics _analytics;

  /// Flips collection in the native SDK, so opting out stops the SDK
  /// collecting rather than merely stopping us calling it. Firebase
  /// persists this across restarts on its own.
  Future<void> setCollectionEnabled(bool enabled) =>
      _analytics.setAnalyticsCollectionEnabled(enabled);

  @override
  Future<void> logEvent(
    AnalyticsEvent event, [
    Map<AnalyticsParam, Object> params = const {},
  ]) async {
    try {
      await _analytics.logEvent(
        name: event.wire,
        parameters: encodeAnalyticsParams(params),
      );
    } on Object catch (error) {
      // Analytics is never worth an exception in a tap handler. Same
      // contract as ActivityRecorder: log and swallow.
      _swallow(error, event.wire);
    }
  }

  @override
  Future<void> logScreen(AnalyticsScreen screen) async {
    try {
      await _analytics.logScreenView(screenName: screen.wire);
    } on Object catch (error) {
      _swallow(error, 'screen_view');
    }
  }

  void _swallow(Object error, String what) {
    if (kDebugMode) {
      developer.log('analytics "$what" failed: $error', name: 'telemetry');
    }
  }
}
