import 'package:faith_mobile/core/theme/app_theme.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:faith_mobile/core/theme/faith_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // testWidgets (not test): AppTheme._buildTextTheme() calls
  // GoogleFonts.*TextTheme(), which kicks off an unawaited font-load future.
  // Under a bare `test()` that rejection surfaces as an unhandled async
  // error attributed to whichever test happens to be running when it lands
  // (flaky across the two tests in this file). testWidgets runs inside
  // TestWidgetsFlutterBinding's managed zone, which attributes the error to
  // the test that actually triggered it instead. See
  // test/flutter_test_config.dart for the accompanying
  // `allowRuntimeFetching = false` that makes the failure fast/deterministic
  // rather than a slow network-dependent reject.
  testWidgets('light/dark themes carry the requested faith', (tester) async {
    final light = AppTheme.light(FaithId.hindu);
    final dark = AppTheme.dark(FaithId.hindu);
    expect(light.extension<FaithThemeExtension>()!.faithId, FaithId.hindu);
    expect(dark.extension<FaithThemeExtension>()!.faithId, FaithId.hindu);
  });

  testWidgets('islam and hindu themes have different primary colors', (
    tester,
  ) async {
    final islam = AppTheme.light(FaithId.islam);
    final hindu = AppTheme.light(FaithId.hindu);
    expect(
      islam.colorScheme.primary,
      isNot(equals(hindu.colorScheme.primary)),
    );
  });

  // Regression guard: nothing else in this file asserts contrast ratios, so a
  // future edit to FaithPalette's hex values (or a new low-emphasis widget
  // style added the same way textButtonTheme was) could silently reintroduce
  // a WCAG failure with no test catching it. This test pins every faith x
  // brightness combination to the WCAG AA "normal text" threshold (4.5:1).
  testWidgets('every faith x brightness theme meets WCAG AA contrast (4.5:1)', (
    tester,
  ) async {
    for (final faith in FaithId.values) {
      for (final brightness in [Brightness.light, Brightness.dark]) {
        final theme = brightness == Brightness.light
            ? AppTheme.light(faith)
            : AppTheme.dark(faith);
        final scheme = theme.colorScheme;
        final label = '${faith.name}/${brightness.name}';

        expect(
          _contrastRatio(scheme.onPrimary, scheme.primary),
          greaterThanOrEqualTo(4.5),
          reason: 'onPrimary vs primary failed for $label',
        );
        expect(
          _contrastRatio(scheme.onSecondary, scheme.secondary),
          greaterThanOrEqualTo(4.5),
          reason: 'onSecondary vs secondary failed for $label',
        );
        expect(
          _contrastRatio(scheme.onError, scheme.error),
          greaterThanOrEqualTo(4.5),
          reason: 'onError vs error failed for $label',
        );

        final textButtonForeground = theme.textButtonTheme.style!
            .foregroundColor!
            .resolve(<WidgetState>{});
        expect(
          textButtonForeground,
          isNotNull,
          reason: 'textButtonTheme foregroundColor unresolved for $label',
        );
        expect(
          _contrastRatio(textButtonForeground!, scheme.surface),
          greaterThanOrEqualTo(4.5),
          reason: 'textButtonTheme foreground vs surface failed for $label',
        );
      }
    }
  });
}

/// Local re-derivation of the WCAG contrast-ratio formula (same formula as
/// AppTheme._contrastRatio, duplicated here so this test doesn't depend on a
/// private implementation detail of the file it's guarding).
double _contrastRatio(Color a, Color b) {
  final l1 = a.computeLuminance() + 0.05;
  final l2 = b.computeLuminance() + 0.05;
  return l1 > l2 ? l1 / l2 : l2 / l1;
}
