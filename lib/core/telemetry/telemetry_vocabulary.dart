/// The complete, closed vocabulary of everything this app is able to send
/// to Google Analytics. Nothing outside this file can become a wire value.
///
/// ## Why this is a closed set rather than a convention
///
/// Siraat knows two things about a person that nobody should hold lightly:
/// **their religion and their emotional state**. The project's own research
/// calls that the worst data pairing this product could hold, and the DPDP
/// Act treats both as sensitive personal data. A conventional analytics
/// layer — `logEvent(String name, Map<String, dynamic> params)` — makes
/// leaking either of them a one-line mistake that no reviewer would catch:
///
/// ```dart
/// analytics.logEvent('mood_picked', {'mood': slug});   // not possible here
/// ```
///
/// So the leak is closed structurally instead of by discipline. Event
/// names, parameter names and parameter *values* are all enums declared
/// here. There is no public API anywhere in `lib/core/telemetry` that
/// accepts a free-form `String`, and the encoder in `analytics_sink.dart`
/// drops anything that is not an `int` or a member of one of these enums.
/// The result is a finite universe of strings the app can emit — small
/// enough to read in one sitting, and enumerable, which is what makes
/// `test/core/telemetry/forbidden_data_test.dart` able to prove the
/// forbidden values are not in it.
///
/// ## The second filter: redundancy
///
/// Siraat already records acts of worship on its own server, through the
/// event-sourced activity stream (`ActivityEvent` / `DailyRollup` /
/// `StreakState`): verses read, prayers logged, dhikr and japa counts,
/// goals, streaks, collections opened, journal entries. Sending any of
/// that to Google would be redundant *and* a liability. Analytics here is
/// only for what our own backend structurally cannot see — what happens
/// before sign-in, where people abandon a flow, which permissions are
/// granted, and client-side failures that never reach a server.
///
/// Every event below has to survive both filters: it must not be content,
/// and it must not be something we can already query ourselves.
library;

/// Implemented by every enum whose members may travel as a parameter
/// *value*.
///
/// The encoder accepts an `int` or an [AnalyticsVocabulary]; a `String`
/// handed to it is dropped. This interface is therefore the only way a
/// non-numeric value reaches Google, and every implementation of it is in
/// this file.
abstract interface class AnalyticsVocabulary {
  /// The exact token sent on the wire.
  String get wire;
}

/// Every event Siraat can log.
///
/// Automatic events — `app_open`, `session_start`, `first_open` — come from
/// the Firebase SDK and are not listed here; they carry no app data.
/// `screen_view` is logged manually (see [AnalyticsScreen]) because the
/// automatic version derives its name from the route, and one of this app's
/// routes is `/reflect/feelings/:mood`.
enum AnalyticsEvent {
  /// Which intro slide a first-launch user reached. The only measure of
  /// onboarding drop-off there can be: it happens before sign-in, so the
  /// backend has no user to attribute it to. Index 0 is the denominator.
  onboardingSlideViewed('onboarding_slide_viewed'),

  /// The faith picker was completed.
  ///
  /// **Deliberately carries no parameter.** *Which* faith was chosen is the
  /// single most sensitive fact this app holds, and tagging a user as Islam
  /// or Hindu inside Google's systems is exactly what the privacy line
  /// forbids — as an event parameter no less than as a user property. This
  /// event answers "did they get past the picker", which is a funnel
  /// question. "How many chose which" is a question for our own database,
  /// where the answer already lives.
  onboardingFaithChosen('onboarding_faith_chosen'),

  /// A sign-in or sign-up attempt began. Pre-auth, so invisible to us.
  authStarted('auth_started'),

  /// The attempt succeeded. The pair with [authStarted] is the auth
  /// conversion rate; the backend sees only the successes.
  authSucceeded('auth_succeeded'),

  /// The attempt failed, with a coarse reason code. Never a server message
  /// and never the address that was typed — see [AnalyticsAuthFailure].
  authFailed('auth_failed'),

