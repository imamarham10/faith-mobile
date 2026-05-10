// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mood_history_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$moodFrequencyHash() => r'8aae427c9a0112c8eaab9791a4909db7dcc5c291';

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

/// Frequency of each mood over the trailing [days] window. Derived from the
/// journal so we have a single source of truth — no separate "history"
/// store to keep in sync.
///
/// Copied from [moodFrequency].
@ProviderFor(moodFrequency)
const moodFrequencyProvider = MoodFrequencyFamily();

/// Frequency of each mood over the trailing [days] window. Derived from the
/// journal so we have a single source of truth — no separate "history"
/// store to keep in sync.
///
/// Copied from [moodFrequency].
class MoodFrequencyFamily extends Family<Map<String, int>> {
  /// Frequency of each mood over the trailing [days] window. Derived from the
  /// journal so we have a single source of truth — no separate "history"
  /// store to keep in sync.
  ///
  /// Copied from [moodFrequency].
  const MoodFrequencyFamily();

  /// Frequency of each mood over the trailing [days] window. Derived from the
  /// journal so we have a single source of truth — no separate "history"
  /// store to keep in sync.
  ///
  /// Copied from [moodFrequency].
  MoodFrequencyProvider call({int days = 30}) {
    return MoodFrequencyProvider(days: days);
  }

  @override
  MoodFrequencyProvider getProviderOverride(
    covariant MoodFrequencyProvider provider,
  ) {
    return call(days: provider.days);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'moodFrequencyProvider';
}

/// Frequency of each mood over the trailing [days] window. Derived from the
/// journal so we have a single source of truth — no separate "history"
/// store to keep in sync.
///
/// Copied from [moodFrequency].
class MoodFrequencyProvider extends AutoDisposeProvider<Map<String, int>> {
  /// Frequency of each mood over the trailing [days] window. Derived from the
  /// journal so we have a single source of truth — no separate "history"
  /// store to keep in sync.
  ///
  /// Copied from [moodFrequency].
  MoodFrequencyProvider({int days = 30})
    : this._internal(
        (ref) => moodFrequency(ref as MoodFrequencyRef, days: days),
        from: moodFrequencyProvider,
        name: r'moodFrequencyProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$moodFrequencyHash,
        dependencies: MoodFrequencyFamily._dependencies,
        allTransitiveDependencies:
            MoodFrequencyFamily._allTransitiveDependencies,
        days: days,
      );

  MoodFrequencyProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.days,
  }) : super.internal();

  final int days;

  @override
  Override overrideWith(
    Map<String, int> Function(MoodFrequencyRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MoodFrequencyProvider._internal(
        (ref) => create(ref as MoodFrequencyRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        days: days,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<Map<String, int>> createElement() {
    return _MoodFrequencyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MoodFrequencyProvider && other.days == days;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, days.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MoodFrequencyRef on AutoDisposeProviderRef<Map<String, int>> {
  /// The parameter `days` of this provider.
  int get days;
}

class _MoodFrequencyProviderElement
    extends AutoDisposeProviderElement<Map<String, int>>
    with MoodFrequencyRef {
  _MoodFrequencyProviderElement(super.provider);

  @override
  int get days => (origin as MoodFrequencyProvider).days;
}

String _$moodHistoryEntriesHash() =>
    r'62af698c76b640ed5a18fab3b8d5a003f2e9fb85';

/// Entries within the trailing [days] window, newest first.
///
/// Copied from [moodHistoryEntries].
@ProviderFor(moodHistoryEntries)
const moodHistoryEntriesProvider = MoodHistoryEntriesFamily();

/// Entries within the trailing [days] window, newest first.
///
/// Copied from [moodHistoryEntries].
class MoodHistoryEntriesFamily extends Family<List<JournalEntry>> {
  /// Entries within the trailing [days] window, newest first.
  ///
  /// Copied from [moodHistoryEntries].
  const MoodHistoryEntriesFamily();

  /// Entries within the trailing [days] window, newest first.
  ///
  /// Copied from [moodHistoryEntries].
  MoodHistoryEntriesProvider call({int days = 30}) {
    return MoodHistoryEntriesProvider(days: days);
  }

  @override
  MoodHistoryEntriesProvider getProviderOverride(
    covariant MoodHistoryEntriesProvider provider,
  ) {
    return call(days: provider.days);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'moodHistoryEntriesProvider';
}

/// Entries within the trailing [days] window, newest first.
///
/// Copied from [moodHistoryEntries].
class MoodHistoryEntriesProvider
    extends AutoDisposeProvider<List<JournalEntry>> {
  /// Entries within the trailing [days] window, newest first.
  ///
  /// Copied from [moodHistoryEntries].
  MoodHistoryEntriesProvider({int days = 30})
    : this._internal(
        (ref) => moodHistoryEntries(ref as MoodHistoryEntriesRef, days: days),
        from: moodHistoryEntriesProvider,
        name: r'moodHistoryEntriesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$moodHistoryEntriesHash,
        dependencies: MoodHistoryEntriesFamily._dependencies,
        allTransitiveDependencies:
            MoodHistoryEntriesFamily._allTransitiveDependencies,
        days: days,
      );

  MoodHistoryEntriesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.days,
  }) : super.internal();

  final int days;

  @override
  Override overrideWith(
    List<JournalEntry> Function(MoodHistoryEntriesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MoodHistoryEntriesProvider._internal(
        (ref) => create(ref as MoodHistoryEntriesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        days: days,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<JournalEntry>> createElement() {
    return _MoodHistoryEntriesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MoodHistoryEntriesProvider && other.days == days;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, days.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MoodHistoryEntriesRef on AutoDisposeProviderRef<List<JournalEntry>> {
  /// The parameter `days` of this provider.
  int get days;
}

class _MoodHistoryEntriesProviderElement
    extends AutoDisposeProviderElement<List<JournalEntry>>
    with MoodHistoryEntriesRef {
  _MoodHistoryEntriesProviderElement(super.provider);

  @override
  int get days => (origin as MoodHistoryEntriesProvider).days;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
