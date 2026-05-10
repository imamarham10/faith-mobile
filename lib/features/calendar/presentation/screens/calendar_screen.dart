import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/section_label.dart';
import '../controllers/calendar_controller.dart';
import '../widgets/event_tile.dart';
import '../widgets/hijri_month_grid.dart';

/// `/today/calendar` — Hijri / Gregorian month browser + Islamic events.
class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final monthAsync = ref.watch(calendarMonthProvider);
    final anchor = ref.watch(calendarAnchorControllerProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () {
            HapticFeedback.lightImpact();
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/today');
            }
          },
        ),
        title: Text('Calendar', style: theme.textTheme.titleLarge),
      ),
      body: monthAsync.when(
        loading: () => const _LoadingShimmer(),
        error: (e, _) => _ErrorView(
          message: e.toString(),
          onRetry: () => ref.invalidate(islamicEventsProvider),
        ),
        data: (data) => _Content(data: data, mode: anchor.mode),
      ),
    );
  }
}

class _Content extends ConsumerWidget {
  const _Content({required this.data, required this.mode});

  final CalendarMonthData data;
  final CalendarMode mode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return ListView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenEdge,
        AppSpacing.lg,
        AppSpacing.screenEdge,
        AppSpacing.xxl,
      ),
      children: [
        _MonthHeader(
          hijriLabel: data.hijriMonthLabel,
          gregorianLabel: data.gregorianMonthLabel,
          mode: mode,
          onPrev: () {
            HapticFeedback.selectionClick();
            ref.read(calendarAnchorControllerProvider.notifier).previous();
          },
          onNext: () {
            HapticFeedback.selectionClick();
            ref.read(calendarAnchorControllerProvider.notifier).next();
          },
        ),
        const Gap(AppSpacing.lg),
        _ModeToggle(
          mode: mode,
          onChanged: (m) {
            HapticFeedback.selectionClick();
            ref.read(calendarAnchorControllerProvider.notifier).setMode(m);
          },
        ),
        const Gap(AppSpacing.lg),
        HijriMonthGrid(
          cells: data.cells,
          mode: mode,
          onDayTap: (cell) {
            if (cell.events.isEmpty) return;
            HapticFeedback.lightImpact();
            context.push('/today/calendar/event/${cell.events.first.id}');
          },
        ),
        const Gap(AppSpacing.xxl),
        const SectionLabel('Events this month'),
        const Gap(AppSpacing.md),
        if (data.eventsThisMonth.isEmpty)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.base,
              vertical: AppSpacing.lg,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: theme.colorScheme.outline),
            ),
            child: Text(
              'No major Islamic events this month.',
              style: theme.textTheme.bodyMedium,
            ),
          )
        else
          ...data.eventsThisMonth.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: EventTile(
                event: e,
                onTap: () => context.push('/today/calendar/event/${e.id}'),
              ),
            ),
          ),
      ],
    );
  }
}

class _MonthHeader extends StatelessWidget {
  const _MonthHeader({
    required this.hijriLabel,
    required this.gregorianLabel,
    required this.mode,
    required this.onPrev,
    required this.onNext,
  });

  final String hijriLabel;
  final String gregorianLabel;
  final CalendarMode mode;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = mode == CalendarMode.hijri ? hijriLabel : gregorianLabel;
    final secondary = mode == CalendarMode.hijri ? gregorianLabel : hijriLabel;

    return Row(
      children: [
        _ChevronButton(
          icon: Icons.chevron_left,
          onPressed: onPrev,
          tooltip: 'Previous month',
        ),
        const Gap.h(AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(primary, style: theme.textTheme.headlineMedium),
              const Gap(2),
              Text(secondary, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
        _ChevronButton(
          icon: Icons.chevron_right,
          onPressed: onNext,
          tooltip: 'Next month',
        ),
      ],
    );
  }
}

class _ChevronButton extends StatelessWidget {
  const _ChevronButton({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Tooltip(
      message: tooltip,
      child: SizedBox(
        width: 44,
        height: 44,
        child: Material(
          color: theme.colorScheme.surface,
          shape: CircleBorder(
            side: BorderSide(color: theme.colorScheme.outline),
          ),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onPressed,
            child: Icon(icon, color: theme.colorScheme.onSurface, size: 22),
          ),
        ),
      ),
    );
  }
}

class _ModeToggle extends StatelessWidget {
  const _ModeToggle({required this.mode, required this.onChanged});

  final CalendarMode mode;
  final ValueChanged<CalendarMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ToggleSegment(
              label: 'Hijri',
              selected: mode == CalendarMode.hijri,
              onTap: () => onChanged(CalendarMode.hijri),
            ),
          ),
          Expanded(
            child: _ToggleSegment(
              label: 'Gregorian',
              selected: mode == CalendarMode.gregorian,
              onTap: () => onChanged(CalendarMode.gregorian),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleSegment extends StatelessWidget {
  const _ToggleSegment({
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
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? theme.colorScheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: theme.textTheme.titleMedium?.copyWith(
              color: selected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

class _LoadingShimmer extends StatelessWidget {
  const _LoadingShimmer();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final base = theme.colorScheme.outline.withValues(alpha: 0.4);
    final highlight = theme.colorScheme.surface;
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenEdge,
        AppSpacing.lg,
        AppSpacing.screenEdge,
        AppSpacing.xxl,
      ),
      children: [
        Shimmer.fromColors(
          baseColor: base,
          highlightColor: highlight,
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
        ),
        const Gap(AppSpacing.lg),
        Shimmer.fromColors(
          baseColor: base,
          highlightColor: highlight,
          child: Container(
            height: 320,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
          ),
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
      children: [
        const Gap(120),
        Icon(
          Icons.cloud_off_outlined,
          size: 56,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const Gap(AppSpacing.base),
        Text(
          'Couldn\'t load the calendar',
          style: theme.textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const Gap(AppSpacing.xs),
        Text(
          message,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium,
        ),
        const Gap(AppSpacing.lg),
        Center(
          child: FilledButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              onRetry();
            },
            child: const Text('Try again'),
          ),
        ),
      ],
    );
  }
}
