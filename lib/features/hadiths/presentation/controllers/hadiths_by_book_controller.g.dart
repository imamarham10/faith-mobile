// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hadiths_by_book_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$hadithsByBookControllerHash() =>
    r'a65b51a0e0a0701b885ee9bcced59fc5c7e8b090';

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

abstract class _$HadithsByBookController
    extends BuildlessAutoDisposeAsyncNotifier<HadithFeed> {
  late final String bookId;

  FutureOr<HadithFeed> build(String bookId);
}

/// See also [HadithsByBookController].
@ProviderFor(HadithsByBookController)
const hadithsByBookControllerProvider = HadithsByBookControllerFamily();

/// See also [HadithsByBookController].
class HadithsByBookControllerFamily extends Family<AsyncValue<HadithFeed>> {
  /// See also [HadithsByBookController].
  const HadithsByBookControllerFamily();

  /// See also [HadithsByBookController].
  HadithsByBookControllerProvider call(String bookId) {
    return HadithsByBookControllerProvider(bookId);
  }

  @override
  HadithsByBookControllerProvider getProviderOverride(
    covariant HadithsByBookControllerProvider provider,
  ) {
    return call(provider.bookId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'hadithsByBookControllerProvider';
}

/// See also [HadithsByBookController].
class HadithsByBookControllerProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          HadithsByBookController,
          HadithFeed
        > {
  /// See also [HadithsByBookController].
  HadithsByBookControllerProvider(String bookId)
    : this._internal(
        () => HadithsByBookController()..bookId = bookId,
        from: hadithsByBookControllerProvider,
        name: r'hadithsByBookControllerProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$hadithsByBookControllerHash,
        dependencies: HadithsByBookControllerFamily._dependencies,
        allTransitiveDependencies:
            HadithsByBookControllerFamily._allTransitiveDependencies,
        bookId: bookId,
      );

  HadithsByBookControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.bookId,
  }) : super.internal();

  final String bookId;

  @override
  FutureOr<HadithFeed> runNotifierBuild(
    covariant HadithsByBookController notifier,
  ) {
    return notifier.build(bookId);
  }

  @override
  Override overrideWith(HadithsByBookController Function() create) {
    return ProviderOverride(
      origin: this,
      override: HadithsByBookControllerProvider._internal(
        () => create()..bookId = bookId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        bookId: bookId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<HadithsByBookController, HadithFeed>
  createElement() {
    return _HadithsByBookControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HadithsByBookControllerProvider && other.bookId == bookId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, bookId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin HadithsByBookControllerRef
    on AutoDisposeAsyncNotifierProviderRef<HadithFeed> {
  /// The parameter `bookId` of this provider.
  String get bookId;
}

class _HadithsByBookControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          HadithsByBookController,
          HadithFeed
        >
    with HadithsByBookControllerRef {
  _HadithsByBookControllerProviderElement(super.provider);

  @override
  String get bookId => (origin as HadithsByBookControllerProvider).bookId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
