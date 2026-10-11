// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'curated_collection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CuratedCollection {

/// URL segment: `/quran/collection/<slug>`.
 String get slug;/// `islam` or `hindu`. The endpoint already pins this; it is kept so a
/// collection carries its own provenance when passed around.
 String get faithId; String get title;/// A short line under the title — "Before sleep".
 String? get subtitle;/// Long-form; shown on the collection screen, never on a card.
 String? get description;/// Server vocabulary: `nightly`, `morning`, `evening`, `after_prayer`,
/// `weekday`, `hijri`, `panchang`, `festival`, `situational`,
/// `evergreen`. Carried, not branched on — see the class doc.
 String? get occasionType;/// Free-form JSON whose shape depends on [occasionType] (`{clock: {from,
/// to}}`, `{always: true}`, …). Kept raw: parsing a shape nothing reads
/// would only create a way to crash on a shape the server adds later.
 Map<String, dynamic>? get occasionConfig;/// `sequence` or `set`. Order is meaningful either way; `set` only means
/// the items are not one continuous recitation run.
 String? get orderSemantics; String? get artworkKey;/// Roughly how long the set takes to read, in minutes.
 int? get estimatedMinutes;/// Whether this collection is promoted onto the Today dashboard.
///
/// Placement only — never availability. A collection with this false is
/// still listed in full on the Qur'an/Scripture tab and on Practice, so
/// nothing becomes unreachable by not being featured.
///
/// Defaults to false so a server that predates the column serves a
/// dashboard with no collections on it rather than one with all of them.
 bool get showOnHome; int get priority;/// The server's display order, ascending. Obeyed as given — there is no
/// client-side re-sort anywhere in this feature.
 int get sortOrder;/// Who curated and reviewed the set. Shown once, at the foot of the
/// collection screen.
 CollectionProvenance? get provenance;/// Served by both endpoints, so a card never needs the item list.
 int get itemCount;/// Served by the detail endpoint only; empty on a summary.
 List<CollectionItem> get items;
/// Create a copy of CuratedCollection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CuratedCollectionCopyWith<CuratedCollection> get copyWith => _$CuratedCollectionCopyWithImpl<CuratedCollection>(this as CuratedCollection, _$identity);

  /// Serializes this CuratedCollection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CuratedCollection&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.faithId, faithId) || other.faithId == faithId)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.description, description) || other.description == description)&&(identical(other.occasionType, occasionType) || other.occasionType == occasionType)&&const DeepCollectionEquality().equals(other.occasionConfig, occasionConfig)&&(identical(other.orderSemantics, orderSemantics) || other.orderSemantics == orderSemantics)&&(identical(other.artworkKey, artworkKey) || other.artworkKey == artworkKey)&&(identical(other.estimatedMinutes, estimatedMinutes) || other.estimatedMinutes == estimatedMinutes)&&(identical(other.showOnHome, showOnHome) || other.showOnHome == showOnHome)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.provenance, provenance) || other.provenance == provenance)&&(identical(other.itemCount, itemCount) || other.itemCount == itemCount)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,slug,faithId,title,subtitle,description,occasionType,const DeepCollectionEquality().hash(occasionConfig),orderSemantics,artworkKey,estimatedMinutes,showOnHome,priority,sortOrder,provenance,itemCount,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'CuratedCollection(slug: $slug, faithId: $faithId, title: $title, subtitle: $subtitle, description: $description, occasionType: $occasionType, occasionConfig: $occasionConfig, orderSemantics: $orderSemantics, artworkKey: $artworkKey, estimatedMinutes: $estimatedMinutes, showOnHome: $showOnHome, priority: $priority, sortOrder: $sortOrder, provenance: $provenance, itemCount: $itemCount, items: $items)';
}


}

