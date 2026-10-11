// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collections_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$collectionsHash() => r'908e89bd1bac27f6025aafe78cd49ce115d60c1d';

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

/// Every curated collection for a faith, in the server's order.
///
/// `keepAlive` because four surfaces read it — Today, the Qur'an tab, the
/// Scripture tab and Practice — and they must share one fetch. An
/// auto-disposed provider would re-request the list on every tab switch,
/// which on a `max: 10` serverless pool is exactly the kind of avoidable
/// traffic the below-the-fold gate exists to remove.
///
/// Keyed by faith rather than reading `selectedFaithProvider` here: the
/// screens already branch on faith before they get this far, and a family
/// keeps the two verticals' lists from evicting each other on a switch.
///
/// Copied from [collections].
@ProviderFor(collections)
const collectionsProvider = CollectionsFamily();

/// Every curated collection for a faith, in the server's order.
///
/// `keepAlive` because four surfaces read it — Today, the Qur'an tab, the
/// Scripture tab and Practice — and they must share one fetch. An
/// auto-disposed provider would re-request the list on every tab switch,
/// which on a `max: 10` serverless pool is exactly the kind of avoidable
/// traffic the below-the-fold gate exists to remove.
///
/// Keyed by faith rather than reading `selectedFaithProvider` here: the
/// screens already branch on faith before they get this far, and a family
/// keeps the two verticals' lists from evicting each other on a switch.
///
/// Copied from [collections].
class CollectionsFamily extends Family<AsyncValue<List<CuratedCollection>>> {
  /// Every curated collection for a faith, in the server's order.
  ///
  /// `keepAlive` because four surfaces read it — Today, the Qur'an tab, the
  /// Scripture tab and Practice — and they must share one fetch. An
  /// auto-disposed provider would re-request the list on every tab switch,
  /// which on a `max: 10` serverless pool is exactly the kind of avoidable
  /// traffic the below-the-fold gate exists to remove.
  ///
  /// Keyed by faith rather than reading `selectedFaithProvider` here: the
  /// screens already branch on faith before they get this far, and a family
  /// keeps the two verticals' lists from evicting each other on a switch.
  ///
  /// Copied from [collections].
  const CollectionsFamily();

  /// Every curated collection for a faith, in the server's order.
  ///
  /// `keepAlive` because four surfaces read it — Today, the Qur'an tab, the
  /// Scripture tab and Practice — and they must share one fetch. An
  /// auto-disposed provider would re-request the list on every tab switch,
  /// which on a `max: 10` serverless pool is exactly the kind of avoidable
  /// traffic the below-the-fold gate exists to remove.
  ///
  /// Keyed by faith rather than reading `selectedFaithProvider` here: the
  /// screens already branch on faith before they get this far, and a family
  /// keeps the two verticals' lists from evicting each other on a switch.
  ///
  /// Copied from [collections].
  CollectionsProvider call(FaithId faith) {
    return CollectionsProvider(faith);
  }

  @override
  CollectionsProvider getProviderOverride(
    covariant CollectionsProvider provider,
  ) {
    return call(provider.faith);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'collectionsProvider';
}

/// Every curated collection for a faith, in the server's order.
///
/// `keepAlive` because four surfaces read it — Today, the Qur'an tab, the
/// Scripture tab and Practice — and they must share one fetch. An
/// auto-disposed provider would re-request the list on every tab switch,
/// which on a `max: 10` serverless pool is exactly the kind of avoidable
/// traffic the below-the-fold gate exists to remove.
///
/// Keyed by faith rather than reading `selectedFaithProvider` here: the
/// screens already branch on faith before they get this far, and a family
/// keeps the two verticals' lists from evicting each other on a switch.
///
/// Copied from [collections].
class CollectionsProvider extends FutureProvider<List<CuratedCollection>> {
  /// Every curated collection for a faith, in the server's order.
  ///
  /// `keepAlive` because four surfaces read it — Today, the Qur'an tab, the
  /// Scripture tab and Practice — and they must share one fetch. An
  /// auto-disposed provider would re-request the list on every tab switch,
  /// which on a `max: 10` serverless pool is exactly the kind of avoidable
  /// traffic the below-the-fold gate exists to remove.
  ///
  /// Keyed by faith rather than reading `selectedFaithProvider` here: the
  /// screens already branch on faith before they get this far, and a family
  /// keeps the two verticals' lists from evicting each other on a switch.
  ///
  /// Copied from [collections].
  CollectionsProvider(FaithId faith)
    : this._internal(
        (ref) => collections(ref as CollectionsRef, faith),
        from: collectionsProvider,
        name: r'collectionsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$collectionsHash,
        dependencies: CollectionsFamily._dependencies,
        allTransitiveDependencies: CollectionsFamily._allTransitiveDependencies,
        faith: faith,
      );

  CollectionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.faith,
  }) : super.internal();

  final FaithId faith;

  @override
  Override overrideWith(
    FutureOr<List<CuratedCollection>> Function(CollectionsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CollectionsProvider._internal(
        (ref) => create(ref as CollectionsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        faith: faith,
      ),
    );
  }

  @override
  FutureProviderElement<List<CuratedCollection>> createElement() {
    return _CollectionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CollectionsProvider && other.faith == faith;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, faith.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CollectionsRef on FutureProviderRef<List<CuratedCollection>> {
  /// The parameter `faith` of this provider.
  FaithId get faith;
}

class _CollectionsProviderElement
    extends FutureProviderElement<List<CuratedCollection>>
    with CollectionsRef {
  _CollectionsProviderElement(super.provider);

  @override
  FaithId get faith => (origin as CollectionsProvider).faith;
}

String _$homeCollectionsHash() => r'0d5a6a30707898eab723f3c82192a06d2f1683e6';

/// The collections the database says belong on the Today dashboard.
///
/// A filter over [collections] and not a second request — `showOnHome` is
/// served on the same list payload, so featuring is free once the list is
/// in hand, and Today, Practice and the scripture tabs still share the one
/// fetch.
///
/// The order is the server's, untouched: the list arrives sorted by
/// `sortOrder` ascending and `where` preserves it. There is deliberately no
/// client-side re-sort and no client-side clock — the dashboard used to
/// decide for itself that the nightly set belonged there between 19:00 and
/// 03:59, and that rule is gone rather than layered under this flag.
///
/// An empty result is an ordinary state, not a failure: most collections
/// are not featured, and a faith may legitimately feature none.
///
/// Copied from [homeCollections].
@ProviderFor(homeCollections)
const homeCollectionsProvider = HomeCollectionsFamily();

/// The collections the database says belong on the Today dashboard.
///
/// A filter over [collections] and not a second request — `showOnHome` is
/// served on the same list payload, so featuring is free once the list is
/// in hand, and Today, Practice and the scripture tabs still share the one
/// fetch.
///
/// The order is the server's, untouched: the list arrives sorted by
/// `sortOrder` ascending and `where` preserves it. There is deliberately no
/// client-side re-sort and no client-side clock — the dashboard used to
/// decide for itself that the nightly set belonged there between 19:00 and
/// 03:59, and that rule is gone rather than layered under this flag.
///
/// An empty result is an ordinary state, not a failure: most collections
/// are not featured, and a faith may legitimately feature none.
///
/// Copied from [homeCollections].
class HomeCollectionsFamily
    extends Family<AsyncValue<List<CuratedCollection>>> {
  /// The collections the database says belong on the Today dashboard.
  ///
  /// A filter over [collections] and not a second request — `showOnHome` is
  /// served on the same list payload, so featuring is free once the list is
  /// in hand, and Today, Practice and the scripture tabs still share the one
  /// fetch.
  ///
  /// The order is the server's, untouched: the list arrives sorted by
  /// `sortOrder` ascending and `where` preserves it. There is deliberately no
  /// client-side re-sort and no client-side clock — the dashboard used to
  /// decide for itself that the nightly set belonged there between 19:00 and
  /// 03:59, and that rule is gone rather than layered under this flag.
  ///
  /// An empty result is an ordinary state, not a failure: most collections
  /// are not featured, and a faith may legitimately feature none.
  ///
  /// Copied from [homeCollections].
  const HomeCollectionsFamily();

  /// The collections the database says belong on the Today dashboard.
  ///
  /// A filter over [collections] and not a second request — `showOnHome` is
  /// served on the same list payload, so featuring is free once the list is
  /// in hand, and Today, Practice and the scripture tabs still share the one
  /// fetch.
  ///
  /// The order is the server's, untouched: the list arrives sorted by
  /// `sortOrder` ascending and `where` preserves it. There is deliberately no
  /// client-side re-sort and no client-side clock — the dashboard used to
  /// decide for itself that the nightly set belonged there between 19:00 and
  /// 03:59, and that rule is gone rather than layered under this flag.
  ///
  /// An empty result is an ordinary state, not a failure: most collections
  /// are not featured, and a faith may legitimately feature none.
  ///
  /// Copied from [homeCollections].
  HomeCollectionsProvider call(FaithId faith) {
    return HomeCollectionsProvider(faith);
  }

  @override
  HomeCollectionsProvider getProviderOverride(
    covariant HomeCollectionsProvider provider,
  ) {
    return call(provider.faith);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'homeCollectionsProvider';
}

/// The collections the database says belong on the Today dashboard.
///
/// A filter over [collections] and not a second request — `showOnHome` is
/// served on the same list payload, so featuring is free once the list is
/// in hand, and Today, Practice and the scripture tabs still share the one
/// fetch.
///
/// The order is the server's, untouched: the list arrives sorted by
/// `sortOrder` ascending and `where` preserves it. There is deliberately no
/// client-side re-sort and no client-side clock — the dashboard used to
/// decide for itself that the nightly set belonged there between 19:00 and
/// 03:59, and that rule is gone rather than layered under this flag.
///
/// An empty result is an ordinary state, not a failure: most collections
/// are not featured, and a faith may legitimately feature none.
///
/// Copied from [homeCollections].
class HomeCollectionsProvider extends FutureProvider<List<CuratedCollection>> {
  /// The collections the database says belong on the Today dashboard.
  ///
  /// A filter over [collections] and not a second request — `showOnHome` is
  /// served on the same list payload, so featuring is free once the list is
  /// in hand, and Today, Practice and the scripture tabs still share the one
  /// fetch.
  ///
  /// The order is the server's, untouched: the list arrives sorted by
  /// `sortOrder` ascending and `where` preserves it. There is deliberately no
  /// client-side re-sort and no client-side clock — the dashboard used to
  /// decide for itself that the nightly set belonged there between 19:00 and
  /// 03:59, and that rule is gone rather than layered under this flag.
  ///
  /// An empty result is an ordinary state, not a failure: most collections
  /// are not featured, and a faith may legitimately feature none.
  ///
  /// Copied from [homeCollections].
  HomeCollectionsProvider(FaithId faith)
    : this._internal(
        (ref) => homeCollections(ref as HomeCollectionsRef, faith),
        from: homeCollectionsProvider,
        name: r'homeCollectionsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$homeCollectionsHash,
        dependencies: HomeCollectionsFamily._dependencies,
        allTransitiveDependencies:
            HomeCollectionsFamily._allTransitiveDependencies,
        faith: faith,
      );

  HomeCollectionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.faith,
  }) : super.internal();

  final FaithId faith;

  @override
  Override overrideWith(
    FutureOr<List<CuratedCollection>> Function(HomeCollectionsRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HomeCollectionsProvider._internal(
        (ref) => create(ref as HomeCollectionsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        faith: faith,
      ),
    );
  }

  @override
  FutureProviderElement<List<CuratedCollection>> createElement() {
    return _HomeCollectionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HomeCollectionsProvider && other.faith == faith;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, faith.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin HomeCollectionsRef on FutureProviderRef<List<CuratedCollection>> {
  /// The parameter `faith` of this provider.
  FaithId get faith;
}

class _HomeCollectionsProviderElement
    extends FutureProviderElement<List<CuratedCollection>>
    with HomeCollectionsRef {
  _HomeCollectionsProviderElement(super.provider);

  @override
  FaithId get faith => (origin as HomeCollectionsProvider).faith;
}

String _$collectionDetailHash() => r'4748b047ca768f8f11d75100935bed9adcedea07';

/// One collection with its items resolved — the collection screen's source.
///
/// Auto-disposed, unlike the list. The detail payload carries every item's
/// scripture inline (≈196 KB for the six-item nightly set), and holding
/// that for the life of the process to save a request the user makes once
/// per visit is the wrong trade.
///
/// Copied from [collectionDetail].
@ProviderFor(collectionDetail)
const collectionDetailProvider = CollectionDetailFamily();

/// One collection with its items resolved — the collection screen's source.
///
/// Auto-disposed, unlike the list. The detail payload carries every item's
/// scripture inline (≈196 KB for the six-item nightly set), and holding
/// that for the life of the process to save a request the user makes once
/// per visit is the wrong trade.
///
/// Copied from [collectionDetail].
class CollectionDetailFamily extends Family<AsyncValue<CuratedCollection>> {
  /// One collection with its items resolved — the collection screen's source.
  ///
  /// Auto-disposed, unlike the list. The detail payload carries every item's
  /// scripture inline (≈196 KB for the six-item nightly set), and holding
  /// that for the life of the process to save a request the user makes once
  /// per visit is the wrong trade.
  ///
  /// Copied from [collectionDetail].
  const CollectionDetailFamily();

  /// One collection with its items resolved — the collection screen's source.
  ///
  /// Auto-disposed, unlike the list. The detail payload carries every item's
  /// scripture inline (≈196 KB for the six-item nightly set), and holding
  /// that for the life of the process to save a request the user makes once
  /// per visit is the wrong trade.
  ///
  /// Copied from [collectionDetail].
  CollectionDetailProvider call(FaithId faith, String slug) {
    return CollectionDetailProvider(faith, slug);
  }

  @override
  CollectionDetailProvider getProviderOverride(
    covariant CollectionDetailProvider provider,
  ) {
    return call(provider.faith, provider.slug);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'collectionDetailProvider';
}

/// One collection with its items resolved — the collection screen's source.
///
/// Auto-disposed, unlike the list. The detail payload carries every item's
/// scripture inline (≈196 KB for the six-item nightly set), and holding
/// that for the life of the process to save a request the user makes once
/// per visit is the wrong trade.
///
/// Copied from [collectionDetail].
class CollectionDetailProvider
    extends AutoDisposeFutureProvider<CuratedCollection> {
  /// One collection with its items resolved — the collection screen's source.
  ///
  /// Auto-disposed, unlike the list. The detail payload carries every item's
  /// scripture inline (≈196 KB for the six-item nightly set), and holding
  /// that for the life of the process to save a request the user makes once
  /// per visit is the wrong trade.
  ///
  /// Copied from [collectionDetail].
  CollectionDetailProvider(FaithId faith, String slug)
    : this._internal(
        (ref) => collectionDetail(ref as CollectionDetailRef, faith, slug),
        from: collectionDetailProvider,
        name: r'collectionDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$collectionDetailHash,
        dependencies: CollectionDetailFamily._dependencies,
        allTransitiveDependencies:
            CollectionDetailFamily._allTransitiveDependencies,
        faith: faith,
        slug: slug,
      );

  CollectionDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.faith,
    required this.slug,
  }) : super.internal();

  final FaithId faith;
  final String slug;

  @override
  Override overrideWith(
    FutureOr<CuratedCollection> Function(CollectionDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CollectionDetailProvider._internal(
        (ref) => create(ref as CollectionDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        faith: faith,
        slug: slug,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<CuratedCollection> createElement() {
    return _CollectionDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CollectionDetailProvider &&
        other.faith == faith &&
        other.slug == slug;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, faith.hashCode);
    hash = _SystemHash.combine(hash, slug.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CollectionDetailRef on AutoDisposeFutureProviderRef<CuratedCollection> {
  /// The parameter `faith` of this provider.
  FaithId get faith;

  /// The parameter `slug` of this provider.
  String get slug;
}

class _CollectionDetailProviderElement
    extends AutoDisposeFutureProviderElement<CuratedCollection>
    with CollectionDetailRef {
  _CollectionDetailProviderElement(super.provider);

  @override
  FaithId get faith => (origin as CollectionDetailProvider).faith;
  @override
  String get slug => (origin as CollectionDetailProvider).slug;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
