import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/art/artwork.dart';
import '../../../../core/theme/app_motion.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../../../shared/habit/faith_habit_pack.dart';
import '../../../../shared/widgets/artwork_panel.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/mascot_view.dart';
import '../../../../shared/widgets/poppy_button.dart';
import '../../domain/today_dashboard.dart';

/// "Today's goal — 1 / 5 verses", with a bar — or the invitation to set one.
///
/// The number carries a real unit, never a synthetic currency. Points exist
/// in the design only so a cross-activity leaderboard is possible; they are
/// never what a user is shown.
///
/// A null [goal] is **not** a goal of zero. §5.4 returns `goal: null` only
/// when the user has never set one, precisely so this card can tell that
/// apart from a goal sitting at `progress: 0`, and §2.4 is emphatic that no
/// day can be met until the user has agreed to a target. The first renders
/// as an invitation, the second as an empty ring; collapsing them would
/// leave every new user looking at `0 / 0` with no way to start a streak.
class GoalCard extends StatelessWidget {
  /// Builds the card.
  const GoalCard({
    super.key,
    required this.goal,
    required this.pack,
    required this.onEdit,
  });

  /// Today's goal, or null when none has ever been set.
  final GoalProgress? goal;

  /// The active faith's pack — supplies the prompt copy.
  final FaithHabitPack pack;

  /// Opens the picker.
  final VoidCallback onEdit;

  /// How much of the card's right edge the motif occupies. Narrow enough
  /// that the count and the progress bar keep a clean ground under them at
  /// the narrowest width the project supports (320pt).
  static const double _artWidth = 116;

  /// Clears the label-and-tune row above it.
  static const double _artTopInset = 30;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.extension<FaithThemeExtension>()!.palette;
    final goal = this.goal;

    if (goal == null) {
      return _GoalPrompt(prompt: pack.goalPrompt, onTap: onEdit);
    }

    // The count sits on the left and the right half of this card has always
    // been empty, so the motif goes there — inset and fading leftward into
    // the card rather than sitting behind the numbers, which must stay at
    // full contrast.
    return Stack(
      children: [
        Positioned(
          // Starts below the header row. At `top: 0` the motif ran under the
          // 24pt "Change daily goal" control, which is `inkMuted` on a busy
          // gold-and-lapis ground — it disappeared in light mode. The header
          // row keeps clean card under it.
          top: _artTopInset,
          bottom: 0,
          right: 0,
          width: _artWidth,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: const ArtworkPanel(
              slot: ArtSlot.todayGoal,
              scrim: ArtworkScrim.leftFade,
              alignment: Alignment.centerRight,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    "TODAY'S GOAL",
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                if (goal.isComplete) ...[
                  Icon(Icons.check_circle, size: 16, color: palette.primary),
                  const Gap.h(AppSpacing.xs),
                  Text(
                    'Complete',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: palette.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
                // Always present, complete or not. Hiding it on a met goal
                // locks the user out of changing their target for the rest of
                // the day — and the day they most want to raise it is the day
                // they have just met it.
                Semantics(
                  button: true,
                  label: 'Change daily goal',
                  excludeSemantics: true,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      onEdit();
                    },
                    // 44pt tap target around a 16pt glyph.
                    child: SizedBox(
                      width: 44,
                      height: 24,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.tune,
                          size: 16,
                          color: palette.inkMuted,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Gap(AppSpacing.sm),
            // RichText so the count reads as one phrase to a screen reader
            // instead of three separate nodes.
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '${goal.done}',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: goal.done > 0 ? palette.ink : palette.inkMuted,
                    ),
                  ),
                  TextSpan(
                    text: ' / ${goal.target} ${goal.unit}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: palette.inkMuted,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(AppSpacing.md),
            _GoalBar(fraction: goal.fraction),
          ],
        ),
      ],
    );
  }
}

/// §5.4's never-set-a-goal state: an invitation, not a zero.
class _GoalPrompt extends StatelessWidget {
  const _GoalPrompt({required this.prompt, required this.onTap});

  final String prompt;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<FaithThemeExtension>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "TODAY'S GOAL",
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const Gap(AppSpacing.sm),
                  Text(prompt, style: theme.textTheme.titleMedium),
                ],
              ),
            ),
            const Gap(AppSpacing.md, axis: Axis.horizontal),
            // Asleep because the streak has not started yet — and because
            // `sleep` is the only MascotState that does not animate forever,
            // which matters: this card is inside the Today goldens.
            MascotView(faith: ext.faithId, state: MascotState.sleep, size: 56),
          ],
        ),
        const Gap(AppSpacing.md),
        SizedBox(
          width: double.infinity,
          child: PoppyButton(
            label: 'Set a goal',
            onPressed: () {
              HapticFeedback.lightImpact();
              onTap();
            },
          ),
        ),
      ],
    );
  }
}

class _GoalBar extends StatelessWidget {
  const _GoalBar({required this.fraction});

  final double fraction;

  static const double _height = 12;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<FaithThemeExtension>()!;
    final palette = ext.palette;

    return Semantics(
      value: '${(fraction * 100).round()}%',
      child: Container(
        height: _height,
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(color: palette.outline, width: 2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          child: Align(
            alignment: Alignment.centerLeft,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return TweenAnimationBuilder<double>(
                  tween: Tween<double>(end: fraction),
                  duration: AppMotion.cardSpringBack,
                  curve: AppMotion.enterCurve,
                  builder: (context, value, _) => Container(
                    width: constraints.maxWidth * value,
                    color: palette.primary,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
