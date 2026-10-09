/// The goal picker: what to count, and how much of it.
///
/// Every string, icon, goal type and target choice comes from the active
/// [FaithHabitPack], so this sheet is built once and reads correctly under
/// both faiths with no branch of its own.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_motion.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../../../shared/habit/activity_event.dart';
import '../../../../shared/habit/faith_habit_pack.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/poppy_button.dart';
import '../controllers/goal_controller.dart';

/// Opens the goal picker for [pack], pre-selected on [current] if the user
/// already has a goal.
///
/// `isScrollControlled` and `useSafeArea` because the sheet is taller than
/// half the screen on a small device and must clear the gesture bar.
Future<void> showGoalSheet(
  BuildContext context, {
  required FaithHabitPack pack,
  GoalType? current,
  int? currentTarget,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (_) => GoalSheet(
      pack: pack,
      initialGoalType: current,
      initialTarget: currentTarget,
    ),
  );
}

/// Picks a goal type and a target, then writes it.
class GoalSheet extends ConsumerStatefulWidget {
  /// Builds the sheet.
  const GoalSheet({
    super.key,
    required this.pack,
    this.initialGoalType,
    this.initialTarget,
  });

  /// The active faith's pack.
  final FaithHabitPack pack;

  /// The goal the user already has, if any.
  final GoalType? initialGoalType;

  /// The target they already set, if any.
  final int? initialTarget;

  @override
  ConsumerState<GoalSheet> createState() => _GoalSheetState();
}

class _GoalSheetState extends ConsumerState<GoalSheet> {
  late GoalType _goalType =
      widget.initialGoalType ?? widget.pack.defaultGoalType;
  late int _target =
      widget.initialTarget ?? widget.pack.defaultTargetFor(_goalType);
  bool _saving = false;

  void _selectGoalType(GoalType type) {
    if (type == _goalType) return;
    HapticFeedback.selectionClick();
    setState(() {
      _goalType = type;
      // The previous target may be out of range for the new unit — 20
      // verses is legal, 20 prayers is not (§1.3 caps `prayers` at 5) and
      // the server would reject it as `invalid_target`. Reset to the
      // pack's default rather than clamping, which would silently hand the
      // user a number they did not choose.
      _target = widget.pack.defaultTargetFor(type);
    });
  }

  void _selectTarget(int target) {
    if (target == _target) return;
    HapticFeedback.selectionClick();
    setState(() => _target = target);
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await ref
          .read(goalControllerProvider.notifier)
          .setGoal(
            faith: widget.pack.faith,
            goalType: _goalType,
            target: _target,
          );
      if (!mounted) return;
      HapticFeedback.mediumImpact();
      Navigator.of(context).pop();
    } on Object {
      if (!mounted) return;
      HapticFeedback.heavyImpact();
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Couldn't save your goal. Try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pack = widget.pack;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Daily goal', style: theme.textTheme.headlineSmall),
          const Gap(AppSpacing.xs),
          Text(
            'Meet it to keep your streak. You can change it any time.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const Gap(AppSpacing.lg),
          Text('WHAT TO COUNT', style: theme.textTheme.labelSmall),
          const Gap(AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final type in pack.goalTypes)
                _Choice(
                  label: pack.labelFor(type.counts),
                  icon: pack.iconFor(type.counts),
                  selected: type == _goalType,
                  onTap: () => _selectGoalType(type),
                ),
            ],
          ),
          const Gap(AppSpacing.lg),
          Text('HOW MANY', style: theme.textTheme.labelSmall),
          const Gap(AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final choice in pack.targetChoicesFor(_goalType))
                _Choice(
                  label: '$choice ${pack.unitFor(_goalType, choice)}',
                  selected: choice == _target,
                  onTap: () => _selectTarget(choice),
                ),
            ],
          ),
          const Gap(AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            child: PoppyButton(
              label: _saving
                  ? 'Saving…'
                  : 'Set $_target ${pack.unitFor(_goalType, _target)} a day',
              onPressed: _saving ? null : _save,
            ),
          ),
        ],
      ),
    );
  }
}

class _Choice extends StatelessWidget {
  const _Choice({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.extension<FaithThemeExtension>()!.palette;

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppMotion.cardPress,
          curve: AppMotion.pressCurve,
          // 44pt minimum tap target.
          constraints: const BoxConstraints(minHeight: 44),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.base,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: selected ? palette.secondary : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(
              color: selected ? palette.outline : palette.inkMuted,
              width: 2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: palette.ink),
                const Gap.h(AppSpacing.xs),
              ],
              Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: selected ? palette.ink : palette.inkMuted,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
