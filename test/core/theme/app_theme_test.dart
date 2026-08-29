import 'package:faith_mobile/core/theme/app_theme.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:faith_mobile/core/theme/faith_theme_extension.dart';
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
}
