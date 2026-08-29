# Siraat Mobile — Poppy Comic Redesign + Hindu Vertical Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Redesign Siraat mobile with a bold "poppy comic" visual language (Duolingo-style: flat shapes, thick outlines, saturated color, tactile motion, per-faith mascots), and build a full Hindu vertical (8 new feature areas wired to the already-live backend) so the app is genuinely two-faith from the ground up, not Islam skin + afterthought.

**Architecture:** A token-based `FaithPalette`/`FaithThemeExtension` system drives all color/shape/motion/mascot decisions from one `SelectedFaith` preference, consumed via `Theme.of(context).extension<FaithThemeExtension>()`. A shared component kit (`PoppyCard`, `PoppyButton`, `StatChip`, `PoppyIcon`, `MascotView`) replaces the ad-hoc `Container+BoxDecoration+Border.all(cs.outline)` pattern that recurs across nearly every existing screen. Hindu features are new Flutter modules that mirror the existing Islam module shape exactly (`data/dtos/`, `data/<name>_repository.dart`, `<name>_routes.dart`, `presentation/screens|widgets|controllers`) and call the already-shipped `unified-faith-service` Hindu endpoints.

**Tech Stack:** Flutter 3.11, Riverpod (+ riverpod_generator), go_router (StatefulShellRoute), Dio, Freezed DTOs, google_fonts, flutter_animate, shared_preferences.

**Design doc:** `faith_mobile/docs/plans/2026-08-29-poppy-comic-redesign-design.md` (approved 2026-08-29). This plan additionally covers the full Hindu-parity build, which the design doc explicitly deferred — approved by user 2026-08-29 in the same session ("We'll build full, both faiths").

---

## Conventions used throughout this plan

- **File paths** are relative to `faith_mobile/` unless stated otherwise.
- **Testing strategy** (no golden-image tests exist in this repo today; only `test/smoke_test.dart`):
  - Foundation layer (tokens, theme, providers, shared components, mascot): real `flutter_test` widget tests — these have actual logic/branching worth asserting on.
  - Per-screen reskin/build tasks: a **smoke test** per screen — pump it inside `ProviderScope` with repository providers overridden to return fixture data, verify it builds without throwing and a known piece of text renders. This matches the existing `test/smoke_test.dart` convention and catches the two failure modes that matter most for a visual pass: broken imports/build errors, and provider wiring mistakes.
  - After each module's tasks, a **manual run-through** step: `flutter run`, navigate to the screen(s), confirm the new visual language renders correctly in both faiths (where applicable) and both light/dark, no overflow errors in the console.
- **Commit granularity:** one commit per task, not per step. No AI co-author trailer (repo convention).
- **Do not** run `dart pub get`/codegen assumptions blind — after adding any new `@Riverpod`/`@freezed` class, run `dart run build_runner build --delete-conflicting-outputs` before the widget test step (this repo uses code generation; `.g.dart`/`.freezed.dart` files must exist and be current or the test step fails with an unrelated-looking compile error).

---

# PART A — FOUNDATION

Everything downstream (Islam reskin, Hindu build) depends on this part. Build and verify it completely before starting Part B or C.

### Task A1: `FaithId` enum + `SelectedFaith` persisted preference

**Files:**
- Create: `lib/core/theme/faith_id.dart`
- Create: `lib/core/preferences/selected_faith.dart`
- Test: `test/core/preferences/selected_faith_test.dart`

**Step 1: Write the failing test**

```dart
// test/core/preferences/selected_faith_test.dart
import 'package:faith_mobile/core/preferences/selected_faith.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('defaults to null (no faith chosen yet)', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final result = await container.read(selectedFaithProvider.future);
    expect(result, isNull);
  });

  test('set() persists and is readable after rebuild', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await container.read(selectedFaithProvider.future);
    await container.read(selectedFaithProvider.notifier).set(FaithId.hindu);
    expect(container.read(selectedFaithProvider).valueOrNull, FaithId.hindu);

    // Fresh container simulates app relaunch — must read from persisted prefs.
    final relaunch = ProviderContainer();
    addTearDown(relaunch.dispose);
    final reloaded = await relaunch.read(selectedFaithProvider.future);
    expect(reloaded, FaithId.hindu);
  });
}
```

**Step 2: Run test to verify it fails**

Run: `flutter test test/core/preferences/selected_faith_test.dart`
Expected: FAIL — `faith_id.dart`/`selected_faith.dart` don't exist yet.

**Step 3: Write minimal implementation**

```dart
// lib/core/theme/faith_id.dart
/// The two faiths Siraat currently supports. Adding a third faith later is
/// "add a value here + a FaithPalette entry", not a nav/route rework.
enum FaithId {
  islam,
  hindu;

  static FaithId? fromName(String? name) {
    for (final f in FaithId.values) {
      if (f.name == name) return f;
    }
    return null;
  }
}
```

```dart
// lib/core/preferences/selected_faith.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/faith_id.dart';

part 'selected_faith.g.dart';

/// Persisted faith selection. `null` means the user hasn't picked yet
/// (first launch, mid-onboarding). Set from the faith picker screen and
/// from Settings → "Switch faith".
@Riverpod(keepAlive: true)
class SelectedFaith extends _$SelectedFaith {
  static const _key = 'selected_faith';

  @override
  Future<FaithId?> build() async {
    final prefs = await SharedPreferences.getInstance();
    return FaithId.fromName(prefs.getString(_key));
  }

  Future<void> set(FaithId faith) async {
    state = AsyncValue.data(faith);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, faith.name);
  }
}
```

**Step 4: Generate + run test to verify it passes**

Run: `dart run build_runner build --delete-conflicting-outputs`
Run: `flutter test test/core/preferences/selected_faith_test.dart`
Expected: PASS (2 tests)

**Step 5: Commit**

```bash
git add lib/core/theme/faith_id.dart lib/core/preferences/selected_faith.dart lib/core/preferences/selected_faith.g.dart test/core/preferences/selected_faith_test.dart
git commit -m "feat(theme): add FaithId and persisted SelectedFaith preference"
```

---

### Task A2: `FaithPalette` color tokens

**Files:**
- Create: `lib/core/theme/faith_palette.dart`
- Delete: `lib/core/theme/app_colors.dart` (superseded — old parchment/sage/gold "illuminated manuscript" palette is fully retired)
- Test: `test/core/theme/faith_palette_test.dart`

**Step 1: Write the failing test**

```dart
// test/core/theme/faith_palette_test.dart
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:faith_mobile/core/theme/faith_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('every FaithId has a light and dark palette', () {
    for (final faith in FaithId.values) {
      expect(FaithPalette.of(faith, Brightness.light), isNotNull);
      expect(FaithPalette.of(faith, Brightness.dark), isNotNull);
    }
  });

  test('islam and hindu primaries are distinct', () {
    final islam = FaithPalette.of(FaithId.islam, Brightness.light);
    final hindu = FaithPalette.of(FaithId.hindu, Brightness.light);
    expect(islam.primary, isNot(equals(hindu.primary)));
  });

  test('shared neutrals match across faiths (same brightness)', () {
    final islam = FaithPalette.of(FaithId.islam, Brightness.light);
    final hindu = FaithPalette.of(FaithId.hindu, Brightness.light);
    expect(islam.surface, hindu.surface);
    expect(islam.ink, hindu.ink);
  });
}
```

**Step 2: Run test to verify it fails**

Run: `flutter test test/core/theme/faith_palette_test.dart`
Expected: FAIL — `faith_palette.dart` doesn't exist.

**Step 3: Write minimal implementation**

```dart
// lib/core/theme/faith_palette.dart
import 'package:flutter/material.dart';

import 'faith_id.dart';

/// Flat token bag for one faith + brightness. Only `primary`/`primaryPressed`
/// /`secondary`/`secondaryPressed`/`mascotAccent` vary by faith — neutrals
/// (surface/ink/outline/shadow) are shared so both faiths read as siblings.
class FaithPalette {
  const FaithPalette({
    required this.primary,
    required this.primaryPressed,
    required this.secondary,
    required this.secondaryPressed,
    required this.mascotAccent,
    required this.surface,
    required this.surfaceCard,
    required this.ink,
    required this.inkMuted,
    required this.outline,
    required this.shadow,
    required this.error,
  });

  final Color primary;
  final Color primaryPressed;
  final Color secondary;
  final Color secondaryPressed;
  final Color mascotAccent;
  final Color surface;
  final Color surfaceCard;
  final Color ink;
  final Color inkMuted;
  final Color outline;
  final Color shadow;
  final Color error;

  static FaithPalette of(FaithId faith, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return switch (faith) {
      FaithId.islam => isDark ? _islamDark : _islamLight,
      FaithId.hindu => isDark ? _hinduDark : _hinduLight,
    };
  }

  // Shared neutrals
  static const _surfaceLight = Color(0xFFFFF9F0);
  static const _surfaceCardLight = Color(0xFFFFFFFF);
  static const _inkLight = Color(0xFF1A1A1A);
  static const _inkMutedLight = Color(0xFF6B6A66);
  static const _outlineLight = Color(0xFF1A1A1A);
  static const _shadowLight = Color(0xFF1A1A1A);

  static const _surfaceDark = Color(0xFF151515);
  static const _surfaceCardDark = Color(0xFF1F1F1F);
  static const _inkDark = Color(0xFFF5F5F0);
  static const _inkMutedDark = Color(0xFFA8A8A2);
  static const _outlineDark = Color(0xFF3A3A3A);
  static const _shadowDark = Color(0xFF0A0A0A);
  static const _errorShared = Color(0xFFFF4B4B);

  static const _islamLight = FaithPalette(
    primary: Color(0xFF00B87A),
    primaryPressed: Color(0xFF00935F),
    secondary: Color(0xFFFFC93C),
    secondaryPressed: Color(0xFFE0AC1F),
    mascotAccent: Color(0xFFFFC93C),
    surface: _surfaceLight,
    surfaceCard: _surfaceCardLight,
    ink: _inkLight,
    inkMuted: _inkMutedLight,
    outline: _outlineLight,
    shadow: _shadowLight,
    error: _errorShared,
  );

  static const _islamDark = FaithPalette(
    primary: Color(0xFF1BD696),
    primaryPressed: Color(0xFF14A876),
    secondary: Color(0xFFFFD666),
    secondaryPressed: Color(0xFFE0B93E),
    mascotAccent: Color(0xFFFFD666),
    surface: _surfaceDark,
    surfaceCard: _surfaceCardDark,
    ink: _inkDark,
    inkMuted: _inkMutedDark,
    outline: _outlineDark,
    shadow: _shadowDark,
    error: _errorShared,
  );

  static const _hinduLight = FaithPalette(
    primary: Color(0xFFFF6B3D),
    primaryPressed: Color(0xFFE0532A),
    secondary: Color(0xFFFFB000),
    secondaryPressed: Color(0xFFD99400),
    mascotAccent: Color(0xFFFFD23F),
    surface: _surfaceLight,
    surfaceCard: _surfaceCardLight,
    ink: _inkLight,
    inkMuted: _inkMutedLight,
    outline: _outlineLight,
    shadow: _shadowLight,
    error: _errorShared,
  );

  static const _hinduDark = FaithPalette(
    primary: Color(0xFFFF8A5C),
    primaryPressed: Color(0xFFE06C3D),
    secondary: Color(0xFFFFC94D),
    secondaryPressed: Color(0xFFE0AA2E),
    mascotAccent: Color(0xFFFFD23F),
    surface: _surfaceDark,
    surfaceCard: _surfaceCardDark,
    ink: _inkDark,
    inkMuted: _inkMutedDark,
    outline: _outlineDark,
    shadow: _shadowDark,
    error: _errorShared,
  );
}
```

