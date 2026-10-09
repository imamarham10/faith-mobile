import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/location/location_service.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/poppy_button.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../../../shared/widgets/poppy_skeleton.dart';
import '../../../../shared/widgets/section_label.dart';
import '../controllers/nearby_temples_controller.dart';
import '../controllers/temple_favorites_controller.dart';
import '../controllers/temples_browse_controller.dart';
import '../widgets/temple_list_tile.dart';

/// `/practice/temples` — nearby temples (location-gated), search shortcut,
/// browse-by-state and browse-by-deity chip rows, and a pinned Favorites
/// entry. Mirrors `StoriesHomeScreen`'s section shape, with a nearby-list
/// section on top like `PrayerTimesScreen`/`PanchangScreen`.
class TemplesHomeScreen extends ConsumerWidget {
  const TemplesHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final favoritesAsync = ref.watch(templeFavoritesControllerProvider);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
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
            Text('Temples', style: theme.textTheme.displaySmall),
            const SizedBox(height: 4),
            Text(
              'Find and save sacred places.',
              style: theme.textTheme.bodyMedium,
            ),
            const Gap(AppSpacing.lg),
            _SearchTrigger(
              onTap: () {
                HapticFeedback.lightImpact();
                context.push('/practice/temples/search');
              },
            ),
            const Gap(AppSpacing.lg),
            _FavoritesCard(
              count: favoritesAsync.valueOrNull?.length ?? 0,
              onTap: () => context.push('/practice/temples/favorites'),
            ),
            const Gap(AppSpacing.xxl),
            const SectionLabel('Near you'),
            const Gap(AppSpacing.md),
            const _NearbySection(),
            const Gap(AppSpacing.xxl),
            const SectionLabel('Browse by state'),
            const Gap(AppSpacing.md),
            const _StatesChipRow(),
            const Gap(AppSpacing.xxl),
            const SectionLabel('Browse by deity'),
            const Gap(AppSpacing.md),
            const _DeitiesChipRow(),
          ],
        ),
      ),
    );
  }
}

class _SearchTrigger extends StatelessWidget {
  const _SearchTrigger({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return PoppyCard(
      radius: AppRadius.md,
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.base,
        vertical: AppSpacing.base,
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: cs.onSurfaceVariant, size: 20),
          const Gap.h(AppSpacing.md),
          Expanded(
            child: Text(
              'Search temples',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FavoritesCard extends StatelessWidget {
  const _FavoritesCard({required this.onTap, required this.count});

  final VoidCallback onTap;
  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final accentText = theme
        .extension<FaithThemeExtension>()!
        .palette
        .accentText;

    return PoppyCard(
      radius: AppRadius.lg,
      color: cs.secondaryContainer,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.base,
      ),
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Row(
        children: [
          Icon(Icons.favorite, size: 22, color: accentText),
          const Gap.h(AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Favorites', style: theme.textTheme.titleMedium),
                Text(
                  count == 0
                      ? 'Tap any heart to save'
                      : count == 1
                      ? '1 saved'
                      : '$count saved',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
        ],
      ),
    );
  }
}

class _NearbySection extends ConsumerWidget {
  const _NearbySection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(nearbyTemplesControllerProvider);
    final favoritesController = ref.watch(
      templeFavoritesControllerProvider.notifier,
    );
    final favorites =
        ref.watch(templeFavoritesControllerProvider).valueOrNull ?? const [];

    return async.when(
      loading: () => const PoppySkeleton(height: 96, radius: AppRadius.lg),
      error: (_, __) => PoppyCard(
        radius: AppRadius.lg,
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Text(
          'Couldn\'t load nearby temples.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
      data: (temples) {
        if (temples == null) {
          return _LocationDeniedPanel(
            onEnable: () async {
              final granted = await ref
                  .read(locationServiceProvider)
                  .ensurePermission();
              if (granted) {
                await ref
                    .read(nearbyTemplesControllerProvider.notifier)
                    .refresh();
              }
            },
          );
        }
        if (temples.isEmpty) {
          return PoppyCard(
            radius: AppRadius.lg,
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Text(
              'No temples found nearby yet.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        }
        return Column(
          children: [
            for (final t in temples.take(5))
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: TempleListTile(
                  temple: t,
                  isFavorite: favorites.any((f) => f.id == t.id),
                  onToggleFavorite: () => favoritesController.toggle(t),
                  onTap: () => context.push('/practice/temples/${t.id}'),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _LocationDeniedPanel extends StatelessWidget {
  const _LocationDeniedPanel({required this.onEnable});

  final VoidCallback onEnable;

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
            size: 40,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const Gap(AppSpacing.base),
          Text(
            'Enable location to find temples near you',
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
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

class _StatesChipRow extends ConsumerWidget {
  const _StatesChipRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(templeStatesProvider);
    return async.when(
      loading: () => const PoppySkeleton(height: 40, radius: AppRadius.pill),
      error: (_, __) => Text(
        'Couldn\'t load states.',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      data: (states) {
        if (states.isEmpty) {
          return Text(
            'No states available yet.',
            style: Theme.of(context).textTheme.bodyMedium,
          );
        }
        return _ChipWrap(
          labels: states,
          onTap: (state) {
            HapticFeedback.selectionClick();
            context.push('/practice/temples/state/$state');
          },
        );
      },
    );
  }
}

class _DeitiesChipRow extends ConsumerWidget {
  const _DeitiesChipRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allAsync = ref.watch(allTemplesProvider);
    final keys = ref.watch(templeDeityKeysProvider);

    return allAsync.when(
      loading: () => const PoppySkeleton(height: 40, radius: AppRadius.pill),
      error: (_, __) => Text(
        'Couldn\'t load deities.',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      data: (_) {
        if (keys.isEmpty) {
          return Text(
            'No deities available yet.',
            style: Theme.of(context).textTheme.bodyMedium,
          );
        }
        return _ChipWrap(
          labels: keys,
          onTap: (deity) {
            HapticFeedback.selectionClick();
            context.push('/practice/temples/deity/$deity');
          },
        );
      },
    );
  }
}

class _ChipWrap extends StatelessWidget {
  const _ChipWrap({required this.labels, required this.onTap});

  final List<String> labels;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final label in labels)
          InkWell(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            onTap: () => onTap(label),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: cs.primaryContainer,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(color: cs.primary),
              ),
            ),
          ),
      ],
    );
  }
}
