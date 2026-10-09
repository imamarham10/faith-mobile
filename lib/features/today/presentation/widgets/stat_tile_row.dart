import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_motion.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../domain/practice_day.dart';
import '../../domain/today_dashboard.dart';

/// Window selector plus the stat tiles beneath it.
///
/// Tiles carry real units — prayers, dhikr, sandhya, japa — never "points".
/// The streak tile is appended here rather than coming from [TodayDashboard.
/// stats] because it is the one number a window does not apply to.
class StatTileRow extends StatefulWidget {
  const StatTileRow({super.key, required this.stats, this.streak});

  final List<StatSeries> stats;
  final PracticeStreak? streak;

  @override
  State<StatTileRow> createState() => _StatTileRowState();
}

class _StatTileRowState extends State<StatTileRow> {
  StatWindow _window = StatWindow.today;

  void _select(StatWindow window) {
    if (window == _window) return;
    HapticFeedback.selectionClick();
    setState(() => _window = window);
  }

  /// Tiles with a gap between each, and none trailing — a dangling gap
  /// would shift the row off-centre whenever a tile is omitted for lack of
  /// honest data, which is a thing that happens here by design.
  List<Widget> _tiles() {
    final streak = widget.streak;
    final cells = <Widget>[
      for (final stat in widget.stats)
        _Tile(label: stat.label, value: '${stat.valueFor(_window)}'),
      // `days > 0`, not just non-null: the local derivation returns a
      // zero streak rather than null for a user with no history, and a
      // tile reading "0 / Day streak" on a fresh install is a daily
      // reminder of failure. StreakChip hides on the same condition —
      // the two must agree or the header and the row contradict.
      if (streak != null && streak.days > 0)
        _Tile(
          label: 'Day streak',
          // "12+" when the run reaches the edge of the history the server
          // will return — an understated streak reads as a bug to the
          // person who earned it.
          value: '${streak.days}${streak.isFloor ? '+' : ''}',
        ),
    ];
    return <Widget>[
      for (var i = 0; i < cells.length; i++) ...[
        if (i > 0) const Gap.h(AppSpacing.sm),
        Expanded(child: cells[i]),
      ],
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (widget.stats.isEmpty && widget.streak == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _WindowSelector(selected: _window, onSelect: _select),
        const Gap(AppSpacing.md),
        // IntrinsicHeight so the tiles match the tallest of them. Without
        // it, `CrossAxisAlignment.stretch` on a Row whose height is
        // unconstrained — which is exactly where this sits, inside a
        // scrolling Column — forces an infinite height and fails layout.
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _tiles(),
          ),
        ),
      ],
    );
  }
}

class _WindowSelector extends StatelessWidget {
  const _WindowSelector({required this.selected, required this.onSelect});

  final StatWindow selected;
  final ValueChanged<StatWindow> onSelect;

  @override
  Widget build(BuildContext context) {
    const windows = StatWindow.values;
    return Row(
      children: [
        for (var i = 0; i < windows.length; i++) ...[
          if (i > 0) const Gap.h(AppSpacing.sm),
          _WindowChip(
            label: windows[i].label,
            selected: windows[i] == selected,
            onTap: () => onSelect(windows[i]),
          ),
        ],
      ],
    );
  }
}

class _WindowChip extends StatelessWidget {
  const _WindowChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<FaithThemeExtension>()!;
    final palette = ext.palette;

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
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.base,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: selected ? palette.secondary : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(
              color: selected ? palette.outline : Colors.transparent,
              width: 2,
            ),
          ),
          child: Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: selected ? palette.ink : palette.inkMuted,
              fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.extension<FaithThemeExtension>()!.palette;

    return PoppyCard(
      radius: AppRadius.lg,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.base,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // The numeral must not shrink the tile below its siblings when it
          // grows to three digits, nor wrap. FittedBox scales it instead.
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              maxLines: 1,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: palette.ink,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelSmall?.copyWith(
              color: palette.inkMuted,
            ),
          ),
        ],
      ),
    );
  }
}
