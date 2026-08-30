// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'temple.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Temple {

 String get id; String get name; String? get deityKey; double get lat; double get lng; String get address; String? get city; String? get state; String get country; String? get description; String? get significance; List<String> get photos; String? get googlePlaceId; String get source; DateTime? get createdAt; double? get distanceKm;
/// Create a copy of Temple
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TempleCopyWith<Temple> get copyWith => _$TempleCopyWithImpl<Temple>(this as Temple, _$identity);

  /// Serializes this Temple to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Temple&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.deityKey, deityKey) || other.deityKey == deityKey)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.address, address) || other.address == address)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.country, country) || other.country == country)&&(identical(other.description, description) || other.description == description)&&(identical(other.significance, significance) || other.significance == significance)&&const DeepCollectionEquality().equals(other.photos, photos)&&(identical(other.googlePlaceId, googlePlaceId) || other.googlePlaceId == googlePlaceId)&&(identical(other.source, source) || other.source == source)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,deityKey,lat,lng,address,city,state,country,description,significance,const DeepCollectionEquality().hash(photos),googlePlaceId,source,createdAt,distanceKm);

@override
String toString() {
  return 'Temple(id: $id, name: $name, deityKey: $deityKey, lat: $lat, lng: $lng, address: $address, city: $city, state: $state, country: $country, description: $description, significance: $significance, photos: $photos, googlePlaceId: $googlePlaceId, source: $source, createdAt: $createdAt, distanceKm: $distanceKm)';
}


}

/// @nodoc
abstract mixin class $TempleCopyWith<$Res>  {
  factory $TempleCopyWith(Temple value, $Res Function(Temple) _then) = _$TempleCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? deityKey, double lat, double lng, String address, String? city, String? state, String country, String? description, String? significance, List<String> photos, String? googlePlaceId, String source, DateTime? createdAt, double? distanceKm
});




}
/// @nodoc
class _$TempleCopyWithImpl<$Res>
    implements $TempleCopyWith<$Res> {
  _$TempleCopyWithImpl(this._self, this._then);

  final Temple _self;
  final $Res Function(Temple) _then;

/// Create a copy of Temple
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? deityKey = freezed,Object? lat = null,Object? lng = null,Object? address = null,Object? city = freezed,Object? state = freezed,Object? country = null,Object? description = freezed,Object? significance = freezed,Object? photos = null,Object? googlePlaceId = freezed,Object? source = null,Object? createdAt = freezed,Object? distanceKm = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,deityKey: freezed == deityKey ? _self.deityKey : deityKey // ignore: cast_nullable_to_non_nullable
as String?,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,significance: freezed == significance ? _self.significance : significance // ignore: cast_nullable_to_non_nullable
as String?,photos: null == photos ? _self.photos : photos // ignore: cast_nullable_to_non_nullable
as List<String>,googlePlaceId: freezed == googlePlaceId ? _self.googlePlaceId : googlePlaceId // ignore: cast_nullable_to_non_nullable
as String?,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,distanceKm: freezed == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [Temple].
extension TemplePatterns on Temple {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Temple value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Temple() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Temple value)  $default,){
final _that = this;
switch (_that) {
case _Temple():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Temple value)?  $default,){
final _that = this;
switch (_that) {
case _Temple() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? deityKey,  double lat,  double lng,  String address,  String? city,  String? state,  String country,  String? description,  String? significance,  List<String> photos,  String? googlePlaceId,  String source,  DateTime? createdAt,  double? distanceKm)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Temple() when $default != null:
return $default(_that.id,_that.name,_that.deityKey,_that.lat,_that.lng,_that.address,_that.city,_that.state,_that.country,_that.description,_that.significance,_that.photos,_that.googlePlaceId,_that.source,_that.createdAt,_that.distanceKm);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? deityKey,  double lat,  double lng,  String address,  String? city,  String? state,  String country,  String? description,  String? significance,  List<String> photos,  String? googlePlaceId,  String source,  DateTime? createdAt,  double? distanceKm)  $default,) {final _that = this;
switch (_that) {
case _Temple():
return $default(_that.id,_that.name,_that.deityKey,_that.lat,_that.lng,_that.address,_that.city,_that.state,_that.country,_that.description,_that.significance,_that.photos,_that.googlePlaceId,_that.source,_that.createdAt,_that.distanceKm);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? deityKey,  double lat,  double lng,  String address,  String? city,  String? state,  String country,  String? description,  String? significance,  List<String> photos,  String? googlePlaceId,  String source,  DateTime? createdAt,  double? distanceKm)?  $default,) {final _that = this;
switch (_that) {
case _Temple() when $default != null:
return $default(_that.id,_that.name,_that.deityKey,_that.lat,_that.lng,_that.address,_that.city,_that.state,_that.country,_that.description,_that.significance,_that.photos,_that.googlePlaceId,_that.source,_that.createdAt,_that.distanceKm);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Temple implements Temple {
  const _Temple({required this.id, required this.name, this.deityKey, required this.lat, required this.lng, required this.address, this.city, this.state, required this.country, this.description, this.significance, final  List<String> photos = const <String>[], this.googlePlaceId, required this.source, this.createdAt, this.distanceKm}): _photos = photos;
  factory _Temple.fromJson(Map<String, dynamic> json) => _$TempleFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? deityKey;
@override final  double lat;
@override final  double lng;
@override final  String address;
@override final  String? city;
@override final  String? state;
@override final  String country;
@override final  String? description;
@override final  String? significance;
 final  List<String> _photos;
@override@JsonKey() List<String> get photos {
  if (_photos is EqualUnmodifiableListView) return _photos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_photos);
}

@override final  String? googlePlaceId;
@override final  String source;
@override final  DateTime? createdAt;
@override final  double? distanceKm;

/// Create a copy of Temple
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TempleCopyWith<_Temple> get copyWith => __$TempleCopyWithImpl<_Temple>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TempleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Temple&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.deityKey, deityKey) || other.deityKey == deityKey)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.address, address) || other.address == address)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.country, country) || other.country == country)&&(identical(other.description, description) || other.description == description)&&(identical(other.significance, significance) || other.significance == significance)&&const DeepCollectionEquality().equals(other._photos, _photos)&&(identical(other.googlePlaceId, googlePlaceId) || other.googlePlaceId == googlePlaceId)&&(identical(other.source, source) || other.source == source)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,deityKey,lat,lng,address,city,state,country,description,significance,const DeepCollectionEquality().hash(_photos),googlePlaceId,source,createdAt,distanceKm);

