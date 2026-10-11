# Siraat Mobile — Retention Engine

Design doc. Approved 2026-10-08.

## Context

Siraat (`faith_mobile`) has 23 feature modules and 63 screens across two faiths, and it has never
been published to a store. The visual language was already rebuilt once — see
`2026-08-29-poppy-comic-redesign-design.md`, whose scope line reads *"no new gamification mechanics
(streaks/XP/badges) beyond what already exists."* That redesign shipped. The app still reads as
text-heavy, which tells us the remaining gap is not the skin: it is that nothing on the home screen
changes because of what the user did yesterday.

`today_screen.dart` is a vertical stack of text cards — greeting, prayer countdown, Verse of the Day
(a hardcoded string literal, `At-Talaq 65:2`, unchanged since February), Hadith of the Day (this one
is live), mood prompt, quick actions. There is no streak, no goal, no sense of progress.

The asymmetry underneath it: **streaks exist only on the Hindu side.** `japa_stats` and `puja_stats`
carry streak fields. The entire Islam side — prayers, Quran, dhikr — has none. `leaderboard` and
`challenge` appear zero times in the codebase.

This document designs the habit loop that the August redesign deferred, for both faiths.

**Reference set:** Quranly (home, stats, reader session), FiveSalah (prayer streak, week strip,
month dot-grid), and a widely-shared "Muslimah Nafs Fighter" habit-tracker spreadsheet.

## 1. The loop

```
  set a small daily goal  ──►  do it in-app  ──►  ring fills, streak +1
          ▲                                              │
          │                                              ▼
   reminder fires        ◄──  streak at risk  ◄──  evening, goal unmet
```

Challenges, circle and points all hang off this spine. The spine must work on its own first, which
is why Phase 1 ships it alone and is independently releasable.

## 2. Today, rebuilt

Same anatomy for both faiths; the content pack differs.

```
┌──────────────────────────────────────────┐
│  Asalam Alaykum, Arham      [📅] [🔥 25] │  ← streak chip → Circle
│  ( M )( T )( W )[ T ]( F )( S )( S )     │  ← rings, not checkboxes
├──────────────────────────────────────────┤
│  Today's Goal              Completed ✓   │
│  5 / 5 verses                            │
│  Al-Baqara 148/286              [✎]      │  ← resume position
│  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░   2/30 Juz   2.5% │
│  [        Read Quran        ]            │
├──────────────────────────────────────────┤
│  ✓ Fajr  ✓ Dhuhr  ✓ Asr  ✓ Maghrib ☐ Isha│  ← deep-links; nothing self-reported
│  ☐ Dhikr goal            40 / 100        │
├──────────────────────────────────────────┤
│  Friday Challenge · Surah Kahf           │
│  ░░░░░░░░░░  0/110        7d 2h left     │
├──────────────────────────────────────────┤
│  [Today] Week  All                       │
│  │ Verses ││ Pages  ││  Time  ││Prayers ││  ← real units, never "points"
│  │   12   ││   03   ││  14m   ││  5/5   ││
├──────────────────────────────────────────┤
│  Verse for today        (now rotating)   │
│  Quick actions                           │
└──────────────────────────────────────────┘
```

Hindu pack: panchang chip instead of Hijri, sandhya ×3 instead of prayers ×5, malas and shlokas
instead of verses and pages.

### Navigation: no Circle tab

The shell already carries five tabs — Today, two faith tabs, Practice, Reflect. A sixth is
unreadable at 320px, a width already in the project's screenshot set. **The streak chip in the Today
header is the entry point to Circle**, which is a pushed screen rather than a tab. FiveSalah uses the
same pattern: the flame is a tappable header element. A leaderboard is somewhere people check, not
somewhere they live.

### What actually fixes "text heavy"

1. Verse of the Day rotates from the API instead of being a constant.
2. Numbers replace sentences — rings, tiles and bars carry state the user currently has to read.
3. Arabic/Devanagari scales up; translation collapses behind a tap, so scripture leads.
4. Challenges get artwork. Every reference card has an illustration; none of ours do.

## 3. The reader session

Opening a surah or a Gita chapter starts a session: live timer, verses counted, a micro-goal
("Reach 5 mins"). **"I'm Done"** closes it into a summary sheet — what was read, goal progress,
streak status.

This is the largest behavioural change in the app. Reading becomes a bounded act with an ending
instead of an infinite scroll the user drifts out of, and it is where most activity events originate.

## 4. Data model

Six new models. Everything else is derived.

