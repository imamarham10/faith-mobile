# Siraat Retention Engine Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Give Siraat a habit loop — daily goal, streak, challenges and a friends-only circle — built on an event-sourced core that serves both faiths, and fix the ship-blockers that would make a streak feature backfire.

**Architecture:** Every in-app act of worship writes one `ActivityEvent` row carrying the user's *local* day and IANA timezone. Streaks, goals, points, challenge progress and leaderboard rank are all projections over that single stream, recomputable at will. The mobile side records events through one faith-agnostic recorder in `lib/shared/habit/`, queued locally so it works offline; two thin content packs map activity types to faith-specific labels, icons and deep links.

**Tech Stack:** Flutter 3.11 · Riverpod (codegen) · go_router · Dio · sqflite (new) · adhan (new) · posthog_flutter (new) — against NestJS 11 · Prisma 7.2 · PostgreSQL 17 (RDS, schema `faith`) · Redis via `@nestjs/cache-manager` · Vercel serverless.

**Design doc:** `docs/plans/2026-10-08-retention-engine-design.md`

---

## How to read this plan

Fidelity is deliberately uneven, and that is not laziness:

| Phase | Fidelity | Why |
|---|---|---|
| 0, 1, 2 | Full TDD steps, complete code, exact commands | The bugs are confirmed at line level and the design is settled. Executable as written. |
| 3, 4 | Task lists with files, test names and acceptance criteria | They depend on data that does not exist yet. |

**Re-plan gates.** Do not execute Phase 3 from this document. Re-plan it after Phase 1 analytics has two weeks of real data, because the answers to *"does anyone set a goal?"* and *"does the streak survive a week?"* change what the social layer should even be. Phase 4 re-plans after Phase 2.

---

## Setup — do this once, before Task 0.1

Two repos. Paths below are relative to each repo root.

- **Mobile:** `/Users/imamarham10/Desktop/Arham/Faith/faith_mobile`
- **Backend:** `/Users/imamarham10/Desktop/Arham/Faith/unified-faith-service`

**Riverpod is codegen here.** Every task that adds or changes a provider, a `@riverpod` function, or a `freezed`/`json_serializable` DTO must run this before its test will compile:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Where a task needs it, it is written as an explicit step. Skipping it blocks every subsequent step with a confusing "undefined name `fooProvider`" error.

**Migrations reach the `faith` schema, not `public`.** The Prisma CLI reads `DATABASE_URL_UNPOOLED`, which since the 2026-10-08 RDS cutover carries `?schema=faith`. Confirm before the first migration:

```bash
cd unified-faith-service && npx prisma migrate status
# Expected: Datasource "db": PostgreSQL database "utility", schema "faith" at "habuild-dev...".
```

If it says `public`, your `.env` is stale — stop and fix it rather than creating a second copy of every table.

**The backend has no test runner.** `package.json` has `"test": "echo \"Error: no test specified\" && exit 1"` and zero `.spec.ts` files. Task 1.1 installs Jest. Do not attempt TDD on the backend before it.

## Device QA is a gate on every mobile task

No mobile task is complete without evidence from a physical device. Green unit tests are necessary and not sufficient: a test asserting `buildNotificationPlan` returns 60 entries proves the arithmetic, not that Android registered 60 alarms. Those are different claims and only hardware settles the second.

Run `scratchpad/qa/device-qa.sh <label>` before and after each mobile task. It captures runtime permission state, the pending-alarm dump, logcat fatals, and a screenshot.

**Reference device:** OnePlus 9R (LE2101), Android 14 / SDK 34. SDK 34 matters — `POST_NOTIFICATIONS` is a runtime permission from SDK 33+, and exact alarms are restricted from SDK 31+. The manifest has been verified to declare `POST_NOTIFICATIONS`, `SCHEDULE_EXACT_ALARM`, `USE_EXACT_ALARM` and `RECEIVE_BOOT_COMPLETED`, plus the boot receiver, so the scheduling work rests on solid ground.

**Baseline captured 2026-10-08, pre-Phase-0** — the defects reproduced on hardware, not inferred from reading code:

| Measure | Baseline | After Phase 0 |
|---|---|---|
| Pending alarms | **0** | ~60, furthest ~6 days out |
| `POST_NOTIFICATIONS` | granted | granted |
| Verse of the day | At-Talaq 65:2 (hardcoded) | rotating (Phase 1) |

The baseline is damning and worth keeping in mind: the app was displaying *"NEXT · Fajr — 6h 56m"* with notification permission granted and **zero** pending alarms. It knew the prayer was coming and would not have reminded anyone.

If a device check contradicts a green test, the device wins and the test is wrong.

---

# Phase 0 — Ship-blockers (~1 week)

Three confirmed defects. A streak feature sitting on top of any of them makes retention worse, not better: a streak is a reminder feature wearing a progress bar.

## Task 0.1: Add the `adhan` package and compute prayer times on-device

**Why first:** `NotificationService.rescheduleForToday` can only schedule today because the app only *has* today's times — they come from the API via `prayerTimesControllerProvider`. Scheduling a week of reminders over the network means reminders silently stop whenever the network does. Computing locally removes the dependency entirely.

The risk is divergence from the server's numbers, so this task ends with a parity test.

