import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/art/artwork.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/illustrated_empty_state.dart';
import '../../../../shared/widgets/mascot_view.dart';
import '../../../../shared/widgets/poppy_button.dart';
import '../../../../shared/widgets/poppy_skeleton.dart';
import '../controllers/temple_favorites_controller.dart';
import '../controllers/temples_browse_controller.dart';
import '../widgets/temple_list_tile.dart';

/// `/practice/temples/deity/:deity` — temples filtered to one deity key.
/// Mirrors `TempleStateScreen`'s shape exactly, filtered by `deity` instead
/// of `state`.
class TempleDeityScreen extends ConsumerWidget {
  const TempleDeityScreen({super.key, required this.deity});

  final String deity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templesAsync = ref.watch(templesByDeityProvider(deity));
    final favorites =
        ref.watch(templeFavoritesControllerProvider).valueOrNull ?? const [];
    final favsCtrl = ref.read(templeFavoritesControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(deity),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        top: false,
        child: templesAsync.when(
          loading: () => const _ListShimmer(),
          error: (_, __) => _ErrorPanel(
            onRetry: () => ref.invalidate(templesByDeityProvider(deity)),
          ),
          data: (temples) {
            if (temples.isEmpty) {
              return Center(
                child: IllustratedEmptyState(
                  title: 'Nothing here yet',
                  message: 'No temples found for $deity yet.',
                  slot: ArtSlot.emptyCollection,
                  mascot: MascotState.sleep,
                ),
              );
            }
            return ListView.separated(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenEdge,
                AppSpacing.sm,
                AppSpacing.screenEdge,
                AppSpacing.xxl,
              ),
              itemCount: temples.length,
              separatorBuilder: (_, __) => const Gap(AppSpacing.sm),
              itemBuilder: (_, i) {
                final temple = temples[i];
                return TempleListTile(
                  temple: temple,
                  isFavorite: favorites.any((f) => f.id == temple.id),
                  onToggleFavorite: () {
                    HapticFeedback.selectionClick();
                    favsCtrl.toggle(temple);
                  },
                  onTap: () => context.push('/practice/temples/${temple.id}'),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _ListShimmer extends StatelessWidget {
  const _ListShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenEdge,
        AppSpacing.sm,
        AppSpacing.screenEdge,
        AppSpacing.xxl,
      ),
      itemCount: 8,
      separatorBuilder: (_, __) => const Gap(AppSpacing.sm),
      itemBuilder: (_, __) =>
          const PoppySkeleton(height: 72, radius: AppRadius.lg),
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
            Text(
              'We couldn\'t load these temples.',
              style: theme.textTheme.bodyLarge,
            ),
            const Gap(AppSpacing.lg),
            PoppyButton(label: 'Try again', onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}
