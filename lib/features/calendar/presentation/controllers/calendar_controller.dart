import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/calendar_repository.dart';
import '../../data/dtos/islamic_event.dart';

part 'calendar_controller.g.dart';

/// Cached list of all Islamic events (Hijri-anchored).
@Riverpod(keepAlive: true)
Future<List<IslamicEvent>> islamicEvents(Ref ref) {
  final repo = ref.watch(calendarRepositoryProvider);
  return repo.getEvents();
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
@riverpod
Future<CalendarMonthData> calendarMonth(Ref ref) async {
  final anchor = ref.watch(calendarAnchorControllerProvider);
  final events = await ref.watch(islamicEventsProvider.future);

  // Determine the Gregorian first-of-view-month start, then back up to the
  // Sunday before so we render a stable 6×7 grid regardless of weekday.
  late final DateTime gregFirst;
  late final int viewHijriMonth;
  late final int viewHijriYear;
  late final int viewGregMonth;
  late final int viewGregYear;

  if (anchor.mode == CalendarMode.hijri) {
    final h = HijriCalendar()
      ..hYear = anchor.year
      ..hMonth = anchor.month
      ..hDay = 1;
    gregFirst = h.hijriToGregorian(anchor.year, anchor.month, 1);
    viewHijriMonth = anchor.month;
    viewHijriYear = anchor.year;
    viewGregMonth = gregFirst.month;
    viewGregYear = gregFirst.year;
  } else {
    gregFirst = DateTime(anchor.year, anchor.month, 1);
    final h = HijriCalendar.fromDate(gregFirst);
    viewHijriMonth = h.hMonth;
    viewHijriYear = h.hYear;
    viewGregMonth = anchor.month;
    viewGregYear = anchor.year;
  }

  // Sunday-leading grid. weekday: Mon=1..Sun=7 → offset back to Sunday.
  final firstWeekday = gregFirst.weekday % 7; // 0..6 with Sun=0
  final gridStart = gregFirst.subtract(Duration(days: firstWeekday));

  final cells = <HijriDayCell>[];
  for (var i = 0; i < 42; i++) {
    final date = DateTime(gridStart.year, gridStart.month, gridStart.day + i);
    final h = HijriCalendar.fromDate(date);
    final inView = anchor.mode == CalendarMode.hijri
        ? (h.hMonth == viewHijriMonth && h.hYear == viewHijriYear)
        : (date.month == viewGregMonth && date.year == viewGregYear);

    final dayEvents = events
        .where((e) => e.hijriMonth == h.hMonth && e.hijriDay == h.hDay)
        .toList(growable: false);

    cells.add(
      HijriDayCell(
        gregorianDate: date,
        hijriDay: h.hDay,
        hijriMonth: h.hMonth,
        hijriYear: h.hYear,
        inViewMonth: inView,
        events: dayEvents,
      ),
    );
  }

  // Events in the visible Hijri month, sorted by hijri day.
  final eventsThisMonth =
      events.where((e) => e.hijriMonth == viewHijriMonth).toList(growable: true)
        ..sort((a, b) => a.hijriDay.compareTo(b.hijriDay));

  // Labels — Hijri month name from the package, Gregorian via DateFormat.
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
