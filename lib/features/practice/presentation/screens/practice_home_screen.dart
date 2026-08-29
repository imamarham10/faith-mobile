import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/preferences/selected_faith.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/faith_id.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/mascot_view.dart';
import '../../../../shared/widgets/poppy_card.dart';

/// Practice tab home.
///
/// Faith-aware: branches on [selectedFaithProvider]. Islam has the full
/// Dhikr/Duas/Names/Qibla grid (`_IslamPracticeContent`); Hindu doesn't have
/// a Practice vertical yet (that's Part C — no Hindu feature screens exist
/// in this app yet at all), so it gets an honest placeholder rather than
/// linking to Islam-only routes.
class PracticeHomeScreen extends ConsumerWidget {
  const PracticeHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final faith = ref.watch(selectedFaithProvider).valueOrNull ?? FaithId.islam;
    return switch (faith) {
      FaithId.islam => const _IslamPracticeContent(),
      FaithId.hindu => const _HinduPracticePlaceholder(),
    };
  }
}

/// A calm hub linking to Dhikr, Duas, Names, and Qibla.
///
/// Layout: a 2×2 grid of generous cards. Each tile carries an icon, a
/// title, and a subtitle, with a thick outline and 20-radius rounded
/// corners — mirroring the poppy-comic card language.
class _IslamPracticeContent extends StatelessWidget {
  const _IslamPracticeContent();

  static const _tiles = <_PracticeTileData>[
    _PracticeTileData(
      icon: Icons.fingerprint,
      title: 'Dhikr',
      subtitle: 'Counter & goals',
      route: '/practice/dhikr',
    ),
    _PracticeTileData(
      icon: Icons.menu_book_outlined,
      title: 'Duas',
      subtitle: 'Supplications',
      route: '/practice/duas',
    ),
    _PracticeTileData(
      icon: Icons.auto_awesome_outlined,
      title: 'Names',
      subtitle: '99 Names',
      route: '/practice/names',
    ),
    _PracticeTileData(
      icon: Icons.explore_outlined,
      title: 'Qibla',
      subtitle: 'Direction',
      route: '/practice/qibla',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenEdge,
                AppSpacing.lg,
                AppSpacing.screenEdge,
                AppSpacing.xl,
              ),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Practice', style: theme.textTheme.headlineMedium),
                    const Gap(4),
                    Text(
                      'Tend your practice.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenEdge,
                0,
                AppSpacing.screenEdge,
                AppSpacing.xxl,
              ),
              sliver: SliverGrid.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  mainAxisExtent: 150,
                ),
                itemCount: _tiles.length,
                itemBuilder: (_, i) => _PracticeTile(data: _tiles[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Part C (the Hindu vertical) hasn't been built yet — no Hindu feature
/// screens exist in this app at all — so there is no real Hindu "Practice"
/// content to link to. This is a deliberately honest placeholder rather
/// than either crashing or routing to Islam-only screens.
class _HinduPracticePlaceholder extends StatelessWidget {
  const _HinduPracticePlaceholder();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenEdge,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const MascotView(faith: FaithId.hindu, state: MascotState.idle),
                const Gap(AppSpacing.lg),
                Text(
                  'Hindu practice is coming soon',
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const Gap(AppSpacing.sm),
                Text(
                  'We\'re building this out next — check back soon.',
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PracticeTileData {
  const _PracticeTileData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String route;
}

class _PracticeTile extends StatelessWidget {
  const _PracticeTile({required this.data});

  final _PracticeTileData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return PoppyCard(
      radius: AppRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.lg),
      onTap: () {
        HapticFeedback.lightImpact();
        context.push(data.route);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(data.icon, size: 28, color: cs.primary),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(data.title, style: theme.textTheme.titleLarge),
              const Gap(2),
              Text(data.subtitle, style: theme.textTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}
