import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';

/// Four-slide intro per design spec line 124. Final slide CTA jumps to
/// `/onboarding/faith` for faith selection.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pages = PageController();
  int _index = 0;

  static const _slides = <_SlideData>[
    _SlideData(
      icon: Icons.self_improvement_rounded,
      tint: Color(0xFF7A8E73),
      title: 'Your spiritual companion',
      body: 'Siraat helps you build and maintain your spiritual practice — '
          'gently, steadily, day by day.',
    ),
    _SlideData(
      icon: Icons.notifications_active_rounded,
      tint: Color(0xFFB08B5C),
      title: 'Never miss a prayer',
      body: 'Accurate prayer times for your location, with soft reminders '
          'that respect your day.',
    ),
    _SlideData(
      icon: Icons.menu_book_rounded,
      tint: Color(0xFFB089C9),
      title: 'Read, reflect, grow',
      body: 'Quran reader, dhikr counter, dua library, hadiths — '
          'all in one quiet place.',
    ),
    _SlideData(
      icon: Icons.insights_rounded,
      tint: Color(0xFFC9A95F),
      title: 'Your journey, your way',
      body: 'Track your progress and grow at your own pace. '
          'No streak shame, no noise.',
    ),
  ];

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _next() {
    HapticFeedback.lightImpact();
    if (_index < _slides.length - 1) {
      _pages.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    } else {
      context.go(Routes.faithSelection);
    }
  }

  void _skip() {
    HapticFeedback.selectionClick();
    context.go(Routes.faithSelection);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isLast = _index == _slides.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.sm,
                0,
              ),
              child: Row(
                children: [
                  const Spacer(),
                  TextButton(
                    onPressed: isLast ? null : _skip,
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: isLast
                            ? cs.onSurfaceVariant.withValues(alpha: 0.4)
                            : cs.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pages,
                onPageChanged: (i) => setState(() => _index = i),
                itemCount: _slides.length,
                itemBuilder: (_, i) => _Slide(data: _slides[i], pageIndex: i),
              ),
            ),
            _DotIndicator(count: _slides.length, index: _index),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.xl,
              ),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _next,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  child: Text(isLast ? 'Get started' : 'Next'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SlideData {
  const _SlideData({
    required this.icon,
    required this.tint,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final Color tint;
  final String title;
  final String body;
}

class _Slide extends StatelessWidget {
  const _Slide({required this.data, required this.pageIndex});

  final _SlideData data;
  // Used to key animations so each page swipe re-plays its hero entrance.
  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        children: [
          const Spacer(flex: 2),
          // Halo behind the icon for warmth — pulses while visible.
          SizedBox(
                width: 220,
                height: 220,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            data.tint.withValues(alpha: 0.28),
                            data.tint.withValues(alpha: 0),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 132,
                      height: 132,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: data.tint.withValues(alpha: 0.15),
                      ),
                      alignment: Alignment.center,
                      child: Icon(data.icon, size: 60, color: data.tint),
                    ),
                  ],
                ),
              )
              .animate(key: ValueKey('hero-$pageIndex'))
              .fadeIn(duration: 450.ms, curve: Curves.easeOut)
              .scaleXY(
                begin: 0.86,
                end: 1.0,
                duration: 520.ms,
                curve: Curves.easeOutCubic,
              ),
          const SizedBox(height: 40),
          Text(
                data.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.fraunces(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface,
                  height: 1.2,
                ),
              )
              .animate(key: ValueKey('title-$pageIndex'))
              .fadeIn(delay: 220.ms, duration: 420.ms)
              .moveY(begin: 8, end: 0, delay: 220.ms, duration: 420.ms),
          const SizedBox(height: 16),
          Text(
                data.body,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              )
              .animate(key: ValueKey('body-$pageIndex'))
              .fadeIn(delay: 380.ms, duration: 480.ms),
          const Spacer(flex: 3),
        ],
      ),
    );
  }
}

class _DotIndicator extends StatelessWidget {
  const _DotIndicator({required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 240),
            curve: Curves.easeOutCubic,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: i == index ? 22 : 7,
            height: 7,
            decoration: BoxDecoration(
              color: i == index
                  ? cs.primary
                  : cs.onSurfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
      ],
    );
  }
}
