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
import '../../../../shared/widgets/poppy_card.dart';
import '../../../../shared/widgets/poppy_icon.dart';
import '../../../../shared/widgets/poppy_skeleton.dart';
import '../../../../shared/widgets/section_label.dart';
import '../../../calendar/presentation/controllers/calendar_controller.dart';
import '../../../collections/presentation/widgets/featured_collection_card.dart';
import '../../../hindu_panchang/presentation/controllers/panchang_today_controller.dart';
import '../../../hindu_puja_times/presentation/widgets/puja_countdown_card.dart';
import '../../../quran/presentation/widgets/often_read_row.dart';
import '../widgets/below_fold.dart';
import '../widgets/continue_reading_card.dart';
import '../widgets/daily_hadith_card.dart';
import '../widgets/daily_katha_card.dart';
import '../widgets/daily_shloka_card.dart';
import '../widgets/daily_verse_card.dart';
import '../widgets/mood_prompt.dart';
import '../widgets/prayer_countdown_card.dart';
import '../widgets/quick_actions_row.dart';
import '../widgets/streak_chip.dart';
import '../widgets/today_progress_section.dart';

/// The first impression — sets the brand tone and the architectural pattern
/// Phase 1 feature agents will mirror.
///
/// Faith-aware: branches on [selectedFaithProvider] and picks content by
/// faith. Islam has the full Phase 1 build-out (`_IslamTodayContent`);
/// Hindu's own build-out (`_HinduTodayContent`) mirrors its shape with the
/// Hindu equivalents built in Part C — panchang in place of the Hijri
/// calendar, sandhya countdown in place of prayer countdown.
///
/// ## The order of the first three blocks
///
/// Greeting → continue-reading → featured collection → habit loop, in both
/// faiths, through the same widgets.
///
/// Reading comes first because it is the act the app exists to support:
/// every other block on this screen *reports on* a practice, and this one
/// is the practice. For a returning reader the highest-value thing on the
/// dashboard is one tap back to the verse they stopped on.
///
/// The habit loop — [TodayProgressSection] — stays whole and moves down
/// behind it. That section is week strip, goal card, checklist and stat
/// tiles as a single unit, built once for both faiths, and it owns the
/// release of the below-the-fold gate. Interleaving continue-reading
/// between its strip and its goal card would mean splitting a deliberate
/// unit into fragments and giving one of them the gate, which is a real
/// cost paid for a cosmetic resemblance to a reference screenshot. The
/// greeting still carries the streak chip, so the "how am I doing" signal
/// is above the fold regardless.
///
/// Neither of the two new blocks adds a request to the launch path: the
/// continue-reading card reads only `shared_preferences`, and the featured
/// collection waits behind the same below-the-fold gate it always did.
class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final faith = ref.watch(selectedFaithProvider).valueOrNull ?? FaithId.islam;
    return switch (faith) {
      FaithId.islam => const _IslamTodayContent(),
      FaithId.hindu => const _HinduTodayContent(),
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
                  // Reading leads — see this file's class doc for the
                  // argument, and `continue_reading_card.dart` for why
                  // putting it here costs the habit loop nothing.
                  const ContinueReadingCard(faith: FaithId.islam),
                  // Then whatever the database has promoted, full width.
                  // See `_FeaturedCollections` for why it is gated and why
                  // it draws nothing until it has something.
                  const _FeaturedCollections(faith: FaithId.islam),
                  // Then the loop: what you did this week, what today's
                  // goal is, and what is left of it.
                  const TodayProgressSection(),
                  const Gap(AppSpacing.xxl),
                  PrayerCountdownCard(
                    onTap: () => context.push('/today/prayers'),
                  ),
                  const Gap(32),
                  const SectionLabel('Verse for today'),
                  const Gap(16),
                  // Deferred: the verse is a whole-surah read, the largest
                  // single payload on this screen, and it was competing
                  // with the two activity reads that gate the habit loop.
                  const BelowFold(
                    placeholder: PoppySkeleton(height: 200),
                    child: DailyVerseCard(),
                  ),
                  const Gap(24),
                  const SectionLabel('Hadith of the day'),
                  const Gap(16),
                  const BelowFold(
                    placeholder: PoppySkeleton(height: 200),
                    child: DailyHadithCard(),
                  ),
                  const Gap(32),
                  // Reading begets reading: this follows the two readings
                  // of the day rather than being filed with the Quick row
                  // at the foot, because the moment someone has just read a
                  // verse is the moment "open a surah" is the obvious next
                  // thing. It is also the cheapest block on this screen —
                  // a constant, so it paints with the first frame and adds
                  // no request to a cold start.
                  const SectionLabel('Often read'),
                  const Gap(12),
                  // Zero inset: this list already carries the screen edge,
                  // and the row's own default would start the chips two
                  // margins in.
                  const OftenReadRow(showLabel: false, horizontalPadding: 0),
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

/// The full Hindu "Today" build-out, mirroring `_IslamTodayContent`'s
/// shape: a panchang-dated greeting (in place of the Hijri date), a sandhya
/// countdown (in place of the prayer countdown), a shloka/katha pair (in
/// place of verse/hadith), and quick actions into Japa/Stotras/Temples (in
/// place of Qibla/Tasbih/Last-read). No mood-prompt equivalent — that
/// copy is Islam-specific with no faith-neutral Hindu counterpart built
/// yet.
class _HinduTodayContent extends ConsumerWidget {
  const _HinduTodayContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final panchang = ref.watch(panchangTodayControllerProvider).valueOrNull;
    final dayLabel = panchang != null
        ? '${DateFormat.EEEE().format(now)} · ${panchang.tithi.name}'
        : DateFormat.EEEE().format(now);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            SliverToBoxAdapter(child: _HinduGreeting(dayLabel: dayLabel)),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenEdge,
                0,
                AppSpacing.screenEdge,
                AppSpacing.xxl,
              ),
              sliver: SliverList.list(
                children: [
                  // Identical treatment to Islam's, in the same order,
                  // through the same two widgets.
                  const ContinueReadingCard(faith: FaithId.hindu),
                  const _FeaturedCollections(faith: FaithId.hindu),
                  const TodayProgressSection(),
                  const Gap(AppSpacing.xxl),
                  PujaCountdownCard(
                    onTap: () => context.push('/today/puja-times'),
                  ),
                  const Gap(32),
                  const SectionLabel('Shloka for today'),
                  const Gap(16),
                  // The Hindu peers of the verse/hadith pair, deferred for
                  // the same reason and through the same gate — the habit
                  // loop above is built once for both faiths.
                  const BelowFold(
                    placeholder: PoppySkeleton(height: 200),
                    child: DailyShlokaCard(),
                  ),
                  const Gap(24),
                  const SectionLabel('Katha for today'),
                  const Gap(16),
                  const BelowFold(
                    placeholder: PoppySkeleton(height: 160),
                    child: DailyKathaCard(),
                  ),
                  const Gap(32),
                  const SectionLabel('Quick'),
                  const Gap(12),
                  const _HinduQuickActionsRow(),
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

/// The featured-collections rail, held back until the habit loop has drawn.
///
/// ## Why it is gated at all, sitting where it does
///
/// This is the first block on the screen, so it is tempting to let it
/// fetch immediately. It must not. Today's cold start was measured going
/// bad under exactly this pressure: eight concurrent requests on a
/// `max: 10` serverless pool turned a 0.99s read into 3.49s. The
/// collections list is one more request on a screen that currently makes
/// none for it, so it waits behind the same gate as the verse and the
/// hadith — the habit loop is what the user is actually waiting for, and
/// nothing above it in the queue may be something they did not ask for.
///
/// The gate is session-scoped and one-way, so only the first cold start
/// pays it; every later visit to Today has both the gate open and the
/// list already cached, and the rail is there in the first frame.
///
/// ## Why the placeholder is nothing
///
/// [BelowFold]'s own doc argues for a matching skeleton, and for the verse
/// and hadith that is right — those are always there, so a silhouette is a
/// true promise. A featured collection may legitimately not exist. A
/// skeleton that resolves to nothing would be a lie told directly above
/// the goal card, and reserving height for it would push the goal down the
/// screen for a thing that may never arrive. So nothing is drawn until
/// there is something to draw, and the rail makes the same choice
/// internally for its loading, error and empty states.
class _FeaturedCollections extends StatelessWidget {
  const _FeaturedCollections({required this.faith});

  final FaithId faith;

  @override
  Widget build(BuildContext context) {
    return BelowFold(
      placeholder: const SizedBox.shrink(),
      child: FeaturedCollectionCard(faith: faith),
    );
  }
}

class _HinduGreeting extends StatelessWidget {
  const _HinduGreeting({required this.dayLabel});

  final String dayLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
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
                Text('Namaste', style: theme.textTheme.headlineMedium),
                const SizedBox(height: 4),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.push('/today/panchang');
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
        const _HeaderActions(),
      ],
    );
  }
}

