import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/notifications/notification_service.dart';
import '../../../../core/router/routes.dart';
import '../../../../shared/widgets/poppy_button.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../../../shared/widgets/poppy_icon.dart';

/// Two-slide intro per design doc §3 (condensed from the original 4):
/// (1) brand/value-prop, (2) notification-permission ask. Final slide CTA
/// jumps to `/onboarding/faith` for faith selection — this screen runs
/// *before* a faith is chosen, so its visuals stay faith-neutral: no
/// [MascotView] here (its faith-specific accessory — crescent-and-star vs.
/// diya flame — would read as a religious-symbol claim on the screen right
/// before "Choose your path"). [PoppyIcon] is used instead: it only picks up
/// the active palette's brand *color*, which is ambient/pre-existing
/// (main.dart already falls back to the Islam palette before a faith is
/// selected) rather than a symbolic statement. Mascot-narrated onboarding
/// per the design doc becomes possible once onboarding moves *after* the
/// picker — out of scope for this task.
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
      title: 'Meet Siraat',
      body:
          'Your gentle companion for building a steady spiritual '
          'practice — one small step at a time.',
    ),
    _SlideData(
      icon: Icons.notifications_active_rounded,
      title: 'Stay gently on track',
      body:
          'Turn on notifications so Siraat can nudge you at the right '
          'moments. Nothing pushy — just a gentle reminder.',
      showPermissionAction: true,
    ),
  ];

  // Lifted up here (rather than kept inside a per-page widget) so it
  // survives page swipes: PageView.builder's children aren't wrapped in
  // AutomaticKeepAliveClientMixin, so per-page State could be disposed once
  // a page scrolls out of the viewport/cache extent.
  bool? _remindersGranted;

  Future<void> _enableReminders() async {
    HapticFeedback.mediumImpact();
    final granted = await NotificationService.instance.requestPermissions();
    if (!mounted) return;
    setState(() => _remindersGranted = granted);
  }

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
              padding: const EdgeInsets.fromLTRB(20, 8, 8, 0),
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
                itemBuilder: (_, i) => _Slide(
                  data: _slides[i],
                  pageIndex: i,
                  remindersGranted: _remindersGranted,
                  onEnableReminders: _enableReminders,
                ),
              ),
            ),
            _DotIndicator(count: _slides.length, index: _index),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: SizedBox(
                width: double.infinity,
                child: PoppyButton(
                  label: isLast ? 'Get started' : 'Next',
                  onPressed: _next,
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
    required this.title,
    required this.body,
    this.showPermissionAction = false,
  });

  final IconData icon;
  final String title;
  final String body;
  // True only for the notification-permission slide — kept on the data
  // rather than inferred from a page index, so reordering/inserting slides
  // can't silently misplace the in-card action.
  final bool showPermissionAction;
}

class _Slide extends StatelessWidget {
  const _Slide({
    required this.data,
    required this.pageIndex,
    required this.remindersGranted,
    required this.onEnableReminders,
  });

  final _SlideData data;
  // Used to key animations so each page swipe re-plays its hero entrance.
  final int pageIndex;
  final bool? remindersGranted;
  final VoidCallback onEnableReminders;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const Spacer(flex: 2),
          PoppyCard(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PoppyIcon(icon: data.icon, size: 72),
                    const SizedBox(height: 24),
                    Text(
                      data.title,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.displaySmall,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      data.body,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge,
                    ),
                    if (data.showPermissionAction) ...[
                      const SizedBox(height: 20),
                      PoppyButton(
                        label: remindersGranted == true
                            ? 'Reminders on'
                            : 'Turn on reminders',
                        icon: remindersGranted == true
                            ? Icons.check_circle
                            : Icons.notifications_active_rounded,
                        variant: PoppyButtonVariant.secondary,
                        onPressed: remindersGranted == true
                            ? null
                            : onEnableReminders,
                      ),
                      if (remindersGranted == false) ...[
                        const SizedBox(height: 8),
                        Text(
                          'You can turn these on later in Settings.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ],
                ),
              )
              .animate(key: ValueKey('hero-$pageIndex'))
              .fadeIn(duration: 450.ms, curve: Curves.easeOut)
              .moveY(
                begin: 12,
                end: 0,
                duration: 450.ms,
                curve: Curves.easeOutCubic,
              ),
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
