// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'juz_reader_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$juzReaderControllerHash() =>
    r'7f7ce4fbed73d518d1e9665dd543c2d5cd0816fd';

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

abstract class _$JuzReaderController
    extends BuildlessAutoDisposeAsyncNotifier<JuzReaderState> {
  late final int juzNumber;

  FutureOr<JuzReaderState> build(int juzNumber);
}

/// Drives [JuzReaderState]: loads the first page, then keeps the pages
/// either side of the cursor resident so a step forward never waits.
///
/// Copied from [JuzReaderController].
@ProviderFor(JuzReaderController)
const juzReaderControllerProvider = JuzReaderControllerFamily();

/// Drives [JuzReaderState]: loads the first page, then keeps the pages
/// either side of the cursor resident so a step forward never waits.
///
/// Copied from [JuzReaderController].
class JuzReaderControllerFamily extends Family<AsyncValue<JuzReaderState>> {
  /// Drives [JuzReaderState]: loads the first page, then keeps the pages
  /// either side of the cursor resident so a step forward never waits.
  ///
  /// Copied from [JuzReaderController].
  const JuzReaderControllerFamily();

  /// Drives [JuzReaderState]: loads the first page, then keeps the pages
  /// either side of the cursor resident so a step forward never waits.
  ///
  /// Copied from [JuzReaderController].
  JuzReaderControllerProvider call(int juzNumber) {
    return JuzReaderControllerProvider(juzNumber);
  }

  @override
  JuzReaderControllerProvider getProviderOverride(
    covariant JuzReaderControllerProvider provider,
  ) {
    return call(provider.juzNumber);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'juzReaderControllerProvider';
}

/// Drives [JuzReaderState]: loads the first page, then keeps the pages
/// either side of the cursor resident so a step forward never waits.
///
/// Copied from [JuzReaderController].
class JuzReaderControllerProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          JuzReaderController,
          JuzReaderState
        > {
  /// Drives [JuzReaderState]: loads the first page, then keeps the pages
  /// either side of the cursor resident so a step forward never waits.
  ///
  /// Copied from [JuzReaderController].
  JuzReaderControllerProvider(int juzNumber)
    : this._internal(
        () => JuzReaderController()..juzNumber = juzNumber,
        from: juzReaderControllerProvider,
        name: r'juzReaderControllerProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$juzReaderControllerHash,
        dependencies: JuzReaderControllerFamily._dependencies,
        allTransitiveDependencies:
            JuzReaderControllerFamily._allTransitiveDependencies,
        juzNumber: juzNumber,
      );

  JuzReaderControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.juzNumber,
  }) : super.internal();

  final int juzNumber;

  @override
  FutureOr<JuzReaderState> runNotifierBuild(
    covariant JuzReaderController notifier,
  ) {
    return notifier.build(juzNumber);
  }

  @override
  Override overrideWith(JuzReaderController Function() create) {
    return ProviderOverride(
      origin: this,
      override: JuzReaderControllerProvider._internal(
        () => create()..juzNumber = juzNumber,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        juzNumber: juzNumber,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<JuzReaderController, JuzReaderState>
  createElement() {
    return _JuzReaderControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is JuzReaderControllerProvider && other.juzNumber == juzNumber;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, juzNumber.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin JuzReaderControllerRef
    on AutoDisposeAsyncNotifierProviderRef<JuzReaderState> {
  /// The parameter `juzNumber` of this provider.
  int get juzNumber;
}

class _JuzReaderControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          JuzReaderController,
          JuzReaderState
        >
    with JuzReaderControllerRef {
  _JuzReaderControllerProviderElement(super.provider);

  @override
  int get juzNumber => (origin as JuzReaderControllerProvider).juzNumber;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