**Files:**
- Modify: `pubspec.yaml`
- Create: `lib/core/prayer/local_prayer_times.dart`
- Test: `test/core/prayer/local_prayer_times_test.dart`

**Step 1: Add the dependency**

```bash
flutter pub add adhan
```

**Step 2: Write the failing parity test**

Fixture values are Bangalore, 2026-10-08, Muslim World League, Shafi — taken from the backend's own calculation so the test is a genuine cross-check and not a tautology.

```dart
// test/core/prayer/local_prayer_times_test.dart
import 'package:faith_mobile/core/prayer/local_prayer_times.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('computes a 7-day window starting from the given date', () {
    final days = LocalPrayerTimes.forRange(
      latitude: 12.9716,
      longitude: 77.5946,
      from: DateTime(2026, 10, 8),
      days: 7,
      method: 'MWL',
      madhab: 'shafi',
    );

    expect(days, hasLength(7));
    expect(days.first.date, DateTime(2026, 10, 8));
    expect(days.last.date, DateTime(2026, 10, 14));
    // Each day must be computed for its own date — this is what catches the
    // real bug (seven LocalPrayerDay objects whose `date` advances but whose
    // times were all computed from `from`).
    //
    // CORRECTED 2026-10-08: this line originally asserted that Fajr drifts
    // later across the week. It cannot. Bangalore is at 12.97°N, where
    // seasonal daylight variation is minimal, and `adhan` rounds to the
    // minute — Oct 8 and Oct 14 Fajr are both 04:59:00, so the assertion was
    // unsatisfiable by any correct implementation. Prefer date-alignment,
    // which holds at the equator and at 60°N alike.
    for (final d in days) {
      expect(d.fajr.year, d.date.year);
      expect(d.fajr.month, d.date.month);
      expect(d.fajr.day, d.date.day,
          reason: 'each day must be computed for its own date');
    }
  });

  test('every day carries all five prayers in chronological order', () {
    final day = LocalPrayerTimes.forRange(
      latitude: 12.9716, longitude: 77.5946,
      from: DateTime(2026, 10, 8), days: 1,
      method: 'MWL', madhab: 'shafi',
    ).single;

    final ordered = [day.fajr, day.dhuhr, day.asr, day.maghrib, day.isha];
    for (var i = 1; i < ordered.length; i++) {
      expect(ordered[i].isAfter(ordered[i - 1]), isTrue,
          reason: 'prayer $i is not after prayer ${i - 1}');
    }
  });
}
```

**Step 3: Run it and watch it fail**

```bash
flutter test test/core/prayer/local_prayer_times_test.dart
```
Expected: compile error, `Target of URI doesn't exist: '.../local_prayer_times.dart'`.

**Step 4: Implement**

```dart
// lib/core/prayer/local_prayer_times.dart
import 'package:adhan/adhan.dart';

/// One day of computed prayer times. Mirrors the server's shape closely
/// enough that the notification scheduler does not care which produced it.
class LocalPrayerDay {
  const LocalPrayerDay({
    required this.date,
    required this.fajr,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  final DateTime date;
  final DateTime fajr, dhuhr, asr, maghrib, isha;

  Map<String, DateTime> get byKey => {
        'fajr': fajr, 'dhuhr': dhuhr, 'asr': asr,
        'maghrib': maghrib, 'isha': isha,
      };
}

/// On-device prayer-time computation.
///
/// The app otherwise reads prayer times from the API, and for display that is
/// correct — the server owns calculation-method semantics. But *notification
/// scheduling* must survive with no network: a reminder that fails to schedule
/// because the user was offline at the wrong moment is indistinguishable from
/// a reminder that does not exist. So the scheduler computes its own window
/// and accepts a possible sub-minute divergence from the server.
class LocalPrayerTimes {
  const LocalPrayerTimes._();

  static List<LocalPrayerDay> forRange({
    required double latitude,
    required double longitude,
    required DateTime from,
    required int days,
    required String method,
    required String madhab,
  }) {
    final coords = Coordinates(latitude, longitude);
    final params = _paramsFor(method)..madhab = _madhabFor(madhab);

    return List.generate(days, (i) {
      // Calendar-day arithmetic, NOT `.add(Duration(days: i))` — a fixed 24h
      // across a DST boundary lands on 23:00 or 01:00 of a neighbouring day.
      // The same wall-clock-vs-instant rule this whole plan is built on.
      final day = DateTime(from.year, from.month, from.day + i);
      final t = PrayerTimes(coords, DateComponents.from(day), params);
      return LocalPrayerDay(
        date: day,
        fajr: t.fajr, dhuhr: t.dhuhr, asr: t.asr,
        maghrib: t.maghrib, isha: t.isha,
      );
    }, growable: false);
  }

  static CalculationParameters _paramsFor(String method) => switch (method.toLowerCase()) {
        'isna' => CalculationMethod.north_america.getParameters(),
        // Both spellings: the app's own CalcMethod.all ships the code
        // 'EGYPTIAN', which lowercases to `egyptian`. Matching only 'egypt'
        // falls through to the MWL default and silently serves Egyptian-method
        // users the wrong prayer times, with no error anywhere.
        'egypt' || 'egyptian' => CalculationMethod.egyptian.getParameters(),
        'makkah' => CalculationMethod.umm_al_qura.getParameters(),
        'karachi' => CalculationMethod.karachi.getParameters(),
        'kuwait' => CalculationMethod.kuwait.getParameters(),
        'qatar' => CalculationMethod.qatar.getParameters(),
        'singapore' => CalculationMethod.singapore.getParameters(),
        _ => CalculationMethod.muslim_world_league.getParameters(),
      };

  static Madhab _madhabFor(String madhab) =>
      madhab.toLowerCase() == 'hanafi' ? Madhab.hanafi : Madhab.shafi;
}
```