@override
String toString() {
  return 'Temple(id: $id, name: $name, deityKey: $deityKey, lat: $lat, lng: $lng, address: $address, city: $city, state: $state, country: $country, description: $description, significance: $significance, photos: $photos, googlePlaceId: $googlePlaceId, source: $source, createdAt: $createdAt, distanceKm: $distanceKm)';
}


}

/// @nodoc
abstract mixin class _$TempleCopyWith<$Res> implements $TempleCopyWith<$Res> {
  factory _$TempleCopyWith(_Temple value, $Res Function(_Temple) _then) = __$TempleCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? deityKey, double lat, double lng, String address, String? city, String? state, String country, String? description, String? significance, List<String> photos, String? googlePlaceId, String source, DateTime? createdAt, double? distanceKm
});




}
/// @nodoc
class __$TempleCopyWithImpl<$Res>
    implements _$TempleCopyWith<$Res> {
  __$TempleCopyWithImpl(this._self, this._then);

  final _Temple _self;
  final $Res Function(_Temple) _then;

/// Create a copy of Temple
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? deityKey = freezed,Object? lat = null,Object? lng = null,Object? address = null,Object? city = freezed,Object? state = freezed,Object? country = null,Object? description = freezed,Object? significance = freezed,Object? photos = null,Object? googlePlaceId = freezed,Object? source = null,Object? createdAt = freezed,Object? distanceKm = freezed,}) {
  return _then(_Temple(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,deityKey: freezed == deityKey ? _self.deityKey : deityKey // ignore: cast_nullable_to_non_nullable
as String?,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,significance: freezed == significance ? _self.significance : significance // ignore: cast_nullable_to_non_nullable
as String?,photos: null == photos ? _self._photos : photos // ignore: cast_nullable_to_non_nullable
as List<String>,googlePlaceId: freezed == googlePlaceId ? _self.googlePlaceId : googlePlaceId // ignore: cast_nullable_to_non_nullable
as String?,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,distanceKm: freezed == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