```prisma
model ActivityEvent {                      // the only source of truth
  id            String   @id @default(uuid())
  userId        String   @map("user_id")
  faithId       String   @map("faith_id")        // islam | hindu
  activityType  String   @map("activity_type")   // quran_verse | prayer | dhikr |
                                                 // gita_shloka | sandhya | japa_mala
  quantity      Int      @default(1)
  occurredAt    DateTime @map("occurred_at")         // real instant, UTC
  localDay      DateTime @map("local_day") @db.Date  // the user's day — what streaks count
  timezone      String                               // IANA, e.g. Asia/Kolkata
  sourceRef     String?  @map("source_ref")          // "quran:2:148", "prayer:fajr"
  clientEventId String   @map("client_event_id")     // UUID minted on device

  @@unique([userId, clientEventId])        // idempotency: retries are free
  @@index([userId, localDay])
  @@index([userId, activityType, localDay])
}

model DailyRollup {                        // cache. deletable, recomputable
  userId   String
  faithId  String
  localDay DateTime @db.Date
  counts   Json                            // {quran_verse: 12, prayer: 5}
  points   Int      @default(0)
  goalMet  Boolean  @default(false)
  @@id([userId, faithId, localDay])
}

// CORRECTED 2026-10-08: effective-dated and append-only, NOT one mutable row.
// A single current row cannot be replayed: recomputing a past day would use
// *today's* target, so lowering the goal to 1 retroactively manufactures a
// 90-day streak, and "delete the rollups, replay, get identical state" — the
// property that justifies event sourcing at all — becomes false.
// Rollup and replay read the goal in force on the day being computed.
model UserGoal     { userId, faithId, goalType, target, effectiveFrom, effectiveTo? }
model StreakState  { userId, faithId, current, longest, lastGoalMetDay, freezesLeft, freezeResetOn }
model Challenge    { id, slug, faithId?, kind, activityType, target,
                     title, artworkKey, startsAt, endsAt, recurrence }
model ChallengeEnrollment { challengeId, userId, progress, completedAt
                            @@unique([challengeId, userId]) }
model Friendship   { userIdA, userIdB, createdAt  @@unique([userIdA, userIdB]) }  // pair sorted
model InviteCode   { code @unique, userId, useCount, maxUses, expiresAt }
```

`StreakState` and `DailyRollup` are projections. Rebalance the points, or redefine what a day is, and
you drop them and replay the event table. That property is the whole reason for this shape — and it
is what makes the Hindu pack a set of new `activityType` values rather than a second implementation.

Migrations land in the `faith` schema on RDS; run `prisma migrate deploy` against
`DATABASE_URL_UNPOOLED` as per the 2026-10-08 database cutover.

## 5. API surface

```
POST /activity/events          batch, idempotent on clientEventId
GET  /activity/today?timezone= rollup + streak + goal in one call
                               timezone is REQUIRED — without it the server
                               cannot know which day "today" is, and a Kolkata
                               user at 02:00 IST gets yesterday's card and a
                               streak that looks broken
GET  /activity/history?from&to week strip and month dot-grid
PUT  /activity/goal
GET  /challenges               active, enrollment state, participant count
POST /challenges/:id/join
GET  /circle                   friends ranked by points over a window
POST /circle/invite            → code + deep link
POST /circle/accept
GET  /pulse                    live aggregates
```

## 6. Live counters, without sockets

Redis is already wired (`@nestjs/cache-manager` + `@keyv/redis`, used for caching in names, calendar,
hadiths and prayers). The backend is Vercel serverless and cannot hold a connection open, so there is
no WebSocket option and none is needed:

- `pulse:reading` — 5-minute sliding set of active userIds → *"353 reading right now"*
- `pulse:verses:<localDay>` — `INCRBY` on ingest → *"524 verses read today"*
- challenge participant counts — `COUNT` cached 60s

The app polls `/pulse` every 45s while Today is foregrounded. These numbers are social proof, not
telemetry; approximate is the correct target.

Nightly rollup and challenge recurrence run as a **GitHub Actions cron**, reusing the pattern already
in `.github/workflows/keep-warm.yml`, rather than introducing Vercel cron.

## 7. Mobile architecture

```
lib/shared/habit/            ← faith-agnostic, built once
  activity_recorder.dart       record(quranVerse, qty: 1, ref: '2:148')
  local_event_queue.dart       sqflite-backed; survives offline and restart
  streak_engine.dart           local compute for instant UI
  daily_goal.dart
  session_controller.dart      timer, micro-goal, "I'm Done" summary
  challenge_repository.dart
  circle_repository.dart

lib/features/islam/habit_pack.dart    ← labels, icons, goal types, deep links
lib/features/hindu/habit_pack.dart    ← same shape, different content
```

One call site per feature. `QuranReaderScreen` calls `record()` and knows nothing about streaks,
points or challenges.

## 8. Day boundaries, offline, and the other ways streaks die

**The day boundary is the one that matters.** A streak is a day-boundary bug waiting to happen, and
this project has already paid for the lesson once: the Hindu panchang bug compared a real instant
against wall-clock time and cost a day of debugging. This is the same class of bug, except it
silently kills a 90-day run and surfaces as a 1-star review rather than a stack trace.

