/// Crash reporting, analytics bootstrap, and the single kill switch for
/// both.
///
/// ## The one place that turns everything off
///
/// [Telemetry.setEnabled] is the only switch. It persists the user's
/// choice, flips Firebase's own `setCrashlyticsCollectionEnabled` and
/// `setAnalyticsCollectionEnabled` (so the native SDKs stop collecting,
/// not merely stop being called), and swaps the analytics sink for
/// [NoopAnalyticsSink]. Nothing else in the app has a path to Google that
/// does not pass through here, which is what makes the Play Data Safety
/// answer "users can turn this off" a thing we can point at rather than
/// assert.
///
/// ## Builds that never report
///
/// [Telemetry.isEligibleBuild] is `false` in debug, in profile, and under
/// `flutter test`. In those builds [bootstrap] returns before it installs
/// a single error handler: Flutter's own red-screen and console reporting
/// stays exactly as it was, no Firebase SDK is initialised, and the
/// analytics sink stays [NoopAnalyticsSink] forever. Developer crashes and
/// test failures therefore cannot pollute production crash-free rates, and
/// the 797 tests in this repo run with telemetry structurally absent
/// rather than merely unconfigured.
///
/// ## Missing Firebase config
///
/// `android/app/google-services.json` is not in this repository — a
/// Firebase project needs the owner's Google account. Without it
/// `Firebase.initializeApp()` throws, so [bootstrap] catches it, logs, and
/// leaves collection off. The app runs identically; it simply reports
/// nothing. Drop the file in and the next release build starts reporting
/// with no code change.
///
/// ## Cold start
///
/// [bootstrap] is synchronous and does no I/O. It installs three error
/// handlers (cheap field assignments) and then fires `_start()` without
/// awaiting it, so `main()` reaches `runApp` at exactly the moment it did
/// before. Errors thrown in the window before Firebase finishes
/// initialising are held in a small bounded buffer and replayed once it
/// does — a crash during the first 300ms is the most valuable crash there
/// is, and dropping it to keep the boot cheap would defeat the point.
library;

import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io' show Platform;
import 'dart:isolate';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'analytics_sink.dart';
import 'siraat_analytics.dart';
import 'telemetry_vocabulary.dart';

/// An error that arrived before Firebase was ready.
class _BufferedError {
  const _BufferedError(this.error, this.stack, {required this.fatal});

  final Object error;
  final StackTrace stack;
  final bool fatal;
}

/// Process-wide telemetry. One instance, created lazily, never disposed.
class Telemetry {
  Telemetry._();

  /// The singleton. A singleton rather than a provider because the error
  /// handlers must be installed in `main()` before there is a
  /// `ProviderScope` to read from.
  static final Telemetry instance = Telemetry._();

  /// Where the user's choice lives. Versioned so a future change to the
  /// default cannot silently re-enable collection for someone who opted
  /// out: a new key reads as "never asked", not as "opted in".
  static const String optOutPrefsKey = 'telemetry_opt_out_v1';

  /// How many pre-init errors to hold. Enough for the handful a boot
  /// failure produces, small enough that a crash loop cannot grow it.
  static const int _maxBufferedErrors = 16;

  /// Whether this *build* may report at all, before any user preference is
  /// consulted.
  ///
  /// Debug and profile builds are excluded by [kReleaseMode]. Tests are
  /// excluded again by `FLUTTER_TEST`, which `flutter_test` sets in the
  /// child process — belt and braces, because a crash-free rate poisoned
  /// by CI is not something you notice until you are trying to read it.
  static bool get isEligibleBuild => kReleaseMode && !_isUnderTest;

  static bool get _isUnderTest {
    if (kIsWeb) return false;
    try {
      return Platform.environment.containsKey('FLUTTER_TEST');
    } on Object {
      return false;
    }
  }

  bool _bootstrapped = false;
  bool _firebaseReady = false;
  bool _collecting = false;

  /// The user's stored choice: `false` opted in, `true` opted out, `null`
  /// not yet known — either because the preference has not been read yet
  /// or because reading it failed. The null case is why [_record] keeps
  /// buffering past [_firebaseReady]: "we could not tell" must not be
  /// indistinguishable from "they said no".
  bool? _consent;
  AnalyticsSink _sink = const NoopAnalyticsSink();
  FirebaseAnalyticsSink? _firebaseSink;
  FirebaseCrashlytics? _crashlytics;
  final List<_BufferedError> _buffered = <_BufferedError>[];

  /// Whether anything is currently being sent.
  bool get isCollecting => _collecting;

  /// The typed analytics façade. Backed by [NoopAnalyticsSink] whenever
  /// collection is off, so call sites never have to ask.
  SiraatAnalytics get analytics => SiraatAnalytics(_sink);

