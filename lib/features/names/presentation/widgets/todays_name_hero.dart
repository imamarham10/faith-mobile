import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/arabic_text.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../../../shared/widgets/gap.dart';
import '../../data/dtos/divine_name.dart';

/// Big card at the top of each tab — "Name of the day".
///
/// Tap → routes to the matching name detail screen.
class TodaysNameHero extends ConsumerWidget {
  const TodaysNameHero({super.key, required this.name, required this.onTap});

  final DivineName name;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final accentText = theme
        .extension<FaithThemeExtension>()!
        .palette
        .accentText;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        child: Ink(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(color: cs.outline),
          ),
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name of the day'.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(color: accentText),
              ),
              const Gap(AppSpacing.lg),
              Center(
                child: Text(
                  name.nameArabic,
                  style: arabicTextStyleOf(
                    ref,
                    fontSize: 44,
                    height: 1.4,
                    color: cs.onSurface,
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Gap(AppSpacing.md),
              Center(
                child: Text(
                  name.nameTranslit,
                  style: theme.textTheme.displaySmall?.copyWith(fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
              const Gap(AppSpacing.xs),
              Center(
                child: Text(
                  name.meaning ?? name.nameEnglish,
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              const Gap(AppSpacing.lg),
              Container(
                width: 40,
                height: 1,
                color: cs.secondary.withValues(alpha: 0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