  /// An OS permission dialog was about to be shown. The denominator for
  /// [permissionResolved].
  permissionRequested('permission_requested'),

  /// How an OS permission dialog ended. Explains an otherwise invisible
  /// cohort: users for whom prayer reminders never fire, or for whom the
  /// Qibla compass has no fix. Nothing about this reaches our server.
  permissionResolved('permission_resolved'),

  /// The mood picker was opened.
  ///
  /// Count the act, never the content: this records that someone reached
  /// for the feelings flow, and carries no indication of what they felt.
  /// The picker is a bottom sheet rather than a route, so `screen_view`
  /// does not cover it, and the sheet can be dismissed without choosing —
  /// which is the drop-off this is here to measure.
  feelingsOpened('feelings_opened'),

  /// A share card actually left the app through the system sheet.
  ///
  /// No parameter: the kind of content shared ("verse" vs "shloka") would
  /// imply the user's faith, which is the one inference this layer must
  /// not make possible.
  shareCompleted('share_completed'),

  /// A non-fatal client-side failure, by coarse area.
  ///
  /// Crashlytics holds the detail; this exists so the *rate* is joinable
  /// against the funnels and retention cohorts in GA4, which Crashlytics
  /// cannot do.
  appError('app_error');

  const AnalyticsEvent(this.wire);

  /// The event name sent to Firebase.
  final String wire;
}

/// Every parameter name that may accompany an event.
enum AnalyticsParam {
  /// Zero-based index of an onboarding slide. An `int`.
  slideIndex('slide_index'),

  /// Which authentication route — see [AnalyticsAuthMethod].
  method('method'),

  /// Why an auth attempt failed — see [AnalyticsAuthFailure].
  reason('reason'),

  /// Which OS permission — see [AnalyticsPermission].
  permission('permission'),

  /// How a permission dialog ended — see [AnalyticsPermissionOutcome].
  outcome('outcome'),

  /// Which part of the app failed — see [AnalyticsErrorArea].
  area('area');

  const AnalyticsParam(this.wire);

  /// The parameter name sent to Firebase.
  final String wire;
}

/// Which authentication route an attempt took.
enum AnalyticsAuthMethod implements AnalyticsVocabulary {
  signIn('sign_in'),
  signUp('sign_up');

  const AnalyticsAuthMethod(this.wire);

  @override
  final String wire;
}

/// Why an auth attempt failed, coarsely.
///
/// Deliberately a closed set of five rather than the server's message: a
/// message can quote the address that was typed, and an address is an
/// identifier. Anything the app cannot classify is [unknown], which is
/// less useful and entirely safe.
enum AnalyticsAuthFailure implements AnalyticsVocabulary {
  /// Wrong password, unknown account, bad OTP — a 401/403.
  credentials('credentials'),

  /// The address is already registered — a 409.
  alreadyRegistered('already_registered'),

  /// The form was rejected by the server — a 400/422.
  validation('validation'),

  /// No usable connection, DNS failure, or a timeout.
  network('network'),

  /// A 5xx.
  server('server'),

  /// Anything else. The app does not guess.
  unknown('unknown');

  const AnalyticsAuthFailure(this.wire);

  @override
  final String wire;
}

/// Which OS permission a dialog concerned.
enum AnalyticsPermission implements AnalyticsVocabulary {
  notifications('notifications'),

  /// Coarse location, for prayer times and the Qibla bearing. The *fact*
  /// of a grant, never a coordinate: location is on the never-leaves-the-
  /// device list and this layer has no parameter capable of carrying one.
  location('location'),

  /// Android 14+ exact-alarm scheduling, which prayer reminders degrade
  /// without.
  exactAlarm('exact_alarm');

  const AnalyticsPermission(this.wire);

  @override
  final String wire;
}