/// @nodoc
abstract mixin class $CuratedCollectionCopyWith<$Res>  {
  factory $CuratedCollectionCopyWith(CuratedCollection value, $Res Function(CuratedCollection) _then) = _$CuratedCollectionCopyWithImpl;
@useResult
$Res call({
 String slug, String faithId, String title, String? subtitle, String? description, String? occasionType, Map<String, dynamic>? occasionConfig, String? orderSemantics, String? artworkKey, int? estimatedMinutes, bool showOnHome, int priority, int sortOrder, CollectionProvenance? provenance, int itemCount, List<CollectionItem> items
});


$CollectionProvenanceCopyWith<$Res>? get provenance;

}
/// @nodoc
class _$CuratedCollectionCopyWithImpl<$Res>
    implements $CuratedCollectionCopyWith<$Res> {
  _$CuratedCollectionCopyWithImpl(this._self, this._then);

  final CuratedCollection _self;
  final $Res Function(CuratedCollection) _then;

/// Create a copy of CuratedCollection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? slug = null,Object? faithId = null,Object? title = null,Object? subtitle = freezed,Object? description = freezed,Object? occasionType = freezed,Object? occasionConfig = freezed,Object? orderSemantics = freezed,Object? artworkKey = freezed,Object? estimatedMinutes = freezed,Object? showOnHome = null,Object? priority = null,Object? sortOrder = null,Object? provenance = freezed,Object? itemCount = null,Object? items = null,}) {
  return _then(_self.copyWith(
slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,faithId: null == faithId ? _self.faithId : faithId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,occasionType: freezed == occasionType ? _self.occasionType : occasionType // ignore: cast_nullable_to_non_nullable
as String?,occasionConfig: freezed == occasionConfig ? _self.occasionConfig : occasionConfig // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,orderSemantics: freezed == orderSemantics ? _self.orderSemantics : orderSemantics // ignore: cast_nullable_to_non_nullable
as String?,artworkKey: freezed == artworkKey ? _self.artworkKey : artworkKey // ignore: cast_nullable_to_non_nullable
as String?,estimatedMinutes: freezed == estimatedMinutes ? _self.estimatedMinutes : estimatedMinutes // ignore: cast_nullable_to_non_nullable
as int?,showOnHome: null == showOnHome ? _self.showOnHome : showOnHome // ignore: cast_nullable_to_non_nullable
as bool,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,provenance: freezed == provenance ? _self.provenance : provenance // ignore: cast_nullable_to_non_nullable
as CollectionProvenance?,itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<CollectionItem>,
  ));
}
/// Create a copy of CuratedCollection
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CollectionProvenanceCopyWith<$Res>? get provenance {
    if (_self.provenance == null) {
    return null;
  }

  return $CollectionProvenanceCopyWith<$Res>(_self.provenance!, (value) {
    return _then(_self.copyWith(provenance: value));
  });
}
}


