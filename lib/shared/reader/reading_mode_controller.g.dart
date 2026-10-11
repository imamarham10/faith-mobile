// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading_mode_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$readingModeControllerHash() =>
    r'c28843c927ca3b86e9b5b1b7f016ecd9123c5b45';

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
///
/// Copied from [ReadingModeController].
@ProviderFor(ReadingModeController)
final readingModeControllerProvider =
    AsyncNotifierProvider<ReadingModeController, ReadingMode>.internal(
      ReadingModeController.new,
      name: r'readingModeControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$readingModeControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ReadingModeController = AsyncNotifier<ReadingMode>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
