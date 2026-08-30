// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'japa_history_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$japaHistoryGroupedHash() =>
    r'2e87591a186fb0bdf8a7c21319228291a236f2cb';

/// Japa session history grouped by day, descending.
///
/// Unlike Dhikr's history (`recordedAt` with time-of-day), this backend's
/// `date` field is day-granularity; `createdAt` (when present) supplies a
/// time-of-day for the row display, falling back to `date` itself.
///
/// Copied from [japaHistoryGrouped].
@ProviderFor(japaHistoryGrouped)
final japaHistoryGroupedProvider =
    AutoDisposeFutureProvider<Map<DateTime, List<JapaHistoryEntry>>>.internal(
      japaHistoryGrouped,
      name: r'japaHistoryGroupedProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$japaHistoryGroupedHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef JapaHistoryGroupedRef =
    AutoDisposeFutureProviderRef<Map<DateTime, List<JapaHistoryEntry>>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