/// Adds pattern-matching-related methods to [CuratedCollection].
extension CuratedCollectionPatterns on CuratedCollection {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CuratedCollection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CuratedCollection() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CuratedCollection value)  $default,){
final _that = this;
switch (_that) {
case _CuratedCollection():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CuratedCollection value)?  $default,){
final _that = this;
switch (_that) {
case _CuratedCollection() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String slug,  String faithId,  String title,  String? subtitle,  String? description,  String? occasionType,  Map<String, dynamic>? occasionConfig,  String? orderSemantics,  String? artworkKey,  int? estimatedMinutes,  bool showOnHome,  int priority,  int sortOrder,  CollectionProvenance? provenance,  int itemCount,  List<CollectionItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CuratedCollection() when $default != null:
return $default(_that.slug,_that.faithId,_that.title,_that.subtitle,_that.description,_that.occasionType,_that.occasionConfig,_that.orderSemantics,_that.artworkKey,_that.estimatedMinutes,_that.showOnHome,_that.priority,_that.sortOrder,_that.provenance,_that.itemCount,_that.items);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String slug,  String faithId,  String title,  String? subtitle,  String? description,  String? occasionType,  Map<String, dynamic>? occasionConfig,  String? orderSemantics,  String? artworkKey,  int? estimatedMinutes,  bool showOnHome,  int priority,  int sortOrder,  CollectionProvenance? provenance,  int itemCount,  List<CollectionItem> items)  $default,) {final _that = this;
switch (_that) {
case _CuratedCollection():
return $default(_that.slug,_that.faithId,_that.title,_that.subtitle,_that.description,_that.occasionType,_that.occasionConfig,_that.orderSemantics,_that.artworkKey,_that.estimatedMinutes,_that.showOnHome,_that.priority,_that.sortOrder,_that.provenance,_that.itemCount,_that.items);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String slug,  String faithId,  String title,  String? subtitle,  String? description,  String? occasionType,  Map<String, dynamic>? occasionConfig,  String? orderSemantics,  String? artworkKey,  int? estimatedMinutes,  bool showOnHome,  int priority,  int sortOrder,  CollectionProvenance? provenance,  int itemCount,  List<CollectionItem> items)?  $default,) {final _that = this;
switch (_that) {
case _CuratedCollection() when $default != null:
return $default(_that.slug,_that.faithId,_that.title,_that.subtitle,_that.description,_that.occasionType,_that.occasionConfig,_that.orderSemantics,_that.artworkKey,_that.estimatedMinutes,_that.showOnHome,_that.priority,_that.sortOrder,_that.provenance,_that.itemCount,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CuratedCollection implements CuratedCollection {
  const _CuratedCollection({required this.slug, required this.faithId, required this.title, this.subtitle, this.description, this.occasionType, final  Map<String, dynamic>? occasionConfig, this.orderSemantics, this.artworkKey, this.estimatedMinutes, this.showOnHome = false, this.priority = 0, this.sortOrder = 0, this.provenance, this.itemCount = 0, final  List<CollectionItem> items = const <CollectionItem>[]}): _occasionConfig = occasionConfig,_items = items;
  factory _CuratedCollection.fromJson(Map<String, dynamic> json) => _$CuratedCollectionFromJson(json);

/// URL segment: `/quran/collection/<slug>`.
@override final  String slug;
/// `islam` or `hindu`. The endpoint already pins this; it is kept so a
/// collection carries its own provenance when passed around.
@override final  String faithId;
@override final  String title;
/// A short line under the title — "Before sleep".
@override final  String? subtitle;
/// Long-form; shown on the collection screen, never on a card.
@override final  String? description;
/// Server vocabulary: `nightly`, `morning`, `evening`, `after_prayer`,
/// `weekday`, `hijri`, `panchang`, `festival`, `situational`,
/// `evergreen`. Carried, not branched on — see the class doc.
@override final  String? occasionType;
/// Free-form JSON whose shape depends on [occasionType] (`{clock: {from,
/// to}}`, `{always: true}`, …). Kept raw: parsing a shape nothing reads
/// would only create a way to crash on a shape the server adds later.
 final  Map<String, dynamic>? _occasionConfig;
/// Free-form JSON whose shape depends on [occasionType] (`{clock: {from,
/// to}}`, `{always: true}`, …). Kept raw: parsing a shape nothing reads
/// would only create a way to crash on a shape the server adds later.
@override Map<String, dynamic>? get occasionConfig {
  final value = _occasionConfig;
  if (value == null) return null;
  if (_occasionConfig is EqualUnmodifiableMapView) return _occasionConfig;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

/// `sequence` or `set`. Order is meaningful either way; `set` only means
/// the items are not one continuous recitation run.
@override final  String? orderSemantics;
@override final  String? artworkKey;
/// Roughly how long the set takes to read, in minutes.
@override final  int? estimatedMinutes;
/// Whether this collection is promoted onto the Today dashboard.
///
/// Placement only — never availability. A collection with this false is
/// still listed in full on the Qur'an/Scripture tab and on Practice, so
/// nothing becomes unreachable by not being featured.
///
/// Defaults to false so a server that predates the column serves a
/// dashboard with no collections on it rather than one with all of them.
@override@JsonKey() final  bool showOnHome;
@override@JsonKey() final  int priority;
/// The server's display order, ascending. Obeyed as given — there is no
/// client-side re-sort anywhere in this feature.
@override@JsonKey() final  int sortOrder;
/// Who curated and reviewed the set. Shown once, at the foot of the
/// collection screen.
@override final  CollectionProvenance? provenance;
/// Served by both endpoints, so a card never needs the item list.
@override@JsonKey() final  int itemCount;
/// Served by the detail endpoint only; empty on a summary.
 final  List<CollectionItem> _items;
/// Served by the detail endpoint only; empty on a summary.
@override@JsonKey() List<CollectionItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of CuratedCollection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CuratedCollectionCopyWith<_CuratedCollection> get copyWith => __$CuratedCollectionCopyWithImpl<_CuratedCollection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CuratedCollectionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CuratedCollection&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.faithId, faithId) || other.faithId == faithId)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.description, description) || other.description == description)&&(identical(other.occasionType, occasionType) || other.occasionType == occasionType)&&const DeepCollectionEquality().equals(other._occasionConfig, _occasionConfig)&&(identical(other.orderSemantics, orderSemantics) || other.orderSemantics == orderSemantics)&&(identical(other.artworkKey, artworkKey) || other.artworkKey == artworkKey)&&(identical(other.estimatedMinutes, estimatedMinutes) || other.estimatedMinutes == estimatedMinutes)&&(identical(other.showOnHome, showOnHome) || other.showOnHome == showOnHome)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.provenance, provenance) || other.provenance == provenance)&&(identical(other.itemCount, itemCount) || other.itemCount == itemCount)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,slug,faithId,title,subtitle,description,occasionType,const DeepCollectionEquality().hash(_occasionConfig),orderSemantics,artworkKey,estimatedMinutes,showOnHome,priority,sortOrder,provenance,itemCount,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'CuratedCollection(slug: $slug, faithId: $faithId, title: $title, subtitle: $subtitle, description: $description, occasionType: $occasionType, occasionConfig: $occasionConfig, orderSemantics: $orderSemantics, artworkKey: $artworkKey, estimatedMinutes: $estimatedMinutes, showOnHome: $showOnHome, priority: $priority, sortOrder: $sortOrder, provenance: $provenance, itemCount: $itemCount, items: $items)';
}


}