**Step 5: Run the tests**

```bash
flutter test test/core/prayer/local_prayer_times_test.dart
```
Expected: PASS, 2 tests. Then run the full suite.

**The baseline is 54 pass / 1 fail, not all-green.** `test/smoke_test.dart:10` asserts `find.text('Faith')` while `splash_screen.dart:101` has rendered `'Siraat'` since the rebrand. Fix that in its own commit, separate from this task — a permanently-red suite makes every later "the suite is green" check worthless and teaches everyone to ignore the runner.

**Step 6: Commit**

```bash
git add pubspec.yaml pubspec.lock lib/core/prayer/local_prayer_times.dart test/core/prayer/local_prayer_times_test.dart
git commit -m "feat(prayer): compute prayer times on-device for offline scheduling"
```

---

## Task 0.2: Schedule a rolling 6-day notification window

**The bug:** `NotificationService.rescheduleForToday` (`lib/core/notifications/notification_service.dart:104`) cancels everything and schedules only today. Once today's prayers pass, the user has zero pending notifications until they next open the app. For anyone who installs and does not return the same day, the core feature is dead.

**Why six days and not seven:** iOS caps pending local notifications at **64**. Five prayers × two notifications (at-time + lead) = 10 per day. Six days = 60, leaving four spare for the daily goal reminder added in Phase 1. Seven days would be 70 and iOS would silently drop the tail — the worst possible failure mode.

**Files:**
- Modify: `lib/core/notifications/notification_service.dart:104-139`
- Modify: `lib/core/notifications/notification_orchestrator.dart:33-38`
- Test: `test/core/notifications/notification_schedule_test.dart`

**Step 1: Write the failing test**

Test the *plan*, not the plugin — extract scheduling decisions into a pure function so they are testable without a platform channel.

```dart
// test/core/notifications/notification_schedule_test.dart
import 'package:faith_mobile/core/notifications/notification_schedule.dart';
import 'package:faith_mobile/core/preferences/notification_preferences.dart';
import 'package:faith_mobile/core/prayer/local_prayer_times.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final days = LocalPrayerTimes.forRange(
    latitude: 12.9716, longitude: 77.5946,
    from: DateTime(2026, 10, 8), days: 6,
    method: 'MWL', madhab: 'shafi',
  );

  test('never exceeds the iOS 64-notification ceiling', () {
    final plan = buildNotificationPlan(
      days: days,
      prefs: const NotificationPreferences(leadMinutes: 15),
      now: DateTime(2026, 10, 8, 0, 1),
    );
    expect(plan.length, lessThanOrEqualTo(64));
  });

  test('skips times already in the past', () {
    final plan = buildNotificationPlan(
      days: days,
      prefs: const NotificationPreferences(leadMinutes: 0),
      now: DateTime(2026, 10, 8, 23, 59),
    );
    expect(plan.every((e) => e.when.isAfter(DateTime(2026, 10, 8, 23, 59))), isTrue);
    expect(plan.any((e) => e.when.day == 9), isTrue,
        reason: 'late on day 1 we should still hold future days');
  });

  test('allocates unique ids so later days do not overwrite earlier ones', () {
    final plan = buildNotificationPlan(
      days: days,
      prefs: const NotificationPreferences(leadMinutes: 15),
      now: DateTime(2026, 10, 8, 0, 1),
    );
    expect(plan.map((e) => e.id).toSet().length, plan.length);
  });

  test('lead notifications disappear when leadMinutes is 0', () {
    final plan = buildNotificationPlan(
      days: days,
      prefs: const NotificationPreferences(leadMinutes: 0),
      now: DateTime(2026, 10, 8, 0, 1),
    );
    expect(plan.every((e) => !e.isLead), isTrue);
  });
}
```

**Step 2: Run it, confirm it fails**

```bash
flutter test test/core/notifications/notification_schedule_test.dart
```
Expected: `Target of URI doesn't exist: '.../notification_schedule.dart'`.

**Step 3: Implement the pure planner**