/// How a permission dialog ended.
enum AnalyticsPermissionOutcome implements AnalyticsVocabulary {
  granted('granted'),
  denied('denied'),

  /// Android's "don't ask again" / iOS after a first denial: unreachable
  /// without a trip to system settings.
  permanentlyDenied('permanently_denied'),

  /// Dismissed without an answer.
  dismissed('dismissed');

  const AnalyticsPermissionOutcome(this.wire);

  @override
  final String wire;
}

/// The coarse area a non-fatal error came from.
enum AnalyticsErrorArea implements AnalyticsVocabulary {
  network('network'),
  audio('audio'),
  location('location'),
  notifications('notifications'),
  storage('storage'),
  share('share'),

  /// The offline activity queue failing to drain. Worth a rate because a
  /// stuck queue is silently lost worship history.
  activitySync('activity_sync');

  const AnalyticsErrorArea(this.wire);

  @override
  final String wire;
}

/// Every screen name that may be sent as a `screen_view`.
///
/// ## Why these are constants and not route paths
///
/// `FirebaseAnalyticsObserver` and Firebase's automatic screen reporting
/// both name a screen after the route that produced it. This app has
/// `/reflect/feelings/:mood`, so with either of those turned on a visit to
/// `/reflect/feelings/grieving` would send the user's emotional state to
/// Google as `screen_name` — the exact forbidden value, arriving
/// automatically, through a path nobody reviews.
///
/// So the observer is not installed, automatic screen reporting is turned
/// off in `AndroidManifest.xml`, and screens are named from this enum by
/// [screenForLocation], which maps a path to a constant through a closed
/// set of prefixes and **never echoes its input**. A route it does not
/// recognise produces `null`, and `null` sends nothing: a new route added
/// without touching the mapper is silent rather than leaky.
enum AnalyticsScreen implements AnalyticsVocabulary {
  splash('splash'),
  login('login'),
  register('register'),
  onboarding('onboarding'),
  onboardingFaith('onboarding_faith'),

  today('today'),
  prayers('prayers'),
  calendar('calendar'),
  panchang('panchang'),
  pujaTimes('puja_times'),

  scriptureHome('scripture_home'),
  scriptureReader('scripture_reader'),
  scriptureChapters('scripture_chapters'),
  collection('collection'),
  juzReader('juz_reader'),
  bookmarks('bookmarks'),

  hadithsHome('hadiths_home'),
  hadithDetail('hadith_detail'),

  practice('practice'),
  dhikr('dhikr'),
  duas('duas'),
  names('names'),
  qibla('qibla'),
  japa('japa'),
  stotras('stotras'),
  temples('temples'),

  /// `/reflect` — the Reflect tab's home.
  reflect('reflect'),

  /// `/reflect/feelings/:mood`. The screen the user lands on after picking
  /// an emotion — named for the *screen*, with the slug discarded. This is
  /// the single most important entry in this enum: it is the one route
  /// whose path carries forbidden data, and the reason route-derived
  /// screen names are banned app-wide.
  feelingsResult('feelings_result'),

  /// `/reflect/journal`. Opening the journal is a navigation; what is
  /// written in it never leaves the device by this path or any other.
  journal('journal'),
  moodHistory('mood_history'),

  settings('settings'),
  settingsSwitchFaith('settings_switch_faith'),
  settingsDeleteAccount('settings_delete_account'),
  shareCard('share_card');

  const AnalyticsScreen(this.wire);

  @override
  final String wire;
}

