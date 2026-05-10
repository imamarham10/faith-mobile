import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/gap.dart';

/// Practice tab home — a calm hub linking to Dhikr, Duas, Names, and Qibla.
///
/// Layout: a 2×2 grid of generous cards. Each tile carries an icon, a
/// title, and a subtitle, with a hairline border and 20-radius rounded
/// corners — mirroring the Today screen's aesthetic.
class PracticeHomeScreen extends StatelessWidget {
  const PracticeHomeScreen({super.key});

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
                  mainAxisExtent: 140,
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
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: () {
          HapticFeedback.lightImpact();
          context.push(data.route);
        },
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: cs.outline),
          ),
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
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
        ),
      ),
    );
  }
}
