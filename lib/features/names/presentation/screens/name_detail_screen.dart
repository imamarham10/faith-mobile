import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/arabic_text.dart';
import '../../../../shared/widgets/gap.dart';
import '../../data/dtos/divine_name.dart';
import '../../domain/names_kind.dart';
import '../controllers/name_detail_controller.dart';
import '../controllers/name_favorites_controller.dart';

/// `/practice/names/:kind/:id` — full-screen name detail.
class NameDetailScreen extends ConsumerWidget {
  const NameDetailScreen({super.key, required this.kind, required this.id});

  final NamesKind kind;
  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(nameDetailProvider(kind: kind, id: id));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        top: false,
        child: detail.when(
          loading: () => const _DetailShimmer(),
          error: (_, __) => _ErrorPanel(
            onRetry: () =>
                ref.invalidate(nameDetailProvider(kind: kind, id: id)),
          ),
          data: (name) => _DetailContent(kind: kind, name: name),
        ),
      ),
    );
  }
}

class _DetailContent extends ConsumerWidget {
  const _DetailContent({required this.kind, required this.name});

  final NamesKind kind;
  final DivineName name;

  Future<void> _copy(BuildContext context) async {
    final buffer = StringBuffer()
      ..writeln(name.nameArabic)
      ..writeln(name.nameTranslit)
      ..writeln(name.meaning ?? name.nameEnglish);
    if ((name.description ?? '').isNotEmpty) {
      buffer
        ..writeln()
        ..writeln(name.description);
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
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final favs = ref.watch(nameFavoritesControllerProvider(kind));
    final favsCtrl = ref.read(nameFavoritesControllerProvider(kind).notifier);
    final isFav = favs.valueOrNull?.any((n) => n.id == name.id) ?? false;

    return Column(
      children: [
        Expanded(
          child: ListView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenEdge,
              AppSpacing.lg,
              AppSpacing.screenEdge,
              AppSpacing.xl,
            ),
            children: [
              Center(
                child: Text(
                  '${name.id} of 99'.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: cs.secondary,
                  ),
                ),
              ),
              const Gap(AppSpacing.xl),
              Center(
                child: Text(
                  name.nameArabic,
                  textAlign: TextAlign.center,
                  style: arabicTextStyleOf(
                    ref,
                    fontSize: 56,
                    height: 1.4,
                    color: cs.onSurface,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              const Gap(AppSpacing.lg),
              Center(
                child: Text(
                  name.nameTranslit,
                  style: theme.textTheme.displaySmall,
                  textAlign: TextAlign.center,
                ),
              ),
              const Gap(AppSpacing.sm),
              Center(
                child: Text(
                  name.meaning ?? name.nameEnglish,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Gap(AppSpacing.xl),
              Container(
                width: 40,
                height: 1,
                color: cs.secondary.withValues(alpha: 0.4),
              ),
              const Gap(AppSpacing.xl),
              if ((name.description ?? '').isNotEmpty)
                Text(
                  name.description!,
                  style: theme.textTheme.bodyLarge?.copyWith(height: 1.7),
                ),
            ],
          ),
        ),
        _ActionBar(
          isFavorite: isFav,
          onToggleFavorite: () => favsCtrl.toggle(name),
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
    required this.onCopy,
  });

  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
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
              tint: isFavorite ? cs.secondary : cs.onSurfaceVariant,
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
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Shimmer.fromColors(
        baseColor: cs.surface,
        highlightColor: cs.outline,
        child: Column(
          children: [
            Container(
              height: 72,
              width: 220,
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
            ),
            const Gap(AppSpacing.lg),
            Container(
              height: 24,
              width: 140,
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(AppRadius.sm),
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
              'We couldn\'t load this name.',
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
