// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading_mode_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$readingModeControllerHash() =>
    r'7bc437dcc60225ad7a558a182398d223ee69ff6f';

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