```dart
// lib/core/notifications/notification_schedule.dart
import '../prayer/local_prayer_times.dart';
import '../preferences/notification_preferences.dart';

/// iOS silently drops pending local notifications past 64. Android's limit is
/// far higher, so this ceiling is the binding one on both platforms.
const int kMaxPendingNotifications = 64;

/// How many days ahead we schedule. 6 days x 5 prayers x 2 (at-time + lead)
/// = 60, leaving headroom under [kMaxPendingNotifications] for the daily goal
/// reminder added in Phase 1.
const int kScheduleWindowDays = 6;

const List<String> kPrayerKeys = ['fajr', 'dhuhr', 'asr', 'maghrib', 'isha'];

class ScheduledNotification {
  const ScheduledNotification({
    required this.id,
    required this.when,
    required this.prayerKey,
    required this.isLead,
  });

  final int id;
  final DateTime when;
  final String prayerKey;
  final bool isLead;
}

/// Pure: decides what should be pending. Separated from the plugin so the
/// scheduling rules are testable without a platform channel — the rules are
/// where the bugs live, not the `zonedSchedule` call.
List<ScheduledNotification> buildNotificationPlan({
  required List<LocalPrayerDay> days,
  required NotificationPreferences prefs,
  required DateTime now,
}) {
  final out = <ScheduledNotification>[];

  for (var dayIndex = 0; dayIndex < days.length; dayIndex++) {
    final day = days[dayIndex];
    day.byKey.forEach((key, at) {
      if (!prefs.isEnabledFor(key)) return;

      if (at.isAfter(now)) {
        out.add(ScheduledNotification(
          id: notificationId(dayIndex: dayIndex, prayerKey: key, lead: false),
          when: at, prayerKey: key, isLead: false,
        ));
      }

      if (prefs.leadMinutes > 0) {
        final lead = at.subtract(Duration(minutes: prefs.leadMinutes));
        if (lead.isAfter(now)) {
          out.add(ScheduledNotification(
            id: notificationId(dayIndex: dayIndex, prayerKey: key, lead: true),
            when: lead, prayerKey: key, isLead: true,
          ));
        }
      }
    });
  }

  out.sort((a, b) => a.when.compareTo(b.when));
  // Keep the soonest ones if we somehow overflow; losing tomorrow's reminder
  // is survivable, losing tonight's is not.
  return out.length <= kMaxPendingNotifications
      ? out
      : out.sublist(0, kMaxPendingNotifications);
}

/// Stable, collision-free ids. The old `_idFor(key, lead:)` had no day
/// component, so day 2's Fajr overwrote day 1's.
int notificationId({
  required int dayIndex,
  required String prayerKey,
  required bool lead,
}) =>
    1000 + (dayIndex * 100) + (kPrayerKeys.indexOf(prayerKey) * 2) + (lead ? 1 : 0);
```

**Step 4: Run the tests**

```bash
flutter test test/core/notifications/notification_schedule_test.dart
```
Expected: PASS, 4 tests.

**Step 5: Wire the planner into the service**

Replace `rescheduleForToday` (`notification_service.dart:104-139`) with:

```dart
  /// Cancels everything pending and schedules a rolling
  /// [kScheduleWindowDays]-day window.
  ///
  /// Previously this scheduled today only, which meant a user who installed
  /// and did not reopen the app had no pending reminders by the next morning.
  Future<void> rescheduleWindow({
    required double latitude,
    required double longitude,
    required NotificationPreferences prefs,
    required String method,
    required String madhab,
  }) async {
    await _plugin.cancelAll();

    final plan = buildNotificationPlan(
      days: LocalPrayerTimes.forRange(
        latitude: latitude, longitude: longitude,
        from: DateTime.now(), days: kScheduleWindowDays,
        method: method, madhab: madhab,
      ),
      prefs: prefs,
      now: DateTime.now(),
    );

    for (final n in plan) {
      final display = _displayName(n.prayerKey);
      await _scheduleOne(
        id: n.id,
        when: n.when,
        title: n.isLead
            ? '$display in ${prefs.leadMinutes} min'
            : '$display — time for prayer',
        body: n.isLead
            ? '$display prayer at ${_clock(n.when.add(Duration(minutes: prefs.leadMinutes)))} — get ready.'
            : 'It is now time to pray $display.',
      );
    }
  }
```

Keep `rescheduleForToday` as a deprecated one-line delegate for one release so nothing breaks silently:

```dart
  @Deprecated('Use rescheduleWindow — this scheduled today only. Remove after v1.1.')
  Future<void> rescheduleForToday(PrayerTimes times, NotificationPreferences prefs) =>
      rescheduleWindow(
        latitude: times.latitude, longitude: times.longitude,
        prefs: prefs, method: 'MWL', madhab: 'shafi',
      );
```

**Step 6: Update the orchestrator**

In `notification_orchestrator.dart:33-38`, swap the call to `rescheduleWindow`, passing lat/lng from `locationServiceProvider` and method/madhab from settings. Add a `WidgetsBindingObserver` that reschedules on `AppLifecycleState.resumed`, so the window slides forward every time the app is opened.

**Step 7: Run the full suite and commit**

```bash
flutter test
git add lib/core/notifications/ test/core/notifications/
git commit -m "fix(notifications): schedule a rolling 6-day window instead of today only

Scheduling stopped at midnight, so a user who installed and did not
reopen the app had no pending reminders by the next morning — the core
feature was dead out of the box. Ids now carry a day component; the old
_idFor had none, so day 2's Fajr overwrote day 1's.

Window is 6 days because iOS caps pending local notifications at 64 and
5 prayers x 2 x 6 = 60, leaving headroom for the Phase 1 goal reminder."
```

---

## Task 0.3: Request notification permission at a moment that converts

**The bug:** `NotificationService.requestPermissions()` exists (`notification_service.dart:82`) and is never called outside the Settings "send test" tile. On Android 13+ and iOS, nothing is ever delivered until the user grants permission — so the default experience is silence.

