import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/gap.dart';
import '../controllers/hadith_search_controller.dart';
import '../controllers/hadiths_home_controller.dart';
import '../widgets/hadith_list_tile.dart';

/// `/hadiths/search` — server-side search with debounced query.
class HadithSearchScreen extends ConsumerStatefulWidget {
  const HadithSearchScreen({super.key});

  @override
  ConsumerState<HadithSearchScreen> createState() => _HadithSearchScreenState();
}

class _HadithSearchScreenState extends ConsumerState<HadithSearchScreen> {
  final TextEditingController _ctrl = TextEditingController();
  final FocusNode _focus = FocusNode();
  Timer? _debounce;
  String _query = '';

  @override
  void initState() {
    super.initState();
    // Auto-focus when the route mounts so the keyboard rises immediately.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focus.requestFocus();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 280), () {
      if (!mounted) return;
      setState(() => _query = value.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
        title: TextField(
          controller: _ctrl,
          focusNode: _focus,
          onChanged: _onChanged,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Search hadiths',
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            filled: false,
            contentPadding: EdgeInsets.zero,
            hintStyle: theme.textTheme.bodyLarge?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
          style: theme.textTheme.bodyLarge,
        ),
        actions: [
          if (_query.isNotEmpty)
            IconButton(
              tooltip: 'Clear',
              icon: const Icon(Icons.close_rounded, size: 22),
              onPressed: () {
                HapticFeedback.selectionClick();
                _ctrl.clear();
                _onChanged('');
              },
            ),
        ],
      ),
      body: SafeArea(top: false, child: _Body(query: _query)),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.query});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    if (query.length < 3) {
      return _EmptyTip(query: query);
    }

    final resultsAsync = ref.watch(hadithSearchProvider(query));

    return resultsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (e, __) => _ErrorPanel(
        message: e is Exception ? _humanize(e) : 'Search failed.',
        onRetry: () => ref.invalidate(hadithSearchProvider(query)),
      ),
      data: (hits) {
        if (hits.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.search_off_outlined,
                    size: 36,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const Gap(AppSpacing.md),
                  Text('No hadiths matched.', style: theme.textTheme.bodyLarge),
                  const Gap(AppSpacing.xs),
                  Text(
                    'Try a different word or phrase.',
                    style: theme.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
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
          itemCount: hits.length,
          separatorBuilder: (_, __) => const Gap(AppSpacing.sm),
          itemBuilder: (_, i) {
            final hadith = hits[i];
            return HadithListTile(
              hadith: hadith,
              highlightTerm: query,
              onTap: () => context.push('/hadiths/${hadith.id}'),
            );
          },
        );
      },
    );
  }

  static String _humanize(Object e) {
    final s = e.toString();
    final colon = s.indexOf(': ');
    return colon >= 0 ? s.substring(colon + 2) : s;
  }
}

class _EmptyTip extends ConsumerWidget {
  const _EmptyTip({required this.query});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final booksAsync = ref.watch(hadithBooksProvider);

    final tip = booksAsync.maybeWhen(
      data: (books) {
        final total = books
            .where((b) => !b.isPremium)
            .fold<int>(0, (sum, b) => sum + b.totalHadiths);
        if (total <= 0) return 'Search the hadith corpus.';
        return 'Search ${_format(total)} hadiths.';
      },
      orElse: () => 'Search the hadith corpus.',
    );

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_outlined, size: 36, color: cs.onSurfaceVariant),
            const Gap(AppSpacing.md),
            Text(tip, style: theme.textTheme.bodyLarge),
            const Gap(AppSpacing.xs),
            Text(
              query.isEmpty
                  ? 'Type at least 3 characters.'
                  : 'Keep typing — at least 3 characters.',
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  static String _format(int n) {
    if (n >= 1000000) {
      return '${(n / 1000000).toStringAsFixed(1)} million';
    }
    if (n >= 1000) {
      return '${(n / 1000).toStringAsFixed(n % 1000 == 0 ? 0 : 1)}K';
    }
    return n.toString();
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