class _HinduQuickActionsRow extends StatelessWidget {
  const _HinduQuickActionsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _HinduQuickAction(
            icon: Icons.self_improvement,
            label: 'Japa',
            onTap: () => context.push('/practice/japa'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _HinduQuickAction(
            icon: Icons.menu_book_outlined,
            label: 'Stotras',
            onTap: () => context.push('/practice/stotras'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _HinduQuickAction(
            icon: Icons.temple_hindu_outlined,
            label: 'Temples',
            onTap: () => context.push('/practice/temples'),
          ),
        ),
      ],
    );
  }
}

/// Mirrors `quick_actions_row.dart`'s private `_QuickAction` shape exactly
/// — that widget is file-private so this Hindu row needs its own copy
/// rather than importing it.
class _HinduQuickAction extends StatelessWidget {
  const _HinduQuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PoppyCard(
      padding: const EdgeInsets.symmetric(vertical: 20),
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Column(
        children: [
          PoppyIcon(icon: icon, size: 36),
          const SizedBox(height: 8),
          Text(label, style: theme.textTheme.labelLarge),
        ],
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
        Flexible(
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
        const _HeaderActions(),
      ],
    );
  }
}

/// Streak chip plus settings, in the header of every faith branch.
///
/// The chip draws nothing until a streak exists, so on a fresh install this
/// is exactly the settings button it replaced.
class _HeaderActions extends StatelessWidget {
  const _HeaderActions();

  /// One canonical inset for every faith branch — lifted from the original
  /// `_Greeting` padding, the more deliberate of the two independently
  /// tuned insets that existed before — so switching faiths never visibly
  /// moves the settings button.
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const StreakChip(),
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
