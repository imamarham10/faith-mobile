// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scripture_audio_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$scriptureAudioControllerHash() =>
    r'7c7355626044df2075ce8547c0d85fd347a77555';

/// UI-facing state for the chapter-narration player.
///
/// A chapter narration is minutes of audio, so playback runs where Qur'an
/// recitation runs: inside [PlaybackAudioHandler], in a real `mediaPlayback`
/// foreground service. A raw `AudioPlayer` here left the process in the
/// cached bucket (`oom_score_adj` 900 with narration audibly playing) and
/// OEM memory cleaners killed it mid-chapter.
///
/// `audio_service` allows exactly one `AudioService.init()` per process, so
/// that handler is shared with the Quran module rather than duplicated —
/// which is also what makes the two mutually exclusive: starting a chapter
/// takes the one player from recitation, and [PlaybackCallbacks.onDisplaced]
/// takes the other vertical's mini player down.
///
/// Unlike Quran's `AudioController` (hardcoded third-party mp3 host with
/// no reciter choice), this hits the real backend narration endpoint and
/// lets the user switch between available reciter/language tracks.
///
/// Copied from [ScriptureAudioController].
@ProviderFor(ScriptureAudioController)
final scriptureAudioControllerProvider =
    NotifierProvider<ScriptureAudioController, ScriptureAudioState>.internal(
      ScriptureAudioController.new,
      name: r'scriptureAudioControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$scriptureAudioControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ScriptureAudioController = Notifier<ScriptureAudioState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
