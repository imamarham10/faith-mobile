import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import 'presentation/screens/delete_account_screen.dart';
import 'presentation/screens/settings_screen.dart';

/// `/settings` lives outside the StatefulShellRoute so it pushes a new full
/// screen rather than swapping a tab branch.
final settingsRoutes = <RouteBase>[
  GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
  GoRoute(
    path: Routes.deleteAccount,
    builder: (_, __) => const DeleteAccountScreen(),
  ),
];
