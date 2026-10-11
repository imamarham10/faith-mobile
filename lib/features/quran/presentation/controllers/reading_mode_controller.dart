import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/reading_mode.dart';

part 'reading_mode_controller.g.dart';

/// Which reader a surah opens in, remembered across launches.
///
/// ## Why a remembered preference and not a choice on tap
///
/// Every entry point to a surah — an "Often read" chip, a collection item,
/// the index, Continue reading — is a one-tap affordance, and all of them
/// would have to grow the same second step. Reading mode is also not a
/// per-surah decision: someone who reads verse by verse reads *everything*
/// that way, because the reason is how they read (slowly, with the
/// translation, one ayah at a time) and not which surah it is. A chooser
/// would ask the same question several times a day and get the same answer
/// every time.
///
/// ## Why it is set from inside the reader
///
/// There is no mode switch on the Qur'an tab, deliberately: the tab already
/// has a Surah | Juz segmented control, and a second segmented control
/// beside it meaning a different thing is how you make both unreadable.
/// Instead each reader carries a button to the other one, which both
/// *performs* the switch for the surah in hand and records it as the new
/// default. The preference is therefore never set in the abstract — it is
/// always set by someone looking at the layout they are choosing between.
///
/// Persisted with `shared_preferences`, like [LastReadController] and the
/// Arabic script preference. Not folded into `ReaderPreferences`, which is
/// documented as in-memory only and would forget the choice on every
/// restart — which is the one thing this must not do.
@Riverpod(keepAlive: true)
class ReadingModeController extends _$ReadingModeController {
  static const _key = 'quran.readingMode';

  @override
  Future<ReadingMode> build() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return ReadingMode.continuous;
    return ReadingMode.values.firstWhere(
      (m) => m.name == raw,
      orElse: () => ReadingMode.continuous,
    );
  }

  Future<void> set(ReadingMode mode) async {
    // Optimistic: the switch is a navigation the user is already mid-way
    // through, and nothing downstream should wait on a preferences write.
    state = AsyncValue.data(mode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode.name);
  }
}

/// The mode to open a surah in right now.
///
/// Falls back to [ReadingMode.continuous] while the preference is still
/// loading — which is the mode a reader who has never chosen gets anyway,
/// so a tap during the first few milliseconds of a cold start behaves
/// exactly like a tap from a fresh install rather than stalling.
ReadingMode activeReadingMode(WidgetRef ref) =>
    ref.watch(readingModeControllerProvider).valueOrNull ??
    ReadingMode.continuous;
