// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scripture_audio_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$scriptureAudioControllerHash() =>
    r'fab9b181a404a1c676bc84a626953b9039bb0cc6';

/// Shared `AudioPlayer` for chapter narration.
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
