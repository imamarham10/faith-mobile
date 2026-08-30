import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/poppy_button.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../../../shared/widgets/poppy_skeleton.dart';
import '../../../share/domain/shareable_content.dart';
import '../../data/dtos/hindu_story.dart';
import '../controllers/story_controller.dart';
import '../controllers/story_favorites_controller.dart';

/// `/hadiths/hindu-stories/:id` — the centerpiece: title, character chips,
/// the full narrative body, and a bottom action bar (favorite / share /
/// copy). Deliberately plain prose rendering — no Sanskrit/Arabic block,
/// no narrator chain, no grade — these are katha, read start to finish,
/// not cited reports.
class StoryDetailScreen extends ConsumerWidget {
  const StoryDetailScreen({super.key, required this.storyId});

  final String storyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(storyByIdProvider(storyId));

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
            onRetry: () => ref.invalidate(storyByIdProvider(storyId)),
          ),
          data: (story) => _DetailContent(story: story),
        ),
      ),
    );
  }
}

class _DetailContent extends ConsumerWidget {
  const _DetailContent({required this.story});

  final HinduStoryDetail story;

  Future<void> _copy(BuildContext context) async {
    final buffer = StringBuffer()
      ..writeln(story.title)
      ..writeln()
      ..writeln(story.body);
    await Clipboard.setData(ClipboardData(text: buffer.toString()));
    await HapticFeedback.lightImpact();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Story copied to clipboard'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _share(BuildContext context) {
    HapticFeedback.lightImpact();
    context.push(
      '/share',
      extra: ShareableContent(
        eyebrow: story.collection?.name ?? 'Story',
        title: story.title,
        translation: story.summary,
        attribution: story.collection != null ? '— ${story.collection!.name}' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final favs = ref.watch(storyFavoritesControllerProvider);
    final favsCtrl = ref.read(storyFavoritesControllerProvider.notifier);
    final asListItem = HinduStory(
      id: story.id,
      storyNumber: story.storyNumber,
      title: story.title,
      summary: story.summary,
      deityKey: story.deityKey,
      characters: story.characters,
      collection: story.collection,
    );
    final isFav = favs.valueOrNull?.any((s) => s.id == story.id) ?? false;

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
              Text(story.title, style: theme.textTheme.headlineMedium),
              if (story.collection != null) ...[
                const Gap(4),
                Text(story.collection!.name, style: theme.textTheme.bodyMedium),
              ],
              if (story.characters.isNotEmpty) ...[
                const Gap(AppSpacing.base),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final c in story.characters)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: cs.primaryContainer.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                          border: Border.all(color: cs.outline),
                        ),
                        child: Text(
                          c,
                          style: theme.textTheme.labelSmall?.copyWith(color: cs.onSurface),
                        ),
                      ),
                  ],
                ),
              ],
              const Gap(AppSpacing.lg),
              PoppyCard(
                radius: AppRadius.lg,
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Text(story.body, style: theme.textTheme.bodyLarge?.copyWith(height: 1.7)),
              ),
            ],
          ),
        ),
        _ActionBar(
          isFavorite: isFav,
          onToggleFavorite: () => favsCtrl.toggle(asListItem),
          onShare: () => _share(context),
          onCopy: () => _copy(context),
        ),
      ],
    );
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.onShare,
    required this.onCopy,
  });

  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback onShare;
  final VoidCallback onCopy;

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
              icon: Icons.ios_share_outlined,
              label: 'Share',
              color: cs.primary,
              onTap: onShare,
            ),
            _ActionButton(
              icon: Icons.copy_rounded,
              label: 'Copy',
              color: cs.onSurfaceVariant,
              onTap: onCopy,
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
      onTap: onTap,
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
          PoppySkeleton(height: 320, radius: AppRadius.lg),
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
            Text('We couldn\'t load this story.', style: theme.textTheme.bodyLarge),
            const Gap(AppSpacing.lg),
            PoppyButton(label: 'Try again', onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}