**Do not** request on first launch. A cold permission prompt before the user understands the app is the single most common way to get a permanent denial, and a denial is not re-promptable without a trip to system settings.

**Ask after the first prayer is logged** — the user has just demonstrated intent, and the ask has an obvious reason.

**Files:**
- Create: `lib/core/notifications/permission_gate.dart`
- Test: `test/core/notifications/permission_gate_test.dart`
- Modify: the prayer-log success path in `lib/features/prayers/presentation/controllers/`

**Step 1: Failing test**

```dart
// test/core/notifications/permission_gate_test.dart
void main() {
  test('asks once after the first prayer log, never again', () async {
    final gate = PermissionGate(store: InMemoryGateStore(), ask: () async => false);
    expect(await gate.maybeAskAfterFirstLog(), isTrue);   // asked
    expect(await gate.maybeAskAfterFirstLog(), isFalse);  // already asked
  });

  test('does not ask before any prayer has been logged', () async {
    final gate = PermissionGate(store: InMemoryGateStore(), ask: () async => true);
    expect(await gate.shouldAskOnLaunch(), isFalse);
  });
}
```

**Steps 2-5:** Implement `PermissionGate` with a `hasAsked` flag in `SharedPreferences`, call `maybeAskAfterFirstLog()` from the prayer-log success handler, run tests, commit.

Commit message: `feat(notifications): request permission after the first prayer is logged`

---

## Task 0.4: Fail the release build rather than ship localhost

**The bug:** `lib/core/network/dio_client.dart:15-17` — `kApiBaseUrl` is a `String.fromEnvironment` with `defaultValue: 'http://localhost:3000'`. A release build without `--dart-define` ships pointing at the device's own loopback. Every network call fails, and there is no guard.

**Files:**
- Modify: `lib/core/network/dio_client.dart:15-27`
- Test: `test/core/network/api_base_url_test.dart`

**Step 1: Failing test**

```dart
test('localhost default is rejected in release mode', () {
  expect(
    () => assertApiBaseUrlIsProductionSafe(
      url: 'http://localhost:3000', isReleaseBuild: true),
    throwsA(isA<StateError>()),
  );
});

test('localhost is fine in debug', () {
  expect(
    () => assertApiBaseUrlIsProductionSafe(
      url: 'http://localhost:3000', isReleaseBuild: false),
    returnsNormally,
  );
});

test('a real host passes in release', () {
  expect(
    () => assertApiBaseUrlIsProductionSafe(
      url: 'https://unified-faith-service.vercel.app', isReleaseBuild: true),
    returnsNormally,
  );
});
```

**Step 3: Implement**

```dart
/// Fails loudly at boot rather than shipping a build that cannot reach the
/// API. A release binary pointed at loopback fails every single request with
/// an opaque connection error — far better to never get out of CI.
void assertApiBaseUrlIsProductionSafe({
  required String url,
  required bool isReleaseBuild,
}) {
  if (!isReleaseBuild) return;
  final isLoopback = url.contains('localhost') ||
      url.contains('127.0.0.1') ||
      url.contains('10.0.2.2');
  if (isLoopback) {
    throw StateError(
      'Release build has API_BASE_URL="$url". Pass a real host:\n'
      '  flutter build apk --dart-define=API_BASE_URL=https://...',
    );
  }
}
```

Call it from `main()` before `runApp`, with `isReleaseBuild: kReleaseMode`.

**Step 5: Verify both paths, then commit**

```bash
flutter test test/core/network/api_base_url_test.dart
flutter build apk --release        # Expected: FAILS with the StateError message
flutter build apk --release --dart-define=API_BASE_URL=https://unified-faith-service.vercel.app  # Expected: succeeds
git commit -m "fix(network): refuse to build a release binary pointing at localhost"
```

---

## Task 0.5: Stop the splash from bricking on an auth error

**The bug, exactly:** `lib/core/router/app_router.dart:61-68`.

```dart
final stillBooting = auth.isLoading || !auth.hasValue || ...
```

When `authControllerProvider` resolves to `AsyncError` — expired refresh token, backend 500, DNS failure — `isLoading` is `false` *and* `hasValue` is `false`. `stillBooting` stays `true` forever and the router pins `/splash`. The user sees the brand animation and nothing else, permanently, with no way out but a reinstall.

**Files:**
- Modify: `lib/core/router/app_router.dart:56-70`
- Test: `test/core/router/app_router_redirect_test.dart`

**Step 1: Failing test**

```dart
test('auth error routes to login, not an infinite splash', () {
  final target = resolveBootRedirect(
    auth: const AsyncError('token expired', StackTrace.empty),
    onboarding: const AsyncData(true),
    splash: const AsyncData(true),
    location: Routes.splash,
  );
  expect(target, Routes.login);
});

test('auth still loading holds the splash', () {
  final target = resolveBootRedirect(
    auth: const AsyncLoading(),
    onboarding: const AsyncData(true),
    splash: const AsyncData(true),
    location: Routes.splash,
  );
  expect(target, isNull); // already on splash, stay
});
```

**Step 3: Implement** — extract the redirect decision into a pure `resolveBootRedirect` and treat `hasError` as resolved-and-unauthenticated:

