// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'japa_goal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JapaGoal {

 String get id; String? get userId; String get mantraSanskrit; int get targetCount; int get currentCount; JapaGoalPeriod get period; DateTime get startDate; DateTime get endDate; DateTime? get createdAt; double get progressPercent; int get daysRemaining; bool get isComplete;
/// Create a copy of JapaGoal
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JapaGoalCopyWith<JapaGoal> get copyWith => _$JapaGoalCopyWithImpl<JapaGoal>(this as JapaGoal, _$identity);

  /// Serializes this JapaGoal to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JapaGoal&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.mantraSanskrit, mantraSanskrit) || other.mantraSanskrit == mantraSanskrit)&&(identical(other.targetCount, targetCount) || other.targetCount == targetCount)&&(identical(other.currentCount, currentCount) || other.currentCount == currentCount)&&(identical(other.period, period) || other.period == period)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.progressPercent, progressPercent) || other.progressPercent == progressPercent)&&(identical(other.daysRemaining, daysRemaining) || other.daysRemaining == daysRemaining)&&(identical(other.isComplete, isComplete) || other.isComplete == isComplete));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,mantraSanskrit,targetCount,currentCount,period,startDate,endDate,createdAt,progressPercent,daysRemaining,isComplete);

@override
String toString() {
  return 'JapaGoal(id: $id, userId: $userId, mantraSanskrit: $mantraSanskrit, targetCount: $targetCount, currentCount: $currentCount, period: $period, startDate: $startDate, endDate: $endDate, createdAt: $createdAt, progressPercent: $progressPercent, daysRemaining: $daysRemaining, isComplete: $isComplete)';
}


}

/// @nodoc
abstract mixin class $JapaGoalCopyWith<$Res>  {
  factory $JapaGoalCopyWith(JapaGoal value, $Res Function(JapaGoal) _then) = _$JapaGoalCopyWithImpl;
@useResult
$Res call({
 String id, String? userId, String mantraSanskrit, int targetCount, int currentCount, JapaGoalPeriod period, DateTime startDate, DateTime endDate, DateTime? createdAt, double progressPercent, int daysRemaining, bool isComplete
});




}
/// @nodoc
class _$JapaGoalCopyWithImpl<$Res>
    implements $JapaGoalCopyWith<$Res> {
  _$JapaGoalCopyWithImpl(this._self, this._then);

  final JapaGoal _self;
  final $Res Function(JapaGoal) _then;

/// Create a copy of JapaGoal
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = freezed,Object? mantraSanskrit = null,Object? targetCount = null,Object? currentCount = null,Object? period = null,Object? startDate = null,Object? endDate = null,Object? createdAt = freezed,Object? progressPercent = null,Object? daysRemaining = null,Object? isComplete = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,mantraSanskrit: null == mantraSanskrit ? _self.mantraSanskrit : mantraSanskrit // ignore: cast_nullable_to_non_nullable
as String,targetCount: null == targetCount ? _self.targetCount : targetCount // ignore: cast_nullable_to_non_nullable
as int,currentCount: null == currentCount ? _self.currentCount : currentCount // ignore: cast_nullable_to_non_nullable
as int,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as JapaGoalPeriod,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,progressPercent: null == progressPercent ? _self.progressPercent : progressPercent // ignore: cast_nullable_to_non_nullable
as double,daysRemaining: null == daysRemaining ? _self.daysRemaining : daysRemaining // ignore: cast_nullable_to_non_nullable
as int,isComplete: null == isComplete ? _self.isComplete : isComplete // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [JapaGoal].
extension JapaGoalPatterns on JapaGoal {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JapaGoal value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JapaGoal() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JapaGoal value)  $default,){
final _that = this;
switch (_that) {
case _JapaGoal():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JapaGoal value)?  $default,){
final _that = this;
switch (_that) {
case _JapaGoal() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? userId,  String mantraSanskrit,  int targetCount,  int currentCount,  JapaGoalPeriod period,  DateTime startDate,  DateTime endDate,  DateTime? createdAt,  double progressPercent,  int daysRemaining,  bool isComplete)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JapaGoal() when $default != null:
return $default(_that.id,_that.userId,_that.mantraSanskrit,_that.targetCount,_that.currentCount,_that.period,_that.startDate,_that.endDate,_that.createdAt,_that.progressPercent,_that.daysRemaining,_that.isComplete);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? userId,  String mantraSanskrit,  int targetCount,  int currentCount,  JapaGoalPeriod period,  DateTime startDate,  DateTime endDate,  DateTime? createdAt,  double progressPercent,  int daysRemaining,  bool isComplete)  $default,) {final _that = this;
switch (_that) {
case _JapaGoal():
return $default(_that.id,_that.userId,_that.mantraSanskrit,_that.targetCount,_that.currentCount,_that.period,_that.startDate,_that.endDate,_that.createdAt,_that.progressPercent,_that.daysRemaining,_that.isComplete);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? userId,  String mantraSanskrit,  int targetCount,  int currentCount,  JapaGoalPeriod period,  DateTime startDate,  DateTime endDate,  DateTime? createdAt,  double progressPercent,  int daysRemaining,  bool isComplete)?  $default,) {final _that = this;
switch (_that) {
case _JapaGoal() when $default != null:
return $default(_that.id,_that.userId,_that.mantraSanskrit,_that.targetCount,_that.currentCount,_that.period,_that.startDate,_that.endDate,_that.createdAt,_that.progressPercent,_that.daysRemaining,_that.isComplete);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JapaGoal implements JapaGoal {
  const _JapaGoal({required this.id, this.userId, required this.mantraSanskrit, required this.targetCount, this.currentCount = 0, required this.period, required this.startDate, required this.endDate, this.createdAt, this.progressPercent = 0, this.daysRemaining = 0, this.isComplete = false});
  factory _JapaGoal.fromJson(Map<String, dynamic> json) => _$JapaGoalFromJson(json);

@override final  String id;
@override final  String? userId;
@override final  String mantraSanskrit;
@override final  int targetCount;
@override@JsonKey() final  int currentCount;
@override final  JapaGoalPeriod period;
@override final  DateTime startDate;
@override final  DateTime endDate;
@override final  DateTime? createdAt;
@override@JsonKey() final  double progressPercent;
@override@JsonKey() final  int daysRemaining;
@override@JsonKey() final  bool isComplete;

/// Create a copy of JapaGoal
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JapaGoalCopyWith<_JapaGoal> get copyWith => __$JapaGoalCopyWithImpl<_JapaGoal>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JapaGoalToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JapaGoal&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.mantraSanskrit, mantraSanskrit) || other.mantraSanskrit == mantraSanskrit)&&(identical(other.targetCount, targetCount) || other.targetCount == targetCount)&&(identical(other.currentCount, currentCount) || other.currentCount == currentCount)&&(identical(other.period, period) || other.period == period)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.progressPercent, progressPercent) || other.progressPercent == progressPercent)&&(identical(other.daysRemaining, daysRemaining) || other.daysRemaining == daysRemaining)&&(identical(other.isComplete, isComplete) || other.isComplete == isComplete));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,mantraSanskrit,targetCount,currentCount,period,startDate,endDate,createdAt,progressPercent,daysRemaining,isComplete);

