import 'package:faith_mobile/core/network/dio_client.dart';
import 'package:faith_mobile/core/preferences/selected_faith.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:faith_mobile/features/settings/presentation/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';
// `LinkDelegate` is declared in link.dart and not re-exported by the
// barrel, but the platform interface requires it — so both imports.
import 'package:url_launcher_platform_interface/link.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../../helpers/fake_selected_faith.dart';

/// Records what the app asked the platform to open, instead of opening it.
class _RecordingLauncher extends UrlLauncherPlatform
    with MockPlatformInterfaceMixin {
  _RecordingLauncher({this.succeed = true});

  final bool succeed;
  final List<String> launched = [];
  final List<LaunchOptions> options = [];

  @override
  LinkDelegate? get linkDelegate => null;

  @override
  Future<bool> canLaunch(String url) async => true;

  @override
  Future<bool> launchUrl(String url, LaunchOptions opts) async {
    launched.add(url);
    options.add(opts);
    return succeed;
  }
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  late _RecordingLauncher launcher;

  Future<void> pump(
    WidgetTester tester, {
    FaithId faith = FaithId.islam,
    bool succeed = true,
  }) async {
    launcher = _RecordingLauncher(succeed: succeed);
    UrlLauncherPlatform.instance = launcher;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          selectedFaithProvider.overrideWith(() => FakeSelectedFaith(faith)),
        ],
        child: MaterialApp.router(
          routerConfig: GoRouter(
            initialLocation: '/settings',
            routes: [
              GoRoute(
                path: '/settings',
                builder: (_, __) => const SettingsScreen(),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
  }

  Future<void> tapRow(WidgetTester tester, String label) async {
    await tester.scrollUntilVisible(
      find.text(label),
      400,
      scrollable: find.byType(Scrollable),
    );
    await tester.tap(find.text(label));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
  }

  for (final faith in FaithId.values) {
    testWidgets('both legal rows are present for ${faith.name}', (
      tester,
    ) async {
      // Play requires the policy to be reachable regardless of which
      // tradition the user picked, so these sit outside the Islam-only
      // block the prayer and script sections live in.
      await pump(tester, faith: faith);
      await tester.scrollUntilVisible(
        find.text('Privacy policy'),
        400,
        scrollable: find.byType(Scrollable),
      );
      expect(find.text('Privacy policy'), findsOneWidget);
      expect(find.text('Terms of service'), findsOneWidget);
    });
  }

  testWidgets('privacy opens the published policy in a real browser', (
    tester,
  ) async {
    await pump(tester);
    await tapRow(tester, 'Privacy policy');

    expect(launcher.launched, ['$kWebBaseUrl/privacy']);
    // externalApplication, not an in-app webview: the user should be able to
    // keep, share or print the page.
    expect(
      launcher.options.single.mode,
      PreferredLaunchMode.externalApplication,
    );
  });

  testWidgets('terms opens the published terms', (tester) async {
    await pump(tester);
    await tapRow(tester, 'Terms of service');

    expect(launcher.launched, ['$kWebBaseUrl/terms']);
  });

  testWidgets('the URLs point at the web app, which Play links to', (
    tester,
  ) async {
    await pump(tester);
    await tapRow(tester, 'Privacy policy');

    final uri = Uri.parse(launcher.launched.single);
    expect(uri.scheme, 'https');
    expect(uri.host, 'www.siraat.website');
    expect(uri.path, '/privacy');
  });

  testWidgets('says so when no browser can take the link', (tester) async {
    await pump(tester, succeed: false);
    await tapRow(tester, 'Privacy policy');

    expect(find.textContaining("Couldn't open"), findsOneWidget);
  });
}