/// @nodoc
abstract mixin class _$CuratedCollectionCopyWith<$Res> implements $CuratedCollectionCopyWith<$Res> {
  factory _$CuratedCollectionCopyWith(_CuratedCollection value, $Res Function(_CuratedCollection) _then) = __$CuratedCollectionCopyWithImpl;
@override @useResult
$Res call({
 String slug, String faithId, String title, String? subtitle, String? description, String? occasionType, Map<String, dynamic>? occasionConfig, String? orderSemantics, String? artworkKey, int? estimatedMinutes, bool showOnHome, int priority, int sortOrder, CollectionProvenance? provenance, int itemCount, List<CollectionItem> items
});


@override $CollectionProvenanceCopyWith<$Res>? get provenance;

}
/// @nodoc
class __$CuratedCollectionCopyWithImpl<$Res>
    implements _$CuratedCollectionCopyWith<$Res> {
  __$CuratedCollectionCopyWithImpl(this._self, this._then);

  final _CuratedCollection _self;
  final $Res Function(_CuratedCollection) _then;

/// Create a copy of CuratedCollection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? slug = null,Object? faithId = null,Object? title = null,Object? subtitle = freezed,Object? description = freezed,Object? occasionType = freezed,Object? occasionConfig = freezed,Object? orderSemantics = freezed,Object? artworkKey = freezed,Object? estimatedMinutes = freezed,Object? showOnHome = null,Object? priority = null,Object? sortOrder = null,Object? provenance = freezed,Object? itemCount = null,Object? items = null,}) {
  return _then(_CuratedCollection(
slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,faithId: null == faithId ? _self.faithId : faithId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,occasionType: freezed == occasionType ? _self.occasionType : occasionType // ignore: cast_nullable_to_non_nullable
as String?,occasionConfig: freezed == occasionConfig ? _self._occasionConfig : occasionConfig // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,orderSemantics: freezed == orderSemantics ? _self.orderSemantics : orderSemantics // ignore: cast_nullable_to_non_nullable
as String?,artworkKey: freezed == artworkKey ? _self.artworkKey : artworkKey // ignore: cast_nullable_to_non_nullable
as String?,estimatedMinutes: freezed == estimatedMinutes ? _self.estimatedMinutes : estimatedMinutes // ignore: cast_nullable_to_non_nullable
as int?,showOnHome: null == showOnHome ? _self.showOnHome : showOnHome // ignore: cast_nullable_to_non_nullable
as bool,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,provenance: freezed == provenance ? _self.provenance : provenance // ignore: cast_nullable_to_non_nullable
as CollectionProvenance?,itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<CollectionItem>,
  ));
}

/// Create a copy of CuratedCollection
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CollectionProvenanceCopyWith<$Res>? get provenance {
    if (_self.provenance == null) {
    return null;
  }

  return $CollectionProvenanceCopyWith<$Res>(_self.provenance!, (value) {
    return _then(_self.copyWith(provenance: value));
  });
}
}