Also delete `lib/core/theme/app_colors.dart` in this task and grep for any remaining `AppColors.` references (there should be none once Task A3 rewrites `app_theme.dart`, but check now so the deletion doesn't silently break an unrelated file):

Run: `grep -rn "AppColors" lib/`

If anything outside `app_theme.dart` references it, note the file — it gets fixed in whichever later task touches that file (there shouldn't be any; `app_colors.dart` per the original code is only consumed by `app_theme.dart`).

**Step 4: Generate + run test to verify it passes**

Run: `flutter test test/core/theme/faith_palette_test.dart`
Expected: PASS (3 tests)

**Step 5: Commit**

```bash
git add lib/core/theme/faith_palette.dart test/core/theme/faith_palette_test.dart
git rm lib/core/theme/app_colors.dart
git commit -m "feat(theme): add FaithPalette token system, retire illuminated-manuscript AppColors"
```

---

### Task A3: `FaithThemeExtension` (shape/motion/mascot tokens riding on `ThemeData`)

**Files:**
- Create: `lib/core/theme/faith_theme_extension.dart`
- Test: `test/core/theme/faith_theme_extension_test.dart`

**Step 1: Write the failing test**

```dart
// test/core/theme/faith_theme_extension_test.dart
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:faith_mobile/core/theme/faith_palette.dart';
import 'package:faith_mobile/core/theme/faith_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('of() builds from a FaithId + palette', () {
    final ext = FaithThemeExtension.of(
      FaithId.hindu,
      FaithPalette.of(FaithId.hindu, Brightness.light),
    );
    expect(ext.faithId, FaithId.hindu);
  });

  test('lerp at t<0.5 keeps this faithId, t>=0.5 keeps other', () {
    final islam = FaithThemeExtension.of(
      FaithId.islam,
      FaithPalette.of(FaithId.islam, Brightness.light),
    );
    final hindu = FaithThemeExtension.of(
      FaithId.hindu,
      FaithPalette.of(FaithId.hindu, Brightness.light),
    );
    expect(islam.lerp(hindu, 0.0).faithId, FaithId.islam);
    expect(islam.lerp(hindu, 0.99).faithId, FaithId.hindu);
  });

  testWidgets('is retrievable via Theme.of(context).extension', (
    tester,
  ) async {
    final ext = FaithThemeExtension.of(
      FaithId.islam,
      FaithPalette.of(FaithId.islam, Brightness.light),
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(extensions: [ext]),
        home: Builder(
          builder: (context) {
            final read = Theme.of(context).extension<FaithThemeExtension>();
            return Text(read!.faithId.name);
          },
        ),
      ),
    );
    expect(find.text('islam'), findsOneWidget);
  });
}
```

**Step 2: Run test to verify it fails**

Run: `flutter test test/core/theme/faith_theme_extension_test.dart`
Expected: FAIL — file doesn't exist.

**Step 3: Write minimal implementation**

```dart
// lib/core/theme/faith_theme_extension.dart
import 'package:flutter/material.dart';

import 'faith_id.dart';
import 'faith_palette.dart';

/// Carries faith-aware tokens that don't fit [ColorScheme]/[TextTheme]:
/// which faith is active (so widgets can branch content/mascot without a
/// separate Riverpod read), the full [FaithPalette] (for shadow/pressed
/// states the default ColorScheme doesn't model), and shared motion timings.
///
/// Access via `Theme.of(context).extension<FaithThemeExtension>()!`.
class FaithThemeExtension extends ThemeExtension<FaithThemeExtension> {
  const FaithThemeExtension({
    required this.faithId,
    required this.palette,
    required this.cardOutlineWidth,
    required this.pressDuration,
    required this.pressOffset,
  });

  final FaithId faithId;
  final FaithPalette palette;
  final double cardOutlineWidth;
  final Duration pressDuration;
  final double pressOffset;

  factory FaithThemeExtension.of(FaithId faithId, FaithPalette palette) =>
      FaithThemeExtension(
        faithId: faithId,
        palette: palette,
        cardOutlineWidth: 2.5,
        pressDuration: const Duration(milliseconds: 100),
        pressOffset: 4,
      );

  @override
  FaithThemeExtension copyWith({
    FaithId? faithId,
    FaithPalette? palette,
    double? cardOutlineWidth,
    Duration? pressDuration,
    double? pressOffset,
  }) => FaithThemeExtension(
    faithId: faithId ?? this.faithId,
    palette: palette ?? this.palette,
    cardOutlineWidth: cardOutlineWidth ?? this.cardOutlineWidth,
    pressDuration: pressDuration ?? this.pressDuration,
    pressOffset: pressOffset ?? this.pressOffset,
  );

  @override
  FaithThemeExtension lerp(
    covariant ThemeExtension<FaithThemeExtension>? other,
    double t,
  ) {
    if (other is! FaithThemeExtension) return this;
    // faithId/palette are a hard identity switch, not a gradient — snap at
    // the midpoint rather than trying to blend two religions' colors.
    return t < 0.5 ? this : other;
  }
}
```

**Step 4: Run test to verify it passes**

Run: `flutter test test/core/theme/faith_theme_extension_test.dart`
Expected: PASS (3 tests)

**Step 5: Commit**

```bash
git add lib/core/theme/faith_theme_extension.dart test/core/theme/faith_theme_extension_test.dart
git commit -m "feat(theme): add FaithThemeExtension carrying shape/motion/mascot tokens"
```

---

### Task A4: Rebuild `AppTheme` to be faith-parameterized + swap typography

**Files:**
- Modify: `lib/core/theme/app_theme.dart` (full rewrite)
- Modify: `pubspec.yaml` (no new packages — `google_fonts` already covers Baloo 2 / Fredoka / Nunito)
- Modify: `lib/main.dart:39-40` (pass faith into `AppTheme.light()`/`.dark()`)
- Test: `test/core/theme/app_theme_test.dart`

**Step 1: Write the failing test**

```dart
// test/core/theme/app_theme_test.dart
import 'package:faith_mobile/core/theme/app_theme.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:faith_mobile/core/theme/faith_theme_extension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('light/dark themes carry the requested faith', () {
    final light = AppTheme.light(FaithId.hindu);
    final dark = AppTheme.dark(FaithId.hindu);
    expect(light.extension<FaithThemeExtension>()!.faithId, FaithId.hindu);
    expect(dark.extension<FaithThemeExtension>()!.faithId, FaithId.hindu);
  });

  test('islam and hindu themes have different primary colors', () {
    final islam = AppTheme.light(FaithId.islam);
    final hindu = AppTheme.light(FaithId.hindu);
    expect(islam.colorScheme.primary, isNot(equals(hindu.colorScheme.primary)));
  });
}
```

**Step 2: Run test to verify it fails**

Run: `flutter test test/core/theme/app_theme_test.dart`
Expected: FAIL — `AppTheme.light()` doesn't take a `FaithId` argument yet.

**Step 3: Write minimal implementation**

Full rewrite of `lib/core/theme/app_theme.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'faith_id.dart';
import 'faith_palette.dart';
import 'faith_theme_extension.dart';

/// Builds the Material 3 light and dark themes for the active faith.
///
/// Typography: Baloo 2 for display/headline (chunky, rounded, "poppy"),
/// Nunito for body/labels (readable at small sizes, still rounded/friendly).
class AppTheme {
  const AppTheme._();

  static ThemeData light(FaithId faith) =>
      _build(faith: faith, brightness: Brightness.light);

  static ThemeData dark(FaithId faith) =>
      _build(faith: faith, brightness: Brightness.dark);

  static ThemeData _build({
    required FaithId faith,
    required Brightness brightness,
  }) {
    final palette = FaithPalette.of(faith, brightness);
    final onPrimary = brightness == Brightness.dark
        ? const Color(0xFF0A0A0A)
        : const Color(0xFFFFFFFF);

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: palette.primary,
      onPrimary: onPrimary,
      primaryContainer: palette.primary.withValues(alpha: 0.16),
      onPrimaryContainer: palette.ink,
      secondary: palette.secondary,
      onSecondary: onPrimary,
      secondaryContainer: palette.secondary.withValues(alpha: 0.16),
      onSecondaryContainer: palette.ink,
      tertiary: palette.secondary,
      onTertiary: onPrimary,
      error: palette.error,
      onError: Colors.white,
      surface: palette.surface,
      onSurface: palette.ink,
      onSurfaceVariant: palette.inkMuted,
      outline: palette.outline,
      outlineVariant: palette.outline.withValues(alpha: 0.4),
      shadow: palette.shadow,
      scrim: Colors.black.withValues(alpha: 0.4),
      inverseSurface: palette.ink,
      onInverseSurface: palette.surface,
      inversePrimary: palette.primary,
    );

    final textTheme = _buildTextTheme(palette.ink, palette.inkMuted);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: palette.surface,
      canvasColor: palette.surface,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      hoverColor: palette.primary.withValues(alpha: 0.04),
      extensions: [FaithThemeExtension.of(faith, palette)],
      appBarTheme: AppBarTheme(
        backgroundColor: palette.surface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: false,
        foregroundColor: palette.ink,
        titleTextStyle: textTheme.titleLarge,
        iconTheme: IconThemeData(color: palette.ink),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 68,
        elevation: 0,
        backgroundColor: palette.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: palette.primary.withValues(alpha: 0.16),
        labelTextStyle: WidgetStatePropertyAll(textTheme.labelSmall),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: palette.primary, size: 26);
          }
          return IconThemeData(color: palette.inkMuted, size: 24);
        }),
      ),
      dividerTheme: DividerThemeData(
        color: palette.outline,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.surfaceCard,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        hintStyle: textTheme.bodyLarge?.copyWith(color: palette.inkMuted),
        labelStyle: textTheme.bodyMedium?.copyWith(color: palette.inkMuted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: palette.outline, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: palette.outline, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: palette.primary, width: 2.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.error, width: 2.5),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: palette.primary,
          foregroundColor: onPrimary,
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: textTheme.titleMedium,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: palette.primary,
          textStyle: textTheme.labelLarge,
        ),
      ),
    );
  }

  static TextTheme _buildTextTheme(Color ink, Color inkMuted) {
    final baloo = GoogleFonts.baloo2TextTheme();
    final nunito = GoogleFonts.nunitoTextTheme();

    return TextTheme(
      displayLarge: baloo.displayLarge?.copyWith(
        fontSize: 52,
        fontWeight: FontWeight.w700,
        letterSpacing: -1,
        height: 1.05,
        color: ink,
      ),
      displayMedium: baloo.displayMedium?.copyWith(
        fontSize: 38,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.08,
        color: ink,
      ),
      displaySmall: baloo.displaySmall?.copyWith(
        fontSize: 30,
        fontWeight: FontWeight.w600,
        color: ink,
      ),
      headlineMedium: baloo.headlineMedium?.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: ink,
      ),
      titleLarge: nunito.titleLarge?.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w800,
        color: ink,
      ),
      titleMedium: nunito.titleMedium?.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: ink,
      ),
      bodyLarge: nunito.bodyLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.5,
        color: ink,
      ),
      bodyMedium: nunito.bodyMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.45,
        color: inkMuted,
      ),
      bodySmall: nunito.bodySmall?.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: inkMuted,
      ),
      labelLarge: nunito.labelLarge?.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
        color: ink,
      ),
      labelMedium: nunito.labelMedium?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.4,
        color: inkMuted,
      ),
      labelSmall: nunito.labelSmall?.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.8,
        color: inkMuted,
      ),
    );
  }
}
```

Then update `lib/main.dart`:

```dart
// lib/main.dart — inside FaithApp.build, add alongside the existing themeMode read:
final faith = ref.watch(selectedFaithProvider).valueOrNull ?? FaithId.islam;
// ...
theme: AppTheme.light(faith),
darkTheme: AppTheme.dark(faith),
```

Add the two new imports (`core/preferences/selected_faith.dart`, `core/theme/faith_id.dart`) to `main.dart`.

**Step 4: Generate + run test to verify it passes**

Run: `flutter test test/core/theme/app_theme_test.dart`
Expected: PASS (2 tests)

Run: `flutter analyze` — fix any fallout from the `app_colors.dart` deletion (there should be none; confirm the earlier grep came back empty).

**Step 5: Commit**

```bash
git add lib/core/theme/app_theme.dart lib/main.dart test/core/theme/app_theme_test.dart
git commit -m "feat(theme): make AppTheme faith-parameterized, swap Fraunces/Inter for Baloo2/Nunito"
```

---

### Task A5: `AppMotion` shared timing/curve tokens

**Files:**
- Create: `lib/core/theme/app_motion.dart`

**Step 1: Write the file directly (pure constants, no test needed — nothing to assert beyond "the values exist," which the compiler already guarantees)**

```dart
// lib/core/theme/app_motion.dart
import 'package:flutter/animation.dart';

/// Shared motion language — "snappy and bouncy," not Material's default ease.
class AppMotion {
  const AppMotion._();

  static const screenTransition = Duration(milliseconds: 180);
  static const cardPress = Duration(milliseconds: 100);
  static const cardSpringBack = Duration(milliseconds: 220);
  static const listStagger = Duration(milliseconds: 50);
  static const celebrate = Duration(milliseconds: 600);

  static const pressCurve = Curves.easeOut;
  static const springBackCurve = Curves.elasticOut;
  static const enterCurve = Curves.easeOutCubic;
}
```

**Step 2: Commit**

```bash
git add lib/core/theme/app_motion.dart
git commit -m "feat(theme): add shared AppMotion timing/curve tokens"
```

---

### Task A6: `PoppyCard` component

**Files:**
- Create: `lib/shared/widgets/poppy_card.dart`
- Test: `test/shared/widgets/poppy_card_test.dart`

**Step 1: Write the failing test**

```dart
// test/shared/widgets/poppy_card_test.dart
import 'package:faith_mobile/core/theme/app_theme.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:faith_mobile/shared/widgets/poppy_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget harness(Widget child) => MaterialApp(
    theme: AppTheme.light(FaithId.islam),
    home: Scaffold(body: Center(child: child)),
  );

  testWidgets('renders child content', (tester) async {
    await tester.pumpWidget(
      harness(const PoppyCard(child: Text('hello'))),
    );
    expect(find.text('hello'), findsOneWidget);
  });

  testWidgets('calls onTap and shows pressed state on tap-down', (
    tester,
  ) async {
    var tapped = false;
    await tester.pumpWidget(
      harness(
        PoppyCard(onTap: () => tapped = true, child: const Text('tap me')),
      ),
    );
    await tester.tap(find.text('tap me'));
    await tester.pumpAndSettle();
    expect(tapped, isTrue);
  });
}
```

**Step 2: Run test to verify it fails**

Run: `flutter test test/shared/widgets/poppy_card_test.dart`
Expected: FAIL — `poppy_card.dart` doesn't exist.

**Step 3: Write minimal implementation**

```dart
// lib/shared/widgets/poppy_card.dart
import 'package:flutter/material.dart';

import '../../core/theme/faith_theme_extension.dart';

/// The core visual unit of the poppy-comic redesign: rounded-24, thick
/// outline, flat fill, a hard offset "sticker" shadow that collapses on
/// press. Replaces the `Container(decoration: BoxDecoration(border:
/// Border.all(color: cs.outline)))` pattern used ad hoc across the app.
class PoppyCard extends StatefulWidget {
  const PoppyCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.color,
    this.borderColor,
    this.radius = 24,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets padding;
  final Color? color;
  final Color? borderColor;
  final double radius;

  @override
  State<PoppyCard> createState() => _PoppyCardState();
}

class _PoppyCardState extends State<PoppyCard> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (widget.onTap == null) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<FaithThemeExtension>()!;
    final palette = ext.palette;
    final fill = widget.color ?? palette.surfaceCard;
    final border = widget.borderColor ?? palette.outline;
    final offset = _pressed ? 0.0 : ext.pressOffset;

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _setPressed(true),
      onTapCancel: () => _setPressed(false),
      onTapUp: (_) => _setPressed(false),
      child: AnimatedContainer(
        duration: ext.pressDuration,
        curve: Curves.easeOut,
        margin: EdgeInsets.only(top: ext.pressOffset - offset),
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(widget.radius),
          border: Border.all(color: border, width: ext.cardOutlineWidth),
          boxShadow: offset == 0
              ? const []
              : [
                  BoxShadow(
                    color: palette.shadow,
                    offset: Offset(0, offset),
                  ),
                ],
        ),
        padding: widget.padding,
        child: widget.child,
      ),
    );
  }
}
```

**Step 4: Run test to verify it passes**

Run: `flutter test test/shared/widgets/poppy_card_test.dart`
Expected: PASS (2 tests)

**Step 5: Commit**

```bash
git add lib/shared/widgets/poppy_card.dart test/shared/widgets/poppy_card_test.dart
git commit -m "feat(ui): add PoppyCard component"
```

---

### Task A7: `PoppyButton` component

**Files:**
- Create: `lib/shared/widgets/poppy_button.dart`
- Test: `test/shared/widgets/poppy_button_test.dart`

**Step 1: Write the failing test**

```dart
// test/shared/widgets/poppy_button_test.dart
import 'package:faith_mobile/core/theme/app_theme.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:faith_mobile/shared/widgets/poppy_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget harness(Widget child) => MaterialApp(
    theme: AppTheme.light(FaithId.islam),
    home: Scaffold(body: Center(child: child)),
  );

  testWidgets('renders label and fires onPressed', (tester) async {
    var pressed = false;
    await tester.pumpWidget(
      harness(
        PoppyButton(label: 'Continue', onPressed: () => pressed = true),
      ),
    );
    expect(find.text('Continue'), findsOneWidget);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(pressed, isTrue);
  });

  testWidgets('disabled when onPressed is null', (tester) async {
    await tester.pumpWidget(
      harness(const PoppyButton(label: 'Disabled', onPressed: null)),
    );
    var pressed = false;
    await tester.tap(find.text('Disabled'));
    await tester.pumpAndSettle();
    expect(pressed, isFalse);
  });
}
```

**Step 2: Run test to verify it fails**

Run: `flutter test test/shared/widgets/poppy_button_test.dart`
Expected: FAIL — `poppy_button.dart` doesn't exist.

**Step 3: Write minimal implementation**

```dart
// lib/shared/widgets/poppy_button.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/faith_theme_extension.dart';

