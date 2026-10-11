// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$audioControllerHash() => r'dea655cba5401fb0d8911d2fd76f9f704af67678';

/// UI-facing state for the Quran recitation player.
///
/// Playback itself lives in [PlaybackAudioHandler], inside an
/// `audio_service` foreground service, so recitation survives the screen
/// going off. This controller owns only the state the reader renders, and
/// forwards intent to the handler.
///
/// That handler is shared with Hindu chapter narration — one process, one
/// `AudioService.init()`, one player — so starting a surah takes the player
/// from a Gita chapter and vice versa. The hand-over arrives here as
/// [PlaybackCallbacks.onDisplaced].
///
/// The handler is created on the first [playAyah] — never at build time, so
/// opening the reader costs nothing and the launch path is untouched.
///
/// Copied from [AudioController].
@ProviderFor(AudioController)
final audioControllerProvider =
    NotifierProvider<AudioController, AudioState>.internal(
      AudioController.new,
      name: r'audioControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$audioControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AudioController = Notifier<AudioState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
