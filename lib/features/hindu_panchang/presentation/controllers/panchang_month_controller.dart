import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/location/location_service.dart';
import '../../data/dtos/panchang_day.dart';
import '../../data/hindu_panchang_repository.dart';

part 'panchang_month_controller.g.dart';

/// One grid cell. Unlike Islamic calendar's dual Hijri/Gregorian cells,
/// panchang is Gregorian-native, so there's no mode toggle — just a plain
/// date, whether it's in the viewed month, and (for in-month cells only)
/// that day's already-fetched [PanchangDay].
///
/// Leading/trailing cells from adjacent months intentionally carry no
/// [panchangDay] — the backend computes each day's panchang serially
/// (documented server-side as a sequential per-day astronomy computation,
/// no batching), so fetching 1–2 extra months just to populate grid padding
/// cells would multiply an already-expensive month fetch for cells the user
/// mostly just skims past. Those cells render as a plain muted day number
/// with no festival dot.
class PanchangDayCell {
  const PanchangDayCell({
    required this.date,
    required this.inViewMonth,
    this.panchangDay,
  });

  final DateTime date;
  final bool inViewMonth;
  final PanchangDay? panchangDay;
}

class PanchangMonthGridData {
  const PanchangMonthGridData({
    required this.cells,
    required this.monthLabel,
  });

  final List<PanchangDayCell> cells;
  final String monthLabel;
}

/// The viewed (year, month). No mode enum needed (see [PanchangDayCell]).
class PanchangAnchor {
  const PanchangAnchor({required this.year, required this.month});

  final int year;
  final int month;

  PanchangAnchor next() {
    return month == 12
        ? PanchangAnchor(year: year + 1, month: 1)
        : PanchangAnchor(year: year, month: month + 1);
  }

  PanchangAnchor previous() {
    return month == 1
        ? PanchangAnchor(year: year - 1, month: 12)
        : PanchangAnchor(year: year, month: month - 1);
  }
}

@Riverpod(keepAlive: true)
class PanchangAnchorController extends _$PanchangAnchorController {
  @override
  PanchangAnchor build() {
    final now = DateTime.now();
    return PanchangAnchor(year: now.year, month: now.month);
  }

  void next() => state = state.next();

  void previous() => state = state.previous();
}

const _monthNames = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];

/// Builds the 42-cell (Sunday-leading) month grid for a given (year, month).
/// A family keyed by both, `keepAlive`, so paging back to a previously
/// viewed month within a session is instant — the screen watches
/// `panchangMonthGridProvider(anchor.year, anchor.month)` rather than
/// reading the anchor internally, so each month combination gets its own
/// cached instance instead of one shared provider re-fetching on every page.
@Riverpod(keepAlive: true)
Future<PanchangMonthGridData?> panchangMonthGrid(
  Ref ref,
  int year,
  int month,
) async {
  final loc = await ref.watch(locationServiceProvider).currentPosition();
  if (loc == null) return null;

  final repo = ref.watch(hinduPanchangRepositoryProvider);
  final monthData = await repo.getMonth(
    year,
    month,
    lat: loc.latitude,
    lng: loc.longitude,
  );

  final byDay = <int, PanchangDay>{
    for (final d in monthData.days) DateTime.parse(d.date).day: d,
  };

  final firstOfMonth = DateTime(year, month, 1);
  // Sunday-leading grid, same algorithm as the Islamic calendar's own grid.
  final firstWeekday = firstOfMonth.weekday % 7; // Mon=1..Sun=7 -> Sun=0
  final gridStart = firstOfMonth.subtract(Duration(days: firstWeekday));

  final cells = List<PanchangDayCell>.generate(42, (i) {
    final date = gridStart.add(Duration(days: i));
    final inViewMonth = date.year == year && date.month == month;
    return PanchangDayCell(
      date: date,
      inViewMonth: inViewMonth,
      panchangDay: inViewMonth ? byDay[date.day] : null,
    );
  });

  return PanchangMonthGridData(
    cells: cells,
    monthLabel: '${_monthNames[month - 1]} $year',
  );
}
