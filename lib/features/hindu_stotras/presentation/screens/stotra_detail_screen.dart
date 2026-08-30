import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../../../core/theme/sanskrit_text.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/poppy_button.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../../../shared/widgets/poppy_skeleton.dart';
import '../../data/dtos/stotra.dart';
import '../controllers/stotra_controller.dart';
import '../controllers/stotra_favorites_controller.dart';
import '../widgets/stotra_verse_block.dart';

/// `/practice/stotras/:slug` — the centerpiece of the stotras feature.
///
/// Unlike `DuaDetailScreen` (a single Arabic/translation block), a stotra
/// is a sequence of verses — each with its own Sanskrit, transliteration,
/// and translation — so this renders one `StotraVerseBlock` per verse,
/// divided, inside a single card.
class StotraDetailScreen extends ConsumerWidget {
  const StotraDetailScreen({super.key, required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stotraAsync = ref.watch(stotraBySlugProvider(slug));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        top: false,
        child: stotraAsync.when(
          loading: () => const _DetailShimmer(),
          error: (_, __) => _ErrorPanel(
            onRetry: () => ref.invalidate(stotraBySlugProvider(slug)),
          ),
          data: (stotra) => _DetailContent(stotra: stotra),
        ),
      ),
    );
  }
}

class _DetailContent extends ConsumerStatefulWidget {
  const _DetailContent({required this.stotra});

  final StotraDetail stotra;

  @override
  ConsumerState<_DetailContent> createState() => _DetailContentState();
}

class _DetailContentState extends ConsumerState<_DetailContent> {
  int _repeatCount = 0;

  void _incrementRepeat() {
    HapticFeedback.lightImpact();
    setState(() => _repeatCount += 1);
  }

  void _resetRepeat() {
    HapticFeedback.selectionClick();
    setState(() => _repeatCount = 0);
  }

  Future<void> _copy(BuildContext context) async {
    final stotra = widget.stotra;
    final buffer = StringBuffer()
      ..writeln(stotra.titleEnglish)
      ..writeln();
    for (final verse in stotra.verses) {
      buffer.writeln(verse.sanskritText);
      if ((verse.transliteration ?? '').isNotEmpty) {
        buffer.writeln(verse.transliteration);
      }
      if (verse.translations.isNotEmpty) {
        buffer.writeln(verse.translations.first.text);
      }
      buffer.writeln();
    }
    await Clipboard.setData(ClipboardData(text: buffer.toString().trim()));
    await HapticFeedback.lightImpact();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final stotra = widget.stotra;
    final favs = ref.watch(stotraFavoritesControllerProvider);
    final favsCtrl = ref.read(stotraFavoritesControllerProvider.notifier);
    final isFav = favs.valueOrNull?.any((s) => s.id == stotra.id) ?? false;

    final asListItem = Stotra(
      id: stotra.id,
      slug: stotra.slug,
      titleSanskrit: stotra.titleSanskrit,
      titleEnglish: stotra.titleEnglish,
      type: stotra.type,
      deityKey: stotra.deityKey,
      isPremium: stotra.isPremium,
      category: stotra.category,
      verseCount: stotra.verses.length,
    );

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
              Text(stotra.titleEnglish, style: theme.textTheme.headlineMedium),
              const Gap(AppSpacing.xs),
              Text(
                stotra.titleSanskrit,
                style: sanskritTextStyle(fontSize: 18, color: cs.onSurfaceVariant),
              ),
              const Gap(AppSpacing.lg),
              PoppyCard(
                radius: AppRadius.lg,
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < stotra.verses.length; i++) ...[
                      if (i > 0) ...[
                        const Gap(AppSpacing.lg),
                        Container(
                          width: 40,
                          height: 1,
                          color: cs.secondary.withValues(alpha: 0.4),
                        ),
                        const Gap(AppSpacing.lg),
                      ],
                      StotraVerseBlock(verse: stotra.verses[i]),
                    ],
                  ],
                ),
              ),
              const Gap(AppSpacing.xl),
              _RepeatCounter(
                count: _repeatCount,
                onIncrement: _incrementRepeat,
                onReset: _resetRepeat,
              ),
            ],
          ),
        ),
        _ActionBar(
          isFavorite: isFav,
          onToggleFavorite: () => favsCtrl.toggle(asListItem),
          onCopy: () => _copy(context),
        ),
      ],
    );
  }
}

class _RepeatCounter extends StatelessWidget {
  const _RepeatCounter({
    required this.count,
    required this.onIncrement,
    required this.onReset,
  });

  final int count;
  final VoidCallback onIncrement;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return PoppyCard(
      radius: AppRadius.lg,
      color: cs.primaryContainer,
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        children: [
          Text(
            'Repeat',
            style: theme.textTheme.labelSmall?.copyWith(
              color: cs.primary,
              letterSpacing: 1.4,
            ),
          ),
          const Gap(AppSpacing.sm),
          Text(
            '$count',
            style: theme.textTheme.displayMedium?.copyWith(
              color: cs.onSurface,
              fontWeight: FontWeight.w300,
            ),
          ),
          const Gap(AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(onPressed: onReset, child: const Text('Reset')),
              const Gap.h(AppSpacing.md),
              SizedBox(
                width: 160,
                child: PoppyButton(label: 'Tap to count', onPressed: onIncrement),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.onCopy,
  });

  final bool isFavorite;
  final VoidCallback onToggleFavorite;
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _ActionButton(
              icon: isFavorite ? Icons.favorite : Icons.favorite_outline,
              label: 'Favorite',
              tint: isFavorite ? accentText : cs.onSurfaceVariant,
              onTap: onToggleFavorite,
            ),
            _ActionButton(
              icon: Icons.copy_outlined,
              label: 'Copy',
              tint: cs.onSurfaceVariant,
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
    required this.tint,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color tint;
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
            Icon(icon, size: 22, color: tint),
            const SizedBox(height: 4),
            Text(label, style: theme.textTheme.labelMedium?.copyWith(color: tint)),
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
          Gap(AppSpacing.xl),
          PoppySkeleton(height: 160, radius: AppRadius.lg),
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
            Text('We couldn\'t load this stotra.', style: theme.textTheme.bodyLarge),
            const Gap(AppSpacing.lg),
            PoppyButton(label: 'Try again', onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}
