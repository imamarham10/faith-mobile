import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/faith_id.dart';
import 'gap.dart';
import 'mascot_view.dart';

/// Shared "not built yet" placeholder for Hindu tab slots ahead of the
/// matching Part C task landing. Mirrors the honest-placeholder pattern
/// established in Part B (`_HinduTodayPlaceholder` et al.) — a real screen
/// replaces this once its module exists; this is not a permanent UI.
class HinduComingSoonPlaceholder extends StatelessWidget {
  const HinduComingSoonPlaceholder({super.key, required this.label});

  /// e.g. "Scripture" — used as "Hindu $label is coming soon".
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenEdge,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const MascotView(faith: FaithId.hindu, state: MascotState.idle),
                const Gap(AppSpacing.lg),
                Text(
                  'Hindu $label is coming soon',
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const Gap(AppSpacing.sm),
                Text(
                  'We\'re building this out next — check back soon.',
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
