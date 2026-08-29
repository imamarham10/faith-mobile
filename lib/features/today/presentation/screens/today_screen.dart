import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

import '../../../../core/preferences/selected_faith.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/faith_id.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/mascot_view.dart';
import '../../../../shared/widgets/section_label.dart';
import '../../../calendar/presentation/controllers/calendar_controller.dart';
import '../widgets/daily_hadith_card.dart';
import '../widgets/mood_prompt.dart';
import '../widgets/prayer_countdown_card.dart';
import '../widgets/quick_actions_row.dart';
import '../widgets/verse_card.dart';

/// The first impression — sets the brand tone and the architectural pattern
/// Phase 1 feature agents will mirror.
///
/// Faith-aware: branches on [selectedFaithProvider] and picks content by
/// faith. Islam has the full Phase 1 build-out (`_IslamTodayContent`); Hindu
/// doesn't have a Today vertical yet (that's Part C), so it gets an honest
/// placeholder rather than either crashing or silently reusing Islam copy.
class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final faith = ref.watch(selectedFaithProvider).valueOrNull ?? FaithId.islam;
    return switch (faith) {
      FaithId.islam => const _IslamTodayContent(),
      FaithId.hindu => const _HinduTodayPlaceholder(),
    };
  }
}

/// The full Islam "Today" build-out: Hijri-dated greeting, prayer countdown,
/// verse/hadith of the day, mood prompt, quick actions.
class _IslamTodayContent extends ConsumerWidget {
  const _IslamTodayContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    // Prefer the server's calendarAdjust-corrected Hijri date (kept in sync
    // with the Calendar screen's grid); fall back to the local, uncorrected
    // package while loading or on a network error so the greeting never
    // blocks or blanks — being briefly one day off during a cold start is
    // far less jarring than an empty header.
    final serverToday = ref.watch(hijriTodayProvider).valueOrNull;
    final hijriLabel = serverToday != null
        ? '${serverToday.hijriDay} ${serverToday.hijriMonthName}'
        : '${HijriCalendar.fromDate(now).hDay} ${HijriCalendar.fromDate(now).getLongMonthName()}';
    final dayLabel = '${DateFormat.EEEE().format(now)} · $hijriLabel';

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            SliverToBoxAdapter(child: _Greeting(dayLabel: dayLabel)),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenEdge,
                0,
                AppSpacing.screenEdge,
                AppSpacing.xxl,
              ),
              sliver: SliverList.list(
                children: [
                  PrayerCountdownCard(
                    onTap: () => context.push('/today/prayers'),
                  ),
                  const Gap(32),
                  const SectionLabel('Verse for today'),
                  const Gap(16),
                  VerseCard(
                    arabic: 'وَمَن يَتَّقِ ٱللَّهَ يَجْعَل لَّهُۥ مَخْرَجًا',
                    translation:
                        'And whoever fears Allah — He will make for him a way out.',
                    reference: 'At-Talaq 65:2',
                    onTap: () => context.push('/quran/surah/65?ayah=2'),
                  ),
                  const Gap(24),
                  const SectionLabel('Hadith of the day'),
                  const Gap(16),
                  const DailyHadithCard(),
                  const Gap(24),
                  const MoodPrompt(),
                  const Gap(32),
                  const SectionLabel('Quick'),
                  const Gap(12),
                  const QuickActionsRow(),
                  const Gap(24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Part C (the Hindu vertical) hasn't been built yet, so there is no real
/// Hindu "Today" content to show. This is a deliberately honest placeholder
/// — not a crash, not a silent reuse of Islam's greeting/prayer/verse copy —
/// and should be replaced with real Hindu home content once Part C lands.
class _HinduTodayPlaceholder extends StatelessWidget {
  const _HinduTodayPlaceholder();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Align(
              alignment: Alignment.topRight,
              child: _SettingsButton(),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenEdge,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const MascotView(
                        faith: FaithId.hindu,
                        state: MascotState.idle,
                      ),
                      const Gap(AppSpacing.lg),
                      Text(
                        'Hindu home is coming soon',
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
          ],
        ),
      ),
    );
  }
}

class _Greeting extends StatelessWidget {
  const _Greeting({required this.dayLabel});

  final String dayLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenEdge,
              AppSpacing.lg,
              0,
              AppSpacing.xl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'As-salāmu ʿalaykum',
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.push('/today/calendar');
                  },
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          dayLabel,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.chevron_right,
                        size: 16,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const _SettingsButton(),
      ],
    );
  }
}

/// Top-right settings affordance shared by every faith branch's Today
/// layout — one canonical inset (lifted from `_Greeting`'s original padding,
/// the more deliberate of the two independently-tuned insets that existed
/// pre-refactor) so switching faiths never visibly moves the settings
/// button.
class _SettingsButton extends StatelessWidget {
  const _SettingsButton();

  static const EdgeInsets padding = EdgeInsets.fromLTRB(
    AppSpacing.screenEdge,
    AppSpacing.lg,
    AppSpacing.screenEdge,
    AppSpacing.xl,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: IconButton(
        tooltip: 'Settings',
        icon: const Icon(Icons.settings_outlined),
        onPressed: () {
          HapticFeedback.selectionClick();
          context.push('/settings');
        },
      ),
    );
  }
}
