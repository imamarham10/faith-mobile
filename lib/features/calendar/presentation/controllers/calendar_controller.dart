import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/calendar_repository.dart';
import '../../data/dtos/hijri_day.dart';
import '../../data/dtos/hijri_today.dart';
import '../../data/dtos/islamic_event.dart';

part 'calendar_controller.g.dart';

/// Cached list of all Islamic events (Hijri-anchored).
@Riverpod(keepAlive: true)
Future<List<IslamicEvent>> islamicEvents(Ref ref) {
  final repo = ref.watch(calendarRepositoryProvider);
  return repo.getEvents();
}

/// Server-side, calendarAdjust-corrected "today" — consumed by the Today
/// screen's greeting so it agrees with the Calendar screen's grid rather
/// than each computing its own (previously uncorrected, and now
/// inconsistent-with-each-other) local Hijri date. Callers should fall back
/// to a local approximation while loading/on error (see
/// `today_screen.dart`) rather than blocking the greeting on network.
@riverpod
Future<HijriToday> hijriToday(Ref ref) {
  final repo = ref.watch(calendarRepositoryProvider);
  return repo.getToday();
}

/// Single event lookup helper.
@riverpod
Future<IslamicEvent?> islamicEventById(Ref ref, String id) async {
  final all = await ref.watch(islamicEventsProvider.future);
  for (final e in all) {
    if (e.id == id) return e;
  }
  return null;
}

/// One day-cell in the calendar grid.
class HijriDayCell {
  const HijriDayCell({
    required this.gregorianDate,
    required this.hijriDay,
    required this.hijriMonth,
    required this.hijriYear,
    required this.inViewMonth,
    required this.events,
  });

  final DateTime gregorianDate;
  final int hijriDay;
  final int hijriMonth;
  final int hijriYear;
  final bool inViewMonth;
  final List<IslamicEvent> events;
}

/// Materialized 6-row x 7-col grid for either Hijri- or Gregorian-primary view.
class CalendarMonthData {
  const CalendarMonthData({
    required this.cells,
    required this.eventsThisMonth,
    required this.hijriMonthLabel,
    required this.gregorianMonthLabel,
  });

  final List<HijriDayCell> cells;
  final List<IslamicEvent> eventsThisMonth;
  final String hijriMonthLabel;
  final String gregorianMonthLabel;
}

/// Whether the user is browsing by Hijri or Gregorian month.
enum CalendarMode { hijri, gregorian }

/// Anchor month — for Hijri mode it's a (hijriYear, hijriMonth); for Gregorian
/// it's a (year, month). Stored as a single `DateTime`-like record for
/// simplicity.
class CalendarAnchor {
  const CalendarAnchor({
    required this.mode,
    required this.year,
    required this.month,
  });

  final CalendarMode mode;
  final int year;
  final int month;

  CalendarAnchor copyWith({CalendarMode? mode, int? year, int? month}) =>
      CalendarAnchor(
        mode: mode ?? this.mode,
        year: year ?? this.year,
        month: month ?? this.month,
      );

  /// Returns the next anchor in the active mode.
  CalendarAnchor next() {
    final m = month + 1;
    if (mode == CalendarMode.hijri) {
      if (m > 12) return copyWith(year: year + 1, month: 1);
      return copyWith(month: m);
    }
    if (m > 12) return copyWith(year: year + 1, month: 1);
    return copyWith(month: m);
  }

  CalendarAnchor previous() {
    final m = month - 1;
    if (m < 1) return copyWith(year: year - 1, month: 12);
    return copyWith(month: m);
  }
}

/// Controls the active calendar anchor + mode.
@Riverpod(keepAlive: true)
class CalendarAnchorController extends _$CalendarAnchorController {
  @override
  CalendarAnchor build() {
    final today = HijriCalendar.now();
    return CalendarAnchor(
      mode: CalendarMode.hijri,
      year: today.hYear,
      month: today.hMonth,
    );
  }

  void setMode(CalendarMode mode) {
    if (mode == state.mode) return;
    // Anchor on day 15 (mid-month) when converting between systems. Hijri and
    // Gregorian months drift ~10 days, so day 1 of one rarely lives in the
    // *current* month of the other — using day 15 keeps the converted month
    // overlapping the period the user is looking at, and avoids the
    // "switching toggles drifts backward" bug.
    if (mode == CalendarMode.hijri) {
      final greg = DateTime(state.year, state.month, 15);
      final h = HijriCalendar.fromDate(greg);
      state = CalendarAnchor(
        mode: CalendarMode.hijri,
        year: h.hYear,
        month: h.hMonth,
      );
    } else {
      final greg = HijriCalendar().hijriToGregorian(
        state.year,
        state.month,
        15,
      );
      state = CalendarAnchor(
        mode: CalendarMode.gregorian,
        year: greg.year,
        month: greg.month,
      );
    }
  }

  void next() => state = state.next();
  void previous() => state = state.previous();
}