  /// Installs the error handlers and starts Firebase in the background.
  ///
  /// Synchronous and I/O-free; safe to call as the first statement of
  /// `main()`. Idempotent.
  void bootstrap() {
    if (_bootstrapped) return;
    _bootstrapped = true;
    if (!isEligibleBuild) return;
    _installErrorHandlers();
    unawaited(_start());
  }

  /// The kill switch. Turns **all** collection — crashes and analytics —
  /// on or off and remembers the choice.
  ///
  /// Works in every build: in debug the preference is still written, so
  /// the settings toggle behaves normally, there is simply nothing
  /// underneath it to switch.
  Future<void> setEnabled(bool enabled) async {
    await _writeOptOut(!enabled);
    _consent = !enabled;

    // Flip the native SDKs too, not just our sink. Firebase persists this
    // flag itself, so a user who opts out stays opted out across a restart
    // even before our own preference has been read back.
    await _crashlytics?.setCrashlyticsCollectionEnabled(enabled);
    await _firebaseSink?.setCollectionEnabled(enabled);

    final firebaseSink = _firebaseSink;
    _collecting = enabled && _firebaseReady;
    _sink = _collecting && firebaseSink != null
        ? firebaseSink
        : const NoopAnalyticsSink();

    if (_collecting) {
      // Covers the recovery path: a preference read that failed at boot
      // left errors buffered, and this is the first moment we know they
      // may be sent.
      await _flushBuffered();
    } else {
      _buffered.clear();
    }
  }

  /// Whether the user has opted out. `false` when they have never chosen —
  /// collection is on by default, and the switch in Settings is how it is
  /// turned off.
  ///
  /// An unreadable preference reports `true` so the Settings switch shows
  /// "off" rather than claiming a consent we could not confirm. That is a
  /// display decision only: it does not become [_consent], and so it does
  /// not cause buffered crashes to be discarded.
  Future<bool> isOptedOut() async => await _readOptOut() ?? true;

  /// Reports a non-fatal error to Crashlytics.
  ///
  /// [area] is attached as a Crashlytics custom key, and is an enum rather
  /// than a string so the key cannot become a place somebody stashes
  /// context.
  ///
  /// Crashlytics necessarily receives [error] itself — its `toString` and
  /// stack are the whole value of crash reporting. Feature code must
  /// therefore never throw an exception whose message embeds user content:
  /// a journal line, an emotion, or an address. Throw a typed failure and
  /// let the detail stay on the device.
  Future<void> recordError(
    Object error,
    StackTrace? stack, {
    AnalyticsErrorArea? area,
    bool fatal = false,
  }) async {
    if (!isEligibleBuild) return;
    await _record(error, stack ?? StackTrace.current, fatal: fatal, area: area);
  }

  // -------------------------------------------------------------------
  // Internals
  // -------------------------------------------------------------------

  void _installErrorHandlers() {
    // 1. Framework errors (build/layout/paint). Chain to whatever was
    //    already installed so `presentError` still runs and the error is
    //    not swallowed on its way to Crashlytics.
    final previous = FlutterError.onError;
    FlutterError.onError = (details) {
      previous?.call(details);
      unawaited(
        _record(
          details.exception,
          details.stack ?? StackTrace.current,
          fatal: true,
        ),
      );
    };

    // 2. Uncaught asynchronous errors from the root zone. This is the
    //    modern replacement for wrapping `runApp` in `runZonedGuarded`,
    //    and it is why `main()` needs no zone: the boot path is untouched.
    PlatformDispatcher.instance.onError = (error, stack) {
      unawaited(_record(error, stack, fatal: true));
      // `true` means handled — the process keeps running, which is the
      // right call for an app whose users are mid-prayer.
      return true;
    };

    // 3. Errors on other isolates — audio decoding, the sqflite FFI
    //    worker, anything `compute()` is handed. These bypass both of the
    //    above entirely, which is exactly how a class of crash goes
    //    unreported for a year.
    //
    //    The body is wrapped because a throw inside a raw port callback
    //    has nothing above it to catch it and can take the isolate down.
    //    A crash reporter that becomes a crash cause on an unexpected
    //    payload shape is worse than no crash reporter.
    Isolate.current.addErrorListener(
      RawReceivePort((dynamic pair) {
        try {
          final parts = pair as List<dynamic>;
          unawaited(
            _record(
              parts.first ?? 'isolate error',
              StackTrace.fromString('${parts.length > 1 ? parts[1] : ''}'),
              fatal: true,
            ),
          );
        } on Object catch (e) {
          _log('malformed isolate error payload: $e');
        }
      }).sendPort,
    );
  }

