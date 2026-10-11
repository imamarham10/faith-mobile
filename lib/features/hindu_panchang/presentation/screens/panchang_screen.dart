import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/art/artwork.dart';
import '../../../../core/location/request_location_access.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/sanskrit_text.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/illustrated_empty_state.dart';
import '../../../../shared/widgets/mascot_view.dart';
import '../../../../shared/widgets/poppy_button.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../../../shared/widgets/poppy_skeleton.dart';
import '../../../../shared/widgets/section_label.dart';
import '../../data/dtos/panchang_day.dart';
import '../controllers/panchang_festivals_controller.dart';
import '../controllers/panchang_month_controller.dart';
import '../controllers/panchang_today_controller.dart';
import '../widgets/festival_tile.dart';
import '../widgets/panchang_month_grid.dart';

/// `/today/panchang` — today's panchang summary, a month grid, and upcoming
/// festivals. Mirrors `CalendarScreen` structurally, minus the Hijri/
/// Gregorian mode toggle (panchang is Gregorian-native) and with a real
/// per-day summary up top (every day has substantive panchang data, unlike
/// calendar's event-only detail screens).
class PanchangScreen extends ConsumerWidget {
  const PanchangScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final anchor = ref.watch(panchangAnchorControllerProvider);
    final gridAsync = ref.watch(
      panchangMonthGridProvider(anchor.year, anchor.month),
    );

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
        title: Text('Panchang', style: theme.textTheme.titleLarge),
      ),
      body: ListView(
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
          const _TodaySummaryCard(),
          const Gap(AppSpacing.xl),
          _MonthHeader(
            label:
                gridAsync.valueOrNull?.monthLabel ??
                '${anchor.month}/${anchor.year}',
            onPrev: () {
              HapticFeedback.selectionClick();
              ref.read(panchangAnchorControllerProvider.notifier).previous();
            },
            onNext: () {
              HapticFeedback.selectionClick();
              ref.read(panchangAnchorControllerProvider.notifier).next();
            },
          ),
          const Gap(AppSpacing.lg),
          gridAsync.when(
            loading: () =>
                const PoppySkeleton(height: 320, radius: AppRadius.lg),
            error: (e, _) => _ErrorPanel(
              message: e.toString(),
              onRetry: () => ref.invalidate(
                panchangMonthGridProvider(anchor.year, anchor.month),
              ),
            ),
            data: (grid) {
              if (grid == null) {
                return _LocationDeniedPanel(
                  onEnable: () async {
                    final granted = await requestLocationAccess(context, ref);
                    if (granted) {
                      ref.invalidate(
                        panchangMonthGridProvider(anchor.year, anchor.month),
                      );
                    }
                  },
                );
              }
              return PanchangMonthGrid(
                cells: grid.cells,
                onDayTap: (cell) {
                  HapticFeedback.lightImpact();
                  final dateStr = DateFormat('yyyy-MM-dd').format(cell.date);
                  context.push('/today/panchang/day/$dateStr');
                },
              );
            },
          ),
          const Gap(AppSpacing.xxl),
          const SectionLabel('Upcoming festivals'),
          const Gap(AppSpacing.md),
          const _UpcomingFestivalsList(),
        ],
      ),
    );
  }
}

class _TodaySummaryCard extends ConsumerWidget {
  const _TodaySummaryCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final async = ref.watch(panchangTodayControllerProvider);

    return async.when(
      loading: () => const PoppySkeleton(height: 160, radius: AppRadius.lg),
      error: (e, _) => PoppyCard(
        radius: AppRadius.lg,
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Text(
          'Couldn\'t load today\'s panchang.',
          style: theme.textTheme.bodyMedium,
        ),
      ),
      data: (day) {
        if (day == null) {
          return _LocationDeniedPanel(
            compact: true,
            onEnable: () async {
              final granted = await requestLocationAccess(context, ref);
              if (granted) {
                await ref
                    .read(panchangTodayControllerProvider.notifier)
                    .refresh();
              }
            },
          );
        }
        return _PanchangSummary(day: day);
      },
    );
  }
}

class _PanchangSummary extends StatelessWidget {
  const _PanchangSummary({required this.day});

