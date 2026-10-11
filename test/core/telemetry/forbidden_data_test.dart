/// Proves that the things which must never leave this device cannot leave
/// through the analytics layer.
///
/// Siraat knows a person's religion and their emotional state. That is the
/// worst pairing this product could hold, and under the DPDP Act — India
/// is the primary market — both are sensitive personal data. The rule the
/// app is built to is: **count the act, never the content.**
///
/// A test that greps outgoing payloads for the string `"grieving"` would
/// pass today and rot the first time somebody adds an event. These tests
/// are structural instead. The analytics layer's vocabulary is a closed
/// set of enums, so the complete universe of strings the app can ever send
/// is finite and enumerable — and these tests enumerate it, exhaustively,
/// and assert the forbidden values are not in it. A new event that leaks
/// fails here by construction rather than by coincidence of wording.
library;

import 'dart:io';

import 'package:faith_mobile/core/telemetry/analytics_sink.dart';
import 'package:faith_mobile/core/telemetry/siraat_analytics.dart';
import 'package:faith_mobile/core/telemetry/telemetry.dart';
import 'package:faith_mobile/core/telemetry/telemetry_vocabulary.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/recording_analytics_sink.dart';

/// Every emotion slug the two `feelings` tables are seeded with.
///
/// Taken from `unified-faith-service/prisma/seed-feelings.ts` and
/// `seed-hindu-feelings.ts`. These are the actual values the server stores
/// against a user, and the actual values that appear in the path of
/// `/reflect/feelings/:mood`.
const List<String> _emotionSlugs = [
  'angry',
  'anxious',
  'depressed',
  'doubtful',
  'envious',
  'fearful',
  'grateful',
  'grieving',
  'guilty',
  'hurt',
  'jealous',
  'lonely',
  'lost',
  'nervous',
  'overwhelmed',
  'restless',
  'sad',
  'scared',
  'tired',
  'unmotivated',
  'weak',
];

/// Faith identifiers. Not just the values — the *concept* is banned from
/// Google's systems, so the words themselves must not appear as an event
/// name, a parameter name or a parameter value either.
const List<String> _faithValues = ['islam', 'hindu', 'muslim', 'hinduism'];

/// Parameter and event names that would be a leak whatever value they
/// carried, because the name alone declares an intent the privacy line
/// forbids.
const List<String> _bannedKeyFragments = [
  'faith',
  'religion',
  'emotion',
  'mood',
  'feeling',
  'journal',
  'reflection',
  'entry',
  'email',
  'phone',
  'name',
  'lat',
  'lng',
  'longitude',
  'latitude',
  'location',
  'coord',
  'user_id',
  'userid',
  'uid',
  'token',
  'surah',
  'ayah',
  'verse',
];

/// Sample free text, standing in for whatever somebody types into the
/// journal. It is never truncated, hashed or sanitised anywhere in this
/// app's analytics layer — it is simply never accepted.
const String _journalText =
    'I could not stop crying today and I do not want anyone to know.';

/// Calls every method on [SiraatAnalytics] with every value of every enum
/// it accepts, so the recorded emissions are the app's entire analytics
/// output — not a sample of it.
///
/// Coverage of this sweep is itself asserted below: if an event is added
/// to [AnalyticsEvent] and not driven here, the coverage test fails and
/// whoever added it has to come back and put it under these assertions.
Future<void> _emitEverything(SiraatAnalytics analytics) async {
  for (var i = 0; i < 12; i++) {
    await analytics.onboardingSlideViewed(i);
  }
  // Out-of-range indices too: clamping must not become a way to smuggle a
  // number that is really an id.
  await analytics.onboardingSlideViewed(-5);
  await analytics.onboardingSlideViewed(999999);

  await analytics.onboardingFaithChosen();
  await analytics.feelingsOpened();
  await analytics.shareCompleted();

  for (final method in AnalyticsAuthMethod.values) {
    await analytics.authStarted(method);
    await analytics.authSucceeded(method);
    for (final reason in AnalyticsAuthFailure.values) {
      await analytics.authFailed(method, reason);
    }
  }

  for (final permission in AnalyticsPermission.values) {
    await analytics.permissionRequested(permission);
    for (final outcome in AnalyticsPermissionOutcome.values) {
      await analytics.permissionResolved(permission, outcome);
    }
  }

  for (final area in AnalyticsErrorArea.values) {
    await analytics.appError(area);
  }

  for (final screen in AnalyticsScreen.values) {
    await analytics.screenViewed(screen);
  }
}

