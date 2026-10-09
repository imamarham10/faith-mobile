// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_event_queue.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$localEventQueueHash() => r'6ce15e6a0a3a9c215250d3e0538e5fb275d4d705';

/// The app's one queue, opened once and kept for the process lifetime.
///
/// `keepAlive` because the whole point is durability across screens: a
/// queue disposed with the last widget that recorded something would
/// reopen the database on every tap. Closed on dispose so a test container
/// does not leak the file handle.
///
/// Copied from [localEventQueue].
@ProviderFor(localEventQueue)
final localEventQueueProvider = FutureProvider<LocalEventQueue>.internal(
  localEventQueue,
  name: r'localEventQueueProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$localEventQueueHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LocalEventQueueRef = FutureProviderRef<LocalEventQueue>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