```dart
  // An AsyncError here means we asked and got a definitive "no" — an expired
  // refresh token, a 500, no DNS. That is resolved, not still-booting. The
  // previous `!auth.hasValue` check treated it as booting forever and pinned
  // the splash with no way out but a reinstall.
  final authResolved = auth.hasValue || auth.hasError;
  final stillBooting = !authResolved || onboardingAsync.isLoading || ...;
```

Apply the same treatment to `onboardingAsync` — a failed `SharedPreferences` read should fall through to onboarding, not hang.

**Step 5: Commit**

```bash
git commit -m "fix(router): treat an auth error as resolved instead of pinning the splash

AsyncError leaves isLoading false and hasValue false, so stillBooting
stayed true forever and the router held /splash. A failed token refresh
bricked the app until reinstall."
```

---

## Task 0.6: Phase 0 regression pass

Run the full suite, build both release targets with the dart-define, and manually verify on a device: airplane-mode launch reaches login rather than hanging; notification permission prompt appears after the first prayer log; `adb shell dumpsys alarm | grep faith_mobile` shows pending alarms for tomorrow and beyond.

Per the project's standing rule, screenshot the real device rather than trusting the test suite alone.

---

# Phase 1 — Engine and Today (~3 weeks)

Two tracks that can run in parallel **only after Task 1.2 fixes the contract**. Do Task 1.2 first and treat it as frozen.

## Backend track

### Task 1.1: Install and configure Jest

The backend has zero tests and no runner. Everything after this is TDD, so this is a hard prerequisite.

**Files:** `package.json`, `jest.config.js`, `test/setup.ts`

```bash
npm i -D jest @types/jest ts-jest @nestjs/testing
```

Add to `package.json`: `"test": "jest"`, `"test:watch": "jest --watch"`.

Verify with one trivial passing test before moving on, so a red suite later means your code and not your config.

**Commit:** `chore(test): configure jest for the backend`

### Task 1.2: Freeze the API contract

**This unblocks both tracks — do it before anything else in Phase 1.**

**Files:** Create `docs/contracts/activity-api.md` in the backend repo.

Write request/response JSON for all four Phase 1 endpoints, including the error shapes. Mobile codes against this document; backend implements to it. Neither waits for the other.

```
POST /api/v1/activity/events
  { "events": [ { "clientEventId": "uuid", "faithId": "islam",
                  "activityType": "quran_verse", "quantity": 1,
                  "occurredAt": "2026-10-08T14:03:22Z",
                  "localDay": "2026-10-08", "timezone": "Asia/Kolkata",
                  "sourceRef": "quran:2:148" } ] }
  → 200 { "accepted": 12, "duplicates": 3 }

GET /api/v1/activity/today?faithId=islam
  → 200 { "localDay": "2026-10-08",
          "counts": { "quran_verse": 12, "prayer": 5 },
          "goal": { "goalType": "verses", "target": 5, "met": true },
          "streak": { "current": 25, "longest": 41, "freezesLeft": 2 } }

GET /api/v1/activity/history?faithId=islam&from=2026-10-01&to=2026-10-08
PUT /api/v1/activity/goal
```

**Commit:** `docs(contract): freeze the activity API contract`

### Task 1.3: Prisma models and migration

**Files:** `prisma/schema.prisma`, new migration

Add `ActivityEvent`, `DailyRollup`, `UserGoal`, `StreakState` exactly as specified in the design doc §4. Follow the house convention visible in `DhikrCounter`: camelCase fields, `@map` to snake_case, `@@map` to a plural snake_case table name.

```bash
npx prisma migrate dev --name add_activity_engine
npx prisma generate
npx prisma migrate status   # confirm: schema "faith"
```

**Commit:** `feat(db): add activity event, rollup, goal and streak models`

### Task 1.4: Idempotent event ingest

**Files:** `src/activity/activity.module.ts`, `controllers/activity.controller.ts`, `services/activity.service.ts`, `dto/activity.dto.ts`, `services/activity.service.spec.ts`

**Step 1: Failing test**

```typescript
describe('ActivityService.ingest', () => {
  it('writes each event exactly once, however many times it is sent', async () => {
    const batch = [buildEvent({ clientEventId: 'abc' })];
    await service.ingest(userId, batch);
    const second = await service.ingest(userId, batch);

    expect(second.accepted).toBe(0);
    expect(second.duplicates).toBe(1);
    expect(await countEvents(userId)).toBe(1);
  });

  it('rejects a localDay more than one day from the server date', async () => {
    await expect(
      service.ingest(userId, [buildEvent({ localDay: '2027-01-01' })]),
    ).rejects.toThrow(BadRequestException);
  });
});
```

The `@@unique([userId, clientEventId])` constraint does the real work; the service catches `P2002` and counts it as a duplicate rather than failing the batch. A phone retrying a flaky upload must never double-count a user's verses.

The ±1 day validation is the only defence against a broken device clock inflating history, and ±1 (not ±0) is deliberate: a user genuinely 14 hours ahead of UTC is not cheating.

**Commit:** `feat(activity): idempotent event ingest with local-day validation`

### Task 1.5: Rollup and streak projection

