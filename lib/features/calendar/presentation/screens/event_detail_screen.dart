import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../../../shared/widgets/gap.dart';
import '../../data/dtos/islamic_event.dart';
import '../controllers/calendar_controller.dart';

/// `/today/calendar/event/:id` — single Islamic event detail.
class EventDetailScreen extends ConsumerWidget {
  const EventDetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final eventAsync = ref.watch(islamicEventByIdProvider(id));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () {
            HapticFeedback.lightImpact();
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/today/calendar');
            }
          },
        ),
        title: Text('Event', style: theme.textTheme.titleLarge),
      ),
      body: eventAsync.when(
        loading: () => const _LoadingShimmer(),
        error: (e, _) => _ErrorView(
          message: e.toString(),
          onRetry: () => ref.invalidate(islamicEventsProvider),
        ),
        data: (event) {
          if (event == null) {
            return _NotFoundView(onBack: () => context.go('/today/calendar'));
          }
          return _Content(event: event);
        },
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.event});

  final IslamicEvent event;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final accentText = theme
        .extension<FaithThemeExtension>()!
        .palette
        .accentText;

    final probe = HijriCalendar()
      ..hYear = HijriCalendar.now().hYear
      ..hMonth = event.hijriMonth
      ..hDay = event.hijriDay;
    final monthName = probe.getLongMonthName();
    final greg = probe.hijriToGregorian(
      HijriCalendar.now().hYear,
      event.hijriMonth,
      event.hijriDay,
    );

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
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                cs.surface,
                cs.secondaryContainer.withValues(alpha: 0.4),
              ],
            ),
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(color: cs.outline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (event.importance.toLowerCase() == 'major')
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: cs.secondaryContainer,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    'MAJOR',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: accentText,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              if (event.importance.toLowerCase() == 'major')
                const Gap(AppSpacing.md),
              Text(event.name, style: theme.textTheme.displaySmall),
              if (event.nameArabic != null && event.nameArabic!.isNotEmpty) ...[
                const Gap(AppSpacing.xs),
                Text(event.nameArabic!, style: theme.textTheme.headlineMedium),
              ],
              const Gap(AppSpacing.lg),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 18,
                    color: cs.onSurfaceVariant,
                  ),
                  const Gap.h(AppSpacing.sm),
                  Text(
                    '${event.hijriDay} $monthName',
                    style: theme.textTheme.titleMedium,
                  ),
                ],
              ),
              const Gap(AppSpacing.xs),
              Row(
                children: [
                  Icon(
                    Icons.event_outlined,
                    size: 18,
                    color: cs.onSurfaceVariant,
                  ),
                  const Gap.h(AppSpacing.sm),
                  Text(
                    DateFormat.yMMMMd().format(greg),
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ),
        ),
        if (event.description != null && event.description!.isNotEmpty) ...[
          const Gap(AppSpacing.xl),
          Text('About', style: theme.textTheme.titleLarge),
          const Gap(AppSpacing.md),
          Text(event.description!, style: theme.textTheme.bodyLarge),
        ],
      ],
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
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenEdge),
      child: Shimmer.fromColors(
        baseColor: base,
        highlightColor: highlight,
        child: Container(
          height: 220,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
        ),
      ),
    );
  }
}

class _NotFoundView extends StatelessWidget {
  const _NotFoundView({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenEdge),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_outlined,
              size: 56,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const Gap(AppSpacing.base),
            Text('Event not found', style: theme.textTheme.headlineMedium),
            const Gap(AppSpacing.xs),
            Text(
              'It may have been removed.',
              style: theme.textTheme.bodyMedium,
            ),
            const Gap(AppSpacing.lg),
            FilledButton(
              onPressed: onBack,
              child: const Text('Back to calendar'),
            ),
          ],
        ),
      ),
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
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenEdge),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: 56,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const Gap(AppSpacing.base),
            Text('Couldn\'t load event', style: theme.textTheme.headlineMedium),
            const Gap(AppSpacing.xs),
            Text(message, style: theme.textTheme.bodyMedium),
            const Gap(AppSpacing.lg),
            FilledButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                onRetry();
              },
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
