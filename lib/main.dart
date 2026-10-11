import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/network/dio_client.dart';
import 'core/notifications/notification_orchestrator.dart';
import 'core/notifications/notification_service.dart';
import 'core/preferences/selected_faith.dart';
import 'core/preferences/theme_mode.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/faith_id.dart';
import 'core/time/device_timezone.dart';
import 'shared/habit/activity_flush_scheduler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Backstop to the const assert in dio_client.dart: that one stops the build
  // when API_BASE_URL was never passed, this one catches a define that was
  // passed but is unusable in a release binary (loopback host, plain http).
  // Crashing at boot beats every request failing with an opaque socket error.
  assertApiBaseUrlIsProductionSafe(
    url: kApiBaseUrl,
    isReleaseBuild: kReleaseMode,
  );
  // Init local notifications early so the orchestrator can schedule on first
  // prayer-times load. Permission is requested lazily from the settings UI.
  await NotificationService.instance.init();
  // Read the device's IANA zone before the first screen can record anything
  // (contract §1.5). Awaited rather than fired off because it is one method
  // channel round trip and `ActivityRecorder` reads the result synchronously;
  // it never throws, so it cannot hold up the boot.
  await DeviceTimezone.instance.start();
  runApp(const ProviderScope(child: FaithApp()));
}

class FaithApp extends ConsumerWidget {
  const FaithApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode =
        ref.watch(themeModePrefProvider).valueOrNull ?? ThemeMode.system;
    final faith = ref.watch(selectedFaithProvider).valueOrNull ?? FaithId.islam;
    // Both wrappers are side-effect carriers that render their child
    // verbatim. ActivityFlushScope is outermost so the queue starts
    // draining on the very first frame, before any screen has mounted —
    // rows can survive a kill, so there may be events waiting from a
    // previous run that no lifecycle event will ever announce.
    return ActivityFlushScope(
      child: NotificationOrchestrator(
        child: MaterialApp.router(
          title: 'Siraat',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(faith),
          darkTheme: AppTheme.dark(faith),
          themeMode: themeMode,
          routerConfig: router,
          // Publishes the same overlay style the AppBarTheme carries, so the
          // five PageMasthead screens (which have no AppBar, and so no
          // AnnotatedRegion of their own) stop falling back to a style with
          // no icon brightness. Without this the platform value changed as
          // you moved between AppBar and AppBar-less screens, which is what
          // was flickering the status bar. See `systemOverlayStyleFor`.
          builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
            value: systemOverlayStyleFor(Theme.of(context).brightness),
            child: child ?? const SizedBox.shrink(),
          ),
          supportedLocales: const [Locale('en')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        ),
      ),
    );
  }
}