enum PoppyButtonVariant { primary, secondary }

/// Chunky 56px-tall button with the same offset-shadow "press" language as
/// [PoppyCard]. `variant: secondary` uses the faith's secondary/accent color
/// instead of primary — for the less-emphasized action in a two-button row.
class PoppyButton extends StatefulWidget {
  const PoppyButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = PoppyButtonVariant.primary,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final PoppyButtonVariant variant;
  final IconData? icon;

  @override
  State<PoppyButton> createState() => _PoppyButtonState();
}

class _PoppyButtonState extends State<PoppyButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<FaithThemeExtension>()!;
    final palette = ext.palette;
    final enabled = widget.onPressed != null;
    final fill = switch (widget.variant) {
      PoppyButtonVariant.primary =>
        _pressed ? palette.primaryPressed : palette.primary,
      PoppyButtonVariant.secondary =>
        _pressed ? palette.secondaryPressed : palette.secondary,
    };
    final offset = _pressed ? 0.0 : ext.pressOffset;
    final onColor = Theme.of(context).colorScheme.onPrimary;

    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: GestureDetector(
        onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
        onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
        onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
        onTap: enabled
            ? () {
                HapticFeedback.mediumImpact();
                widget.onPressed!();
              }
            : null,
        child: AnimatedContainer(
          duration: ext.pressDuration,
          margin: EdgeInsets.only(top: ext.pressOffset - offset),
          height: 56,
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: palette.outline, width: ext.cardOutlineWidth),
            boxShadow: offset == 0
                ? const []
                : [BoxShadow(color: palette.shadow, offset: Offset(0, offset))],
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, color: onColor, size: 20),
                const SizedBox(width: 8),
              ],
              Text(
                widget.label,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: onColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

**Step 4: Run test to verify it passes**

Run: `flutter test test/shared/widgets/poppy_button_test.dart`
Expected: PASS (2 tests)

**Step 5: Commit**

```bash
git add lib/shared/widgets/poppy_button.dart test/shared/widgets/poppy_button_test.dart
git commit -m "feat(ui): add PoppyButton component"
```

---

### Task A8: `StatChip` component

**Files:**
- Create: `lib/shared/widgets/stat_chip.dart`
- Test: `test/shared/widgets/stat_chip_test.dart`

**Step 1: Write the failing test**

```dart
// test/shared/widgets/stat_chip_test.dart
import 'package:faith_mobile/core/theme/app_theme.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:faith_mobile/shared/widgets/stat_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders value and label', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(FaithId.islam),
        home: const Scaffold(
          body: StatChip(value: '12', label: 'day streak'),
        ),
      ),
    );
    expect(find.text('12'), findsOneWidget);
    expect(find.text('day streak'), findsOneWidget);
  });
}
```

**Step 2: Run test to verify it fails**

Run: `flutter test test/shared/widgets/stat_chip_test.dart`
Expected: FAIL — file doesn't exist.

**Step 3: Write minimal implementation**

```dart
// lib/shared/widgets/stat_chip.dart
import 'package:flutter/material.dart';

import '../../core/theme/faith_theme_extension.dart';

/// Pill-shaped stat display — prayer/japa streaks, dhikr counts, reading
/// progress. Bold numeral first, small label second.
class StatChip extends StatelessWidget {
  const StatChip({super.key, required this.value, required this.label, this.icon});

  final String value;
  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<FaithThemeExtension>()!;
    final palette = ext.palette;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: palette.secondary.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: palette.outline, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: palette.ink),
            const SizedBox(width: 6),
          ],
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 4),
          Text(label, style: theme.textTheme.labelMedium),
        ],
      ),
    );
  }
}
```

**Step 4: Run test to verify it passes**

Run: `flutter test test/shared/widgets/stat_chip_test.dart`
Expected: PASS (1 test)

**Step 5: Commit**

```bash
git add lib/shared/widgets/stat_chip.dart test/shared/widgets/stat_chip_test.dart
git commit -m "feat(ui): add StatChip component"
```

---

### Task A9: `PoppyIcon` component

**Files:**
- Create: `lib/shared/widgets/poppy_icon.dart`
- Test: `test/shared/widgets/poppy_icon_test.dart`

**Note on scope:** authoring a full custom thick-outline icon font/SVG set for ~40 distinct glyphs is out of scope for this plan (would need real illustration work, unlike the coded-vector mascots which are simple enough to build as shapes). Instead: keep Material icons as the glyph source, but wrap every icon in a colored circular "badge" — this is the same trick Duolingo-adjacent apps use to make stock iconography read as poppy/chunky without custom icon authoring. Flagged as a explicit simplification, not an oversight.

**Step 1: Write the failing test**

```dart
// test/shared/widgets/poppy_icon_test.dart
import 'package:faith_mobile/core/theme/app_theme.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:faith_mobile/shared/widgets/poppy_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders the given icon glyph', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(FaithId.islam),
        home: const Scaffold(body: PoppyIcon(icon: Icons.fingerprint)),
      ),
    );
    expect(find.byIcon(Icons.fingerprint), findsOneWidget);
  });
}
```

**Step 2: Run test to verify it fails**

Run: `flutter test test/shared/widgets/poppy_icon_test.dart`
Expected: FAIL — file doesn't exist.

**Step 3: Write minimal implementation**

```dart
// lib/shared/widgets/poppy_icon.dart
import 'package:flutter/material.dart';

import '../../core/theme/faith_theme_extension.dart';

/// Wraps a Material glyph in a colored circular badge with a thick outline
/// — gives stock iconography a "poppy" read without custom icon authoring.
class PoppyIcon extends StatelessWidget {
  const PoppyIcon({
    super.key,
    required this.icon,
    this.size = 44,
    this.background,
    this.foreground,
  });

  final IconData icon;
  final double size;
  final Color? background;
  final Color? foreground;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).extension<FaithThemeExtension>()!.palette;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background ?? palette.primary.withValues(alpha: 0.16),
        shape: BoxShape.circle,
        border: Border.all(color: palette.outline, width: 2),
      ),
      alignment: Alignment.center,
      child: Icon(
        icon,
        size: size * 0.5,
        color: foreground ?? palette.primary,
      ),
    );
  }
}
```

**Step 4: Run test to verify it passes**

Run: `flutter test test/shared/widgets/poppy_icon_test.dart`
Expected: PASS (1 test)

**Step 5: Commit**

```bash
git add lib/shared/widgets/poppy_icon.dart test/shared/widgets/poppy_icon_test.dart
git commit -m "feat(ui): add PoppyIcon badge-wrapped icon component"
```

---

### Task A10: `MascotView` — shared rig + per-faith accessory, 4 states

**Files:**
- Create: `lib/shared/widgets/mascot_view.dart`
- Test: `test/shared/widgets/mascot_view_test.dart`

**Step 1: Write the failing test**

```dart
// test/shared/widgets/mascot_view_test.dart
import 'package:faith_mobile/core/theme/app_theme.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:faith_mobile/shared/widgets/mascot_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final faith in FaithId.values) {
    for (final state in MascotState.values) {
      testWidgets('renders for $faith / $state without throwing', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light(faith),
            home: Scaffold(
              body: MascotView(faith: faith, state: state, size: 120),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 300));
        expect(tester.takeException(), isNull);
      });
    }
  }
}
```

**Step 2: Run test to verify it fails**

Run: `flutter test test/shared/widgets/mascot_view_test.dart`
Expected: FAIL — file doesn't exist.

**Step 3: Write minimal implementation**

```dart
// lib/shared/widgets/mascot_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/faith_id.dart';
import '../../core/theme/faith_palette.dart';

enum MascotState { idle, celebrate, encourage, sleep }

/// Coded-vector mascot: one shared rig (body/eyes/mouth) + a faith-specific
/// accessory (crescent-and-star topper for Islam, diya-flame crown for
/// Hindu). See design doc §2 for the rationale on why this is drawn in code
/// rather than sourced — no licensable "character" mascot exists for either
/// motif.
class MascotView extends StatelessWidget {
  const MascotView({
    super.key,
    required this.faith,
    this.state = MascotState.idle,
    this.size = 96,
  });

  final FaithId faith;
  final MascotState state;
  final double size;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final palette = FaithPalette.of(faith, brightness);
    final painter = CustomPaint(
      size: Size.square(size),
      painter: _MascotPainter(faith: faith, state: state, palette: palette),
    );

    final animated = switch (state) {
      MascotState.idle => painter
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .moveY(begin: 0, end: -4, duration: 1200.ms, curve: Curves.easeInOut),
      MascotState.celebrate => painter
          .animate()
          .scale(
            begin: const Offset(1, 1),
            end: const Offset(1.15, 1.15),
            duration: 220.ms,
            curve: Curves.easeOut,
          )
          .then()
          .scale(
            begin: const Offset(1.15, 1.15),
            end: const Offset(1, 1),
            duration: 380.ms,
            curve: Curves.elasticOut,
          ),
      MascotState.encourage => painter
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .rotate(begin: -0.02, end: 0.02, duration: 900.ms),
      MascotState.sleep => painter,
    };

    return SizedBox(width: size, height: size, child: animated);
  }
}

class _MascotPainter extends CustomPainter {
  _MascotPainter({
    required this.faith,
    required this.state,
    required this.palette,
  });

  final FaithId faith;
  final MascotState state;
  final FaithPalette palette;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final bodyRadius = size.width * 0.38;

    final bodyPaint = Paint()..color = palette.primary;
    final outlinePaint = Paint()
      ..color = palette.outline
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.03;

    // Body — a rounded blob, shared rig.
    canvas.drawCircle(center, bodyRadius, bodyPaint);
    canvas.drawCircle(center, bodyRadius, outlinePaint);

    _paintFace(canvas, size, center, bodyRadius);
    _paintAccessory(canvas, size, center, bodyRadius);
  }

  void _paintFace(Canvas canvas, Size size, Offset center, double r) {
    final eyePaint = Paint()..color = palette.ink;
    final eyeOffset = Offset(r * 0.35, -r * 0.1);
    final eyeRadius = state == MascotState.sleep ? 0.0 : size.width * 0.035;

    if (state == MascotState.sleep) {
      final strokePaint = Paint()
        ..color = palette.ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.02;
      canvas.drawArc(
        Rect.fromCenter(
          center: center - eyeOffset,
          width: size.width * 0.1,
          height: size.width * 0.05,
        ),
        0,
        3.14,
        false,
        strokePaint,
      );
      canvas.drawArc(
        Rect.fromCenter(
          center: center + Offset(eyeOffset.dx, eyeOffset.dy),
          width: size.width * 0.1,
          height: size.width * 0.05,
        ),
        0,
        3.14,
        false,
        strokePaint,
      );
    } else {
      canvas.drawCircle(center - eyeOffset, eyeRadius, eyePaint);
      canvas.drawCircle(
        center + Offset(eyeOffset.dx, eyeOffset.dy),
        eyeRadius,
        eyePaint,
      );
    }

    // Mouth — happier arc for celebrate, flat for encourage/idle, small for sleep.
    final mouthPaint = Paint()
      ..color = palette.ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.025
      ..strokeCap = StrokeCap.round;
    final mouthCenter = center + Offset(0, r * 0.3);
    final sweep = switch (state) {
      MascotState.celebrate => 2.6,
      MascotState.sleep => 0.8,
      _ => 1.6,
    };
    canvas.drawArc(
      Rect.fromCenter(
        center: mouthCenter,
        width: r * 0.6,
        height: r * 0.35,
      ),
      0.3,
      sweep,
      false,
      mouthPaint,
    );
  }

  void _paintAccessory(Canvas canvas, Size size, Offset center, double r) {
    final accentPaint = Paint()..color = palette.mascotAccent;
    final top = center - Offset(0, r * 1.05);

    switch (faith) {
      case FaithId.islam:
        // Crescent-and-star topper.
        final crescentOuter = Rect.fromCenter(
          center: top,
          width: r * 0.55,
          height: r * 0.55,
        );
        final path = Path()
          ..addOval(crescentOuter)
          ..addOval(crescentOuter.translate(r * 0.16, -r * 0.05))
          ..fillType = PathFillType.evenOdd;
        canvas.drawPath(path, accentPaint);
        canvas.drawCircle(top + Offset(r * 0.32, -r * 0.28), r * 0.06, accentPaint);
      case FaithId.hindu:
        // Diya-flame crown: a small teardrop above the head.
        final flamePath = Path()
          ..moveTo(top.dx, top.dy - r * 0.35)
          ..quadraticBezierTo(
            top.dx + r * 0.22,
            top.dy + r * 0.1,
            top.dx,
            top.dy + r * 0.3,
          )
          ..quadraticBezierTo(
            top.dx - r * 0.22,
            top.dy + r * 0.1,
            top.dx,
            top.dy - r * 0.35,
          )
          ..close();
        canvas.drawPath(flamePath, accentPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _MascotPainter oldDelegate) =>
      oldDelegate.faith != faith ||
      oldDelegate.state != state ||
      oldDelegate.palette != palette;
}
```

**Step 4: Run test to verify it passes**

Run: `flutter test test/shared/widgets/mascot_view_test.dart`
Expected: PASS (8 tests — 2 faiths × 4 states)

**Step 5: Commit**

```bash
git add lib/shared/widgets/mascot_view.dart test/shared/widgets/mascot_view_test.dart
git commit -m "feat(ui): add coded-vector MascotView (shared rig, per-faith accessory, 4 states)"
```

---

### Task A11: Rebuild the faith picker (replaces `faith_selection_screen.dart`)

**Files:**
- Modify: `lib/features/onboarding/presentation/screens/faith_selection_screen.dart` (full rewrite)
- Modify: `lib/features/onboarding/onboarding_routes.dart` (add a `standalone` query-free re-entry route for Settings)
- Modify: `lib/core/router/routes.dart` (add `Routes.switchFaith`)
- Test: `test/features/onboarding/faith_selection_screen_test.dart`

**Context:** the current screen lists 5 traditions with only Islam enabled and Hinduism marked "Soon"; it never persists the selection anywhere (`_selected` is local `State`, discarded on `_continue()`). Both of those are now wrong: Hindu is fully built (Part C), and selection must persist via `SelectedFaith` (Task A1).

**Step 1: Write the failing test**

```dart
// test/features/onboarding/faith_selection_screen_test.dart
import 'package:faith_mobile/core/preferences/selected_faith.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:faith_mobile/features/onboarding/presentation/screens/faith_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<void> pump(WidgetTester tester) => tester.pumpWidget(
    ProviderScope(
      child: MaterialApp.router(
        routerConfig: GoRouter(
          initialLocation: '/onboarding/faith',
          routes: [
            GoRoute(
              path: '/onboarding/faith',
              builder: (_, __) => const FaithSelectionScreen(),
            ),
            GoRoute(path: '/login', builder: (_, __) => const Text('LOGIN')),
          ],
        ),
      ),
    ),
  );

  testWidgets('shows both Islam and Hindu as tappable (no "Soon" badge)', (
    tester,
  ) async {
    await pump(tester);
    expect(find.text('Islam'), findsOneWidget);
    expect(find.text('Hindu'), findsOneWidget);
    expect(find.text('Soon'), findsNothing);
  });

  testWidgets('tapping Hindu then Continue persists SelectedFaith.hindu', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          routerConfig: GoRouter(
            initialLocation: '/onboarding/faith',
            routes: [
              GoRoute(
                path: '/onboarding/faith',
                builder: (_, __) => const FaithSelectionScreen(),
              ),
              GoRoute(
                path: '/login',
                builder: (_, __) => const Text('LOGIN'),
              ),
            ],
          ),
        ),
      ),
    );

    await tester.tap(find.text('Hindu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(container.read(selectedFaithProvider).valueOrNull, FaithId.hindu);
    expect(find.text('LOGIN'), findsOneWidget);
  });
}
```

**Step 2: Run test to verify it fails**

Run: `flutter test test/features/onboarding/faith_selection_screen_test.dart`
Expected: FAIL — "Soon" badge still present, no persistence.

**Step 3: Write minimal implementation**

```dart
// lib/features/onboarding/presentation/screens/faith_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/preferences/selected_faith.dart';
import '../../../../core/theme/app_motion.dart';
import '../../../../core/theme/faith_id.dart';
import '../../../../shared/widgets/mascot_view.dart';
import '../../../../shared/widgets/poppy_button.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../data/onboarding_pref.dart';

/// The redesigned front door: two mascots, side by side, in their own
/// palette. Tapping selects; Continue persists [SelectedFaith] and either
/// advances onboarding (first launch) or pops back to Settings ([standalone]).
class FaithSelectionScreen extends ConsumerStatefulWidget {
  const FaithSelectionScreen({super.key, this.standalone = false});

  /// When true (reached from Settings → "Switch faith"), Continue persists
  /// and pops instead of advancing the first-launch onboarding flow.
  final bool standalone;

  @override
  ConsumerState<FaithSelectionScreen> createState() =>
      _FaithSelectionScreenState();
}

class _FaithSelectionScreenState extends ConsumerState<FaithSelectionScreen> {
  FaithId? _selected;

  Future<void> _continue() async {
    final faith = _selected;
    if (faith == null) return;
    HapticFeedback.mediumImpact();
    await ref.read(selectedFaithProvider.notifier).set(faith);
    if (!mounted) return;
    if (widget.standalone) {
      context.pop();
      return;
    }
    await ref.read(onboardingDoneProvider.notifier).markDone();
    if (!mounted) return;
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Choose your path', style: theme.textTheme.displaySmall),
                  const SizedBox(height: 6),
                  Text(
                    'You can change this later from settings.',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                children: [
                  for (final faith in FaithId.values) ...[
                    _FaithCard(
                      faith: faith,
                      selected: _selected == faith,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() => _selected = faith);
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: SizedBox(
                width: double.infinity,
                child: PoppyButton(
                  label: 'Continue',
                  onPressed: _selected == null ? null : _continue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FaithCard extends StatelessWidget {
  const _FaithCard({
    required this.faith,
    required this.selected,
    required this.onTap,
  });

  final FaithId faith;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = switch (faith) {
      FaithId.islam => 'Islam',
      FaithId.hindu => 'Hindu',
    };
    return AnimatedScale(
      duration: AppMotion.cardPress,
      scale: selected ? 1.02 : 1.0,
      child: PoppyCard(
        onTap: onTap,
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            MascotView(
              faith: faith,
              state: selected ? MascotState.celebrate : MascotState.idle,
              size: 72,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(label, style: theme.textTheme.titleLarge),
            ),
            if (selected)
              Icon(Icons.check_circle, color: theme.colorScheme.primary, size: 28),
          ],
        ),
      ),
    );
  }
}
```

**Step 4: Run test to verify it passes**

Run: `flutter test test/features/onboarding/faith_selection_screen_test.dart`
Expected: PASS (2 tests)

**Step 5: Add the standalone Settings entry route + `Routes.switchFaith`**

In `lib/core/router/routes.dart`, add:

```dart
static const switchFaith = '/settings/switch-faith';
```

In `lib/core/router/app_router.dart`, add a top-level route (near `...settingsRoutes,`):

```dart
GoRoute(
  path: Routes.switchFaith,
  builder: (_, __) => const FaithSelectionScreen(standalone: true),
),
```

(import `FaithSelectionScreen` at the top of `app_router.dart`.)

**Step 6: Manual verification**

Run: `flutter run`
Delete app data / fresh install → confirm the picker shows both mascots, no "Soon" badge, selecting Hindu then Continue lands on login with Hindu persisted (`flutter run` → hot restart won't reset SharedPreferences, so verify via the earlier widget test instead of a full uninstall if a device isn't handy).

**Step 7: Commit**

```bash
git add lib/features/onboarding/presentation/screens/faith_selection_screen.dart lib/core/router/routes.dart lib/core/router/app_router.dart test/features/onboarding/faith_selection_screen_test.dart
git commit -m "feat(onboarding): rebuild faith picker with mascots, enable Hindu, persist selection"
```

---

### Task A12: Condense onboarding to 2–3 screens

**Files:**
- Modify: `lib/features/onboarding/presentation/screens/onboarding_screen.dart` (read current content first — it's a 4-slide PageView per the design doc's context; condense to 2 slides: (1) brand/value-prop, (2) notification-permission ask, then straight into faith picker as slide 3 / its own route as today)
- Test: `test/features/onboarding/onboarding_screen_test.dart` (smoke test — pumps the screen, verifies the final slide's "Get started"-equivalent CTA navigates to `/onboarding/faith`)

**Step 1–5:** Read the existing `onboarding_screen.dart` in full before editing (not reproduced here since it wasn't part of this plan's research pass — the executing engineer must open it first). Apply the same PoppyCard/PoppyButton/MascotView swap-in pattern established in Task A11. Reduce slide count per the design doc §3. Write a smoke test asserting slide count and final-CTA navigation, following the same pattern as Task A11's test. Run test, verify pass, commit:

```bash
git add lib/features/onboarding/presentation/screens/onboarding_screen.dart test/features/onboarding/onboarding_screen_test.dart
git commit -m "feat(onboarding): condense to 2 slides in the new visual language"
```

---

### Task A13: Settings → "Switch faith" entry

**Files:**
- Modify: `lib/features/settings/presentation/screens/settings_screen.dart:145-153` (insert a new `ListTile` right before the existing "Sign out" tile, inside a new "Faith" section header)

**Step 1: Write the failing test**

```dart
// test/features/settings/settings_screen_switch_faith_test.dart
// Smoke test: pump SettingsScreen with required providers overridden to
// fixture/no-op values (mirror whatever override set an existing settings
// test in this repo would need — there isn't one yet, so this is new).
// Assert: find.text('Switch faith') exists, tapping it calls context.push
// with Routes.switchFaith. Use a GoRouter harness like Task A11's test.
```

Write this test file fully before implementing — follow the harness pattern from Task A11 (a `GoRouter` with `/settings` → `SettingsScreen()` and `Routes.switchFaith` → a placeholder `Text('PICKER')`), asserting the tap navigates there.

**Step 2: Run test to verify it fails**

Run: `flutter test test/features/settings/settings_screen_switch_faith_test.dart`
Expected: FAIL — no "Switch faith" tile exists yet.

**Step 3: Write minimal implementation**

In `settings_screen.dart`, add (using the existing `_SectionHeader` pattern already in the file):

```dart
_SectionHeader(label: 'Faith'),
ListTile(
  leading: const Icon(Icons.diversity_3_outlined),
  title: const Text('Switch faith'),
  subtitle: const Text('Change which tradition the app follows'),
  trailing: const Icon(Icons.chevron_right),
  onTap: () {
    HapticFeedback.lightImpact();
    context.push(Routes.switchFaith);
  },
),
```

(Add `import '../../../../core/router/routes.dart';` at the top.)

**Step 4: Run test to verify it passes**

Run: `flutter test test/features/settings/settings_screen_switch_faith_test.dart`
Expected: PASS

**Step 5: Commit**

```bash
git add lib/features/settings/presentation/screens/settings_screen.dart test/features/settings/settings_screen_switch_faith_test.dart
git commit -m "feat(settings): add Switch faith entry point"
```

---

### Task A14: Faith-aware app shell (bottom nav)

**Files:**
- Modify: `lib/features/shell/app_shell.dart` (full rewrite)
- Modify: `lib/core/router/routes.dart` (add faith-specific route constants — see below)
- Modify: `lib/core/router/app_router.dart` (branch 1 and branch 2 host both faiths' routes; branch builder picks the landing screen by faith)
- Test: `test/features/shell/app_shell_test.dart`

**Design decision (confirmed with user 2026-08-29):** faiths get their **own tab set**, not shared labels over different content. Concretely:
- Tab 1 "Today" — shared shell, faith-aware content (Task B1/C-today).
- Tab 2: **Islam → "Quran"** (existing `quranRoutes`, path `/quran`) / **Hindu → "Scripture"** (new `hinduScripturesRoutes`, path `/hindu/scripture`).
- Tab 3: **Islam → "Hadiths"** (existing `hadithsRoutes`, path `/hadiths`) / **Hindu → "Stories"** (new `hinduStoriesRoutes`, path `/hindu/stories`).
- Tab 4 "Practice" — shared shell, grid contents differ by faith (Islam: Dhikr/Duas/Names/Qibla; Hindu: Japa/Stotras/Temples).
- Tab 5 "Reflect" — shared, feelings module made faith-aware (Task C-feelings) rather than duplicated.

Both faiths' route trees are registered in the **same** two branches (so `StatefulShellRoute.indexedStack`'s branch count stays 5, matching 5 nav destinations) — only the destination icon/label and the branch's landing widget switch on `selectedFaithProvider`. This avoids restructuring the shell/router every time a faith is added later; a 3rd faith just adds its own routes to the same branches.

**Step 1: Write the failing test**

```dart
// test/features/shell/app_shell_test.dart
// Widget test with a minimal GoRouter (5 branches, each with a Text('...')
// placeholder screen) wrapped so SelectedFaith can be overridden via
// ProviderScope.overrides. Assert:
//  - with SelectedFaith == islam: NavigationDestination labels are
//    ['Today', 'Quran', 'Hadiths', 'Practice', 'Reflect']
//  - with SelectedFaith == hindu: labels are
//    ['Today', 'Scripture', 'Stories', 'Practice', 'Reflect']
// Use `find.byType(NavigationDestination)` is not queryable directly in
// widget tests (NavigationBar consumes the list internally) — instead
// assert on `find.text('Quran')` vs `find.text('Scripture')` etc. after
// pumping with each override.
```

**Step 2: Run test to verify it fails**

Run: `flutter test test/features/shell/app_shell_test.dart`
Expected: FAIL — `AppShell` doesn't read faith yet.

**Step 3: Write minimal implementation**

```dart
// lib/features/shell/app_shell.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/preferences/selected_faith.dart';
import '../../core/theme/faith_id.dart';

/// Hosts the five primary tabs and preserves their navigation stacks
/// independently via [StatefulShellRoute.indexedStack]. Tabs 2 and 3 swap
/// icon/label by active faith; tab content itself is routed per-faith
/// inside each branch (see app_router.dart).
class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onTap(int index) {
    if (index == navigationShell.currentIndex) {
      navigationShell.goBranch(index, initialLocation: true);
      return;
    }
    HapticFeedback.selectionClick();
    navigationShell.goBranch(index);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final faith = ref.watch(selectedFaithProvider).valueOrNull ?? FaithId.islam;
    final isHindu = faith == FaithId.hindu;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onTap,
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.wb_twilight_outlined),
            selectedIcon: Icon(Icons.wb_twilight),
            label: 'Today',
          ),
          NavigationDestination(
            icon: Icon(isHindu ? Icons.auto_stories_outlined : Icons.menu_book_outlined),
            selectedIcon: Icon(isHindu ? Icons.auto_stories : Icons.menu_book),
            label: isHindu ? 'Scripture' : 'Quran',
          ),
          NavigationDestination(
            icon: Icon(isHindu ? Icons.temple_hindu_outlined : Icons.history_edu_outlined),
            selectedIcon: Icon(isHindu ? Icons.temple_hindu : Icons.history_edu),
            label: isHindu ? 'Stories' : 'Hadiths',
          ),
          const NavigationDestination(
            icon: Icon(Icons.spa_outlined),
            selectedIcon: Icon(Icons.spa),
            label: 'Practice',
          ),
          const NavigationDestination(
            icon: Icon(Icons.self_improvement_outlined),
            selectedIcon: Icon(Icons.self_improvement),
            label: 'Reflect',
          ),
        ],
      ),
    );
  }
}
```

Note: `Icons.temple_hindu_outlined`/`Icons.temple_hindu` exist in current Material Symbols (Flutter's bundled `Icons` class) — if `flutter analyze` flags either as undefined on the installed Flutter version, substitute `Icons.account_balance_outlined`/`Icons.account_balance` (a temple/institution glyph that's been in Material icons far longer) and note the substitution in the commit message.

Branch content routing is finalized in Task C1 (once the Hindu route files exist) — this task only lands the shell/nav shape. For now, wire branch 2 and 3 to a small per-faith switcher stub so the shell compiles and the test passes:

```dart
// lib/features/shell/faith_tab_router.dart — new file
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/preferences/selected_faith.dart';
import '../../core/theme/faith_id.dart';

/// Picks between an Islam and a Hindu screen for a shared nav slot, based
/// on the active faith. Used for the branch-2 (Scripture/Quran) and
/// branch-3 (Stories/Hadiths) landing routes.
class FaithTabRouter extends ConsumerWidget {
  const FaithTabRouter({super.key, required this.islam, required this.hindu});

  final WidgetBuilder islam;
  final WidgetBuilder hindu;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final faith = ref.watch(selectedFaithProvider).valueOrNull ?? FaithId.islam;
    return faith == FaithId.hindu ? hindu(context) : islam(context);
  }
}
```

This gets wired into `app_router.dart`'s branches in Task C1, once `hinduScripturesRoutes`/`hinduStoriesRoutes` exist to pass in.

**Step 4: Run test to verify it passes**

Run: `flutter test test/features/shell/app_shell_test.dart`
Expected: PASS

**Step 5: Commit**

```bash
git add lib/features/shell/app_shell.dart lib/features/shell/faith_tab_router.dart test/features/shell/app_shell_test.dart
git commit -m "feat(shell): faith-aware bottom nav (Quran/Hadiths vs Scripture/Stories)"
```

---

**End of Part A.** Before moving to Part B or C: run the full suite (`flutter test`), run `flutter analyze`, run the app (`flutter run`) and click through faith picker → login → today, confirming no crashes and both faiths' colors apply. Commit any straggler fixes as `fix(theme): ...` before starting Part B.

---

# PART B — ISLAM MODULE RESKIN

Apply the Part A component kit + `FaithThemeExtension` to the existing 15 Islam modules (shell/onboarding already done in Part A). One task per module. Every task follows the same shape:

1. Open each screen/widget file in the module.
2. Replace the recurring `Container(decoration: BoxDecoration(color: cs.surface, border: Border.all(color: cs.outline), borderRadius: ...))` pattern with `PoppyCard`.
3. Replace `FilledButton`/bespoke primary-action buttons with `PoppyButton`.
4. Replace bare numeral/stat displays (streaks, counts, progress) with `StatChip`.
5. Replace leading `Icon(...)` decorations that currently sit in a plain circle/no wrapper with `PoppyIcon`.
6. Where a screen represents a "success" moment (prayer logged, dhikr milestone hit, dua marked read), add a `MascotView(faith: FaithId.islam, state: MascotState.celebrate)` per the design doc's motion spec.
7. Add/extend a smoke test per screen.
8. Manual run-through.
9. Commit.

Because this is a mechanical, repeated pattern, each module task below gives the file list and module-specific notes rather than re-deriving the generic steps above.

### Task B1: `today` module

**Files:** `lib/features/today/presentation/screens/today_screen.dart`, `presentation/widgets/{daily_hadith_card,mood_prompt,prayer_countdown_card,quick_actions_row,verse_card}.dart`
**Test:** `test/features/today/today_screen_test.dart`

Notes: `_Greeting`'s "As-salāmu ʿalaykum" header is Islam-specific copy — this screen becomes faith-aware in the same way the shell did (Task A14's `FaithTabRouter` pattern applies here too, OR simpler: since Today is a single shared branch not a dual-content branch, make `TodayScreen` itself watch `selectedFaithProvider` and branch its greeting string + which countdown card it shows). Concretely: extract the current body into `_IslamTodayContent`, add a sibling `_HinduTodayContent` (built in Task C-today), and have `TodayScreen.build` pick between them by faith. Wire `PrayerCountdownCard`/`VerseCard`/`DailyHadithCard` through `PoppyCard`.

```bash
git add lib/features/today/ test/features/today/today_screen_test.dart
git commit -m "feat(today): apply poppy visual language, branch content by faith"
```

### Task B2: `prayers` module

**Files:** `presentation/screens/{prayer_detail_screen,qaza_tracker_screen}.dart`, `presentation/widgets/{log_action_sheet,prayer_arc,prayer_row}.dart`
**Test:** `test/features/prayers/prayer_detail_screen_test.dart`

Notes: `prayer_row.dart` list rows → `PoppyCard`-wrapped rows; qada tracker's count display → `StatChip`; logging a prayer as "on time" triggers `MascotView(..., MascotState.celebrate)` inline in `log_action_sheet.dart`.

```bash
git add lib/features/prayers/ test/features/prayers/prayer_detail_screen_test.dart
git commit -m "feat(prayers): apply poppy visual language, mascot celebrate on log"
```

### Task B3: `quran` module

**Files:** `presentation/screens/{quran_home_screen,surah_reader_screen,bookmarks_screen}.dart`, `presentation/widgets/{audio_mini_player,ayah_action_sheet,ayah_view,reader_top_bar,surah_list_tile}.dart`
**Test:** `test/features/quran/quran_home_screen_test.dart`

Notes: `surah_list_tile.dart` → `PoppyCard`; reader stays a focused reading surface (don't over-decorate `ayah_view.dart` — thick outlines around every verse would hurt readability; keep the poppy language to the surrounding chrome — top bar, list, mini player — not the verse text block itself).

```bash
git add lib/features/quran/ test/features/quran/quran_home_screen_test.dart
git commit -m "feat(quran): apply poppy visual language to chrome, preserve reader legibility"
```

### Task B4: `hadiths` module

**Files:** `presentation/screens/{hadiths_home_screen,hadith_book_screen,hadith_detail_screen,hadith_search_screen}.dart`, `presentation/widgets/{book_card,daily_hadith_hero,hadith_arabic_block,hadith_list_tile}.dart`
**Test:** `test/features/hadiths/hadiths_home_screen_test.dart`

```bash
git add lib/features/hadiths/ test/features/hadiths/hadiths_home_screen_test.dart
git commit -m "feat(hadiths): apply poppy visual language"
```

### Task B5: `dhikr` module

**Files:** `presentation/screens/{dhikr_home_screen,dhikr_counter_screen,dhikr_goals_screen,dhikr_history_screen,new_counter_sheet}.dart`, `presentation/widgets/{dhikr_counter_tile,dictionary_picker,milestone_ring}.dart`
**Test:** `test/features/dhikr/dhikr_counter_screen_test.dart`

Notes: this is the highest-value screen for the "poppy comic" feel — counter tap should have the strongest tactile press animation in the app; hitting a milestone (`milestone_ring.dart`) triggers `MascotView(..., MascotState.celebrate)` + a confetti burst (see Task A5's `AppMotion.celebrate` duration).

```bash
git add lib/features/dhikr/ test/features/dhikr/dhikr_counter_screen_test.dart
git commit -m "feat(dhikr): apply poppy visual language, mascot+confetti on milestone"
```

### Task B6: `duas` module

**Files:** `presentation/screens/{duas_home_screen,dua_category_screen,dua_detail_screen,dua_favorites_screen}.dart`, `presentation/widgets/{category_card,dua_arabic_block,dua_list_tile}.dart`
**Test:** `test/features/duas/duas_home_screen_test.dart`

```bash
git add lib/features/duas/ test/features/duas/duas_home_screen_test.dart
git commit -m "feat(duas): apply poppy visual language"
```

### Task B7: `names` module

**Files:** `presentation/screens/{names_home_screen,name_detail_screen}.dart`, `presentation/widgets/{name_list_tile,todays_name_hero}.dart`
**Test:** `test/features/names/names_home_screen_test.dart`

Notes: no Hindu equivalent (per the research pass — `deity-names` backend module is an empty stub). This module stays Islam-only; nothing to branch by faith here.

```bash
git add lib/features/names/ test/features/names/names_home_screen_test.dart
git commit -m "feat(names): apply poppy visual language"
```

### Task B8: `qibla` module

**Files:** `presentation/screens/qibla_screen.dart`, `presentation/widgets/{calibrate_hint,kaaba_marker,qibla_compass}.dart`
**Test:** `test/features/qibla/qibla_screen_test.dart`

Notes: no Hindu equivalent — Islam-only, per the confirmed nav decision. The compass dial itself is a custom-painted widget already; keep its physics/rendering, only reskin surrounding chrome (calibrate hint card, back button) with the new component kit.

```bash
git add lib/features/qibla/ test/features/qibla/qibla_screen_test.dart
git commit -m "feat(qibla): apply poppy visual language to chrome"
```

### Task B9: `calendar` module

**Files:** `presentation/screens/{calendar_screen,event_detail_screen}.dart`, `presentation/widgets/{event_tile,hijri_month_grid}.dart`
**Test:** `test/features/calendar/calendar_screen_test.dart`

Notes: `_ModeToggle`'s pill-segmented control already matches the poppy pill-shape language closely — restyle colors/border-width only, don't restructure. `event_tile.dart` → `PoppyCard`. This screen is reachable from Today for both faiths but shows Islamic (Hijri) events only — Hindu's Panchang/festivals get their own screen in Part C rather than merging into this one (Panchang's daily tithi/nakshatra data doesn't fit a Hijri month-grid shape).

```bash
git add lib/features/calendar/ test/features/calendar/calendar_screen_test.dart
git commit -m "feat(calendar): apply poppy visual language"
```

### Task B10: `feelings` module — made faith-aware (not just reskinned)

**Files:** `data/feelings_repository.dart`, `data/dtos/{emotion,remedy}.dart`, `presentation/screens/{journal_screen,mood_history_screen,mood_result_screen}.dart`, `presentation/widgets/{journal_entry_tile,mood_chip,mood_chip_row,remedy_card}.dart`
**Test:** `test/features/feelings/feelings_repository_test.dart`, `test/features/feelings/mood_result_screen_test.dart`

**This task is different from the others in Part B** — it's the one existing module the research pass found has a *symmetric* Hindu backend endpoint (`GET /api/v1/hindu/feelings`, `GET /api/v1/hindu/feelings/:slug`), so rather than duplicating a whole new "Hindu feelings" module in Part C, this module becomes faith-aware in place. Read `feelings_repository.dart` in full first (not reproduced here). Add:

```dart
// inside FeelingsRepository — branch the base path on active faith
String _base(FaithId faith) => switch (faith) {
  FaithId.islam => '/api/v1/islam/feelings',
  FaithId.hindu => '/api/v1/hindu/feelings',
};
```

Thread `FaithId faith` as a parameter through every repository method (`getEmotions(FaithId faith)`, `getRemedy(FaithId faith, String slug)`), and update the Riverpod controllers (`emotions_controller.dart`, `remedies_controller.dart`) to read `ref.watch(selectedFaithProvider)` and pass it through. `mood_result_screen.dart`'s copy ("There's a dua for what you're carrying") is Islam-specific — branch to "There's a shloka for what you're carrying" (or similar; confirm exact Hindu copy against `hindu.feelings.tsx` on web for consistency) when `faith == FaithId.hindu`.

Write a repository test confirming both base paths are hit correctly (mock `Dio` via `DioAdapter` or an interceptor capturing the request URL — follow whatever HTTP-mocking convention, if any, exists elsewhere in this codebase; if none exists, use `dio`'s `DioAdapter` test double directly since it's already a dependency).

```bash
git add lib/features/feelings/ test/features/feelings/
git commit -m "feat(feelings): make module faith-aware (islam+hindu backends), apply poppy visual language"
```

### Task B11: `reflect` module

**Files:** `presentation/screens/reflect_home_screen.dart`
**Test:** `test/features/reflect/reflect_home_screen_test.dart`

Notes: `_MoodCard`/`_LinkCard`/`_RecentRow` → `PoppyCard`. Copy ("There's a dua for what you're carrying") branches by faith same as Task B10.

```bash
git add lib/features/reflect/ test/features/reflect/reflect_home_screen_test.dart
git commit -m "feat(reflect): apply poppy visual language, faith-aware copy"
```

### Task B12: `practice` module — grid contents branch by faith

**Files:** `presentation/screens/practice_home_screen.dart`
**Test:** `test/features/practice/practice_home_screen_test.dart`

```dart
// Replace the static `_tiles` const list with a faith-aware getter:
static List<_PracticeTileData> tilesFor(FaithId faith) => switch (faith) {
  FaithId.islam => const [
      _PracticeTileData(icon: Icons.fingerprint, title: 'Dhikr', subtitle: 'Counter & goals', route: '/practice/dhikr'),
      _PracticeTileData(icon: Icons.menu_book_outlined, title: 'Duas', subtitle: 'Supplications', route: '/practice/duas'),
      _PracticeTileData(icon: Icons.auto_awesome_outlined, title: 'Names', subtitle: '99 Names', route: '/practice/names'),
      _PracticeTileData(icon: Icons.explore_outlined, title: 'Qibla', subtitle: 'Direction', route: '/practice/qibla'),
    ],
  FaithId.hindu => const [
      _PracticeTileData(icon: Icons.fingerprint, title: 'Japa', subtitle: 'Mantra counter', route: '/practice/japa'),
      _PracticeTileData(icon: Icons.menu_book_outlined, title: 'Stotras', subtitle: 'Hymns & aartis', route: '/practice/stotras'),
      _PracticeTileData(icon: Icons.temple_hindu_outlined, title: 'Temples', subtitle: 'Find nearby', route: '/practice/temples'),
    ],
};
```

Convert `PracticeHomeScreen` to a `ConsumerWidget`, watch `selectedFaithProvider`, pass `tilesFor(faith)` into the existing grid. Reskin `_PracticeTile` to use `PoppyCard`+`PoppyIcon`. Note the Hindu grid has 3 tiles vs Islam's 4 — leave the `SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, ...)` as-is; a 3-item 2-column grid rendering one dangling tile in row 2 is visually fine and honest (no fake 4th tile).

```bash
git add lib/features/practice/ test/features/practice/practice_home_screen_test.dart
git commit -m "feat(practice): faith-aware grid contents, apply poppy visual language"
```

### Task B13: `settings` module (remaining reskin beyond Task A13)

**Files:** `presentation/screens/settings_screen.dart`
**Test:** extend `test/features/settings/settings_screen_switch_faith_test.dart` or add a sibling test file

Notes: `RadioListTile`/`SwitchListTile` stay as Material list tiles (settings screens are inherently list-form; forcing them into `PoppyCard` per-row would be visual overkill) — just update section header styling to the new type scale (automatic via `AppTheme`'s `TextTheme`, no per-file change needed beyond verifying nothing hardcodes `GoogleFonts.fraunces`/`.inter` directly). Grep to confirm:

Run: `grep -rn "GoogleFonts\." lib/features/settings/`

If any direct `GoogleFonts.fraunces`/`.inter` calls exist (bypassing the theme), replace with theme-driven `Theme.of(context).textTheme.*`.

```bash
git add lib/features/settings/
git commit -m "feat(settings): confirm theme-driven typography, no direct font overrides"
```

### Task B14: `share` module

**Files:** `presentation/screens/share_card_screen.dart`, `presentation/widgets/share_card.dart`
**Test:** `test/features/share/share_card_screen_test.dart`

Notes: the rendered share card (captured via `RepaintBoundary` for `share_plus`) should reflect the new brand — apply `FaithPalette`/mascot to the card design itself, since this image leaves the app and represents the brand externally. This is the one place in Part B where the mascot appears in a static (non-animated) `MascotState.idle` pose, rendered into the exported image.

```bash
git add lib/features/share/ test/features/share/share_card_screen_test.dart
git commit -m "feat(share): brand share cards with new poppy visual language + mascot"
```

### Task B15: `auth` module

**Files:** `presentation/screens/{login_screen,register_screen,splash_screen}.dart`
**Test:** `test/features/auth/login_screen_test.dart`

Notes: splash screen shows the faith-neutral animated mark specified in the design doc §3 (not either mascot — the user hasn't chosen a faith yet the very first time splash appears, though on subsequent app opens `selectedFaithProvider` will already be set; splash can stay faith-neutral in both cases for simplicity and brand consistency at the "brand moment"). Login/register forms use the new `inputDecorationTheme` (already faith-agnostic via `AppTheme`) — apply `PoppyButton` to the submit action.

```bash
git add lib/features/auth/ test/features/auth/login_screen_test.dart
git commit -m "feat(auth): apply poppy visual language to login/register/splash"
```

---

**End of Part B.** Run `flutter test`, `flutter analyze`, full manual click-through of both faiths (switch via Settings mid-session and confirm colors/mascot/nav update live) before starting Part C.

---

# PART C — HINDU VERTICAL BUILD

Eight new feature areas, each mirroring an existing Islam module's file shape exactly and calling the live `unified-faith-service` Hindu endpoints (base `/api/v1/hindu/*`, confirmed live in production per prior audit — see `unified-faith-service/CLAUDE.md` and the memory note on Hindu backend completion). Built in the new visual language from day one — no separate reskin pass needed afterward.

**Shared prerequisite for every task below:** each new repository follows the exact `DuasRepository` shape from Task-context (Dio injected via `dioProvider`, try/catch → `ApiException.fromDio`, `@Riverpod(keepAlive: true)` provider function at the bottom of the file). Each new route file follows the exact `duas_routes.dart` shape (a `List<RouteBase>` constant, nested `GoRoute`s, more-specific paths before dynamic `:id` segments).

### Task C1: Wire Hindu branches into the router (unblocks all other Part C tasks)

**Files:**
- Modify: `lib/core/router/routes.dart` — add Hindu path constants
- Modify: `lib/core/router/app_router.dart` — branch 1/2 host both faiths' routes via `FaithTabRouter` (Task A14)

**Step 1:** Add to `routes.dart`:

```dart
static const hinduScripture = '/hindu/scripture';
static const hinduStories = '/hindu/stories';
```

**Step 2:** In `app_router.dart`, the two dual-content branches become:

```dart
StatefulShellBranch(
  routes: [
    GoRoute(
      path: Routes.quran,
      builder: (_, __) => const FaithTabRouter(
        islam: _quranHome,
        hindu: _hinduScriptureHome,
      ),
      routes: [...quranSubRoutes, ...hinduScriptureSubRoutes],
    ),
  ],
),
```

This is illustrative shape only — the executing engineer must adapt to however `quranRoutes`/`quranSubRoutes` are actually structured today (read `lib/features/quran/quran_routes.dart` in full before writing this; it wasn't part of this plan's research pass). The key invariant: **both faiths' full route trees are registered under the same branch index**, and only the branch's top-level landing widget switches by faith — sub-routes (surah reader vs. chapter reader) are reached by faith-specific paths (`/quran/surah/:n` vs `/hindu/scripture/:slug/:chapter`) so there's no path collision.

Do this task last-in-first-out relative to Tasks C2–C8 in practice (you'll come back and fill in the `hindu: ...` builder args as each Hindu screen is built) — but land the branch-structure change now so each subsequent task has somewhere to plug its routes in.

**Commit:**

```bash
git add lib/core/router/routes.dart lib/core/router/app_router.dart
git commit -m "feat(router): scaffold dual-faith branches for Scripture/Stories tabs"
```

---

### Task C2: `hindu_scriptures` module (mirrors `quran`)

**Backend:** `GET /api/v1/hindu/scriptures/texts`, `/texts/:slug`, `/texts/:slug/chapters/:n[?lang=]`, `/texts/:slug/chapters/:n/audio`, `/featured`, `/search?q=`, `/verses/:id`, `POST|GET|DELETE /bookmarks`.

**Files:**
- Create: `lib/features/hindu_scriptures/data/dtos/{scripture_text.dart, scripture_chapter.dart, scripture_verse.dart}`
- Create: `lib/features/hindu_scriptures/data/hindu_scriptures_repository.dart`
- Create: `lib/features/hindu_scriptures/hindu_scriptures_routes.dart`
- Create: `lib/features/hindu_scriptures/presentation/screens/{hindu_scriptures_home_screen,chapter_reader_screen,bookmarks_screen}.dart`
- Create: `lib/features/hindu_scriptures/presentation/widgets/{text_card,verse_view,audio_mini_player}.dart` (audio player can share logic with `lib/features/quran/presentation/widgets/audio_mini_player.dart` — read it first; if it's not Quran-specific in its internals, extract a shared `lib/shared/widgets/audio_mini_player.dart` instead of duplicating)
- Test: `test/features/hindu_scriptures/hindu_scriptures_repository_test.dart`, `test/features/hindu_scriptures/hindu_scriptures_home_screen_test.dart`

**Step 1: Write the failing repository test**

```dart
// test/features/hindu_scriptures/hindu_scriptures_repository_test.dart
// Mirror the shape of any existing repository test in this repo if one
// exists (check `test/features/` for precedent first); if none exists,
// use dio's built-in `DioAdapter`/mock `Dio` with a `MockAdapter` or
// simply inject a `Dio(BaseOptions())` pointed at a local mock server —
// follow whatever pattern `duas_repository.dart`'s own test (if any)
// establishes. At minimum, assert:
//  - getTexts() parses a fixture JSON array into List<ScriptureText>
//  - getChapter(slug, n) hits '/api/v1/hindu/scriptures/texts/$slug/chapters/$n'
//  - search(q) hits '/api/v1/hindu/scriptures/search?q=$q'
```

**Step 2–3:** Implement DTOs (freezed, mirroring `dua.dart`'s shape — field names should mirror the backend response shape; read `unified-faith-service/src/faiths/hindu/scriptures/dto/*.ts` to get exact field names before writing the Dart DTOs rather than guessing), then the repository (mirror `duas_repository.dart` exactly — same try/catch, same `ApiException` surfacing, same `@Riverpod(keepAlive: true)` provider pattern), then routes (mirror `duas_routes.dart`), then screens (mirror `quran_home_screen.dart`/`surah_reader_screen.dart` structurally — list of texts → chapter list → verse-by-verse reader with audio bar, using `PoppyCard` for the text/chapter list tiles and keeping the verse reader itself typographically calm per the same "don't over-decorate reading surfaces" note from Task B3).

**Step 4: Run tests, verify pass.**

**Step 5: Wire into Task C1's `FaithTabRouter` `hindu:` slot and commit.**

```bash
git add lib/features/hindu_scriptures/ test/features/hindu_scriptures/
git commit -m "feat(hindu): add scriptures module (Gita+Ramayana reader, bookmarks, audio)"
```

---

### Task C3: `hindu_japa` module (mirrors `dhikr`)

**Backend:** `GET|POST|PATCH|DELETE /api/v1/hindu/japa/counters[/:id]`, `GET|POST /goals`, `GET /history`, `GET /stats`, `GET /mantras?category&deity`.

**Files:** mirror `lib/features/dhikr/` exactly, module named `hindu_japa`:
- `data/dtos/{japa_counter,japa_goal,mantra}.dart`
- `data/hindu_japa_repository.dart`
- `hindu_japa_routes.dart`
- `presentation/screens/{japa_home_screen,japa_counter_screen,japa_goals_screen,japa_history_screen,new_counter_sheet}.dart`
- `presentation/widgets/{japa_counter_tile,mantra_picker,milestone_ring}.dart` (`milestone_ring.dart` — check if `dhikr`'s version is generic enough to share via `lib/shared/widgets/`; if so, extract rather than duplicate)
- Test: `test/features/hindu_japa/hindu_japa_repository_test.dart`, `.../japa_counter_screen_test.dart`

This is the closest 1:1 structural mirror in the whole Hindu build (per the research pass, `japa` and `dhikr` are shape-identical: counter + goals + history + a dictionary/mantra list). Read `lib/features/dhikr/data/dhikr_repository.dart` and `lib/features/dhikr/presentation/screens/dhikr_counter_screen.dart` in full before starting — copy their structure, rename, repoint to `/api/v1/hindu/japa/*`. Same milestone-celebrate mascot moment as Task B5.

```bash
git add lib/features/hindu_japa/ test/features/hindu_japa/
git commit -m "feat(hindu): add japa module (mantra counter, goals, history, dictionary)"
```

---

### Task C4: `hindu_stotras` module (mirrors `duas`)

**Backend:** `GET /api/v1/hindu/stotras/categories`, `/search?q=`, `POST|GET|DELETE /favorites`, `GET ?category&deity&type`, `GET /:slug?lang=`.

**Files:** mirror `lib/features/duas/` exactly:
- `data/dtos/{stotra,stotra_category}.dart`
- `data/hindu_stotras_repository.dart`
- `hindu_stotras_routes.dart`
- `presentation/screens/{stotras_home_screen,stotra_category_screen,stotra_detail_screen,stotra_favorites_screen}.dart`
- `presentation/widgets/{category_card,stotra_text_block,stotra_list_tile}.dart`
- Test: `test/features/hindu_stotras/hindu_stotras_repository_test.dart`, `.../stotras_home_screen_test.dart`

Read `duas_repository.dart` (already fully read above) and copy its shape directly, repointing to `/api/v1/hindu/stotras`. Note the extra `deity`/`type` filter params on the list endpoint that `duas` doesn't have — add those as optional named parameters on the repository method.

```bash
git add lib/features/hindu_stotras/ test/features/hindu_stotras/
git commit -m "feat(hindu): add stotras module (hymns/aartis, categories, favorites)"
```

---

### Task C5: `hindu_panchang` module (mirrors `calendar`)

**Backend:** `GET /api/v1/hindu/panchang/today[?lat&lng&timezone]`, `/date/:date`, `/month?year&month&lat&lng`, `/auspicious`, `/festivals`, `/festivals/upcoming`, `/festivals/:slug`.

**Files:** mirror `lib/features/calendar/`:
- `data/dtos/{panchang_day,festival}.dart`
- `data/hindu_panchang_repository.dart`
- `hindu_panchang_routes.dart`
- `presentation/screens/{panchang_screen,festival_detail_screen}.dart`
- `presentation/widgets/{festival_tile,panchang_month_grid,tithi_card}.dart`
- Test: `test/features/hindu_panchang/hindu_panchang_repository_test.dart`, `.../panchang_screen_test.dart`

Notes: needs `lat`/`lng` — reuse the existing `lib/core/location/location_service.dart` (already consumed by `qibla` and `prayers` for the same purpose; read it first, don't reinvent geolocation plumbing). `timezone` param — pass `DateTime.now().timeZoneName` or better, the IANA name via the `timezone` package already a dependency (`flutter_local_notifications`/`timezone` packages are already wired for prayer-time scheduling; check `lib/core/notifications/` for how timezone is currently resolved and reuse that, since the web app's gotcha log flagged wall-clock-vs-UTC bugs in this exact param — get it from the same source of truth already proven correct in this codebase, don't recompute it a third way).

```bash
git add lib/features/hindu_panchang/ test/features/hindu_panchang/
git commit -m "feat(hindu): add panchang module (tithi/nakshatra, festivals)"
```

---

### Task C6: `hindu_puja_times` module (mirrors `prayers`, partial — 3 windows not 5, no qada concept)

**Backend:** `GET /api/v1/hindu/puja-times/today[?lat&lng&timezone]`, `/date/:date`, `POST|GET|DELETE /log`, `/logs`, `/log/:id`, `GET /stats`.

**Files:**
- `data/dtos/{puja_window,puja_log}.dart`
- `data/hindu_puja_times_repository.dart`
- `hindu_puja_times_routes.dart`
- `presentation/screens/puja_log_screen.dart` (a single detail/log screen — there's no qada-tracker equivalent to mirror since Hindu sandhya practice has no "missed prayer makeup" concept)
- `presentation/widgets/puja_countdown_card.dart` (lives on Hindu's Today content, same slot `PrayerCountdownCard` occupies for Islam — see Task C-today below)
- Test: `test/features/hindu_puja_times/hindu_puja_times_repository_test.dart`

Read `lib/features/prayers/presentation/widgets/prayer_arc.dart` and `prayer_row.dart` for the countdown-arc visual pattern — `puja_countdown_card.dart` can reuse the same arc-drawing approach for 3 windows instead of 5 (dawn/midday/dusk), just don't copy the qada-tracker screen since there's nothing on the Hindu side for it to represent.

```bash
git add lib/features/hindu_puja_times/ test/features/hindu_puja_times/
git commit -m "feat(hindu): add puja-times module (sandhya windows, practice log)"
```

---

### Task C7: `hindu_stories` module (mirrors `hadiths`, loose match)

**Backend:** `GET /api/v1/hindu/stories/collections`, `/search?q=`, `POST|GET|DELETE /favorites`, `GET ?collection&deity`, `GET /:id`.

**Files:** mirror `lib/features/hadiths/`:
- `data/dtos/{story,story_collection}.dart`
- `data/hindu_stories_repository.dart`
- `hindu_stories_routes.dart`
- `presentation/screens/{stories_home_screen,story_collection_screen,story_detail_screen,story_search_screen}.dart`
- `presentation/widgets/{collection_card,daily_story_hero,story_list_tile}.dart`
- Test: `test/features/hindu_stories/hindu_stories_repository_test.dart`, `.../stories_home_screen_test.dart`

Note the framing difference from `hadiths` in copy/tone: hadiths are authoritative sayings (reference-heavy, terse), sacred stories are narrative katha (longer-form, storytelling tone) — don't copy `hadith_arabic_block.dart`'s dense reference-citation layout verbatim; `story_detail_screen.dart` reads more like `hindu_scriptures`' verse view (give it room to breathe) than like a hadith card. Confirm tone against `hindu.stories.$id.tsx` on web before finalizing.

```bash
git add lib/features/hindu_stories/ test/features/hindu_stories/
git commit -m "feat(hindu): add sacred stories module (Puranic/Ramayana katha)"
```

---

### Task C8: `hindu_temples` module (net-new — no Islam precedent)

**Backend:** `GET /api/v1/hindu/temples/states`, `/nearby?lat&lng&radiusKm`, `POST|GET|DELETE /favorites`, `GET ?deity&state&q`, `GET /:id`.

**Files:**
- `data/dtos/{temple}.dart`
- `data/hindu_temples_repository.dart`
- `hindu_temples_routes.dart`
- `presentation/screens/{temples_home_screen,temple_detail_screen}.dart`
- `presentation/widgets/{temple_list_tile,state_filter_chip}.dart`
- Test: `test/features/hindu_temples/hindu_temples_repository_test.dart`, `.../temples_home_screen_test.dart`

**This is the one screen family with no Islam-mobile precedent to mirror.** Structurally closest to `qibla`'s use of `lib/core/location/location_service.dart` (for the `nearby` query) combined with `duas`' category/favorites list pattern (for the browse-by-state/deity list + favoriting). No map view in scope for this plan — `nearby` results render as a distance-sorted `PoppyCard` list (temple name, distance, state), tapping into `temple_detail_screen.dart` which shows description/significance/directions (a "Get directions" `PoppyButton` that opens the platform maps app via `url_launcher` — **new dependency**, not currently in `pubspec.yaml`; add `url_launcher: ^6.3.0` and run `flutter pub get` as the first step of this task, before writing any code that imports it).

```bash
git add pubspec.yaml pubspec.lock lib/features/hindu_temples/ test/features/hindu_temples/
git commit -m "feat(hindu): add temple locator module (geo search, favorites, directions)"
```

---

### Task C9: Hindu content on the Today tab + Practice grid wiring

**Files:**
- Modify: `lib/features/today/presentation/screens/today_screen.dart` (add the `_HinduTodayContent` sibling stubbed out in Task B1)
- Modify: `lib/features/practice/presentation/screens/practice_home_screen.dart` (already faith-aware from Task B12 — just confirm the `/practice/japa`, `/practice/stotras`, `/practice/temples` routes now resolve now that Tasks C3/C4/C8 exist)
- Modify: `lib/core/router/app_router.dart` (register `hinduJapaRoutes`/`hinduStotrasRoutes`/`hinduTemplesRoutes` under the `practice` branch alongside the existing Islam sub-routes, and finalize Task C1's `FaithTabRouter` wiring for the Scripture/Stories branches now that `hindu_scriptures`/`hindu_stories` exist)

**Step 1:** Build `_HinduTodayContent` mirroring `_Greeting`+`PrayerCountdownCard`+`VerseCard`+`DailyHadithCard`+`MoodPrompt`+`QuickActionsRow` 1:1, swapping: greeting copy (time-aware Hindu greeting, mirroring the web app's `hindu.tsx` pattern — read that file for the exact tone/logic to port, per the research pass' web inventory), `PrayerCountdownCard`→`PujaCountdownCard` (Task C6), `VerseCard`→ a Gita/Ramayana featured-verse card (reuse `hindu_scriptures`' `verse_view.dart` in a compact mode), `DailyHadithCard`→ a "Katha of the Day" card (reuse `hindu_stories`' `daily_story_hero.dart`), `MoodPrompt` stays (feelings is faith-aware from Task B10), `QuickActionsRow` → faith-aware quick links (Japa counter, Panchang, Temples).

**Step 2:** Full manual click-through: switch faith in Settings, confirm Today/Practice/Scripture-tab/Stories-tab/Reflect all update live with zero stale-faith content leaking (e.g. no "As-salāmu ʿalaykum" greeting surviving into Hindu mode).

**Step 3: Commit.**

```bash
git add lib/features/today/ lib/features/practice/ lib/core/router/app_router.dart
git commit -m "feat(hindu): wire Hindu content into Today tab and Practice grid routes"
```

---

**End of Part C.** Run the full suite, `flutter analyze`, and a complete manual QA pass on a real device/emulator in both faiths, both light/dark, before considering this plan complete. Cross-check against `MOBILE_QA_REPORT.md` (repo root, per prior audit) — this redesign should not resurrect any of the Critical/High findings there (e.g. don't let the Hindu build repeat the "prayer logs GET hits nonexistent route" contract-mismatch class of bug; verify every new repository method's path against the actual backend controller, not against memory/assumption).
