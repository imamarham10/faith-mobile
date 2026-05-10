import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../share/domain/shareable_content.dart';
import '../../data/dtos/hadith.dart';
import '../controllers/hadith_detail_controller.dart';
import '../widgets/hadith_arabic_block.dart';
import '../widgets/hadith_list_tile.dart';

/// `/hadiths/:id` — the centerpiece. Header (book + number + grade), Arabic,
/// hairline divider, narrator, translation, reference, and a bottom share bar.
///
/// Favorites are intentionally absent in v1 — the API is premium-gated and
/// the upgrade flow isn't built yet.
class HadithDetailScreen extends ConsumerWidget {
  const HadithDetailScreen({super.key, required this.hadithId});

  final String hadithId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(hadithDetailProvider(hadithId));

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
          error: (e, __) => _ErrorPanel(
            message: e is Exception
                ? _humanize(e)
                : 'We couldn\'t load this hadith.',
            onRetry: () => ref.invalidate(hadithDetailProvider(hadithId)),
          ),
          data: (hadith) => _DetailContent(hadith: hadith),
        ),
      ),
    );
  }

  static String _humanize(Object e) {
    final s = e.toString();
    final colon = s.indexOf(': ');
    return colon >= 0 ? s.substring(colon + 2) : s;
  }
}

class _DetailContent extends StatelessWidget {
  const _DetailContent({required this.hadith});

  final Hadith hadith;

  Future<void> _copy(BuildContext context) async {
    final buffer = StringBuffer();
    final book = hadith.book?.name;
    if (book != null && book.isNotEmpty) {
      buffer.writeln('$book · #${hadith.hadithNumber}');
      buffer.writeln();
    }
    buffer
      ..writeln(hadith.textArabic)
      ..writeln();
    if ((hadith.narratorChain ?? '').isNotEmpty) {
      buffer
        ..writeln('Narrated by ${hadith.narratorChain}')
        ..writeln();
    }
    buffer.writeln(hadith.textEnglish);
    if ((hadith.reference ?? '').isNotEmpty) {
      buffer
        ..writeln()
        ..writeln('— ${hadith.reference}');
    }
    await Clipboard.setData(ClipboardData(text: buffer.toString()));
    await HapticFeedback.mediumImpact();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Hadith copied to clipboard'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final bookName = hadith.book?.name ?? 'Hadith';

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
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bookName,
                          style: theme.textTheme.headlineMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Hadith ${hadith.hadithNumber}',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  if ((hadith.grade ?? '').isNotEmpty) ...[
                    const Gap.h(AppSpacing.sm),
                    GradeChip(grade: hadith.grade!),
                  ],
                ],
              ),
              if ((hadith.chapterTitle ?? '').isNotEmpty) ...[
                const Gap(AppSpacing.sm),
                Text(
                  hadith.chapterTitle!,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: cs.onSurfaceVariant,
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
                    HadithArabicBlock(text: hadith.textArabic, fontSize: 24),
                    const Gap(AppSpacing.lg),
                    Container(
                      width: 40,
                      height: 1,
                      color: cs.secondary.withValues(alpha: 0.4),
                    ),
                    if ((hadith.narratorChain ?? '').isNotEmpty) ...[
                      const Gap(AppSpacing.base),
                      Text(
                        'Narrated by ${hadith.narratorChain}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                    const Gap(AppSpacing.base),
                    Text(hadith.textEnglish, style: theme.textTheme.bodyLarge),
                    if ((hadith.reference ?? '').isNotEmpty) ...[
                      const Gap(AppSpacing.md),
                      Text(
                        hadith.reference!.toUpperCase(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: cs.secondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        _ActionBar(
          onShare: () => _share(context),
          onCopy: () => _copy(context),
        ),
      ],
    );
  }

  void _share(BuildContext context) {
    HapticFeedback.lightImpact();
    final book = hadith.book?.name ?? 'Hadith';
    final attribution = (hadith.reference ?? '').isNotEmpty
        ? hadith.reference!
        : '$book #${hadith.hadithNumber}';
    context.push(
      '/share',
      extra: ShareableContent(
        eyebrow: 'Hadith',
        title: '$book · #${hadith.hadithNumber}',
        arabic: hadith.textArabic,
        translation: hadith.textEnglish,
        attribution: '— $attribution',
      ),
    );
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({required this.onShare, required this.onCopy});

  final VoidCallback onShare;
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22, color: color),
            const Gap.h(AppSpacing.sm),
            Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(color: color),
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
              height: 320,
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
  const _ErrorPanel({required this.message, required this.onRetry});

  final String message;
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
            Text(message, style: theme.textTheme.bodyLarge),
            const Gap(AppSpacing.lg),
            FilledButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}