  Future<void> _start() async {
    try {
      await Firebase.initializeApp();
    } on Object catch (error) {
      // Overwhelmingly: no `google-services.json`, so the default app has
      // no configuration to read. Not a failure of the app — just no
      // reporting. See the class doc for what the owner has to do.
      _log('Firebase is not configured; telemetry stays off ($error)');
      return;
    }

    _firebaseReady = true;
    final firebaseSink = FirebaseAnalyticsSink.live();
    _firebaseSink = firebaseSink;
    _crashlytics = FirebaseCrashlytics.instance;
    await _applyStoredConsent();
  }

  /// Reads the stored preference and switches collection to match.
  ///
  /// Retried once. The read is a platform channel and this runs during the
  /// cold boot, which is the moment it is least likely to answer — and a
  /// transient failure here used to disable crash reporting for the whole
  /// session, silently, for a user who had never opted out of anything.
  Future<void> _applyStoredConsent() async {
    var optedOut = await _readOptOut();
    if (optedOut == null) {
      await Future<void>.delayed(const Duration(seconds: 2));
      optedOut = await _readOptOut();
    }

    if (optedOut == null) {
      // Still unreadable. Collect nothing — an unreadable preference is
      // not consent — but leave [_consent] null and the buffer intact.
      // This is our failure, not the user's choice: [_record] keeps
      // buffering, and a later [setEnabled] replays what it held.
      _log('could not read the telemetry preference; collection stays off');
      return;
    }

    _consent = optedOut;
    await _crashlytics?.setCrashlyticsCollectionEnabled(!optedOut);
    await _firebaseSink?.setCollectionEnabled(!optedOut);
    if (optedOut) {
      // A real opt-out. Now the buffer may go: holding a user's crashes
      // after they said no is the one thing worse than losing them.
      _buffered.clear();
      return;
    }

    final firebaseSink = _firebaseSink;
    if (firebaseSink == null) return;
    _collecting = true;
    _sink = firebaseSink;
    await _flushBuffered();
  }

  /// Replays anything that arrived before collection was switched on.
  Future<void> _flushBuffered() async {
    final pending = List<_BufferedError>.from(_buffered);
    _buffered.clear();
    for (final e in pending) {
      await _record(e.error, e.stack, fatal: e.fatal);
    }
  }

  Future<void> _record(
    Object error,
    StackTrace stack, {
    required bool fatal,
    AnalyticsErrorArea? area,
  }) async {
    final crashlytics = _crashlytics;
    if (crashlytics == null || !_collecting) {
      // Not collecting. Hold onto it unless the user has actually opted
      // out — bounded, oldest-first, so a crash loop cannot grow the list.
      // Buffering while [_consent] is null is the point: Firebase may
      // still be starting, or the preference read may have failed, and
      // neither is a reason to throw a crash away.
      if (_consent != true) {
        if (_buffered.length >= _maxBufferedErrors) _buffered.removeAt(0);
        _buffered.add(_BufferedError(error, stack, fatal: fatal));
      }
      return;
    }
    try {
      if (area != null) {
        await crashlytics.setCustomKey(AnalyticsParam.area.wire, area.wire);
      }
      await crashlytics.recordError(error, stack, fatal: fatal);
    } on Object catch (e) {
      _log('could not record error: $e');
    }
  }

  /// `false` opted in, `true` opted out, `null` the preference could not
  /// be read. The three cases are deliberately distinct — see [_consent].
  Future<bool?> _readOptOut() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(optOutPrefsKey) ?? false;
    } on Object {
      return null;
    }
  }

  Future<void> _writeOptOut(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(optOutPrefsKey, value);
    } on Object catch (e) {
      _log('could not persist the telemetry preference: $e');
    }
  }

  void _log(String message) {
    if (kDebugMode) developer.log(message, name: 'telemetry');
  }
}

/// The analytics façade, for `ref.read(analyticsProvider).feelingsOpened()`.
///
/// A plain [Provider] rather than a `@riverpod` one: it is a zero-argument
/// bridge to a singleton, so codegen would add a generated file and no
/// safety. Overriding it with a recording sink is how widget tests assert
/// what a flow emits.
final analyticsProvider = Provider<SiraatAnalytics>(
  (ref) => Telemetry.instance.analytics,
);

/// Whether collection is currently allowed, for the Settings toggle.
///
/// Reads the persisted opt-out rather than [Telemetry.isCollecting] so the
/// switch shows the user's choice in every build, including debug where
/// nothing is actually sent.
final telemetryEnabledProvider = AsyncNotifierProvider<TelemetryEnabled, bool>(
  TelemetryEnabled.new,
);

/// Notifier behind [telemetryEnabledProvider].
class TelemetryEnabled extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async => !await Telemetry.instance.isOptedOut();

  /// Flips the kill switch and reflects it in the UI immediately.
  Future<void> set(bool enabled) async {
    state = AsyncData(enabled);
    await Telemetry.instance.setEnabled(enabled);
  }
}
