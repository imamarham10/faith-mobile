// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected_faith.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$selectedFaithHash() => r'c0a894879b0c1f44fc9885d415a14737537a9764';

/// Persisted faith selection. `null` means the user hasn't picked yet
/// (first launch, mid-onboarding). Set from the faith picker screen and
/// from Settings → "Switch faith".
///
/// Copied from [SelectedFaith].
@ProviderFor(SelectedFaith)
final selectedFaithProvider =
    AsyncNotifierProvider<SelectedFaith, FaithId?>.internal(
      SelectedFaith.new,
      name: r'selectedFaithProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedFaithHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedFaith = AsyncNotifier<FaithId?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
