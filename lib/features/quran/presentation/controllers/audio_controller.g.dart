// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$audioControllerHash() => r'0a0d841ce108bdbc0ee19b31687a5e2a237691a4';

/// Shared `AudioPlayer` for the Quran feature.
///
/// Plays one ayah at a time; auto-advances to the next ayah on completion.
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
