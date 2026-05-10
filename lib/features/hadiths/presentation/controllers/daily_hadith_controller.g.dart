// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_hadith_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dailyHadithHash() => r'07e3e965b23ee203a8bd9b1bf899a041fde0b3d3';

/// Hadith of the day — used by the Today screen card and the Hadiths home
/// hero. Cached server-side for 24h, so we keep it alive client-side too.
///
/// Copied from [dailyHadith].
@ProviderFor(dailyHadith)
final dailyHadithProvider = FutureProvider<Hadith?>.internal(
  dailyHadith,
  name: r'dailyHadithProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dailyHadithHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DailyHadithRef = FutureProviderRef<Hadith?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
