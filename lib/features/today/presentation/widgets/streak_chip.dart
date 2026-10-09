import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_motion.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../../../shared/habit/streak_engine.dart';
import '../controllers/today_dashboard_controller.dart';

/// The streak, in the header. **The only streak number on the screen.**
///
/// Task 1.12 retired the other two. `deriveStreak` counted days with *any*
/// logged activity and the Hindu side read `PujaStats.currentStreak`, which
/// is the server's any-activity count — so the app held three definitions
/// across two faiths, and the stat row rendered one of them beside this
/// chip. Two different streak numbers on one screen is not a cosmetic bug:
/// it makes the number unbelievable, and the number is the feature. What
/// remains counts **goal-met days** (§2.5), the same for both faiths.
///
/// Renders **nothing** until a streak is actually known — while the read is
/// in flight, if it fails, and when the user has no run going. A zero and an
/// unknown are different things and neither is worth a chip; a `🔥 0` in the
/// header of a religious-practice app is a daily reminder of failure, which
/// is the opposite of what this is for.
///
/// Not tappable. The design makes this chip the entry point to Circle, but
/// Circle is Phase 3 and `/circle` is not a registered route — pushing an
/// unregistered route throws, and pointing it somewhere else would be worse
/// than inert.
class StreakChip extends ConsumerWidget {
  const StreakChip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streak = ref.watch(todayDashboardProvider).valueOrNull?.streak;
    if (streak == null || streak.current <= 0) return const SizedBox.shrink();
    return _Chip(streak: streak);
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.streak});

  final StreakProjection streak;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.extension<FaithThemeExtension>()!.palette;
    // No `+` suffix any more. The old local derivation could only see a
    // query window and reported a floor; the server's `current` is exact.
    final label = '${streak.current}';

    return Semantics(
      label: '${streak.current} day${streak.current == 1 ? '' : 's'} in a row',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          // Recolours per faith from the tokens alone — marigold under
          // Hindu, amber under Islam — with no duplicated asset.
          color: palette.secondary,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(color: palette.outline, width: 2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.local_fire_department, size: 16, color: palette.ink),
            const SizedBox(width: AppSpacing.xs),
            // §2.7 — reconciliation animates rather than snaps. A silent
            // correction from 25 to 26 reads as a glitch; a brief cross-fade
            // reads as the number updating.
            AnimatedSwitcher(
              duration: AppMotion.cardSpringBack,
              transitionBuilder: (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
              child: Text(
                label,
                key: ValueKey<String>(label),
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: palette.ink,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