/// @nodoc
mixin _$CollectionProvenance {

/// `transmitted` (the set itself is narrated), `assembled` (canonical
/// parts, the app's selection), or `thematic`.
 String? get provenanceClass;/// `self_reviewed` or `scholar_approved` — the server never serves
/// `draft`, `flagged` or `retired`.
 String? get reviewStatus; String? get curatedBy; DateTime? get curatedAt; String? get reviewedBy; DateTime? get reviewedAt;
/// Create a copy of CollectionProvenance
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CollectionProvenanceCopyWith<CollectionProvenance> get copyWith => _$CollectionProvenanceCopyWithImpl<CollectionProvenance>(this as CollectionProvenance, _$identity);

  /// Serializes this CollectionProvenance to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CollectionProvenance&&(identical(other.provenanceClass, provenanceClass) || other.provenanceClass == provenanceClass)&&(identical(other.reviewStatus, reviewStatus) || other.reviewStatus == reviewStatus)&&(identical(other.curatedBy, curatedBy) || other.curatedBy == curatedBy)&&(identical(other.curatedAt, curatedAt) || other.curatedAt == curatedAt)&&(identical(other.reviewedBy, reviewedBy) || other.reviewedBy == reviewedBy)&&(identical(other.reviewedAt, reviewedAt) || other.reviewedAt == reviewedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,provenanceClass,reviewStatus,curatedBy,curatedAt,reviewedBy,reviewedAt);

@override
String toString() {
  return 'CollectionProvenance(provenanceClass: $provenanceClass, reviewStatus: $reviewStatus, curatedBy: $curatedBy, curatedAt: $curatedAt, reviewedBy: $reviewedBy, reviewedAt: $reviewedAt)';
}


}