**Files:** `src/activity/services/rollup.service.ts` + spec

The highest-value tests in this plan. Write these exact cases — "test DST handling" is not a test:

```typescript
it('keeps the streak when the user flies Asia/Kolkata to Europe/London', ...)
  // localDay sequence 2026-10-08..2026-10-10 with timezone changing mid-run;
  // expect current === 3, not a reset.

it('does not drop a day when a DST zone loses an hour', ...)
  // Europe/London, localDay 2026-10-24 and 2026-10-25 (clocks go back);
  // both days have a goalMet rollup; expect current === 2.

it('consumes a freeze for exactly one missed day and no more', ...)
  // gap on 2026-10-09; freezesLeft 2 -> 1; current continues.

it('breaks the streak when two consecutive days are missed and one freeze remains', ...)

it('rebuilds identical state when rollups are deleted and replayed', ...)
  // the property that justifies event sourcing — assert it.
```

**Commit:** `feat(activity): daily rollup and streak projection`

### Task 1.6: Read endpoints

`GET /activity/today`, `GET /activity/history`, `PUT /activity/goal` to the frozen contract. One Nest e2e spec per endpoint.

**Commit:** `feat(activity): today, history and goal endpoints`

### Task 1.7: Nightly rollup cron

**Files:** `.github/workflows/activity-rollup.yml`

Model on the existing `keep-warm.yml` — same three-cron IST-offset pattern. Hits an authenticated maintenance endpoint that rolls up any day not yet closed. Serverless cannot hold a scheduler, and GitHub Actions is already the project's answer to that.

**Commit:** `feat(activity): nightly rollup via github actions cron`

## Mobile track

### Task 1.8: Add sqflite and the local event queue

No local DB exists in the app today. The queue is one table, so sqflite rather than drift — YAGNI.

```bash
flutter pub add sqflite path
```

**Files:** `lib/shared/habit/local_event_queue.dart`, `test/shared/habit/local_event_queue_test.dart`

Tests: events survive a simulated restart; flush removes only acknowledged rows; a failed flush leaves the queue intact; queue is capped (drop oldest past ~5000 rows so a permanently-offline device cannot fill storage).

**Commit:** `feat(habit): offline-durable local event queue`

### Task 1.9: The activity recorder

**Files:** `lib/shared/habit/activity_recorder.dart` + test

One call site per feature. Mints the `clientEventId`, stamps `localDay` from the device and the IANA zone, enqueues, returns immediately. Never awaits the network — reading in a basement must count.

```dart
await ref.read(activityRecorderProvider).record(
  ActivityType.quranVerse, quantity: 1, sourceRef: 'quran:2:148');
```

```bash
dart run build_runner build --delete-conflicting-outputs
```

**Commit:** `feat(habit): faith-agnostic activity recorder`

### Task 1.10: Local streak engine

Mirrors the server's rules for instant UI; the server reconciles. Port the Phase 1.5 test cases to Dart — the two implementations disagreeing is itself a bug worth a test.

**Commit:** `feat(habit): local streak engine for optimistic UI`

### Task 1.11: Faith content packs

**Files:** `lib/features/islam/habit_pack.dart`, `lib/features/hindu/habit_pack.dart`, tests for both

Maps activity types to labels, icons, goal types and deep links. The packs are the *only* place faith-specific strings live; a test asserts both packs implement every member of the shared interface, so Hindu cannot silently fall behind.

**Commit:** `feat(habit): islam and hindu content packs`

### Task 1.12: Wire record() into existing features

Six call sites: Quran reader, prayer log, dhikr counter, Gita reader, sandhya log, japa counter. One line each. Each gets a widget test asserting the event is enqueued.

**Commit:** `feat(habit): record activity from quran, prayers, dhikr, gita, sandhya and japa`

### Task 1.13: Rebuild the Today screen

**Files:** `lib/features/today/presentation/screens/today_screen.dart`, new widgets under `../widgets/`, update `test/features/today/today_screen_test.dart`

Build in design-doc §2 order: streak chip → week strip → goal card → checklist → stat tiles. Existing `PoppyCard`/`PoppyButton`/`StatChip` carry the visual language; this is composition, not new design.

**Also fixes the hardcoded verse** — `today_screen.dart:88-92` has `At-Talaq 65:2` as a string literal. Replace with a `dailyVerseProvider` rotating day-of-year over a curated list, mirroring `dailyHadithProvider`.

**And fixes the hadith card, which is the worst text-heaviness on the screen.** Found on-device 2026-10-08: "Hadith of the day" renders the *isnad* — `حَدَّثَنَا زَكَرِيَّاءُ بْنُ يَحْيَى، حَدَّثَنَا عَبْدُ اللَّهِ بْنُ نُمَيْرٍ...`, the chain of transmission — with the actual teaching below the fold. The most prominent card on the home screen is Arabic provenance boilerplate that means nothing to a casual reader.

The schema has `textArabic`, `textEnglish`, `narratorChain` and `narratorChainArabic` as separate columns, but the raw Bukhari corpus bakes the isnad into `text_arabic`, so the card is faithfully rendering bad data.

This also corrects a rule in the design doc. §2 says *"Arabic/Devanagari scales up; translation collapses behind a tap."* That is right for Qur'an and Gita, where the scripture **is** the point. It is wrong for hadith, where the Arabic opens with boilerplate and the English matn carries the meaning. So:

