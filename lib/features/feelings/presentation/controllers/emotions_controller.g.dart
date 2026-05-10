// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emotions_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$emotionsHash() => r'6e308289b9e9c402e4b8d344e1621fd3f3b350f1';

/// All available emotions. Falls back to [kDefaultMoods] when the server
/// hasn't seeded the full set.
///
/// Copied from [emotions].
@ProviderFor(emotions)
final emotionsProvider = FutureProvider<List<Emotion>>.internal(
  emotions,
  name: r'emotionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$emotionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EmotionsRef = FutureProviderRef<List<Emotion>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