void main() {
  late RecordingAnalyticsSink sink;
  late SiraatAnalytics analytics;

  setUp(() {
    sink = RecordingAnalyticsSink();
    analytics = SiraatAnalytics(sink);
  });

  group('the analytics vocabulary is closed, and the sweep covers it', () {
    test('every event and every screen is exercised by the sweep', () async {
      // The guard on every other test in this file. They assert over the
      // output of `_emitEverything`; this asserts `_emitEverything` is
      // actually everything.
      await _emitEverything(analytics);

      final names = sink.emissions.map((e) => e.name).toSet();
      for (final event in AnalyticsEvent.values) {
        expect(
          names,
          contains(event.wire),
          reason:
              '"${event.wire}" was added to AnalyticsEvent but is not driven '
              'by _emitEverything, so none of the privacy assertions in this '
              'file have looked at it. Add it to the sweep.',
        );
      }

      final screens = sink.emissions
          .where((e) => e.name == 'screen_view')
          .map((e) => e.params['screen_name'])
          .toSet();
      for (final screen in AnalyticsScreen.values) {
        expect(screens, contains(screen.wire));
      }
    });
  });

  group('no emotion ever reaches the analytics layer', () {
    test('no emission contains an emotion slug, anywhere', () async {
      await _emitEverything(analytics);

      final wire = sink.wireStrings.toList();
      for (final slug in _emotionSlugs) {
        expect(
          wire.where((s) => s.contains(slug)),
          isEmpty,
          reason:
              'the emotion "$slug" appears in an analytics emission. Which '
              'feeling a person selected is the single value this app may '
              'never send: not as an event, not as a parameter, not as a '
              'user property.',
        );
      }
    });

    test(
      'every emotion route collapses to one screen name that is not the slug',
      () {
        // `/reflect/feelings/:mood` is the only route in the app whose path
        // carries forbidden data. This is why `FirebaseAnalyticsObserver`
        // and automatic screen reporting are both off: either would name
        // this screen after the path.
        final seen = <AnalyticsScreen?>{};
        for (final slug in _emotionSlugs) {
          final screen = screenForLocation('/reflect/feelings/$slug');
          seen.add(screen);
          expect(screen, AnalyticsScreen.feelingsResult);
          expect(screen!.wire, isNot(contains(slug)));
        }
        expect(
          seen,
          hasLength(1),
          reason:
              'two different emotions produced two different screen names, '
              'which makes the emotion recoverable from the analytics data '
              'even though the slug itself was never sent',
        );
      },
    );

    test('a query string cannot smuggle an emotion past the mapper', () {
      final screen = screenForLocation(
        '/reflect/feelings/grieving?from=depressed#sad',
      );
      expect(screen, AnalyticsScreen.feelingsResult);
      expect(screen!.wire, 'feelings_result');
    });
  });

  group('no free text can reach the analytics layer', () {
    test('the encoder drops a String value rather than forwarding it', () {
      // `Map<AnalyticsParam, Object>` means a caller *can* hand the encoder
      // a String and still compile. This is the line that makes that
      // harmless. There is no branch in `encodeAnalyticsParams` that
      // forwards a String, and this proves it for the two worst ones.
      final encoded = encodeAnalyticsParams({
        AnalyticsParam.reason: _journalText,
        AnalyticsParam.area: 'grieving',
        AnalyticsParam.method: 'islam',
      });

      expect(
        encoded,
        isEmpty,
        reason:
            'encodeAnalyticsParams forwarded a free-form String. Every '
            'parameter value must be an int or an AnalyticsVocabulary enum; '
            'a String is the shape an emotion slug, a journal line and an '
            'email address all arrive in.',
      );
    });

    test('the encoder keeps legitimate vocabulary values', () {
      // The other direction, so the test above cannot pass by the encoder
      // simply dropping everything.
      final encoded = encodeAnalyticsParams({
        AnalyticsParam.slideIndex: 2,
        AnalyticsParam.permission: AnalyticsPermission.notifications,
      });
      expect(encoded, {'slide_index': 2, 'permission': 'notifications'});
    });

    test('no emission carries a value that is not an int or a token', () async {
      await _emitEverything(analytics);

      // Every string value the layer can emit, built from the enums
      // themselves. Nothing outside this set may appear on the wire.
      final allowedValues = <String>{
        for (final v in AnalyticsAuthMethod.values) v.wire,
        for (final v in AnalyticsAuthFailure.values) v.wire,
        for (final v in AnalyticsPermission.values) v.wire,
        for (final v in AnalyticsPermissionOutcome.values) v.wire,
        for (final v in AnalyticsErrorArea.values) v.wire,
        for (final v in AnalyticsScreen.values) v.wire,
      };

      for (final emission in sink.emissions) {
        for (final value in emission.params.values) {
          if (value is int) continue;
          expect(
            allowedValues,
            contains(value),
            reason:
                '"$value" left the app on "${emission.name}" but is not a '
                'member of any analytics enum, so nothing constrains what '
                'it can contain',
          );
        }
      }
    });
  });

  group('faith is never tagged in Google', () {
    test('no event, parameter or value names a faith', () async {
      await _emitEverything(analytics);

      final wire = sink.wireStrings.map((s) => s.toLowerCase()).toList();
      for (final value in _faithValues) {
        expect(
          wire.where((s) => s.contains(value)),
          isEmpty,
          reason:
              '"$value" reached the analytics layer. Users are not tagged by '
              'religion in Google\'s systems — not as a user property and '
              'not as an event parameter. Per-faith numbers are a query '
              'against our own database, where that data already lives.',
        );
      }
    });

    test('onboarding_faith_chosen carries no parameters at all', () async {
      await analytics.onboardingFaithChosen();

      expect(sink.emissions, hasLength(1));
      expect(sink.emissions.single.name, 'onboarding_faith_chosen');
      expect(
        sink.emissions.single.params,
        isEmpty,
        reason:
            'this event exists to answer "did they get past the picker". '
            'The moment it gains a parameter it starts answering "which '
            'faith did they choose", which is the thing that may not leave '
            'the device.',
      );
    });

    test('no banned concept appears as a parameter name', () async {
      await _emitEverything(analytics);

      // Parameter names only. Event names are checked separately: one of
      // them is `feelings_opened`, which is the whole point of "count the
      // act, never the content" and so is deliberately allowed to name the
      // feature. A *parameter* called `feeling`, by contrast, has no
      // innocent reading — it is a slot waiting for a slug.
      //
      // `screen_name` is Firebase's own reserved key and is exempt from
      // the `name` fragment; its values are the AnalyticsScreen allowlist,
      // asserted above.
      final names = sink.emissions
          .expand((e) => e.params.keys)
          .where((n) => n != 'screen_name')
          .toSet();
      for (final name in names) {
        for (final banned in _bannedKeyFragments) {
          expect(
            name.toLowerCase().contains(banned),
            isFalse,
            reason:
                '"$name" contains "$banned". Even with a harmless value '
                'today, a key by that name is where content ends up '
                'tomorrow.',
          );
        }
      }
    });
  });

  group('the analytics layer has no door for identity', () {
    // These read source rather than behaviour, deliberately: the strongest
    // form of "we never set a faith user property" is that no call to set
    // a user property exists anywhere in the app. A behavioural test can
    // only prove the calls it happens to drive.

    test('nothing in lib/ sets a user property, user id or default params', () {
      final offenders = _grepLib(const [
        'setUserProperty',
        'setUserId(',
        'setDefaultEventParameters',
        'setUserIdentifier',
        'setConsent',
      ]);

      expect(
        offenders,
        isEmpty,
        reason:
            'a user-property call appeared in ${offenders.join(', ')}. '
            'AnalyticsSink has no such method on purpose: the most durable '
            'way to guarantee nobody ever writes setUserProperty("faith", '
            '…) is for the capability not to exist.',
      );
    });

    test('FirebaseAnalytics is reachable from exactly one file', () {
      final files = _grepLib(const ['package:firebase_analytics/']);

      expect(
        files,
        ['lib/core/telemetry/analytics_sink.dart'],
        reason:
            'the Firebase Analytics API must have exactly one door. Any '
            'other import of it bypasses SiraatAnalytics, which is the '
            'thing that makes a free-form string impossible to express.',
      );
    });

    test('no route-derived screen reporting is installed', () {
      // `FirebaseAnalyticsObserver` names screens after routes, and one of
      // this app's routes is `/reflect/feelings/:mood`.
      expect(
        _grepLib(const ['FirebaseAnalyticsObserver']),
        isEmpty,
        reason:
            'FirebaseAnalyticsObserver derives screen_name from the route, '
            'which would send /reflect/feelings/grieving to Google',
      );

      // And the Android SDK's own automatic version of the same thing.
      final manifest = File(
        'android/app/src/main/AndroidManifest.xml',
      ).readAsStringSync();
      expect(
        manifest,
        contains('google_analytics_automatic_screen_reporting_enabled'),
        reason:
            'automatic screen reporting must be explicitly disabled in the '
            'manifest; it is on by default and it names screens after '
            'activities and routes',
      );
      final flag = RegExp(
        r'google_analytics_automatic_screen_reporting_enabled[\s\S]{0,120}?'
        r'android:value="(\w+)"',
      ).firstMatch(manifest);
      expect(flag?.group(1), 'false');
    });
  });

  group('nothing reports from a debug build or a test', () {
    test('this build is not eligible to report', () {
      expect(
        Telemetry.isEligibleBuild,
        isFalse,
        reason:
            'telemetry must be structurally off under flutter test. If this '
            'ever passes, 797 tests are writing to the production '
            'crash-free rate.',
      );
    });

    test('the live analytics façade is backed by the no-op sink', () async {
      // `bootstrap()` is what main() calls. Under test it must install
      // nothing: no error handlers, no Firebase, no sink.
      final before = FlutterError.onError;
      Telemetry.instance.bootstrap();
      expect(FlutterError.onError, same(before));
      expect(Telemetry.instance.isCollecting, isFalse);

      // And the façade still works — call sites never branch on whether
      // telemetry is on.
      await _emitEverything(Telemetry.instance.analytics);
    });
  });
}