/// @nodoc
abstract mixin class $CollectionProvenanceCopyWith<$Res>  {
  factory $CollectionProvenanceCopyWith(CollectionProvenance value, $Res Function(CollectionProvenance) _then) = _$CollectionProvenanceCopyWithImpl;
@useResult
$Res call({
 String? provenanceClass, String? reviewStatus, String? curatedBy, DateTime? curatedAt, String? reviewedBy, DateTime? reviewedAt
});




}
/// @nodoc
class _$CollectionProvenanceCopyWithImpl<$Res>
    implements $CollectionProvenanceCopyWith<$Res> {
  _$CollectionProvenanceCopyWithImpl(this._self, this._then);

  final CollectionProvenance _self;
  final $Res Function(CollectionProvenance) _then;

/// Create a copy of CollectionProvenance
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? provenanceClass = freezed,Object? reviewStatus = freezed,Object? curatedBy = freezed,Object? curatedAt = freezed,Object? reviewedBy = freezed,Object? reviewedAt = freezed,}) {
  return _then(_self.copyWith(
provenanceClass: freezed == provenanceClass ? _self.provenanceClass : provenanceClass // ignore: cast_nullable_to_non_nullable
as String?,reviewStatus: freezed == reviewStatus ? _self.reviewStatus : reviewStatus // ignore: cast_nullable_to_non_nullable
as String?,curatedBy: freezed == curatedBy ? _self.curatedBy : curatedBy // ignore: cast_nullable_to_non_nullable
as String?,curatedAt: freezed == curatedAt ? _self.curatedAt : curatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reviewedBy: freezed == reviewedBy ? _self.reviewedBy : reviewedBy // ignore: cast_nullable_to_non_nullable
as String?,reviewedAt: freezed == reviewedAt ? _self.reviewedAt : reviewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [CollectionProvenance].
extension CollectionProvenancePatterns on CollectionProvenance {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CollectionProvenance value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CollectionProvenance() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CollectionProvenance value)  $default,){
final _that = this;
switch (_that) {
case _CollectionProvenance():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CollectionProvenance value)?  $default,){
final _that = this;
switch (_that) {
case _CollectionProvenance() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? provenanceClass,  String? reviewStatus,  String? curatedBy,  DateTime? curatedAt,  String? reviewedBy,  DateTime? reviewedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CollectionProvenance() when $default != null:
return $default(_that.provenanceClass,_that.reviewStatus,_that.curatedBy,_that.curatedAt,_that.reviewedBy,_that.reviewedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? provenanceClass,  String? reviewStatus,  String? curatedBy,  DateTime? curatedAt,  String? reviewedBy,  DateTime? reviewedAt)  $default,) {final _that = this;
switch (_that) {
case _CollectionProvenance():
return $default(_that.provenanceClass,_that.reviewStatus,_that.curatedBy,_that.curatedAt,_that.reviewedBy,_that.reviewedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? provenanceClass,  String? reviewStatus,  String? curatedBy,  DateTime? curatedAt,  String? reviewedBy,  DateTime? reviewedAt)?  $default,) {final _that = this;
switch (_that) {
case _CollectionProvenance() when $default != null:
return $default(_that.provenanceClass,_that.reviewStatus,_that.curatedBy,_that.curatedAt,_that.reviewedBy,_that.reviewedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CollectionProvenance implements CollectionProvenance {
  const _CollectionProvenance({this.provenanceClass, this.reviewStatus, this.curatedBy, this.curatedAt, this.reviewedBy, this.reviewedAt});
  factory _CollectionProvenance.fromJson(Map<String, dynamic> json) => _$CollectionProvenanceFromJson(json);

/// `transmitted` (the set itself is narrated), `assembled` (canonical
/// parts, the app's selection), or `thematic`.
@override final  String? provenanceClass;
/// `self_reviewed` or `scholar_approved` — the server never serves
/// `draft`, `flagged` or `retired`.
@override final  String? reviewStatus;
@override final  String? curatedBy;
@override final  DateTime? curatedAt;
@override final  String? reviewedBy;
@override final  DateTime? reviewedAt;

/// Create a copy of CollectionProvenance
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CollectionProvenanceCopyWith<_CollectionProvenance> get copyWith => __$CollectionProvenanceCopyWithImpl<_CollectionProvenance>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CollectionProvenanceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CollectionProvenance&&(identical(other.provenanceClass, provenanceClass) || other.provenanceClass == provenanceClass)&&(identical(other.reviewStatus, reviewStatus) || other.reviewStatus == reviewStatus)&&(identical(other.curatedBy, curatedBy) || other.curatedBy == curatedBy)&&(identical(other.curatedAt, curatedAt) || other.curatedAt == curatedAt)&&(identical(other.reviewedBy, reviewedBy) || other.reviewedBy == reviewedBy)&&(identical(other.reviewedAt, reviewedAt) || other.reviewedAt == reviewedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,provenanceClass,reviewStatus,curatedBy,curatedAt,reviewedBy,reviewedAt);

@override
String toString() {
  return 'CollectionProvenance(provenanceClass: $provenanceClass, reviewStatus: $reviewStatus, curatedBy: $curatedBy, curatedAt: $curatedAt, reviewedBy: $reviewedBy, reviewedAt: $reviewedAt)';
}


}

/// @nodoc
abstract mixin class _$CollectionProvenanceCopyWith<$Res> implements $CollectionProvenanceCopyWith<$Res> {
  factory _$CollectionProvenanceCopyWith(_CollectionProvenance value, $Res Function(_CollectionProvenance) _then) = __$CollectionProvenanceCopyWithImpl;
@override @useResult
$Res call({
 String? provenanceClass, String? reviewStatus, String? curatedBy, DateTime? curatedAt, String? reviewedBy, DateTime? reviewedAt
});




}
/// @nodoc
class __$CollectionProvenanceCopyWithImpl<$Res>
    implements _$CollectionProvenanceCopyWith<$Res> {
  __$CollectionProvenanceCopyWithImpl(this._self, this._then);

  final _CollectionProvenance _self;
  final $Res Function(_CollectionProvenance) _then;

/// Create a copy of CollectionProvenance
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? provenanceClass = freezed,Object? reviewStatus = freezed,Object? curatedBy = freezed,Object? curatedAt = freezed,Object? reviewedBy = freezed,Object? reviewedAt = freezed,}) {
  return _then(_CollectionProvenance(
provenanceClass: freezed == provenanceClass ? _self.provenanceClass : provenanceClass // ignore: cast_nullable_to_non_nullable
as String?,reviewStatus: freezed == reviewStatus ? _self.reviewStatus : reviewStatus // ignore: cast_nullable_to_non_nullable
as String?,curatedBy: freezed == curatedBy ? _self.curatedBy : curatedBy // ignore: cast_nullable_to_non_nullable
as String?,curatedAt: freezed == curatedAt ? _self.curatedAt : curatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reviewedBy: freezed == reviewedBy ? _self.reviewedBy : reviewedBy // ignore: cast_nullable_to_non_nullable
as String?,reviewedAt: freezed == reviewedAt ? _self.reviewedAt : reviewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