/// Builds the 42-cell grid for the active anchor and folds in any events for
/// the visible Hijri month.
///
/// Grid-window seeding (which Gregorian dates the 42 cells span) still uses
/// the local `hijri` package — it only needs to be in the right ballpark
/// (the 42-cell window has generous lead-in/lead-out slack either side of
/// the target month), so a ~1-day local approximation here is harmless. The
/// per-cell Hijri day/month/year actually shown to the user — and therefore
/// which cells highlight as "in view" and which events land on which day —
/// comes from the backend's calendarAdjust-corrected `/gregorian-month`
/// endpoint instead, since that's the data users actually read off screen
/// (see kCalendarAdjust's doc comment for why the correction matters).
@riverpod
Future<CalendarMonthData> calendarMonth(Ref ref) async {
  final anchor = ref.watch(calendarAnchorControllerProvider);
  final events = await ref.watch(islamicEventsProvider.future);
  final repo = ref.watch(calendarRepositoryProvider);

  // Determine the Gregorian first-of-view-month start, then back up to the
  // Sunday before so we render a stable 6×7 grid regardless of weekday.
  late final DateTime gregFirst;
  late final int viewGregMonth;
  late final int viewGregYear;

  if (anchor.mode == CalendarMode.hijri) {
    final h = HijriCalendar()
      ..hYear = anchor.year
      ..hMonth = anchor.month
      ..hDay = 1;
    gregFirst = h.hijriToGregorian(anchor.year, anchor.month, 1);
    viewGregMonth = gregFirst.month;
    viewGregYear = gregFirst.year;
  } else {
    gregFirst = DateTime(anchor.year, anchor.month, 1);
    viewGregMonth = anchor.month;
    viewGregYear = anchor.year;
  }

  // Sunday-leading grid. weekday: Mon=1..Sun=7 → offset back to Sunday.
  final firstWeekday = gregFirst.weekday % 7; // 0..6 with Sun=0
  final gridStart = gregFirst.subtract(Duration(days: firstWeekday));
  final gridDates = List.generate(
    42,
    (i) => DateTime(gridStart.year, gridStart.month, gridStart.day + i),
  );

  // Fetch every distinct Gregorian (year, month) the 42-cell grid touches —
  // typically 2, occasionally 3 — from the corrected backend endpoint.
  final monthKeys = <String>{};
  final monthsToFetch = <(int, int)>[];
  for (final date in gridDates) {
    final key = '${date.year}-${date.month}';
    if (monthKeys.add(key)) monthsToFetch.add((date.year, date.month));
  }
  final fetched = await Future.wait(
    monthsToFetch.map((ym) => repo.getGregorianMonth(ym.$1, ym.$2)),
  );
  final byDate = <String, HijriDay>{
    for (final month in fetched)
      for (final day in month) day.gregorianDate: day,
  };

  String dateKey(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  // Fallback to the local package only if a date is somehow missing from the
  // fetched months (shouldn't happen — defensive, not the happy path).
  HijriDay resolve(DateTime date) {
    final hit = byDate[dateKey(date)];
    if (hit != null) return hit;
    final h = HijriCalendar.fromDate(date);
    return HijriDay(
      hijriDay: h.hDay,
      hijriMonth: h.hMonth,
      hijriYear: h.hYear,
      hijriMonthName: h.getLongMonthName(),
      gregorianDate: dateKey(date),
      dayOfWeek: '',
    );
  }

  // Hijri mode: the anchor itself IS the Hijri (year, month) being viewed —
  // no need to derive it. Gregorian mode: derive it from gregFirst's info.
  final gregFirstInfo = resolve(gregFirst);
  final viewHijriMonth =
      anchor.mode == CalendarMode.hijri ? anchor.month : gregFirstInfo.hijriMonth;
  final viewHijriYear =
      anchor.mode == CalendarMode.hijri ? anchor.year : gregFirstInfo.hijriYear;

  final cells = <HijriDayCell>[];
  for (final date in gridDates) {
    final info = resolve(date);
    final inView = anchor.mode == CalendarMode.hijri
        ? (info.hijriMonth == viewHijriMonth && info.hijriYear == viewHijriYear)
        : (date.month == viewGregMonth && date.year == viewGregYear);

    final dayEvents = events
        .where(
          (e) => e.hijriMonth == info.hijriMonth && e.hijriDay == info.hijriDay,
        )
        .toList(growable: false);

    cells.add(
      HijriDayCell(
        gregorianDate: date,
        hijriDay: info.hijriDay,
        hijriMonth: info.hijriMonth,
        hijriYear: info.hijriYear,
        inViewMonth: inView,
        events: dayEvents,
      ),
    );
  }

  // Events in the visible Hijri month, sorted by hijri day.
  final eventsThisMonth =
      events.where((e) => e.hijriMonth == viewHijriMonth).toList(growable: true)
        ..sort((a, b) => a.hijriDay.compareTo(b.hijriDay));

  // Labels — Hijri month name from the package (name lookup only, not a
  // date conversion, so calendarAdjust doesn't apply here), Gregorian via
  // DateFormat.
  final hijriProbe = HijriCalendar()
    ..hYear = viewHijriYear
    ..hMonth = viewHijriMonth
    ..hDay = 1;

  final hijriLabel = '${hijriProbe.getLongMonthName()} $viewHijriYear';
  final monthDate = DateTime(viewGregYear, viewGregMonth);
  final gregLabel = _formatGregMonth(monthDate);

  return CalendarMonthData(
    cells: cells,
    eventsThisMonth: eventsThisMonth,
    hijriMonthLabel: hijriLabel,
    gregorianMonthLabel: gregLabel,
  );
}

String _formatGregMonth(DateTime date) {
  const monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return '${monthNames[date.month - 1]} ${date.year}';
}
