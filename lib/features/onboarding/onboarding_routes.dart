import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import 'presentation/screens/faith_selection_screen.dart';
import 'presentation/screens/onboarding_screen.dart';

/// First-launch onboarding: 2-slide intro then faith selection.
final onboardingRoutes = <RouteBase>[
  GoRoute(
    path: Routes.onboarding,
    builder: (_, __) => const OnboardingScreen(),
  ),
  GoRoute(
    path: Routes.faithSelection,
    builder: (_, __) => const FaithSelectionScreen(),
  ),
];