@override
String toString() {
  return 'JapaGoal(id: $id, userId: $userId, mantraSanskrit: $mantraSanskrit, targetCount: $targetCount, currentCount: $currentCount, period: $period, startDate: $startDate, endDate: $endDate, createdAt: $createdAt, progressPercent: $progressPercent, daysRemaining: $daysRemaining, isComplete: $isComplete)';
}


}

/// @nodoc
abstract mixin class _$JapaGoalCopyWith<$Res> implements $JapaGoalCopyWith<$Res> {
  factory _$JapaGoalCopyWith(_JapaGoal value, $Res Function(_JapaGoal) _then) = __$JapaGoalCopyWithImpl;
@override @useResult
$Res call({
 String id, String? userId, String mantraSanskrit, int targetCount, int currentCount, JapaGoalPeriod period, DateTime startDate, DateTime endDate, DateTime? createdAt, double progressPercent, int daysRemaining, bool isComplete
});




}
/// @nodoc
class __$JapaGoalCopyWithImpl<$Res>
    implements _$JapaGoalCopyWith<$Res> {
  __$JapaGoalCopyWithImpl(this._self, this._then);

  final _JapaGoal _self;
  final $Res Function(_JapaGoal) _then;

/// Create a copy of JapaGoal
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = freezed,Object? mantraSanskrit = null,Object? targetCount = null,Object? currentCount = null,Object? period = null,Object? startDate = null,Object? endDate = null,Object? createdAt = freezed,Object? progressPercent = null,Object? daysRemaining = null,Object? isComplete = null,}) {
  return _then(_JapaGoal(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,mantraSanskrit: null == mantraSanskrit ? _self.mantraSanskrit : mantraSanskrit // ignore: cast_nullable_to_non_nullable
as String,targetCount: null == targetCount ? _self.targetCount : targetCount // ignore: cast_nullable_to_non_nullable
as int,currentCount: null == currentCount ? _self.currentCount : currentCount // ignore: cast_nullable_to_non_nullable
as int,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as JapaGoalPeriod,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,progressPercent: null == progressPercent ? _self.progressPercent : progressPercent // ignore: cast_nullable_to_non_nullable
as double,daysRemaining: null == daysRemaining ? _self.daysRemaining : daysRemaining // ignore: cast_nullable_to_non_nullable
as int,isComplete: null == isComplete ? _self.isComplete : isComplete // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
