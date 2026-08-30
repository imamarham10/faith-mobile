import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/sanskrit_text.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../data/dtos/hindu_festival.dart';
import '../controllers/panchang_festivals_controller.dart';

/// `/today/panchang/festival/:slug` — a festival's static metadata. Mirrors
/// `EventDetailScreen`.
class FestivalDetailScreen extends ConsumerWidget {
  const FestivalDetailScreen({super.key, required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final async = ref.watch(hinduFestivalBySlugProvider(slug));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () {
            HapticFeedback.lightImpact();
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/today/panchang');
            }
          },
        ),
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator.adaptive()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Text(
              'We couldn\'t load this festival.',
              style: theme.textTheme.bodyLarge,
            ),
          ),
        ),
        data: (festival) {
          if (festival == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Text(
                  'Festival not found.',
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            );
          }
          return _Content(festival: festival);
        },
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.festival});

  final HinduFestival festival;

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
        AppSpacing.sm,
        AppSpacing.screenEdge,
        AppSpacing.xxl,
      ),
      children: [
        PoppyCard(
          radius: AppRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(festival.nameEnglish, style: theme.textTheme.headlineMedium),
              if ((festival.nameSanskrit ?? '').isNotEmpty) ...[
                const Gap(AppSpacing.xs),
                Text(
                  festival.nameSanskrit!,
                  style: sanskritTextStyle(fontSize: 20, color: cs.onSurfaceVariant),
                ),
              ],
              if (festival.regions.isNotEmpty) ...[
                const Gap(AppSpacing.base),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final r in festival.regions)
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
                          r,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: cs.onSecondaryContainer,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
        if ((festival.description ?? '').isNotEmpty) ...[
          const Gap(AppSpacing.lg),
          Text('About', style: theme.textTheme.titleMedium),
          const Gap(AppSpacing.sm),
          Text(festival.description!, style: theme.textTheme.bodyLarge),
        ],
      ],
    );
  }
}
