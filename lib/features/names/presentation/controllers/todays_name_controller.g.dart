// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todays_name_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$todaysNameHash() => r'71b8cc3e16ca2453e073cdebef1a470eb52b47d2';

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

/// "Name of the day" for the given [kind] — rotates server-side daily.
///
/// Copied from [todaysName].
@ProviderFor(todaysName)
const todaysNameProvider = TodaysNameFamily();

/// "Name of the day" for the given [kind] — rotates server-side daily.
///
/// Copied from [todaysName].
class TodaysNameFamily extends Family<AsyncValue<DivineName>> {
  /// "Name of the day" for the given [kind] — rotates server-side daily.
  ///
  /// Copied from [todaysName].
  const TodaysNameFamily();

  /// "Name of the day" for the given [kind] — rotates server-side daily.
  ///
  /// Copied from [todaysName].
  TodaysNameProvider call(NamesKind kind) {
    return TodaysNameProvider(kind);
  }

  @override
  TodaysNameProvider getProviderOverride(
    covariant TodaysNameProvider provider,
  ) {
    return call(provider.kind);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'todaysNameProvider';
}

/// "Name of the day" for the given [kind] — rotates server-side daily.
///
/// Copied from [todaysName].
class TodaysNameProvider extends FutureProvider<DivineName> {
  /// "Name of the day" for the given [kind] — rotates server-side daily.
  ///
  /// Copied from [todaysName].
  TodaysNameProvider(NamesKind kind)
    : this._internal(
        (ref) => todaysName(ref as TodaysNameRef, kind),
        from: todaysNameProvider,
        name: r'todaysNameProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$todaysNameHash,
        dependencies: TodaysNameFamily._dependencies,
        allTransitiveDependencies: TodaysNameFamily._allTransitiveDependencies,
        kind: kind,
      );

  TodaysNameProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.kind,
  }) : super.internal();

  final NamesKind kind;

  @override
  Override overrideWith(
    FutureOr<DivineName> Function(TodaysNameRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TodaysNameProvider._internal(
        (ref) => create(ref as TodaysNameRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        kind: kind,
      ),
    );
  }

  @override
  FutureProviderElement<DivineName> createElement() {
    return _TodaysNameProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TodaysNameProvider && other.kind == kind;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, kind.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TodaysNameRef on FutureProviderRef<DivineName> {
  /// The parameter `kind` of this provider.
  NamesKind get kind;
}

class _TodaysNameProviderElement extends FutureProviderElement<DivineName>
    with TodaysNameRef {
  _TodaysNameProviderElement(super.provider);

  @override
  NamesKind get kind => (origin as TodaysNameProvider).kind;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
