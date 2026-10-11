import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:faith_mobile/core/theme/app_theme.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';

/// Guards the fix for a flickering status bar.
///
/// The flicker came from two sources of truth: `AppBarTheme` published one
/// overlay style (via Flutter's fallback) and the five AppBar-less
/// PageMasthead screens published none, falling back to a global style that
/// named no icon brightness. Moving between them changed the platform value.
///
/// So the assertion that matters is not "a style exists" but **"every source
/// agrees"** — plus that the iOS and Android fields are the right way round,
/// which is the usual way this ships broken.
void main() {
  group('systemOverlayStyleFor', () {
    test('light theme asks for dark icons so they read on a light page', () {
      final style = systemOverlayStyleFor(Brightness.light);
      expect(style.statusBarIconBrightness, Brightness.dark);
      expect(style.systemNavigationBarIconBrightness, Brightness.dark);
    });

    test('dark theme asks for light icons', () {
      final style = systemOverlayStyleFor(Brightness.dark);
      expect(style.statusBarIconBrightness, Brightness.light);
      expect(style.systemNavigationBarIconBrightness, Brightness.light);
    });

    test('statusBarBrightness names the background, not the icons', () {
      // iOS inverts the convention relative to Android. On a light page the
      // icons are dark but the *background* is light; swapping these two is
      // the classic bug and leaves one platform unreadable.
      expect(
        systemOverlayStyleFor(Brightness.light).statusBarBrightness,
        Brightness.light,
      );
      expect(
        systemOverlayStyleFor(Brightness.dark).statusBarBrightness,
        Brightness.dark,
      );
      expect(
        systemOverlayStyleFor(Brightness.light).statusBarIconBrightness,
        isNot(systemOverlayStyleFor(Brightness.light).statusBarBrightness),
      );
    });

    test('bars are transparent so the page shows through', () {
      for (final b in Brightness.values) {
        final style = systemOverlayStyleFor(b);
        expect(style.statusBarColor, Colors.transparent);
        expect(style.systemNavigationBarColor, Colors.transparent);
      }
    });
  });

  // testWidgets, not test: AppTheme._buildTextTheme() calls
  // GoogleFonts.*TextTheme(), which starts an unawaited font-load future.
  // test/flutter_test_config.dart disables runtime fetching, so that future
  // rejects — and under a bare `test()` the rejection is attributed to
  // whichever test happens to be running when it lands. testWidgets runs
  // inside the binding's managed zone, which attributes it correctly. Same
  // reasoning as test/core/theme/app_theme_test.dart.
  group('AppBarTheme agrees with the root region', () {
    testWidgets('every faith and brightness publishes the shared style', (
      tester,
    ) async {
      for (final faith in FaithId.values) {
        for (final brightness in Brightness.values) {
          final theme = brightness == Brightness.light
              ? AppTheme.light(faith)
              : AppTheme.dark(faith);
          expect(
            theme.appBarTheme.systemOverlayStyle,
            systemOverlayStyleFor(brightness),
            reason:
                'AppBar screens and PageMasthead screens must publish the '
                'same value for $faith/$brightness, or the status bar '
                'flickers between them',
          );
        }
      }
    });

    testWidgets('AppBarTheme never leaves it null, which is what caused this', (
      tester,
    ) async {
      for (final faith in FaithId.values) {
        expect(AppTheme.light(faith).appBarTheme.systemOverlayStyle, isNotNull);
        expect(AppTheme.dark(faith).appBarTheme.systemOverlayStyle, isNotNull);
      }
    });
  });
}
