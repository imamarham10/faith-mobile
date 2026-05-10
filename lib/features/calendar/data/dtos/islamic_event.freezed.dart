// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'islamic_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IslamicEvent {

 String get id; String get name; String? get nameArabic; String? get description; int get hijriMonth; int get hijriDay; String get importance;
/// Create a copy of IslamicEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IslamicEventCopyWith<IslamicEvent> get copyWith => _$IslamicEventCopyWithImpl<IslamicEvent>(this as IslamicEvent, _$identity);

  /// Serializes this IslamicEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IslamicEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameArabic, nameArabic) || other.nameArabic == nameArabic)&&(identical(other.description, description) || other.description == description)&&(identical(other.hijriMonth, hijriMonth) || other.hijriMonth == hijriMonth)&&(identical(other.hijriDay, hijriDay) || other.hijriDay == hijriDay)&&(identical(other.importance, importance) || other.importance == importance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,nameArabic,description,hijriMonth,hijriDay,importance);

@override
String toString() {
  return 'IslamicEvent(id: $id, name: $name, nameArabic: $nameArabic, description: $description, hijriMonth: $hijriMonth, hijriDay: $hijriDay, importance: $importance)';
}


}

/// @nodoc
abstract mixin class $IslamicEventCopyWith<$Res>  {
  factory $IslamicEventCopyWith(IslamicEvent value, $Res Function(IslamicEvent) _then) = _$IslamicEventCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? nameArabic, String? description, int hijriMonth, int hijriDay, String importance
});




}
/// @nodoc
class _$IslamicEventCopyWithImpl<$Res>
    implements $IslamicEventCopyWith<$Res> {
  _$IslamicEventCopyWithImpl(this._self, this._then);

  final IslamicEvent _self;
  final $Res Function(IslamicEvent) _then;

/// Create a copy of IslamicEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? nameArabic = freezed,Object? description = freezed,Object? hijriMonth = null,Object? hijriDay = null,Object? importance = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameArabic: freezed == nameArabic ? _self.nameArabic : nameArabic // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,hijriMonth: null == hijriMonth ? _self.hijriMonth : hijriMonth // ignore: cast_nullable_to_non_nullable
as int,hijriDay: null == hijriDay ? _self.hijriDay : hijriDay // ignore: cast_nullable_to_non_nullable
as int,importance: null == importance ? _self.importance : importance // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [IslamicEvent].
extension IslamicEventPatterns on IslamicEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IslamicEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IslamicEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IslamicEvent value)  $default,){
final _that = this;
switch (_that) {
case _IslamicEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IslamicEvent value)?  $default,){
final _that = this;
switch (_that) {
case _IslamicEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? nameArabic,  String? description,  int hijriMonth,  int hijriDay,  String importance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IslamicEvent() when $default != null:
return $default(_that.id,_that.name,_that.nameArabic,_that.description,_that.hijriMonth,_that.hijriDay,_that.importance);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? nameArabic,  String? description,  int hijriMonth,  int hijriDay,  String importance)  $default,) {final _that = this;
switch (_that) {
case _IslamicEvent():
return $default(_that.id,_that.name,_that.nameArabic,_that.description,_that.hijriMonth,_that.hijriDay,_that.importance);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? nameArabic,  String? description,  int hijriMonth,  int hijriDay,  String importance)?  $default,) {final _that = this;
switch (_that) {
case _IslamicEvent() when $default != null:
return $default(_that.id,_that.name,_that.nameArabic,_that.description,_that.hijriMonth,_that.hijriDay,_that.importance);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IslamicEvent implements IslamicEvent {
  const _IslamicEvent({required this.id, required this.name, this.nameArabic, this.description, required this.hijriMonth, required this.hijriDay, this.importance = 'regular'});
  factory _IslamicEvent.fromJson(Map<String, dynamic> json) => _$IslamicEventFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? nameArabic;
@override final  String? description;
@override final  int hijriMonth;
@override final  int hijriDay;
@override@JsonKey() final  String importance;

/// Create a copy of IslamicEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IslamicEventCopyWith<_IslamicEvent> get copyWith => __$IslamicEventCopyWithImpl<_IslamicEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IslamicEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IslamicEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameArabic, nameArabic) || other.nameArabic == nameArabic)&&(identical(other.description, description) || other.description == description)&&(identical(other.hijriMonth, hijriMonth) || other.hijriMonth == hijriMonth)&&(identical(other.hijriDay, hijriDay) || other.hijriDay == hijriDay)&&(identical(other.importance, importance) || other.importance == importance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,nameArabic,description,hijriMonth,hijriDay,importance);

@override
String toString() {
  return 'IslamicEvent(id: $id, name: $name, nameArabic: $nameArabic, description: $description, hijriMonth: $hijriMonth, hijriDay: $hijriDay, importance: $importance)';
}


}

/// @nodoc
abstract mixin class _$IslamicEventCopyWith<$Res> implements $IslamicEventCopyWith<$Res> {
  factory _$IslamicEventCopyWith(_IslamicEvent value, $Res Function(_IslamicEvent) _then) = __$IslamicEventCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? nameArabic, String? description, int hijriMonth, int hijriDay, String importance
});




}
/// @nodoc
class __$IslamicEventCopyWithImpl<$Res>
    implements _$IslamicEventCopyWith<$Res> {
  __$IslamicEventCopyWithImpl(this._self, this._then);

  final _IslamicEvent _self;
  final $Res Function(_IslamicEvent) _then;

/// Create a copy of IslamicEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? nameArabic = freezed,Object? description = freezed,Object? hijriMonth = null,Object? hijriDay = null,Object? importance = null,}) {
  return _then(_IslamicEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameArabic: freezed == nameArabic ? _self.nameArabic : nameArabic // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,hijriMonth: null == hijriMonth ? _self.hijriMonth : hijriMonth // ignore: cast_nullable_to_non_nullable
as int,hijriDay: null == hijriDay ? _self.hijriDay : hijriDay // ignore: cast_nullable_to_non_nullable
as int,importance: null == importance ? _self.importance : importance // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
