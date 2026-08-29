import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/section_label.dart';
import '../../../calendar/presentation/controllers/calendar_controller.dart';
import '../widgets/daily_hadith_card.dart';
import '../widgets/mood_prompt.dart';
import '../widgets/prayer_countdown_card.dart';
import '../widgets/quick_actions_row.dart';
import '../widgets/verse_card.dart';

/// The first impression — sets the brand tone and the architectural pattern
/// Phase 1 feature agents will mirror.
class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

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

class _Greeting extends StatelessWidget {
  const _Greeting({required this.dayLabel});

  final String dayLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenEdge,
        AppSpacing.lg,
        AppSpacing.screenEdge,
        AppSpacing.xl,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
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
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              HapticFeedback.selectionClick();
              context.push('/settings');
            },
          ),
        ],
      ),
    );
  }
}
