/// The typed façade every feature calls. The only analytics API in `lib/`
/// outside `core/telemetry`.
///
/// Read the signatures below and note what is missing: **not one method
/// takes a `String`.** Every argument is an `int` or an enum from
/// `telemetry_vocabulary.dart`. There is no `logEvent(name, params)` to
/// reach for, which means there is no syntax in which an emotion slug, a
/// journal line, an email address or a faith id can be passed to analytics
/// at all. The privacy rule is enforced by the type checker rather than by
/// a code review that might not happen.
library;

import 'analytics_sink.dart';
import 'telemetry_vocabulary.dart';

/// Siraat's analytics surface.
///
/// Obtain it from `analyticsProvider` (see `telemetry.dart`); it is backed
/// by [NoopAnalyticsSink] whenever collection is off, so call sites never
/// branch on whether telemetry is enabled.
class SiraatAnalytics {
  const SiraatAnalytics(this._sink);

  final AnalyticsSink _sink;

  // ---------------------------------------------------------------------
  // Onboarding — the one stretch of the app that happens before there is a
  // user, and therefore the only funnel our own backend cannot reconstruct.
  // ---------------------------------------------------------------------

  /// A first-launch intro slide was reached. [slideIndex] is zero-based and
  /// clamped: it is an index into a fixed list, so a value outside it is a
  /// bug, not data.
  Future<void> onboardingSlideViewed(int slideIndex) => _sink.logEvent(
    AnalyticsEvent.onboardingSlideViewed,
    {AnalyticsParam.slideIndex: slideIndex.clamp(0, 99)},
  );

  /// The faith picker was completed.
  ///
  /// Takes no argument, and must never gain one. See
  /// [AnalyticsEvent.onboardingFaithChosen] for why: which faith a person
  /// follows does not go to Google, as a parameter or anything else.
  Future<void> onboardingFaithChosen() =>
      _sink.logEvent(AnalyticsEvent.onboardingFaithChosen);

  // ---------------------------------------------------------------------
  // Auth — attempts and failures are invisible to the backend, which only
  // ever learns about the successes.
  // ---------------------------------------------------------------------

  Future<void> authStarted(AnalyticsAuthMethod method) => _sink.logEvent(
    AnalyticsEvent.authStarted,
    {AnalyticsParam.method: method},
  );

  Future<void> authSucceeded(AnalyticsAuthMethod method) => _sink.logEvent(
    AnalyticsEvent.authSucceeded,
    {AnalyticsParam.method: method},
  );

  /// [reason] is a coarse classification, never a server message — a
  /// message can quote the address that was typed.
  Future<void> authFailed(
    AnalyticsAuthMethod method,
    AnalyticsAuthFailure reason,
  ) => _sink.logEvent(AnalyticsEvent.authFailed, {
    AnalyticsParam.method: method,
    AnalyticsParam.reason: reason,
  });

  // ---------------------------------------------------------------------
  // OS permissions — the silent cohort. A user who denied notifications
  // looks identical to an engaged one from the server's side.
  // ---------------------------------------------------------------------

  Future<void> permissionRequested(AnalyticsPermission permission) =>
      _sink.logEvent(AnalyticsEvent.permissionRequested, {
        AnalyticsParam.permission: permission,
      });

  Future<void> permissionResolved(
    AnalyticsPermission permission,
    AnalyticsPermissionOutcome outcome,
  ) => _sink.logEvent(AnalyticsEvent.permissionResolved, {
    AnalyticsParam.permission: permission,
    AnalyticsParam.outcome: outcome,
  });

  // ---------------------------------------------------------------------
  // In-app acts that the activity stream does not already record.
  // ---------------------------------------------------------------------

  /// The mood picker was opened. Count the act, never the content: there
  /// is no parameter on this event and there must never be one.
  Future<void> feelingsOpened() =>
      _sink.logEvent(AnalyticsEvent.feelingsOpened);

  /// A share card left the app through the system sheet. No parameter —
  /// the kind of content would imply the user's faith.
  Future<void> shareCompleted() =>
      _sink.logEvent(AnalyticsEvent.shareCompleted);

  /// A non-fatal client-side failure, by coarse area. The detail belongs
  /// in Crashlytics (`Telemetry.instance.recordError`); this is here so
  /// the rate is joinable against GA4's funnels and cohorts.
  Future<void> appError(AnalyticsErrorArea area) =>
      _sink.logEvent(AnalyticsEvent.appError, {AnalyticsParam.area: area});

  // ---------------------------------------------------------------------
  // Screens.
  // ---------------------------------------------------------------------

  /// Logs a manual `screen_view`.
  ///
  /// Only an allowlisted constant can be passed. Automatic screen
  /// reporting is off and `FirebaseAnalyticsObserver` is not installed,
  /// because both would name the screen after the route — and one of this
  /// app's routes is `/reflect/feelings/:mood`.
  Future<void> screenViewed(AnalyticsScreen screen) => _sink.logScreen(screen);
}
