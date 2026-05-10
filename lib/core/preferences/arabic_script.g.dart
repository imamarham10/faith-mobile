// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'arabic_script.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$arabicScriptControllerHash() =>
    r'cc44207c02b7e6bb249f009a8941ca235e104b96';

/// Persists the user's Arabic script preference via shared_preferences.
/// Default is Indo-Pak.
///
/// Copied from [ArabicScriptController].
@ProviderFor(ArabicScriptController)
final arabicScriptControllerProvider =
    AsyncNotifierProvider<ArabicScriptController, ArabicScript>.internal(
      ArabicScriptController.new,
      name: r'arabicScriptControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$arabicScriptControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ArabicScriptController = AsyncNotifier<ArabicScript>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
