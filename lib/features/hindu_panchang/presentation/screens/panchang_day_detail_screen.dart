import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/sanskrit_text.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/poppy_button.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../../../shared/widgets/poppy_skeleton.dart';
import '../../data/dtos/panchang_day.dart';
import '../controllers/panchang_day_controller.dart';

/// `/today/panchang/day/:date` — the full panchang breakdown for one date:
/// all five elements (tithi, nakshatra, yoga, karana, vaara), sun/moon
/// timings, all auspicious/inauspicious windows, and any festivals landing
/// that day.
class PanchangDayDetailScreen extends ConsumerWidget {
  const PanchangDayDetailScreen({super.key, required this.date});

  final String date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final async = ref.watch(panchangByDateProvider(date));
    final parsed = DateTime.tryParse(date);
    final title = parsed != null ? DateFormat.yMMMMd().format(parsed) : date;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(title, style: theme.textTheme.titleLarge),
      ),
      body: async.when(
        loading: () => const _Shimmer(),
        error: (e, _) => _ErrorPanel(
          message: e.toString(),
          onRetry: () => ref.invalidate(panchangByDateProvider(date)),
        ),
        data: (day) {
          if (day == null) {
            return const _ErrorPanel(
              message: 'Location is required to view this day\'s panchang.',
              onRetry: null,
            );
          }
          return _Content(day: day);
        },
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.day});

  final PanchangDay day;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

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
        if (day.festivals.isNotEmpty) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final f in day.festivals)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
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
          const Gap(AppSpacing.lg),
        ],
        PoppyCard(
          radius: AppRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ElementRow(
                label: 'Tithi',
                name: day.tithi.name,
                sanskrit: day.tithi.nameSanskrit,
                detail:
                    '${day.tithi.paksha == 'shukla' ? 'Shukla' : 'Krishna'} Paksha',
              ),
              const _Divider(),
              _ElementRow(
                label: 'Nakshatra',
                name: day.nakshatra.name,
                sanskrit: day.nakshatra.nameSanskrit,
                detail: 'Deity: ${day.nakshatra.deity}',
              ),
              const _Divider(),
              _ElementRow(
                label: 'Yoga',
                name: day.yoga.name,
                sanskrit: day.yoga.nameSanskrit,
              ),
              const _Divider(),
              _ElementRow(
                label: 'Karana',
                name: day.karana.name,
                sanskrit: day.karana.nameSanskrit,
                detail: day.karana.isAuspicious ? 'Auspicious' : null,
              ),
              const _Divider(),
              _ElementRow(
                label: 'Vaara',
                name: day.vaara.name,
                sanskrit: day.vaara.nameSanskrit,
              ),
            ],
          ),
        ),
        const Gap(AppSpacing.lg),
        PoppyCard(
          radius: AppRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _TimeStat(
                      icon: Icons.wb_sunny_outlined,
                      label: 'Sunrise',
                      time: day.sunrise,
                    ),
                  ),
                  Expanded(
                    child: _TimeStat(
                      icon: Icons.wb_twilight_outlined,
                      label: 'Sunset',
                      time: day.sunset,
                    ),
                  ),
                ],
              ),
              if (day.moonrise != null || day.moonset != null) ...[
                const Gap(AppSpacing.base),
                Row(
                  children: [
                    Expanded(
                      child: _TimeStat(
                        icon: Icons.nightlight_outlined,
                        label: 'Moonrise',
                        time: day.moonrise,
                      ),
                    ),
                    Expanded(
                      child: _TimeStat(
                        icon: Icons.dark_mode_outlined,
                        label: 'Moonset',
                        time: day.moonset,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        const Gap(AppSpacing.lg),
        PoppyCard(
          radius: AppRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Auspicious & inauspicious windows', style: theme.textTheme.titleMedium),
              const Gap(AppSpacing.base),
              _WindowRow(
                label: 'Brahma Muhurta',
                good: true,
                window: day.auspicious.brahmaMuhurta,
              ),
              if (day.auspicious.abhijitMuhurta != null)
                _WindowRow(
                  label: 'Abhijit Muhurta',
                  good: true,
                  window: day.auspicious.abhijitMuhurta!,
                ),
              _WindowRow(
                label: 'Rahu Kaal',
                good: false,
                window: day.auspicious.rahuKaal,
              ),
              _WindowRow(
                label: 'Yamagandam',
                good: false,
                window: day.auspicious.yamagandam,
              ),
              _WindowRow(
                label: 'Gulika Kaal',
                good: false,
                window: day.auspicious.gulika,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ElementRow extends StatelessWidget {
  const _ElementRow({
    required this.label,
    required this.name,
    required this.sanskrit,
    this.detail,
  });

  final String label;
  final String name;
  final String sanskrit;
  final String? detail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                color: cs.onSurfaceVariant,
                letterSpacing: 0.8,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sanskrit,
                  style: sanskritTextStyle(fontSize: 17, color: cs.onSurface),
                ),
                Text(
                  detail != null ? '$name · $detail' : name,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        height: 1,
        color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
      ),
    );
  }
}

class _TimeStat extends StatelessWidget {
  const _TimeStat({required this.icon, required this.label, required this.time});

  final IconData icon;
  final String label;
  final DateTime? time;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Row(
      children: [
        Icon(icon, size: 20, color: cs.primary),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(color: cs.onSurfaceVariant),
            ),
            Text(
              time != null ? DateFormat.jm().format(time!.toLocal()) : '—',
              style: theme.textTheme.titleMedium,
            ),
          ],
        ),
      ],
    );
  }
}

class _WindowRow extends StatelessWidget {
  const _WindowRow({required this.label, required this.good, required this.window});

  final String label;
  final bool good;
  final TimeWindow window;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final start = DateFormat.jm().format(window.start.toLocal());
    final end = DateFormat.jm().format(window.end.toLocal());
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            good ? Icons.check_circle_outline : Icons.warning_amber_outlined,
            size: 16,
            color: good ? cs.primary : cs.error,
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
          Text('$start – $end', style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _Shimmer extends StatelessWidget {
  const _Shimmer();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(AppSpacing.screenEdge),
      child: Column(
        children: [
          PoppySkeleton(height: 220, radius: AppRadius.lg),
          Gap(AppSpacing.lg),
          PoppySkeleton(height: 120, radius: AppRadius.lg),
          Gap(AppSpacing.lg),
          PoppySkeleton(height: 180, radius: AppRadius.lg),
        ],
      ),
    );
  }
}

class _ErrorPanel extends StatelessWidget {
  const _ErrorPanel({required this.message, required this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: 36,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const Gap(AppSpacing.md),
            Text(
              'We couldn\'t load this day\'s panchang.',
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const Gap(4),
            Text(
              message,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const Gap(AppSpacing.lg),
              PoppyButton(label: 'Try again', onPressed: onRetry!),
            ],
          ],
        ),
      ),
    );
  }
}
