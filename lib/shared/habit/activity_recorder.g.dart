// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_recorder.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$activityRecorderHash() => r'a48f1d758e9aaa7a561892e996713af45f5e80d0';

/// The recorder every feature reaches for.
///
/// Synchronously constructible on purpose — call sites do
/// `ref.read(activityRecorderProvider).record(...)` from inside a tap
/// handler, with no `await` before the read and no `AsyncValue` to unwrap.
/// The queue it needs is async, so it is passed in unresolved and awaited
/// inside `record()`, *after* the event has been stamped.
///
/// Copied from [activityRecorder].
@ProviderFor(activityRecorder)
final activityRecorderProvider = Provider<ActivityRecorder>.internal(
  activityRecorder,
  name: r'activityRecorderProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$activityRecorderHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActivityRecorderRef = ProviderRef<ActivityRecorder>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
