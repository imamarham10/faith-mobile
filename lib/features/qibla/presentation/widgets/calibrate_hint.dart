import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/faith_theme_extension.dart';

/// Small "calibrate the compass" prompt shown when the magnetometer's
/// accuracy is low or unavailable.
class CalibrateHint extends StatelessWidget {
  const CalibrateHint({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final accentText = theme
        .extension<FaithThemeExtension>()!
        .palette
        .accentText;
    return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(color: cs.outline),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.compare_arrows_rounded, size: 16, color: accentText),
              const SizedBox(width: 8),
              Text(
                'Calibrate · move phone in a figure-8',
                style: theme.textTheme.labelMedium,
              ),
            ],
          ),
        )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .fadeIn(duration: 260.ms)
        .then()
        .fade(begin: 1, end: 0.55, duration: 1200.ms);
  }
}
