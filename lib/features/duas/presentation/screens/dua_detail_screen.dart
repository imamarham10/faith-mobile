import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../../../shared/widgets/gap.dart';
import '../../data/dtos/dua.dart';
import '../controllers/dua_controller.dart';
import '../controllers/dua_favorites_controller.dart';
import '../widgets/dua_arabic_block.dart';

/// `/practice/duas/:id` — the centerpiece of the duas feature.
///
/// Card-style detail with title, Arabic, divider, transliteration,
/// translation, reference, and a bottom action bar (favorite / copy /
/// repeat).
class DuaDetailScreen extends ConsumerWidget {
  const DuaDetailScreen({super.key, required this.duaId});

  final String duaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final duaAsync = ref.watch(duaByIdProvider(duaId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        top: false,
        child: duaAsync.when(
          loading: () => const _DetailShimmer(),
          error: (_, __) => _ErrorPanel(
            onRetry: () => ref.invalidate(duaByIdProvider(duaId)),
          ),
          data: (dua) => _DetailContent(dua: dua),
        ),
      ),
    );
  }
}

class _DetailContent extends ConsumerStatefulWidget {
  const _DetailContent({required this.dua});

  final Dua dua;

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
    final dua = widget.dua;
    final buffer = StringBuffer()
      ..writeln(dua.titleEnglish)
      ..writeln()
      ..writeln(dua.textArabic)
      ..writeln();
    if ((dua.textTransliteration ?? '').isNotEmpty) {
      buffer
        ..writeln(dua.textTransliteration)
        ..writeln();
    }
    buffer.writeln(dua.textEnglish);
    if ((dua.reference ?? '').isNotEmpty) {
      buffer
        ..writeln()
        ..writeln('— ${dua.reference}');
    }
    await Clipboard.setData(ClipboardData(text: buffer.toString()));
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
    final accentText = theme
        .extension<FaithThemeExtension>()!
        .palette
        .accentText;
    final dua = widget.dua;
    final favs = ref.watch(duaFavoritesControllerProvider);
    final favsCtrl = ref.read(duaFavoritesControllerProvider.notifier);
    final isFav = favs.valueOrNull?.any((d) => d.id == dua.id) ?? false;

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
              Text(dua.titleEnglish, style: theme.textTheme.headlineMedium),
              if (dua.titleArabic.isNotEmpty) ...[
                const Gap(AppSpacing.xs),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    dua.titleArabic,
                    textAlign: TextAlign.right,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
              const Gap(AppSpacing.lg),
              Container(
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: cs.outline),
                ),
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DuaArabicBlock(text: dua.textArabic),
                    const Gap(AppSpacing.lg),
                    Container(
                      width: 40,
                      height: 1,
                      color: cs.secondary.withValues(alpha: 0.4),
                    ),
                    if ((dua.textTransliteration ?? '').isNotEmpty) ...[
                      const Gap(AppSpacing.base),
                      Text(
                        dua.textTransliteration!,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                    const Gap(AppSpacing.base),
                    Text(dua.textEnglish, style: theme.textTheme.bodyLarge),
                    if ((dua.reference ?? '').isNotEmpty) ...[
                      const Gap(AppSpacing.md),
                      Text(
                        dua.reference!.toUpperCase(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: accentText,
                        ),
                      ),
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
          onToggleFavorite: () => favsCtrl.toggle(dua),
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
    return Container(
      decoration: BoxDecoration(
        color: cs.primaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
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
              FilledButton(
                onPressed: onIncrement,
                style: FilledButton.styleFrom(minimumSize: const Size(160, 48)),
                child: const Text('Tap to count'),
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
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(color: tint),
            ),
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
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenEdge),
      child: Shimmer.fromColors(
        baseColor: cs.surface,
        highlightColor: cs.outline,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 28,
              width: 220,
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
            ),
            const Gap(AppSpacing.lg),
            Container(
              height: 220,
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
            ),
            const Gap(AppSpacing.xl),
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
            ),
          ],
        ),
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
            Text(
              'We couldn\'t load this dua.',
              style: theme.textTheme.bodyLarge,
            ),
            const Gap(AppSpacing.lg),
            FilledButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}
