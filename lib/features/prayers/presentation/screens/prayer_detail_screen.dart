import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/location/request_location_access.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/section_label.dart';
import '../../../../shared/widgets/poppy_button.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../data/dtos/prayer_log.dart';
import '../../data/dtos/prayer_times.dart';
import '../../domain/next_prayer.dart';
import '../controllers/prayer_log_controller.dart';
import '../controllers/prayer_times_controller.dart';
import '../widgets/log_action_sheet.dart';
import '../widgets/prayer_arc.dart';
import '../widgets/prayer_row.dart';

/// `/today/prayers` — full schedule + per-prayer logging.
class PrayerDetailScreen extends ConsumerWidget {
  const PrayerDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final timesAsync = ref.watch(prayerTimesControllerProvider);

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
        title: Text('Prayers', style: theme.textTheme.titleLarge),
        actions: [
          IconButton(
            tooltip: 'Calculation method',
            icon: const Icon(Icons.tune),
            onPressed: () {
              HapticFeedback.selectionClick();
              _showMethodPicker(context, ref);
            },
          ),
          IconButton(
            tooltip: 'Qaḍāʾ tracker',
            icon: const Icon(Icons.history_outlined),
            onPressed: () {
              HapticFeedback.lightImpact();
              context.push('/today/prayers/qaza');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(prayerTimesControllerProvider.notifier).refresh();
          ref.invalidate(todayLogsProvider);
        },
        child: timesAsync.when(
          loading: () => const _LoadingShimmer(),
          error: (e, _) => _ErrorView(
            message: e.toString(),
            onRetry: () =>
                ref.read(prayerTimesControllerProvider.notifier).refresh(),
          ),
          data: (data) {
            if (data == null) {
              return _LocationDeniedView(
                onEnable: () async {
                  final granted = await requestLocationAccess(context, ref);
                  if (granted) {
                    await ref
                        .read(prayerTimesControllerProvider.notifier)
                        .refresh();
                  }
                },
              );
            }
            return _Content(times: data.times, next: data.next);
          },
        ),
      ),
    );
  }

  Future<void> _showMethodPicker(BuildContext context, WidgetRef ref) async {
    final current = await ref.read(calcMethodPrefProvider.future);
    if (!context.mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (ctx) => _MethodPickerSheet(currentCode: current),
    );
  }
}

class _Content extends ConsumerWidget {
  const _Content({required this.times, required this.next});

  final PrayerTimes times;
  final NextPrayer next;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final logsAsync = ref.watch(todayLogsProvider);
    final logs = logsAsync.value ?? const <String, PrayerLog>{};
    final now = DateTime.now();

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
        PoppyCard(
          radius: AppRadius.xl,
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.base,
            AppSpacing.lg,
            AppSpacing.base,
            AppSpacing.base,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Up next',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    next.displayName,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const Gap(AppSpacing.sm),
              PrayerArc(times: times, now: now, activeKey: next.key),
            ],
          ),
        ),
        const Gap(AppSpacing.xl),
        const SectionLabel('Today'),
        const Gap(AppSpacing.md),
        ...times.entries.map((e) {
          final state = !e.isPrayer
              ? PrayerRowState.informational
              : (e.key == next.key
                    ? PrayerRowState.current
                    : (e.time.isBefore(now)
                          ? PrayerRowState.past
                          : PrayerRowState.future));
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: PrayerRow(
              displayName: e.displayName,
              time: e.time,
              state: state,
              log: logs[e.key],
              canLog: e.isPrayer,
              onTap: () => _onLogTap(context, ref, e.key, e.displayName),
            ),
          );
        }),
      ],
    );
  }

  Future<void> _onLogTap(
    BuildContext context,
    WidgetRef ref,
    String key,
    String displayName,
  ) async {
    final status = await showLogActionSheet(
      context,
      prayerDisplayName: displayName,
    );
    if (status == null || !context.mounted) return;
    try {
      await ref
          .read(todayLogsProvider.notifier)
          .log(prayerName: key, status: status);
      if (!context.mounted) return;
      HapticFeedback.heavyImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$displayName logged · ${status.label}'),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Couldn\'t log: $e')));
    }
  }
}

class _MethodPickerSheet extends ConsumerWidget {
  const _MethodPickerSheet({required this.currentCode});

  final String currentCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenEdge,
        AppSpacing.sm,
        AppSpacing.screenEdge,
        AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Calculation method', style: theme.textTheme.headlineMedium),
          const Gap(AppSpacing.xs),
          Text(
            'Influences Fajr and ʿIshāʾ. Restart of times triggers automatically.',
            style: theme.textTheme.bodyMedium,
          ),
          const Gap(AppSpacing.lg),
          ...CalcMethod.all.map((m) {
            final selected = m.code == currentCode;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: PoppyCard(
                radius: AppRadius.md,
                color: selected ? theme.colorScheme.primaryContainer : null,
                borderColor: selected
                    ? theme.colorScheme.primary.withValues(alpha: 0.4)
                    : null,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.base,
                  vertical: AppSpacing.md,
                ),
                onTap: () async {
                  HapticFeedback.selectionClick();
                  await ref.read(calcMethodPrefProvider.notifier).set(m.code);
                  if (context.mounted) Navigator.of(context).pop();
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(m.label, style: theme.textTheme.titleMedium),
                          const Gap(2),
                          Text(m.code, style: theme.textTheme.bodySmall),
                        ],
                      ),
                    ),
                    if (selected)
                      Icon(
                        Icons.check_circle,
                        color: theme.colorScheme.primary,
                        size: 22,
                      ),
                  ],
                ),
              ),
            );
          }),
        ],
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
            height: 130,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
          ),
        ),
        const Gap(AppSpacing.xl),
        for (var i = 0; i < 5; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Shimmer.fromColors(
              baseColor: base,
              highlightColor: highlight,
              child: Container(
                height: 64,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
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
          'Couldn\'t load prayer times',
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
        PoppyButton(
          label: 'Try again',
          onPressed: () {
            HapticFeedback.lightImpact();
            onRetry();
          },
        ),
      ],
    );
  }
}

class _LocationDeniedView extends StatelessWidget {
  const _LocationDeniedView({required this.onEnable});

  final VoidCallback onEnable;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
      children: [
        const Gap(120),
        Icon(
          Icons.location_off_outlined,
          size: 56,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const Gap(AppSpacing.base),
        Text(
          'Enable location for accurate prayer times',
          style: theme.textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const Gap(AppSpacing.xs),
        Text(
          'We use your coordinates only to compute today\'s schedule.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium,
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
    );
  }
}
