// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'surah_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$surahDetailHash() => r'75a978de8401878edc1728d2d97ee327db9ca799';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Loads a surah with all its verses. `keepAlive` is intentional — the most
/// common navigation pattern is open → read → back → reopen, and we don't
/// want to re-fetch in that window.
///
/// Copied from [surahDetail].
@ProviderFor(surahDetail)
const surahDetailProvider = SurahDetailFamily();

/// Loads a surah with all its verses. `keepAlive` is intentional — the most
/// common navigation pattern is open → read → back → reopen, and we don't
/// want to re-fetch in that window.
///
/// Copied from [surahDetail].
class SurahDetailFamily extends Family<AsyncValue<SurahDetail>> {
  /// Loads a surah with all its verses. `keepAlive` is intentional — the most
  /// common navigation pattern is open → read → back → reopen, and we don't
  /// want to re-fetch in that window.
  ///
  /// Copied from [surahDetail].
  const SurahDetailFamily();

  /// Loads a surah with all its verses. `keepAlive` is intentional — the most
  /// common navigation pattern is open → read → back → reopen, and we don't
  /// want to re-fetch in that window.
  ///
  /// Copied from [surahDetail].
  SurahDetailProvider call(int surahId) {
    return SurahDetailProvider(surahId);
  }

  @override
  SurahDetailProvider getProviderOverride(
    covariant SurahDetailProvider provider,
  ) {
    return call(provider.surahId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'surahDetailProvider';
}

/// Loads a surah with all its verses. `keepAlive` is intentional — the most
/// common navigation pattern is open → read → back → reopen, and we don't
/// want to re-fetch in that window.
///
/// Copied from [surahDetail].
class SurahDetailProvider extends FutureProvider<SurahDetail> {
  /// Loads a surah with all its verses. `keepAlive` is intentional — the most
  /// common navigation pattern is open → read → back → reopen, and we don't
  /// want to re-fetch in that window.
  ///
  /// Copied from [surahDetail].
  SurahDetailProvider(int surahId)
    : this._internal(
        (ref) => surahDetail(ref as SurahDetailRef, surahId),
        from: surahDetailProvider,
        name: r'surahDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$surahDetailHash,
        dependencies: SurahDetailFamily._dependencies,
        allTransitiveDependencies: SurahDetailFamily._allTransitiveDependencies,
        surahId: surahId,
      );

  SurahDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.surahId,
  }) : super.internal();

  final int surahId;

  @override
  Override overrideWith(
    FutureOr<SurahDetail> Function(SurahDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SurahDetailProvider._internal(
        (ref) => create(ref as SurahDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        surahId: surahId,
      ),
    );
  }

  @override
  FutureProviderElement<SurahDetail> createElement() {
    return _SurahDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SurahDetailProvider && other.surahId == surahId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, surahId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SurahDetailRef on FutureProviderRef<SurahDetail> {
  /// The parameter `surahId` of this provider.
  int get surahId;
}

class _SurahDetailProviderElement extends FutureProviderElement<SurahDetail>
    with SurahDetailRef {
  _SurahDetailProviderElement(super.provider);

  @override
  int get surahId => (origin as SurahDetailProvider).surahId;
}

String _$readerPreferencesControllerHash() =>
    r'0a01edb059b07f3400f4818374d65aae20679208';

/// See also [ReaderPreferencesController].
@ProviderFor(ReaderPreferencesController)
final readerPreferencesControllerProvider =
    NotifierProvider<ReaderPreferencesController, ReaderPreferences>.internal(
      ReaderPreferencesController.new,
      name: r'readerPreferencesControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$readerPreferencesControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ReaderPreferencesController = Notifier<ReaderPreferences>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
