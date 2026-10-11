# Firebase setup (Crashlytics + Analytics)

The app is wired for Firebase Crashlytics and Firebase Analytics, but
`android/app/google-services.json` is **not in this repository**. Creating a
Firebase project needs the owner's Google account, so it could not be done as
part of the integration.

Until that file exists, the app builds and runs exactly as it did before and
reports nothing. Nothing is broken; there is simply no crash reporting.

## What the owner has to do

1. Go to <https://console.firebase.google.com> and create a project. Name it
   something like `siraat` — the name is only a label in the console.
2. In that project, **Add app → Android**.
   * Android package name: `com.faith.companion.faith_mobile`
     (exactly — it must match `applicationId` in
     `android/app/build.gradle.kts`).
   * App nickname: anything.
   * Debug signing certificate SHA-1: leave blank. Nothing here uses Google
     Sign-In or Dynamic Links, which are the only features that need it.
3. Download the `google-services.json` the console offers and put it at:

   ```
   android/app/google-services.json
   ```

4. In the console sidebar, open **Crashlytics** and **Analytics** and click
   through the enable step for each. Crashlytics will say it is waiting for
   its first crash report; that is expected until step 6.
5. Commit the file. Unlike `android/key.properties`, it is deliberately not
   gitignored: on Android `google-services.json` carries no secret — it ships
   inside every APK we publish — and committing it is what lets a CI release
   build upload its R8 mapping file to Crashlytics.
6. Verify, on a real device, with a **release** build (debug builds never
   report — see below):

   ```
   flutter build apk --release --dart-define=API_BASE_URL=<the API base URL>
   ```

   Install it, open the app, and either wait for a real crash or add a
   temporary `throw` behind a debug affordance. Reports appear in the
   Crashlytics console within a few minutes of the *next* app launch — the
   SDK uploads on the launch after the crash, never during it.

Nothing else changes. No code edit, no flag, no rebuild of anything but the
app.

## What happens with the file present

`android/app/build.gradle.kts` checks for the file and, only if it is there,
applies two Gradle plugins:

* `com.google.gms.google-services` — turns the JSON into Android string
  resources the Firebase SDK reads at startup.
* `com.google.firebase.crashlytics` — uploads the R8 mapping file for release
  builds, which is what makes a release stack trace readable instead of a
  column of `a.b.c(Unknown Source)`. Explicitly disabled for debug builds.

Both are declared `apply false` in `android/settings.gradle.kts`, which is
where their versions live.

The guard matters because `com.google.gms.google-services` **hard-fails the
build** when the JSON is missing. Applying it unconditionally would make a
fresh clone unbuildable for anyone who does not have the file.

## What happens with the file absent

`Firebase.initializeApp()` throws, `Telemetry` catches it, logs in debug, and
leaves collection off for the process. Every analytics call still type-checks
and still runs — they go to `NoopAnalyticsSink` — so no call site needs a
branch.

## Builds that never report

`Telemetry.isEligibleBuild` is false in debug, in profile, and under
`flutter test`. In those builds `Telemetry.bootstrap()` returns before it
installs a single error handler, so Flutter's own red screen and console
output behave exactly as they always have, and no test run can touch the
production crash-free rate.

## iOS

Not configured. `ios/Runner/GoogleService-Info.plist` is absent and the iOS
build has no Firebase plugins applied. The Dart side degrades the same way it
does on Android — `Firebase.initializeApp()` throws and is caught — so an iOS
build is unaffected. Wiring iOS is the same shape of work plus a Run Script
build phase for dSYM upload.

## The privacy rules this integration is built to

Read `lib/core/telemetry/telemetry_vocabulary.dart` before adding an event.
The short version:

* Siraat already records acts of worship on its own server, through the
  activity stream. **None of that is duplicated to Google** — not verses
  read, prayers, dhikr, japa, goals, streaks, collections or journal entries.
  Analytics is only for what our own backend structurally cannot see.
* Which emotion a user selected, journal text, location coordinates, and any
  identifier beyond Firebase's own instance id **never leave the device**.
* **Faith is never a user property or an event parameter.** Per-faith numbers
  are a query against our own database. There is no user-property API in the
  analytics layer at all, so there is nothing to add it to.
* `SiraatAnalytics` has no method that takes a `String`. If an event you want
  needs free text, the answer is that it is not an event we send.

`test/core/telemetry/forbidden_data_test.dart` and
`screen_view_privacy_test.dart` enforce all of the above. If you add an event
and the first of those fails telling you to add it to the sweep, that is
working as intended.