So the device stamps `localDay` and `timezone` on every event, and the server stores what the device
says, validated as `|localDay − dateOf(occurredAt, UTC)| ≤ 1` — derived from the event's **own**
`occurredAt`, never from the server's wall clock at the moment of arrival. That distinction is not a
detail: events queue offline and flush days later, so validating against arrival time would reject
every event the offline queue exists to carry. ±1 rather than ±0 is exactly the slack that covers
UTC−12…UTC+14. Three things then follow for free: a user who
flies Delhi→London does not lose a day; DST cannot produce a 23-hour day that drops a goal; a phone
set to the wrong timezone is at least internally consistent.

**Streak freezes.** Two per month, auto-applied. Not a nicety — it is the single largest retention
lever Duolingo has, because the day someone loses a 60-day streak to a flat battery is the day they
stop opening the app.

**Offline-first.** Events queue locally and the UI updates optimistically. Reading in a basement with
no signal must count. The queue flushes on reconnect, and `clientEventId` makes every retry a no-op.

**Reconciliation.** The server rollup wins. Where local and server disagree, the UI animates to the
server's number rather than snapping — a silent correction reads as a bug.

**Clock tampering.** Someone will set their phone forward to farm a streak. We deliberately do not
defend against this: the leaderboard is friends-only by invite, so the only person being cheated is
the cheater. Recorded here so it is a decision rather than an oversight.

## 9. Testing

The mobile app has 16 test files including a Today-screen test, so this extends an existing suite.
The backend has zero `.spec.ts` files.

Not proposing to fix that broadly. The streak engine is the one place that must have tests, because
its failures are silent:

- streak across a DST boundary
- streak across a timezone change
- streak across midnight
- streak with a freeze consumed
- the same `clientEventId` submitted twice yielding exactly one row

Plus golden tests on the rebuilt Today screen for both faiths.

## 10. Analytics

There is currently zero analytics in the app. Without it this quarter is unfalsifiable — we will not
be able to say whether the streak worked. Minimum set, wired in Phase 1: `goal_set`, `goal_met`,
`streak_broken`, `session_start`, `session_end`, `challenge_joined`, `invite_sent`,
`invite_accepted`.

## 11. Phasing

| Phase | | Scope | Est. |
|---|---|---|---|
| 0 | Ship-blockers | Rolling notification schedule + permission request; login-splash brick; release-build localhost guard | ~1 wk |
| 1 | Engine + Today | Event ingest, rollups, streak, goal, week strip, stat tiles, de-texted Today, both packs, analytics | ~3 wks |
| 2 | Sessions + challenges | Reader session timer, micro-goals, "I'm Done" summary, challenge system + 3 launch challenges per faith | ~3 wks |
| 3 | Social | Circle invites, friends leaderboard, pulse counters, referral loop | ~2–3 wks |
| 4 | Launch | Remaining QA waves, store assets, submission | ~2 wks |

**~11–12 weeks.** Phase 1 is independently shippable: stopping there still leaves a working habit
loop and a home screen that is not a wall of text.

Phase 0 is not optional. `MOBILE_QA_REPORT.md` records prayer notifications scheduled for today only
with permission never requested. A streak with no reminder is a streak people lose by accident, which
makes the feature work against retention rather than for it.

## Decisions on record

| Decision | Choice | Why |
|---|---|---|
| Scope | Full retention engine | Visual redesign alone already shipped in August and did not solve it |
| Faiths | Both, full parity this round | Engine built once in `shared/`; two content packs ship together |
| Social model | Anonymous aggregates + friends-by-invite | No public profiles, no moderation queue, no stranger abuse surface — and publicly ranking acts of worship runs into riya'/ostentatious-piety objections in both traditions |
| Currency | Neutral points; real units in the UI | Points exist so a cross-activity leaderboard is possible. Hasanat/Punya framing makes a theological claim an app cannot make, and is the most-criticised thing in this category |
| Habits tracked | Only what the app can verify | No manual-entry fatigue; every row deep-links to a screen that completes it |
| Architecture | Event-sourced core | The only option where the Hindu pack is configuration rather than a second implementation |
| Circle placement | Header chip → pushed screen | Six tabs is unreadable at 320px |
| Clock tampering | Not defended | Friends-only leaderboard makes it self-harm |

## Out of scope (this round)

- Custom/self-reported habits (water, sleep, sadqa) and the mood + weekly/monthly goal sheets from
  the habit-tracker reference. The loop covers only app-verifiable activity.
- Public global leaderboard, usernames, avatars, and the moderation surface they require.
- Hasanat/Punya framing, including as an opt-in setting.
- Home-screen widgets (still carried over from the old Phase 2 roadmap).
- Broad test coverage beyond the streak engine and the Today goldens.
