import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/art/artwork.dart';
import '../../../../core/preferences/selected_faith.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/faith_id.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../../../shared/widgets/artwork_panel.dart';
import '../../../../shared/widgets/colophon.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/page_masthead.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../../../shared/widgets/poppy_icon.dart';
import '../../../quran/presentation/widgets/often_read_row.dart';

/// Practice tab home.
///
/// Faith-aware: branches on [selectedFaithProvider]. Islam links to Dhikr/
/// Duas/Names/Qibla (`_IslamPracticeContent`); Hindu links to Japa/Stotras/
/// Temples (`_HinduPracticeContent`) — both a 2×2-ish grid of the same
/// `_PracticeTile` shape.
class PracticeHomeScreen extends ConsumerWidget {
  const PracticeHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final faith = ref.watch(selectedFaithProvider).valueOrNull ?? FaithId.islam;
    return switch (faith) {
      FaithId.islam => const _IslamPracticeContent(),
      FaithId.hindu => const _HinduPracticeContent(),
    };
  }
}

/// A calm hub linking to Dhikr, Duas, Names, and Qibla.
///
/// Layout: an illustrated masthead over a 2×2 grid of generous cards. Each
/// tile carries a museum motif behind a scrim, an icon badge, a title, and
/// a subtitle — mirroring the poppy-comic card language.
class _IslamPracticeContent extends StatelessWidget {
  const _IslamPracticeContent();

  static const _tiles = <_PracticeTileData>[
    _PracticeTileData(
      icon: Icons.fingerprint,
      title: 'Dhikr',
      subtitle: 'Counter & goals',
      route: '/practice/dhikr',
      slot: ArtSlot.practiceTile1,
    ),
    _PracticeTileData(
      icon: Icons.menu_book_outlined,
      title: 'Duas',
      subtitle: 'Supplications',
      route: '/practice/duas',
      slot: ArtSlot.practiceTile2,
    ),
    _PracticeTileData(
      icon: Icons.auto_awesome_outlined,
      title: 'Names',
      subtitle: '99 Names',
      route: '/practice/names',
      slot: ArtSlot.practiceTile3,
    ),
    _PracticeTileData(
      icon: Icons.explore_outlined,
      title: 'Qibla',
      subtitle: 'Direction',
      route: '/practice/qibla',
      slot: ArtSlot.practiceTile4,
    ),
  ];

  @override
  Widget build(BuildContext context) =>
      const _PracticeScaffold(tiles: _tiles, oftenRead: true);
}

/// A calm hub linking to Japa, Stotras, and Temples. Mirrors
/// `_IslamPracticeContent`'s grid shape exactly.
class _HinduPracticeContent extends StatelessWidget {
  const _HinduPracticeContent();

  static const _tiles = <_PracticeTileData>[
    _PracticeTileData(
      icon: Icons.self_improvement,
      title: 'Japa',
      subtitle: 'Mantra counter',
      route: '/practice/japa',
      slot: ArtSlot.practiceTile1,
    ),
    _PracticeTileData(
      icon: Icons.menu_book_outlined,
      title: 'Stotras',
      subtitle: 'Deity hymns',
      route: '/practice/stotras',
      slot: ArtSlot.practiceTile2,
    ),
    _PracticeTileData(
      icon: Icons.temple_hindu_outlined,
      title: 'Temples',
      subtitle: 'Find & save',
      route: '/practice/temples',
      slot: ArtSlot.practiceTile3,
    ),
  ];

  @override
  Widget build(BuildContext context) => const _PracticeScaffold(tiles: _tiles);
}

/// The shared chrome both faiths render. Only the tile list differs, so the
/// masthead, grid delegate and scroll physics live here once rather than
/// being kept in sync by hand in two places.
class _PracticeScaffold extends StatelessWidget {
  const _PracticeScaffold({required this.tiles, this.oftenRead = false});

  final List<_PracticeTileData> tiles;

