import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/notifications/notification_orchestrator.dart';
import 'core/notifications/notification_service.dart';
import 'core/preferences/selected_faith.dart';
import 'core/preferences/theme_mode.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/faith_id.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  // Init local notifications early so the orchestrator can schedule on first
  // prayer-times load. Permission is requested lazily from the settings UI.
  await NotificationService.instance.init();
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
    return NotificationOrchestrator(
      child: MaterialApp.router(
        title: 'Siraat',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(faith),
        darkTheme: AppTheme.dark(faith),
        themeMode: themeMode,
        routerConfig: router,
        supportedLocales: const [Locale('en')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
  }
}