- **Qur'an / Gita cards:** scripture leads, translation collapses.
- **Hadith cards:** the English matn leads; Arabic and the narrator chain collapse behind a tap.

Strip or demote the isnad for display rather than mutating stored data — the chain is scholarly provenance and must stay retrievable, just not be the headline.

Golden tests for both faiths, using `FakeSelectedFaith` from `test/helpers/`. Add a `FakeActivityRecorder` helper in the same style so goldens never touch the network.

**Commit:** `feat(today): rebuild around streak, goal and progress for both faiths`

### Task 1.14: Analytics

```bash
flutter pub add posthog_flutter
```

PostHog over Firebase Analytics because the question this quarter has to answer is a cohort-retention question, and PostHog answers it out of the box where GA4-shaped reporting does not. Reversible — the wrapper is one file.

**Files:** `lib/core/analytics/analytics.dart` + test

Events: `goal_set`, `goal_met`, `streak_broken`, `session_start`, `session_end`, `challenge_joined`, `invite_sent`, `invite_accepted`. Wrap the SDK behind an interface so tests assert on a fake and no test ever emits a real event.

**Commit:** `feat(analytics): posthog wrapper and the phase 1 event set`

### Task 1.15: Daily goal reminder

Uses the four notification slots Task 0.2 left free. Fires in the evening only when the goal is unmet. Never fires when the goal is already met — a reminder to do what you have done is how people learn to ignore your notifications.

**Commit:** `feat(notifications): evening reminder when the daily goal is unmet`

---

# Phase 2 — Sessions and challenges (~3 weeks)

### Task 2.1: Session controller
`lib/shared/habit/session_controller.dart` — start/stop, elapsed timer, running verse count, micro-goal ("Reach 5 mins"). Tests: timer survives backgrounding; session auto-closes after 30 min idle so a phone left on a verse does not log an eight-hour session.

### Task 2.2: Session HUD in the readers
The top pill from reference image 3 — live hasanat-equivalent, verse count, timer. Both Quran and Gita readers.

### Task 2.3: "I'm Done" summary sheet
What was read, goal progress, streak status, points. The emotional payoff of the loop — this is the screen that makes tomorrow feel worth it.

### Task 2.4: Challenge models and endpoints
`Challenge`, `ChallengeEnrollment`; `GET /challenges`, `POST /challenges/:id/join`. Progress derives from `ActivityEvent` queries, never a separate counter — the point of event sourcing.

### Task 2.5: Recurring challenge generation
Friday Challenge (Surah Kahf) and Nightly Recitations regenerate weekly/daily via the Task 1.7 cron. Tests: no duplicate instance for the same period; timezone-correct Friday for the user's zone.

### Task 2.6: Challenge cards on Today
With artwork. Commission or generate six illustrations (three per faith) — every reference card has one and none of ours do.

### Task 2.7: Six launch challenges
Islam: Friday Surah Kahf, Nightly Recitations, 30-day meaning challenge. Hindu: Gita chapter-a-week, daily sandhya, Ramayana reading.

---

# Phase 3 — Social (~2–3 weeks) · RE-PLAN BEFORE EXECUTING

**Gate:** re-plan after Phase 1 analytics has two weeks of data. If fewer than ~30% of active users set a goal, the social layer is not the problem and this phase should be reconsidered rather than built.

| Task | Files | Acceptance |
|---|---|---|
| 3.1 Friendship + InviteCode models | `prisma/schema.prisma` | Pair stored sorted; no duplicate friendships |
| 3.2 Invite link generation | `src/circle/` | Code is unguessable, expiring, use-capped |
| 3.3 Deep link handling | `lib/core/router/` | Cold-start install → invite accepted after signup |
| 3.4 Circle screen | `lib/features/circle/` | Ranked by points over a window; empty state sells the invite |
| 3.5 Redis pulse counters | `src/activity/services/pulse.service.ts` | `/pulse` under 50ms; degrades to hidden, never to a wrong number |
| 3.6 Pulse UI | Today widgets | Polls at 45s, only while foregrounded |
| 3.7 Referral rewards | TBD | Depends on what Phase 1 shows about what people value |

---

# Phase 4 — Launch (~2 weeks) · RE-PLAN BEFORE EXECUTING

Remaining `MOBILE_QA_REPORT.md` waves (8 Critical / 18 High, minus the four fixed in Phase 0); account deletion verification (store gate, already built backend-side); iOS provisioning; store listing copy and screenshots; privacy policy covering the analytics and the invite graph; staged rollout.

---

## Standing rules for every task

1. **Commit after each task**, not at the end of a phase.
2. **Run `build_runner`** after any provider or DTO change, before running tests.
3. **Device QA gates every mobile task.** Run `device-qa.sh` before and after; attach the alarm count and screenshot to the task's completion. No device evidence, not done. Goldens do not catch a layout that breaks at 320px, and no unit test can prove Android registered an alarm.
4. **Never weaken a test to make it pass.** A failing streak test is the feature telling you it is wrong.
5. **Both faiths or neither.** Any shared-engine change that lands for Islam lands for Hindu in the same commit, or the parity test fails.
