// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qibla_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$qiblaStreamHash() => r'5a230b9428bd1e71d1428ac9e855a7de68fb0794';

/// Streams a [QiblaSnapshot] combining:
///   * one-shot location lookup (Qibla bearing is location-anchored, doesn't
///     need to track movement during a session)
///   * live, low-pass-filtered compass heading
///
/// The Riverpod auto-dispose handles subscription teardown when the screen
/// pops.
///
/// Copied from [qiblaStream].
@ProviderFor(qiblaStream)
final qiblaStreamProvider = AutoDisposeStreamProvider<QiblaSnapshot>.internal(
  qiblaStream,
  name: r'qiblaStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$qiblaStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef QiblaStreamRef = AutoDisposeStreamProviderRef<QiblaSnapshot>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
