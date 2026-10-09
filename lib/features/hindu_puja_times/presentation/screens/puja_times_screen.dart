import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/location/location_service.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/poppy_button.dart';
import '../../../../shared/widgets/poppy_skeleton.dart';
import '../../../../shared/widgets/section_label.dart';
import '../../../../shared/widgets/stat_chip.dart';
import '../../data/dtos/puja_times.dart';
import '../controllers/puja_log_controller.dart';
import '../controllers/puja_times_controller.dart';
import '../widgets/log_action_sheet.dart';
import '../widgets/sandhya_row.dart';

/// `/today/puja-times` — today's three sandhya windows, tap-to-log, and a
/// compact stats summary. Mirrors `PrayerDetailScreen`, minus the qaza
/// tracker sub-route (no qada-equivalent concept here) and minus the
/// calculation-method picker (puja times have no method choice).
class PujaTimesScreen extends ConsumerWidget {
  const PujaTimesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final timesAsync = ref.watch(pujaTimesControllerProvider);

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
        title: Text('Puja Times', style: theme.textTheme.titleLarge),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(pujaTimesControllerProvider.notifier).refresh();
          ref.invalidate(todayPujaLogsProvider);
          ref.invalidate(pujaStatsControllerProvider);
        },
        child: timesAsync.when(
          loading: () => const _LoadingShimmer(),
          error: (e, _) => _ErrorView(
            message: e.toString(),
            onRetry: () =>
                ref.read(pujaTimesControllerProvider.notifier).refresh(),
          ),
          data: (data) {
            if (data == null) {
              return _LocationDeniedView(
                onEnable: () async {
                  final granted = await ref
                      .read(locationServiceProvider)
                      .ensurePermission();
                  if (granted) {
                    await ref
                        .read(pujaTimesControllerProvider.notifier)
                        .refresh();
                  }
                },
              );
            }
            return _Content(times: data.times);
          },
        ),
      ),
    );
  }
}

class _Content extends ConsumerWidget {
  const _Content({required this.times});

  final PujaTimes times;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(todayPujaLogsProvider);
    final statsAsync = ref.watch(pujaStatsControllerProvider);
    final logs = logsAsync.valueOrNull ?? const {};
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
        statsAsync.maybeWhen(
          data: (stats) => stats.total == 0
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                  child: Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      StatChip(
                        value: '${stats.currentStreak}',
                        label: 'day streak',
                        icon: Icons.local_fire_department_outlined,
                      ),
                      StatChip(
                        value: '${stats.completionRate.round()}%',
                        label: 'on time',
                        icon: Icons.check_circle_outline,
                      ),
                    ],
                  ),
                ),
          orElse: () => const SizedBox.shrink(),
        ),
        const SectionLabel('Today'),
        const Gap(AppSpacing.md),
        for (final sandhya in times.sandhyas) ...[
          SandhyaRow(
            sandhya: sandhya,
            state: sandhya.band.end.isBefore(now)
                ? SandhyaRowState.past
                : sandhya.isCurrent
                ? SandhyaRowState.current
                : SandhyaRowState.future,
            log: logs[sandhya.name],
            onTap: () async {
              final status = await showPujaLogActionSheet(
                context,
                sandhyaDisplayName: sandhya.nameEnglish,
              );
              if (status == null) return;
              await ref
                  .read(todayPujaLogsProvider.notifier)
                  .log(sandhya: sandhya.name, status: status);
            },
          ),
          const Gap(AppSpacing.sm),
        ],
      ],
    );
  }
}

class _LoadingShimmer extends StatelessWidget {
  const _LoadingShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenEdge,
        AppSpacing.lg,
        AppSpacing.screenEdge,
        AppSpacing.xxl,
      ),
      children: const [
        PoppySkeleton(height: 28, radius: AppRadius.sm),
        Gap(AppSpacing.lg),
        PoppySkeleton(height: 72, radius: AppRadius.lg),
        Gap(AppSpacing.sm),
        PoppySkeleton(height: 72, radius: AppRadius.lg),
        Gap(AppSpacing.sm),
        PoppySkeleton(height: 72, radius: AppRadius.lg),
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
          'Enable location for accurate puja times',
          style: theme.textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const Gap(AppSpacing.xs),
        Text(
          'We use your coordinates only to compute today\'s sandhya windows.',
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
          'Couldn\'t load puja times',
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
          child: PoppyButton(label: 'Try again', onPressed: onRetry),
        ),
      ],
    );
  }
}
