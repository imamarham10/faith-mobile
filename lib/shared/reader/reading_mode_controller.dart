import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'reading_mode.dart';

part 'reading_mode_controller.g.dart';

/// Which reader a chapter of scripture opens in, remembered across launches.
///
/// ## Why a remembered preference and not a choice on tap
///
/// Every entry point to a passage — an "Often read" chip, a collection item,
/// the index, Continue reading — is a one-tap affordance, and all of them
/// would have to grow the same second step. Reading mode is also not a
/// per-passage decision: someone who reads verse by verse reads *everything*
/// that way, because the reason is how they read (slowly, with the
/// translation, one verse at a time) and not which surah or chapter it is. A
/// chooser would ask the same question several times a day and get the same
/// answer every time.
///
/// ## Why it is set from inside the reader
///
/// There is no mode switch on the scripture tab, deliberately: the tab
/// already carries its own segmented controls, and a second one beside them
/// meaning a different thing is how you make both unreadable. Instead each
/// reader carries a button to the other one, which both *performs* the
/// switch for the passage in hand and records it as the new default. The
/// preference is therefore never set in the abstract — it is always set by
/// someone looking at the layout they are choosing between.
///
/// ## Why one preference across the verticals
///
/// This is "how you read", not "what you are reading". The paragraph above
/// is the whole argument and not one word of it is about the Qur'an: a
/// reader who wants one verse held on a page wants that for a śloka too.
/// Keeping two would mean someone who set it in the Gita reader and later
/// opened a surah would be asked again, having already answered.
///
/// It was [_legacyKey] while only the Qur'an had two readers, and that name
/// would have been a lie the moment the Gita got them. The key is therefore
/// renamed, and migrated once on first read so nobody's existing choice is
/// quietly reset to the default.
///
/// Persisted with `shared_preferences`, like the last-read pointers and the
/// Arabic script preference. Not folded into either vertical's
/// `ReaderPreferences`, which are documented as in-memory only and would
/// forget the choice on every restart — the one thing this must not do.
@Riverpod(keepAlive: true)
class ReadingModeController extends _$ReadingModeController {
  static const _key = 'reader.readingMode';

  /// Where this lived when the Qur'an was the only vertical with a pager.
  /// Read once, forward-written, never written to again.
  static const _legacyKey = 'quran.readingMode';

  @override
  Future<ReadingMode> build() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw != null) return _parse(raw);

    final legacy = prefs.getString(_legacyKey);
    if (legacy == null) return ReadingMode.continuous;
    final migrated = _parse(legacy);
    // Forward-written here rather than left to the next `set()`: a reader
    // who never opens the mode switch again would otherwise re-read the old
    // key on every launch, and the day it is deleted would silently lose a
    // preference they did choose.
    await prefs.setString(_key, migrated.name);
    return migrated;
  }

  Future<void> set(ReadingMode mode) async {
    // Optimistic: the switch is a navigation the user is already mid-way
    // through, and nothing downstream should wait on a preferences write.
    state = AsyncValue.data(mode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode.name);
  }

  static ReadingMode _parse(String raw) => ReadingMode.values.firstWhere(
    (m) => m.name == raw,
    orElse: () => ReadingMode.continuous,
  );
}

/// The mode to open a passage in right now.
///
/// Falls back to [ReadingMode.continuous] while the preference is still
/// loading — which is the mode a reader who has never chosen gets anyway,
/// so a tap during the first few milliseconds of a cold start behaves
/// exactly like a tap from a fresh install rather than stalling.
ReadingMode activeReadingMode(WidgetRef ref) =>
    ref.watch(readingModeControllerProvider).valueOrNull ??
    ReadingMode.continuous;
