/// Keeps `screenForLocation`'s prefixes honest against the real routes.
///
/// The mapper's safe default — an unrecognised path logs nothing — is what
/// stops a route added later from leaking its parameters. It also hides
/// its own mistakes: a prefix typed as `/today/puja_times` instead of
/// `/today/puja-times` would silently turn that screen off forever, and
/// nothing else in the suite would notice, because "no event" is exactly
/// what the safe default looks like.
///
/// So this file pins both directions. Every path the app can actually
/// navigate to resolves to the screen it should, and the handful that are
/// deliberately unmapped are listed by name rather than left to silence.
library;

import 'package:faith_mobile/core/telemetry/telemetry_vocabulary.dart';
import 'package:flutter_test/flutter_test.dart';

/// Concrete locations, one per route in the app, with a path parameter
/// filled in wherever the route has one. Derived from the `*_routes.dart`
/// files; add a row when you add a route.
const Map<String, AnalyticsScreen> _expected = {
  '/splash': AnalyticsScreen.splash,
  '/login': AnalyticsScreen.login,
  '/register': AnalyticsScreen.register,
  '/onboarding': AnalyticsScreen.onboarding,
  '/onboarding/faith': AnalyticsScreen.onboardingFaith,
  '/settings': AnalyticsScreen.settings,
  '/settings/switch-faith': AnalyticsScreen.settingsSwitchFaith,
  '/settings/delete-account': AnalyticsScreen.settingsDeleteAccount,
  '/share': AnalyticsScreen.shareCard,

  '/today': AnalyticsScreen.today,
  '/today/prayers': AnalyticsScreen.prayers,
  '/today/prayers/qaza': AnalyticsScreen.prayers,
  '/today/calendar': AnalyticsScreen.calendar,
  '/today/calendar/day/2026-10-11': AnalyticsScreen.calendar,
  '/today/calendar/event/42': AnalyticsScreen.calendar,
  '/today/panchang': AnalyticsScreen.panchang,
  '/today/panchang/festival/diwali': AnalyticsScreen.panchang,
  '/today/puja-times': AnalyticsScreen.pujaTimes,

  '/quran': AnalyticsScreen.scriptureHome,
  '/quran/surah/2': AnalyticsScreen.scriptureReader,
  '/quran/surah/2/verses': AnalyticsScreen.scriptureReader,
  '/quran/collection/nightly-recitation': AnalyticsScreen.collection,
  '/quran/juz/30': AnalyticsScreen.juzReader,
  '/quran/bookmarks': AnalyticsScreen.bookmarks,
  '/quran/hindu-scripture': AnalyticsScreen.scriptureChapters,
  '/quran/hindu-scripture/bhagavad-gita': AnalyticsScreen.scriptureChapters,
  '/quran/hindu-scripture/bhagavad-gita/2': AnalyticsScreen.scriptureChapters,
  '/quran/hindu-scripture/bhagavad-gita/2/verses':
      AnalyticsScreen.scriptureChapters,

  '/hadiths': AnalyticsScreen.hadithsHome,
  '/hadiths/search': AnalyticsScreen.hadithDetail,
  '/hadiths/book/1': AnalyticsScreen.hadithDetail,
  '/hadiths/favorites': AnalyticsScreen.hadithDetail,
  '/hadiths/hindu-stories': AnalyticsScreen.hadithDetail,

  '/practice': AnalyticsScreen.practice,
  '/practice/dhikr': AnalyticsScreen.dhikr,
  '/practice/dhikr/counter/7': AnalyticsScreen.dhikr,
  '/practice/dhikr/goals': AnalyticsScreen.dhikr,
  '/practice/dhikr/history': AnalyticsScreen.dhikr,
  '/practice/duas': AnalyticsScreen.duas,
  '/practice/duas/category/morning': AnalyticsScreen.duas,
  '/practice/names': AnalyticsScreen.names,
  '/practice/names/allah/1': AnalyticsScreen.names,
  '/practice/names/muhammad/1': AnalyticsScreen.names,
  '/practice/qibla': AnalyticsScreen.qibla,
  '/practice/japa': AnalyticsScreen.japa,
  '/practice/japa/goals': AnalyticsScreen.japa,
  '/practice/stotras': AnalyticsScreen.stotras,
  '/practice/stotras/deity/ganesha': AnalyticsScreen.stotras,
  '/practice/temples': AnalyticsScreen.temples,
  '/practice/temples/state/kerala': AnalyticsScreen.temples,

  '/reflect': AnalyticsScreen.reflect,
  '/reflect/feelings/grieving': AnalyticsScreen.feelingsResult,
  '/reflect/journal': AnalyticsScreen.journal,
  '/reflect/history': AnalyticsScreen.moodHistory,
};

void main() {
  group('every real route resolves to the screen it should', () {
    test('each location maps to its expected screen', () {
      _expected.forEach((location, screen) {
        expect(
          screenForLocation(location),
          screen,
          reason:
              '"$location" resolved to ${screenForLocation(location)?.wire}. '
              'A mistyped prefix in screenForLocation turns a screen off '
              'silently, because "no event" is what the safe default looks '
              'like.',
        );
      });
    });

    test('no listed route falls through to silence', () {
      final silent = _expected.keys
          .where((l) => screenForLocation(l) == null)
          .toList();
      expect(silent, isEmpty);
    });

    test('every screen in the enum is reachable from some route', () {
      // The other half. `AnalyticsScreen` is also used by the exhaustive
      // sweep in `forbidden_data_test.dart`, which calls `screenViewed`
      // directly and so proves nothing about reachability — a constant
      // could sit in the enum for a year with no path that produces it.
      final reachable = _expected.values.toSet();
      for (final screen in AnalyticsScreen.values) {
        expect(
          reachable,
          contains(screen),
          reason:
              '"${screen.wire}" is in AnalyticsScreen but no location in '
              'this file produces it, so either the route is missing from '
              'the table above or the constant is dead',
        );
      }
    });
  });

  group('the fallback is silence, not the path', () {
    test('an unmapped location returns null', () {
      for (final location in const [
        '/',
        '/nope',
        '/reflect-but-not-really',
        '/settings/some-new-screen',
        '/todayish',
      ]) {
        expect(
          screenForLocation(location),
          isNull,
          reason:
              '"$location" produced a screen name. An unrecognised route '
              'must log nothing rather than guess, so that a route added '
              'later is invisible instead of leaking its parameters.',
        );
      }
    });

    test('no path parameter value survives into a screen name', () {
      // The invariant underneath every row above. Screen names share
      // vocabulary with routes on purpose — `/today` is `today` — so the
      // thing to check is not the route words but the *values*: the ids,
      // slugs and dates substituted into the table. None of those may
      // travel, because the function returns compile-time constants.
      const values = [
        '2026-10-11',
        '42',
        '2',
        '30',
        '1',
        '7',
        'nightly-recitation',
        'bhagavad-gita',
        'diwali',
        'morning',
        'ganesha',
        'kerala',
        'grieving',
      ];
      for (final location in _expected.keys) {
        final wire = screenForLocation(location)!.wire;
        for (final value in values) {
          expect(
            wire.contains(value),
            isFalse,
            reason: '"$value" survived from "$location" into "$wire"',
          );
        }
      }
    });
  });
}