/// Maps a router location to an allowlisted [AnalyticsScreen], or `null`.
///
/// Pure, and deliberately total in only one direction: every return value
/// is a compile-time constant from [AnalyticsScreen], so no part of
/// [location] — path segment, path parameter or query string — can reach
/// the wire through this function. `/reflect/feelings/grieving` and
/// `/reflect/feelings/depressed` both return [AnalyticsScreen
/// .feelingsResult] and are indistinguishable downstream.
///
/// Unrecognised locations return `null`, which logs nothing. That is the
/// safe default: a route added later without a case here is invisible in
/// GA4 until someone deliberately adds it, rather than leaking whatever
/// happens to be in its path.
AnalyticsScreen? screenForLocation(String location) {
  // Query strings and fragments can carry anything; the path alone is
  // enough to classify a screen, so drop them before matching.
  final path = location.split('?').first.split('#').first;

  // Ordered longest-prefix-first within each tab: `/today/prayers` must be
  // tested before `/today`.
  return switch (path) {
    '/splash' => AnalyticsScreen.splash,
    '/login' => AnalyticsScreen.login,
    '/register' => AnalyticsScreen.register,
    '/onboarding' => AnalyticsScreen.onboarding,
    '/onboarding/faith' => AnalyticsScreen.onboardingFaith,
    '/settings' => AnalyticsScreen.settings,
    '/settings/switch-faith' => AnalyticsScreen.settingsSwitchFaith,
    '/settings/delete-account' => AnalyticsScreen.settingsDeleteAccount,
    '/share' => AnalyticsScreen.shareCard,
    _ => _sectionFor(path),
  };
}

AnalyticsScreen? _sectionFor(String path) {
  if (path.startsWith('/today')) {
    if (path.startsWith('/today/prayers')) return AnalyticsScreen.prayers;
    if (path.startsWith('/today/calendar')) return AnalyticsScreen.calendar;
    if (path.startsWith('/today/panchang')) return AnalyticsScreen.panchang;
    if (path.startsWith('/today/puja-times')) return AnalyticsScreen.pujaTimes;
    return AnalyticsScreen.today;
  }
  if (path.startsWith('/quran')) {
    if (path.startsWith('/quran/surah')) return AnalyticsScreen.scriptureReader;
    if (path.startsWith('/quran/juz')) return AnalyticsScreen.juzReader;
    if (path.startsWith('/quran/collection')) return AnalyticsScreen.collection;
    if (path.startsWith('/quran/bookmarks')) return AnalyticsScreen.bookmarks;
    if (path.startsWith('/quran/hindu-scripture')) {
      return AnalyticsScreen.scriptureChapters;
    }
    return AnalyticsScreen.scriptureHome;
  }
  if (path.startsWith('/hadiths')) {
    // `/hadiths`, `/hadiths/search`, `/hadiths/book/:id` and the Hindu
    // stories tree all land on one of two names. Finer granularity would
    // start to describe reading behaviour, which the activity stream
    // already records on our own server.
    return path == '/hadiths'
        ? AnalyticsScreen.hadithsHome
        : AnalyticsScreen.hadithDetail;
  }
  if (path.startsWith('/practice')) {
    if (path.startsWith('/practice/dhikr')) return AnalyticsScreen.dhikr;
    if (path.startsWith('/practice/duas')) return AnalyticsScreen.duas;
    if (path.startsWith('/practice/names')) return AnalyticsScreen.names;
    if (path.startsWith('/practice/qibla')) return AnalyticsScreen.qibla;
    if (path.startsWith('/practice/japa')) return AnalyticsScreen.japa;
    if (path.startsWith('/practice/stotras')) return AnalyticsScreen.stotras;
    if (path.startsWith('/practice/temples')) return AnalyticsScreen.temples;
    return AnalyticsScreen.practice;
  }
  if (path.startsWith('/reflect')) {
    // The slug in `/reflect/feelings/:mood` is matched on the prefix and
    // then discarded. Every emotion lands on the same constant.
    if (path.startsWith('/reflect/feelings')) {
      return AnalyticsScreen.feelingsResult;
    }
    if (path.startsWith('/reflect/journal')) return AnalyticsScreen.journal;
    if (path.startsWith('/reflect/history')) return AnalyticsScreen.moodHistory;
    return AnalyticsScreen.reflect;
  }
  return null;
}