  final PanchangDay day;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return PoppyCard(
      radius: AppRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            day.tithi.nameSanskrit,
            style: sanskritTextStyle(fontSize: 24, color: cs.onSurface),
          ),
          const Gap(2),
          Text(
            '${day.tithi.name} · ${day.tithi.paksha == 'shukla' ? 'Shukla' : 'Krishna'} Paksha',
            style: theme.textTheme.bodyMedium,
          ),
          const Gap(AppSpacing.base),
          Row(
            children: [
              Expanded(
                child: _Stat(label: 'Nakshatra', value: day.nakshatra.name),
              ),
              Expanded(
                child: _Stat(label: 'Yoga', value: day.yoga.name),
              ),
            ],
          ),
          const Gap(AppSpacing.base),
          Row(
            children: [
              Expanded(
                child: _Stat(
                  label: 'Sunrise',
                  value: DateFormat.jm().format(day.sunrise.toLocal()),
                ),
              ),
              Expanded(
                child: _Stat(
                  label: 'Sunset',
                  value: DateFormat.jm().format(day.sunset.toLocal()),
                ),
              ),
            ],
          ),
          if (day.festivals.isNotEmpty) ...[
            const Gap(AppSpacing.base),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final f in day.festivals)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: cs.primaryContainer,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Text(
                      f.nameEnglish,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: cs.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 2),
        Text(value, style: theme.textTheme.titleMedium),
      ],
    );
  }
}

class _UpcomingFestivalsList extends ConsumerWidget {
  const _UpcomingFestivalsList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final async = ref.watch(upcomingFestivalsControllerProvider);

    return async.when(
      loading: () => const PoppySkeleton(height: 72, radius: AppRadius.lg),
      error: (e, _) => PoppyCard(
        radius: AppRadius.md,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.base,
          vertical: AppSpacing.lg,
        ),
        child: Text(
          'Couldn\'t load upcoming festivals.',
          style: theme.textTheme.bodyMedium,
        ),
      ),
      data: (list) {
        if (list == null) return const SizedBox.shrink();
        if (list.isEmpty) {
          return const IllustratedEmptyState(
            title: 'A quiet season',
            message: 'No festivals in the next 90 days.',
            slot: ArtSlot.emptyDormant,
            mascot: MascotState.sleep,
          );
        }
        return Column(
          children: [
            for (final occ in list.take(10))
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: FestivalTile(
                  occurrence: occ,
                  onTap: () => context.push(
                    '/today/panchang/festival/${occ.festival.slug}',
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _MonthHeader extends StatelessWidget {
  const _MonthHeader({
    required this.label,
    required this.onPrev,
    required this.onNext,
  });

  final String label;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        _ChevronButton(
          icon: Icons.chevron_left,
          onPressed: onPrev,
          tooltip: 'Previous month',
        ),
        const Gap.h(AppSpacing.sm),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.headlineMedium,
            textAlign: TextAlign.center,
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

class _LocationDeniedPanel extends StatelessWidget {
  const _LocationDeniedPanel({required this.onEnable, this.compact = false});

  final VoidCallback onEnable;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PoppyCard(
      radius: AppRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        children: [
          Icon(
            Icons.location_off_outlined,
            size: compact ? 32 : 56,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const Gap(AppSpacing.base),
          Text(
            'Enable location for today\'s panchang',
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const Gap(AppSpacing.xs),
          Text(
            'We use your coordinates only to compute tithi, nakshatra, and muhurta timings.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall,
          ),
          const Gap(AppSpacing.lg),
          PoppyButton(
            label: 'Enable location',
            onPressed: () {
              HapticFeedback.lightImpact();
              onEnable();
            },
          ),
        ],
      ),
    );
  }
}

class _ErrorPanel extends StatelessWidget {
  const _ErrorPanel({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PoppyCard(
      radius: AppRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Couldn\'t load the calendar',
            style: theme.textTheme.titleMedium,
          ),
          const Gap(6),
          Text(message, style: theme.textTheme.bodySmall),
          const Gap(12),
          PoppyButton(label: 'Try again', onPressed: onRetry),
        ],
      ),
    );
  }
}
