# Siraat Mobile — "Poppy Comic" Redesign

Design doc. Approved 2026-08-29.

## Context

Siraat (`faith_mobile`) launched as a single-faith (Islam) app with an "illuminated manuscript" visual language — serif Fraunces headlines, muted sage/gold/parchment palette, quiet literary tone (`lib/core/theme/app_colors.dart`, `app_theme.dart`). The web app (`faith-web-remix`) has since shipped a full Hindu vertical with its own per-faith brand accents, but mobile is still Islam-only in both content and visual identity. The current look reads as old and doesn't accommodate a second faith.

Goal: redesign mobile's UI/UX with a bold, "poppy comic" visual language (Duolingo as the closest reference point: flat shapes, thick outlines, saturated color, tactile motion, friendly mascots) and restructure the app around **two faiths** as first-class citizens rather than retrofitting Hindu content into an Islam-shaped skin.

**Scope:** full visual/UX redesign across all 16 existing feature modules. Visual language and motion only — no new gamification mechanics (streaks/XP/badges) beyond what already exists; existing habit-tracking data (prayer logs, dhikr counts, etc.) is presented in the new style, not extended.

## 1. Design language & color system

**Principles:** flat shapes, thick (2.5–3px) outlines on key elements, generous rounded corners, high-saturation color blocking, tactile depth via hard offset "pressed" shadows (not blur/glow).

**Token structure** — one `FaithPalette` per faith (Islam, Hindu), each with light + dark variants:

| Token | Islam (light) | Hindu (light) |
|---|---|---|
| `primary` | Bold emerald (~`#00B87A`) | Bold marigold-red (~`#FF6B3D`) |
| `primaryPressed` | Darker shade, offset-press state | Same pattern |
| `secondary/accent` | Gold `#FFC93C` | Deep saffron `#FFB000` |
| `surface` | Warm off-white `#FFF9F0` | Same (shared neutral) |
| `surfaceCard` | White, colored outline | White, colored outline |
| `ink` | Near-black | Same (shared neutral) |
| `mascotAccent` | Crescent silhouette color | Diya-flame color |

Neutrals (surface/ink/borders) are shared across faiths — only primary/secondary/accent shift, so both faiths read as siblings in one product while staying distinctly branded once inside.

Dark mode: same token structure, near-black neutral surfaces (not navy/"night sky" like today), primary/accent bumped brighter to hold saturation.

**Typography:** drop Fraunces entirely. Rounded geometric sans (`Baloo 2` or `Fredoka`, via existing `google_fonts` dependency) for display/headline; `Nunito`/`Inter` for body. Big, bold, tight-tracking numerals for streak/count displays.

## 2. Components, mascot, motion

**Components:**
- **Cards** replace plain list rows as the core unit. Rounded-24, 2.5px outline, flat fill, hard offset shadow that compresses on press. Feature entry points become bold icon-cards.
- **Buttons**: chunky, 56–64px height, thick outline, offset-shadow press animation (shadow collapses + button shifts down 2px on tap).
- **Icons**: custom flat-filled set, thick rounded strokes, replacing Material defaults.
- **Stat chips**: pill-shaped, bold numerals — prayer streaks, dhikr counts, reading progress. Visual language kept gamification-ready for a future phase without building new mechanics now.

**Mascots (coded vector, no external assets):**
- Built as Flutter widgets (`CustomPainter`/layered shapes): shared rig (body silhouette, eyes, mouth) + faith-specific accessory (crescent-and-star topper for Islam, diya-flame crown for Hindu) + faith palette. Shared rig keeps them visually related; accessory + color differentiate.
- 4 states: idle/neutral, celebrate, encourage, sleep/night. Animated with `flutter_animate` (already a dependency) — no Lottie/Rive needed given the simple geometric construction.
- Rationale for coded vector over sourced assets: web-searched for free/commercial-use "character" mascots built around crescent-moon or diya/lotus motifs — none exist. Available resources (Flaticon, IconScout, Freepik, Vecteezy) are icon/clipart-level, not personified characters, and most free tiers require attribution — a liability for a monetized app. Confirmed with user 2026-08-29.

**Motion:**
- Screen transitions: scale+fade (150–200ms), not slide.
- Card taps: 100ms scale-down (0.96) + shadow collapse, spring back on release.
- List/card entrance: staggered fade+slide-up (50ms stagger per item).
- Success moments (prayer logged, dhikr milestone, dua read): mascot celebrate animation + simple particle-shape confetti burst (no external asset).

## 3. Faith picker, navigation, IA

**Faith picker (new front door, replaces current 4-slide onboarding):**
1. Splash — brief animated faith-neutral mark (shared abstract "light" icon, not tied to either mascot).
2. Faith picker screen — both mascots shown as big tappable cards in their own palette, already idle-animated ("Choose your path"). Tap triggers full-screen palette cross-fade + mascot animation into that faith's world.
3. Condensed onboarding (2–3 screens, down from 4) inside the chosen faith's skin: notification permission + a couple of value-prop screens narrated by the mascot.
4. Settings → "Switch faith" re-runs the picker and re-themes the app live. This is the only other entry point to change faiths.

**Faith switching model:** locked-in per session/account, switchable only via settings — not a persistent quick-switcher. Rationale: this is a daily habit-tracking app (prayer times, dhikr, streaks); those are inherently faith-specific rituals, and a persistent single-faith skin keeps notifications/streaks/home focused. Settings-level switching still supports interfaith households or the curious.

**Navigation/IA:** bottom nav keeps its current structure (Today/Home, Practice, Quran/Scripture, Reflect, Settings — matches existing `shell`/`today`/`practice`/`reflect` modules). This is a component/skin swap on existing navigation, not an IA rebuild.

## 4. Technical architecture

- New `lib/core/theme/faith_theme.dart`: `FaithTheme` class holding the full token set (colors, type scale, shape constants, motion durations, mascot widget builder), one instance per faith (`islamTheme`, `hinduTheme`) with light/dark variants each.
- Riverpod provider `currentFaithThemeProvider` exposes the active `FaithTheme`, derived from the user's selected faith preference + existing `theme_mode` preference.
- `app_theme.dart` rebuilt to consume `FaithTheme` and emit Material `ThemeData` (colorScheme, textTheme, component themes) dynamically, instead of the current single static palette — existing Material-based widgets inherit the active faith's look for free.
- New shared component kit (`lib/core/components/` or extend `lib/shared/`): `PoppyCard`, `PoppyButton`, `StatChip`, `MascotView`, faith-themed icon set. Built once, consumed by all 16 feature modules — this is the actual rollout mechanism, not a screen-by-screen from-scratch redesign.
- Chosen specifically because the platform's stated direction (per root `CLAUDE.md`) is to extend beyond Islam/Hindu to more traditions — a token-based system means adding a future faith is "add a token set," not "resweep 48 screens."

**Suggested implementation sequence** (design covers all modules; build sequencing front-loads visibility): shell/nav → faith picker/onboarding → today/home → prayers/practice → quran/duas/names/hadiths → dhikr/reflect/feelings → calendar/qibla/settings/share.

## Out of scope (this round)

- New gamification mechanics (XP, levels, achievements, badges) — visual language only, on top of existing data.
- Sourced/commissioned mascot artwork — using coded vector mascots instead (see rationale above).
- Hindu content/feature parity on mobile (separate workstream — this doc covers UI/UX only, assuming Hindu content lands via the existing module pattern).
- Web app changes — this redesign is mobile-only; web keeps its current "first light / dawn" identity.