/// Returns the `lib/` files whose *code* contains any of [needles],
/// relative to the package root, sorted.
///
/// Comment lines are stripped first. The telemetry files explain at length
/// why `FirebaseAnalyticsObserver` is not installed and why there is no
/// `setUserProperty`, and a scanner that counted prose would make writing
/// that explanation the thing that fails the build.
///
/// Tests run with the package root as the working directory.
List<String> _grepLib(List<String> needles) {
  final hits = <String>[];
  for (final entity in Directory('lib').listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) continue;
    final code = _stripComments(entity.readAsStringSync());
    if (needles.any(code.contains)) {
      hits.add(entity.path.replaceAll(r'\', '/'));
    }
  }
  return hits..sort();
}

/// Drops whole-line comments — `//`, `///` and the body of a `/* */`
/// block. Trailing comments after code are left alone, which is safe: a
/// line that both calls `setUserProperty` and comments about it still
/// fails, and URLs in string literals are not mangled.
String _stripComments(String source) {
  final out = StringBuffer();
  var inBlock = false;
  for (final line in source.split('\n')) {
    final trimmed = line.trimLeft();
    if (inBlock) {
      if (trimmed.contains('*/')) inBlock = false;
      continue;
    }
    if (trimmed.startsWith('/*')) {
      if (!trimmed.contains('*/')) inBlock = true;
      continue;
    }
    if (trimmed.startsWith('//') || trimmed.startsWith('*')) continue;
    out.writeln(line);
  }
  return out.toString();
}