  /// Whether to offer the Qur'an shortcut row under the grid. Islam only —
  /// the row is seven surahs, and the Hindu branch of this tab has no
  /// equivalent built. Faith-gated here rather than inside the row so the
  /// Hindu grid cannot pick it up by sharing this scaffold.
  final bool oftenRead;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            // No horizontal padding: the masthead insets its own text and
            // lets the motif run off the right edge of the screen. A card
            // cannot reach the edge, so the bleed is what tells you this is
            // the page and not something to press.
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(0, AppSpacing.lg, 0, AppSpacing.xl),
              sliver: SliverToBoxAdapter(
                child: PageMasthead(
                  title: 'Practice',
                  subtitle: 'Tend your practice.',
                  slot: ArtSlot.practiceHero,
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
                itemCount: tiles.length,
                itemBuilder: (_, i) => _TileEntrance(
                  index: i,
                  child: _PracticeTile(data: tiles[i]),
                ),
              ),
            ),
            // Between the grid and the tailpiece, in the space the grid
            // leaves — not after the colophon, which is the deliberate end
            // of the page and must stay the last thing on it. Edge-to-edge
            // because the strip scrolls: a chip clipped by the screen edge
            // is what says there are more of them.
            if (oftenRead)
              const SliverPadding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, AppSpacing.xxl),
                sliver: SliverToBoxAdapter(child: OftenReadRow()),
              ),
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.screenEdge,
                0,
                AppSpacing.screenEdge,
                AppSpacing.xxl,
              ),
              sliver: SliverToBoxAdapter(child: _PracticeFooter()),
            ),
          ],
        ),
      ),
    );
  }
}

/// Closes the grid with a tailpiece: a small motif over a steadying line.
///
/// Was a full-width [PoppyCard] with the same art-band-over-title anatomy as
/// a grid tile, and so was read as a button and tapped — twice reported. It
/// carries no action and now wears no container; see [Colophon].
class _PracticeFooter extends StatelessWidget {
  const _PracticeFooter();

  @override
  Widget build(BuildContext context) {
    // Same illuminated page as the masthead, sampled at its gold-and-blue
    // border rather than its centre. The tab then opens and closes on the
    // one manuscript, and the rule is an actual ornament instead of an
    // arbitrary crop of a carpet.
    return const Colophon(
      line: 'Little and often.',
      caption: 'A steady practice outlasts a strong one.',
      slot: ArtSlot.practiceHero,
      ornamentAlignment: Alignment.topCenter,
    );
  }
}

/// Settles a tile in: a short fade and rise, staggered by grid position.
///
/// The stagger is an [Interval] inside one animation rather than a per-tile
/// delay. flutter_animate's `delay:` is backed by a `Timer`, which survives a
/// tree torn down mid-animation and fails tests with "A Timer is still
/// pending even after the widget tree was disposed"; an interval shifts the
/// same curve without scheduling anything.
class _TileEntrance extends StatelessWidget {
  const _TileEntrance({required this.index, required this.child});

  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Capped so a longer grid can never push the last tile past ~0.5s.
    final start = (index * 0.1).clamp(0.0, 0.4);
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 420),
      curve: Interval(start, 1, curve: Curves.easeOutCubic),
      child: child,
      builder: (context, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(
          offset: Offset(0, (1 - t) * 10),
          child: child,
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
    required this.slot,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String route;
  final ArtSlot slot;
}

class _PracticeTile extends StatelessWidget {
  const _PracticeTile({required this.data});

  /// Tile height is pinned by the grid delegate (`mainAxisExtent: 150`), so
  /// the artwork band is a constant rather than a fraction — the text block
  /// below it then always gets the same remainder, and one long title can
  /// never squeeze the picture.
  static const double _artHeight = 74;

  final _PracticeTileData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<FaithThemeExtension>()!;

    return PoppyCard(
      radius: AppRadius.lg,
      padding: EdgeInsets.zero,
      onTap: () {
        HapticFeedback.lightImpact();
        context.push(data.route);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          AppRadius.lg - ext.cardOutlineWidth,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: _artHeight,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Decorative only — the tile's own text already names it,
                  // so a null or failed asset leaves a plain card and loses
                  // nothing but the picture.
                  ArtworkPanel(slot: data.slot, scrim: ArtworkScrim.none),
                  Positioned(
                    top: AppSpacing.sm,
                    right: AppSpacing.sm,
                    // A solid badge rather than a bare glyph: it carries its
                    // own fill and outline, so it stays readable over
                    // whatever the artwork happens to put behind it.
                    child: PoppyIcon(
                      icon: data.icon,
                      size: 34,
                      background: ext.palette.primary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.base,
                  AppSpacing.md,
                  AppSpacing.base,
                  AppSpacing.base,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(data.title, style: theme.textTheme.titleLarge),
                    const Gap(2),
                    Text(data.subtitle, style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
