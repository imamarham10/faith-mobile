import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/poppy_button.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../../../shared/widgets/poppy_skeleton.dart';
import '../../../share/domain/shareable_content.dart';
import '../../data/dtos/temple.dart';
import '../controllers/temple_controller.dart';
import '../controllers/temple_favorites_controller.dart';

/// `/practice/temples/:id` — name, location, deity, description/
/// significance, and a bottom action bar (favorite / directions / share).
/// "Get directions" opens Google Maps via `url_launcher` — no in-app map,
/// mirroring `QiblaScreen`'s reliance on the device's own maps app rather
/// than an embedded map view.
class TempleDetailScreen extends ConsumerWidget {
  const TempleDetailScreen({super.key, required this.templeId});

  final String templeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(templeByIdProvider(templeId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        top: false,
        child: async.when(
          loading: () => const _DetailShimmer(),
          error: (_, __) => _ErrorPanel(
            onRetry: () => ref.invalidate(templeByIdProvider(templeId)),
          ),
          data: (temple) => _DetailContent(temple: temple),
        ),
      ),
    );
  }
}

class _DetailContent extends ConsumerWidget {
  const _DetailContent({required this.temple});

  final Temple temple;

  Future<void> _openDirections(BuildContext context) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${temple.lat},${temple.lng}',
    );
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Couldn\'t open maps'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _share(BuildContext context) {
    HapticFeedback.lightImpact();
    context.push(
      '/share',
      extra: ShareableContent(
        eyebrow: 'Temple',
        title: temple.name,
        translation: temple.description,
        attribution: temple.address,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final favs = ref.watch(templeFavoritesControllerProvider);
    final favsCtrl = ref.read(templeFavoritesControllerProvider.notifier);
    final isFav = favs.valueOrNull?.any((t) => t.id == temple.id) ?? false;
    final locationLabel = [
      temple.city,
      temple.state,
      temple.country,
    ].where((s) => (s ?? '').isNotEmpty).join(', ');

    return Column(
      children: [
        Expanded(
          child: ListView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenEdge,
              AppSpacing.sm,
              AppSpacing.screenEdge,
              AppSpacing.xl,
            ),
            children: [
              Text(temple.name, style: theme.textTheme.headlineMedium),
              const Gap(4),
              Text(temple.address, style: theme.textTheme.bodyMedium),
              if (locationLabel.isNotEmpty) ...[
                const Gap(2),
                Text(
                  locationLabel,
                  style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
              ],
              if (temple.deityKey != null) ...[
                const Gap(AppSpacing.base),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: cs.primaryContainer,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    temple.deityKey!,
                    style: theme.textTheme.labelMedium?.copyWith(color: cs.primary),
                  ),
                ),
              ],
              if ((temple.description ?? '').isNotEmpty) ...[
                const Gap(AppSpacing.lg),
                PoppyCard(
                  radius: AppRadius.lg,
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Text(
                    temple.description!,
                    style: theme.textTheme.bodyLarge?.copyWith(height: 1.7),
                  ),
                ),
              ],
              if ((temple.significance ?? '').isNotEmpty) ...[
                const Gap(AppSpacing.base),
                Text('Significance', style: theme.textTheme.titleMedium),
                const Gap(AppSpacing.xs),
                Text(
                  temple.significance!,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
                ),
              ],
            ],
          ),
        ),
        _ActionBar(
          isFavorite: isFav,
          onToggleFavorite: () => favsCtrl.toggle(temple),
          onDirections: () => _openDirections(context),
          onShare: () => _share(context),
        ),
      ],
    );
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.onDirections,
    required this.onShare,
  });

  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback onDirections;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final accentText = theme
        .extension<FaithThemeExtension>()!
        .palette
        .accentText;
    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          border: Border(top: BorderSide(color: cs.outline)),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenEdge,
          vertical: AppSpacing.md,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _ActionButton(
              icon: isFavorite ? Icons.favorite : Icons.favorite_outline,
              label: 'Favorite',
              color: isFavorite ? accentText : cs.onSurfaceVariant,
              onTap: onToggleFavorite,
            ),
            _ActionButton(
              icon: Icons.directions_outlined,
              label: 'Directions',
              color: cs.primary,
              onTap: onDirections,
            ),
            _ActionButton(
              icon: Icons.ios_share_outlined,
              label: 'Share',
              color: cs.onSurfaceVariant,
              onTap: onShare,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.md),
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 4),
            Text(label, style: theme.textTheme.labelMedium?.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}

class _DetailShimmer extends StatelessWidget {
  const _DetailShimmer();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(AppSpacing.screenEdge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PoppySkeleton(height: 28, radius: AppRadius.sm),
          Gap(AppSpacing.lg),
          PoppySkeleton(height: 220, radius: AppRadius.lg),
        ],
      ),
    );
  }
}

class _ErrorPanel extends StatelessWidget {
  const _ErrorPanel({required this.onRetry});

  final VoidCallback onRetry;

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
            Text('We couldn\'t load this temple.', style: theme.textTheme.bodyLarge),
            const Gap(AppSpacing.lg),
            PoppyButton(label: 'Try again', onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}
