// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$scriptureTextDetailHash() =>
    r'4b0330a1cb9ed63bd28d0e1dffbc5f99fa7b8844';

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

/// Loads a text's chapter list (for chapter-picker / index UI).
///
/// Copied from [scriptureTextDetail].
@ProviderFor(scriptureTextDetail)
const scriptureTextDetailProvider = ScriptureTextDetailFamily();

/// Loads a text's chapter list (for chapter-picker / index UI).
///
/// Copied from [scriptureTextDetail].
class ScriptureTextDetailFamily
    extends Family<AsyncValue<ScriptureTextDetail>> {
  /// Loads a text's chapter list (for chapter-picker / index UI).
  ///
  /// Copied from [scriptureTextDetail].
  const ScriptureTextDetailFamily();

  /// Loads a text's chapter list (for chapter-picker / index UI).
  ///
  /// Copied from [scriptureTextDetail].
  ScriptureTextDetailProvider call(String slug) {
    return ScriptureTextDetailProvider(slug);
  }

  @override
  ScriptureTextDetailProvider getProviderOverride(
    covariant ScriptureTextDetailProvider provider,
  ) {
    return call(provider.slug);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'scriptureTextDetailProvider';
}

/// Loads a text's chapter list (for chapter-picker / index UI).
///
/// Copied from [scriptureTextDetail].
class ScriptureTextDetailProvider extends FutureProvider<ScriptureTextDetail> {
  /// Loads a text's chapter list (for chapter-picker / index UI).
  ///
  /// Copied from [scriptureTextDetail].
  ScriptureTextDetailProvider(String slug)
    : this._internal(
        (ref) => scriptureTextDetail(ref as ScriptureTextDetailRef, slug),
        from: scriptureTextDetailProvider,
        name: r'scriptureTextDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$scriptureTextDetailHash,
        dependencies: ScriptureTextDetailFamily._dependencies,
        allTransitiveDependencies:
            ScriptureTextDetailFamily._allTransitiveDependencies,
        slug: slug,
      );

  ScriptureTextDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.slug,
  }) : super.internal();

  final String slug;

  @override
  Override overrideWith(
    FutureOr<ScriptureTextDetail> Function(ScriptureTextDetailRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ScriptureTextDetailProvider._internal(
        (ref) => create(ref as ScriptureTextDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        slug: slug,
      ),
    );
  }

  @override
  FutureProviderElement<ScriptureTextDetail> createElement() {
    return _ScriptureTextDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ScriptureTextDetailProvider && other.slug == slug;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, slug.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ScriptureTextDetailRef on FutureProviderRef<ScriptureTextDetail> {
  /// The parameter `slug` of this provider.
  String get slug;
}

class _ScriptureTextDetailProviderElement
    extends FutureProviderElement<ScriptureTextDetail>
    with ScriptureTextDetailRef {
  _ScriptureTextDetailProviderElement(super.provider);

  @override
  String get slug => (origin as ScriptureTextDetailProvider).slug;
}

String _$chapterDetailHash() => r'fc1ffedaabc822e56af774929b7e2340336de7d1';

/// Loads a chapter with all its verses. `keepAlive` for the same
/// open→read→back→reopen reasoning as Quran's `surahDetailProvider`.
///
/// Copied from [chapterDetail].
@ProviderFor(chapterDetail)
const chapterDetailProvider = ChapterDetailFamily();

/// Loads a chapter with all its verses. `keepAlive` for the same
/// open→read→back→reopen reasoning as Quran's `surahDetailProvider`.
///
/// Copied from [chapterDetail].
class ChapterDetailFamily extends Family<AsyncValue<ChapterDetail>> {
  /// Loads a chapter with all its verses. `keepAlive` for the same
  /// open→read→back→reopen reasoning as Quran's `surahDetailProvider`.
  ///
  /// Copied from [chapterDetail].
  const ChapterDetailFamily();

  /// Loads a chapter with all its verses. `keepAlive` for the same
  /// open→read→back→reopen reasoning as Quran's `surahDetailProvider`.
  ///
  /// Copied from [chapterDetail].
  ChapterDetailProvider call(String slug, int chapterNumber) {
    return ChapterDetailProvider(slug, chapterNumber);
  }

  @override
  ChapterDetailProvider getProviderOverride(
    covariant ChapterDetailProvider provider,
  ) {
    return call(provider.slug, provider.chapterNumber);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'chapterDetailProvider';
}

/// Loads a chapter with all its verses. `keepAlive` for the same
/// open→read→back→reopen reasoning as Quran's `surahDetailProvider`.
///
/// Copied from [chapterDetail].
class ChapterDetailProvider extends FutureProvider<ChapterDetail> {
  /// Loads a chapter with all its verses. `keepAlive` for the same
  /// open→read→back→reopen reasoning as Quran's `surahDetailProvider`.
  ///
  /// Copied from [chapterDetail].
  ChapterDetailProvider(String slug, int chapterNumber)
    : this._internal(
        (ref) => chapterDetail(ref as ChapterDetailRef, slug, chapterNumber),
        from: chapterDetailProvider,
        name: r'chapterDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$chapterDetailHash,
        dependencies: ChapterDetailFamily._dependencies,
        allTransitiveDependencies:
            ChapterDetailFamily._allTransitiveDependencies,
        slug: slug,
        chapterNumber: chapterNumber,
      );

  ChapterDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.slug,
    required this.chapterNumber,
  }) : super.internal();

  final String slug;
  final int chapterNumber;

  @override
  Override overrideWith(
    FutureOr<ChapterDetail> Function(ChapterDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChapterDetailProvider._internal(
        (ref) => create(ref as ChapterDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        slug: slug,
        chapterNumber: chapterNumber,
      ),
    );
  }

  @override
  FutureProviderElement<ChapterDetail> createElement() {
    return _ChapterDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChapterDetailProvider &&
        other.slug == slug &&
        other.chapterNumber == chapterNumber;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, slug.hashCode);
    hash = _SystemHash.combine(hash, chapterNumber.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ChapterDetailRef on FutureProviderRef<ChapterDetail> {
  /// The parameter `slug` of this provider.
  String get slug;

  /// The parameter `chapterNumber` of this provider.
  int get chapterNumber;
}

class _ChapterDetailProviderElement extends FutureProviderElement<ChapterDetail>
    with ChapterDetailRef {
  _ChapterDetailProviderElement(super.provider);

  @override
  String get slug => (origin as ChapterDetailProvider).slug;
  @override
  int get chapterNumber => (origin as ChapterDetailProvider).chapterNumber;
}

String _$scriptureReaderPreferencesControllerHash() =>
    r'6b65c029281c6194ef05d06e101f26b3e42406bd';

/// See also [ScriptureReaderPreferencesController].
@ProviderFor(ScriptureReaderPreferencesController)
final scriptureReaderPreferencesControllerProvider =
    NotifierProvider<
      ScriptureReaderPreferencesController,
      ScriptureReaderPreferences
    >.internal(
      ScriptureReaderPreferencesController.new,
      name: r'scriptureReaderPreferencesControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$scriptureReaderPreferencesControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ScriptureReaderPreferencesController =
    Notifier<ScriptureReaderPreferences>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
