// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'juz.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JuzBoundary {

 int get surahId; String get surahName; int get verseNumber;
/// Create a copy of JuzBoundary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JuzBoundaryCopyWith<JuzBoundary> get copyWith => _$JuzBoundaryCopyWithImpl<JuzBoundary>(this as JuzBoundary, _$identity);

  /// Serializes this JuzBoundary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JuzBoundary&&(identical(other.surahId, surahId) || other.surahId == surahId)&&(identical(other.surahName, surahName) || other.surahName == surahName)&&(identical(other.verseNumber, verseNumber) || other.verseNumber == verseNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,surahId,surahName,verseNumber);

@override
String toString() {
  return 'JuzBoundary(surahId: $surahId, surahName: $surahName, verseNumber: $verseNumber)';
}


}

/// @nodoc
abstract mixin class $JuzBoundaryCopyWith<$Res>  {
  factory $JuzBoundaryCopyWith(JuzBoundary value, $Res Function(JuzBoundary) _then) = _$JuzBoundaryCopyWithImpl;
@useResult
$Res call({
 int surahId, String surahName, int verseNumber
});




}
/// @nodoc
class _$JuzBoundaryCopyWithImpl<$Res>
    implements $JuzBoundaryCopyWith<$Res> {
  _$JuzBoundaryCopyWithImpl(this._self, this._then);

  final JuzBoundary _self;
  final $Res Function(JuzBoundary) _then;

/// Create a copy of JuzBoundary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? surahId = null,Object? surahName = null,Object? verseNumber = null,}) {
  return _then(_self.copyWith(
surahId: null == surahId ? _self.surahId : surahId // ignore: cast_nullable_to_non_nullable
as int,surahName: null == surahName ? _self.surahName : surahName // ignore: cast_nullable_to_non_nullable
as String,verseNumber: null == verseNumber ? _self.verseNumber : verseNumber // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [JuzBoundary].
extension JuzBoundaryPatterns on JuzBoundary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JuzBoundary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JuzBoundary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JuzBoundary value)  $default,){
final _that = this;
switch (_that) {
case _JuzBoundary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JuzBoundary value)?  $default,){
final _that = this;
switch (_that) {
case _JuzBoundary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int surahId,  String surahName,  int verseNumber)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JuzBoundary() when $default != null:
return $default(_that.surahId,_that.surahName,_that.verseNumber);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int surahId,  String surahName,  int verseNumber)  $default,) {final _that = this;
switch (_that) {
case _JuzBoundary():
return $default(_that.surahId,_that.surahName,_that.verseNumber);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int surahId,  String surahName,  int verseNumber)?  $default,) {final _that = this;
switch (_that) {
case _JuzBoundary() when $default != null:
return $default(_that.surahId,_that.surahName,_that.verseNumber);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JuzBoundary implements JuzBoundary {
  const _JuzBoundary({required this.surahId, required this.surahName, required this.verseNumber});
  factory _JuzBoundary.fromJson(Map<String, dynamic> json) => _$JuzBoundaryFromJson(json);

@override final  int surahId;
@override final  String surahName;
@override final  int verseNumber;

/// Create a copy of JuzBoundary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JuzBoundaryCopyWith<_JuzBoundary> get copyWith => __$JuzBoundaryCopyWithImpl<_JuzBoundary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JuzBoundaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JuzBoundary&&(identical(other.surahId, surahId) || other.surahId == surahId)&&(identical(other.surahName, surahName) || other.surahName == surahName)&&(identical(other.verseNumber, verseNumber) || other.verseNumber == verseNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,surahId,surahName,verseNumber);

@override
String toString() {
  return 'JuzBoundary(surahId: $surahId, surahName: $surahName, verseNumber: $verseNumber)';
}


}

/// @nodoc
abstract mixin class _$JuzBoundaryCopyWith<$Res> implements $JuzBoundaryCopyWith<$Res> {
  factory _$JuzBoundaryCopyWith(_JuzBoundary value, $Res Function(_JuzBoundary) _then) = __$JuzBoundaryCopyWithImpl;
@override @useResult
$Res call({
 int surahId, String surahName, int verseNumber
});




}
/// @nodoc
class __$JuzBoundaryCopyWithImpl<$Res>
    implements _$JuzBoundaryCopyWith<$Res> {
  __$JuzBoundaryCopyWithImpl(this._self, this._then);

  final _JuzBoundary _self;
  final $Res Function(_JuzBoundary) _then;

/// Create a copy of JuzBoundary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? surahId = null,Object? surahName = null,Object? verseNumber = null,}) {
  return _then(_JuzBoundary(
surahId: null == surahId ? _self.surahId : surahId // ignore: cast_nullable_to_non_nullable
as int,surahName: null == surahName ? _self.surahName : surahName // ignore: cast_nullable_to_non_nullable
as String,verseNumber: null == verseNumber ? _self.verseNumber : verseNumber // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$JuzSummary {

 int get number; JuzBoundary get start; JuzBoundary get end; int get verseCount; List<int> get surahIds;
/// Create a copy of JuzSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JuzSummaryCopyWith<JuzSummary> get copyWith => _$JuzSummaryCopyWithImpl<JuzSummary>(this as JuzSummary, _$identity);

  /// Serializes this JuzSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JuzSummary&&(identical(other.number, number) || other.number == number)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.verseCount, verseCount) || other.verseCount == verseCount)&&const DeepCollectionEquality().equals(other.surahIds, surahIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,number,start,end,verseCount,const DeepCollectionEquality().hash(surahIds));

@override
String toString() {
  return 'JuzSummary(number: $number, start: $start, end: $end, verseCount: $verseCount, surahIds: $surahIds)';
}


}

/// @nodoc
abstract mixin class $JuzSummaryCopyWith<$Res>  {
  factory $JuzSummaryCopyWith(JuzSummary value, $Res Function(JuzSummary) _then) = _$JuzSummaryCopyWithImpl;
@useResult
$Res call({
 int number, JuzBoundary start, JuzBoundary end, int verseCount, List<int> surahIds
});


$JuzBoundaryCopyWith<$Res> get start;$JuzBoundaryCopyWith<$Res> get end;

}
/// @nodoc
class _$JuzSummaryCopyWithImpl<$Res>
    implements $JuzSummaryCopyWith<$Res> {
  _$JuzSummaryCopyWithImpl(this._self, this._then);

  final JuzSummary _self;
  final $Res Function(JuzSummary) _then;

/// Create a copy of JuzSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? number = null,Object? start = null,Object? end = null,Object? verseCount = null,Object? surahIds = null,}) {
  return _then(_self.copyWith(
number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as JuzBoundary,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as JuzBoundary,verseCount: null == verseCount ? _self.verseCount : verseCount // ignore: cast_nullable_to_non_nullable
as int,surahIds: null == surahIds ? _self.surahIds : surahIds // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}
/// Create a copy of JuzSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JuzBoundaryCopyWith<$Res> get start {
  
  return $JuzBoundaryCopyWith<$Res>(_self.start, (value) {
    return _then(_self.copyWith(start: value));
  });
}/// Create a copy of JuzSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JuzBoundaryCopyWith<$Res> get end {
  
  return $JuzBoundaryCopyWith<$Res>(_self.end, (value) {
    return _then(_self.copyWith(end: value));
  });
}
}


/// Adds pattern-matching-related methods to [JuzSummary].
extension JuzSummaryPatterns on JuzSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JuzSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JuzSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JuzSummary value)  $default,){
final _that = this;
switch (_that) {
case _JuzSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JuzSummary value)?  $default,){
final _that = this;
switch (_that) {
case _JuzSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int number,  JuzBoundary start,  JuzBoundary end,  int verseCount,  List<int> surahIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JuzSummary() when $default != null:
return $default(_that.number,_that.start,_that.end,_that.verseCount,_that.surahIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int number,  JuzBoundary start,  JuzBoundary end,  int verseCount,  List<int> surahIds)  $default,) {final _that = this;
switch (_that) {
case _JuzSummary():
return $default(_that.number,_that.start,_that.end,_that.verseCount,_that.surahIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int number,  JuzBoundary start,  JuzBoundary end,  int verseCount,  List<int> surahIds)?  $default,) {final _that = this;
switch (_that) {
case _JuzSummary() when $default != null:
return $default(_that.number,_that.start,_that.end,_that.verseCount,_that.surahIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JuzSummary implements JuzSummary {
  const _JuzSummary({required this.number, required this.start, required this.end, required this.verseCount, final  List<int> surahIds = const <int>[]}): _surahIds = surahIds;
  factory _JuzSummary.fromJson(Map<String, dynamic> json) => _$JuzSummaryFromJson(json);

@override final  int number;
@override final  JuzBoundary start;
@override final  JuzBoundary end;
@override final  int verseCount;
 final  List<int> _surahIds;
@override@JsonKey() List<int> get surahIds {
  if (_surahIds is EqualUnmodifiableListView) return _surahIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_surahIds);
}


/// Create a copy of JuzSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JuzSummaryCopyWith<_JuzSummary> get copyWith => __$JuzSummaryCopyWithImpl<_JuzSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JuzSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JuzSummary&&(identical(other.number, number) || other.number == number)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.verseCount, verseCount) || other.verseCount == verseCount)&&const DeepCollectionEquality().equals(other._surahIds, _surahIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,number,start,end,verseCount,const DeepCollectionEquality().hash(_surahIds));

@override
String toString() {
  return 'JuzSummary(number: $number, start: $start, end: $end, verseCount: $verseCount, surahIds: $surahIds)';
}


}

/// @nodoc
abstract mixin class _$JuzSummaryCopyWith<$Res> implements $JuzSummaryCopyWith<$Res> {
  factory _$JuzSummaryCopyWith(_JuzSummary value, $Res Function(_JuzSummary) _then) = __$JuzSummaryCopyWithImpl;
@override @useResult
$Res call({
 int number, JuzBoundary start, JuzBoundary end, int verseCount, List<int> surahIds
});


@override $JuzBoundaryCopyWith<$Res> get start;@override $JuzBoundaryCopyWith<$Res> get end;

}
/// @nodoc
class __$JuzSummaryCopyWithImpl<$Res>
    implements _$JuzSummaryCopyWith<$Res> {
  __$JuzSummaryCopyWithImpl(this._self, this._then);

  final _JuzSummary _self;
  final $Res Function(_JuzSummary) _then;

/// Create a copy of JuzSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? number = null,Object? start = null,Object? end = null,Object? verseCount = null,Object? surahIds = null,}) {
  return _then(_JuzSummary(
number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as JuzBoundary,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as JuzBoundary,verseCount: null == verseCount ? _self.verseCount : verseCount // ignore: cast_nullable_to_non_nullable
as int,surahIds: null == surahIds ? _self._surahIds : surahIds // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}

/// Create a copy of JuzSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JuzBoundaryCopyWith<$Res> get start {
  
  return $JuzBoundaryCopyWith<$Res>(_self.start, (value) {
    return _then(_self.copyWith(start: value));
  });
}/// Create a copy of JuzSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JuzBoundaryCopyWith<$Res> get end {
  
  return $JuzBoundaryCopyWith<$Res>(_self.end, (value) {
    return _then(_self.copyWith(end: value));
  });
}
}


/// @nodoc
mixin _$JuzVerse {

 String get id; int get surahId; String get surahName; int get verseNumber; int get indexInJuz; String get textArabic; String? get textUthmani; String? get textIndopak; String? get translation;
/// Create a copy of JuzVerse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JuzVerseCopyWith<JuzVerse> get copyWith => _$JuzVerseCopyWithImpl<JuzVerse>(this as JuzVerse, _$identity);

  /// Serializes this JuzVerse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JuzVerse&&(identical(other.id, id) || other.id == id)&&(identical(other.surahId, surahId) || other.surahId == surahId)&&(identical(other.surahName, surahName) || other.surahName == surahName)&&(identical(other.verseNumber, verseNumber) || other.verseNumber == verseNumber)&&(identical(other.indexInJuz, indexInJuz) || other.indexInJuz == indexInJuz)&&(identical(other.textArabic, textArabic) || other.textArabic == textArabic)&&(identical(other.textUthmani, textUthmani) || other.textUthmani == textUthmani)&&(identical(other.textIndopak, textIndopak) || other.textIndopak == textIndopak)&&(identical(other.translation, translation) || other.translation == translation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,surahId,surahName,verseNumber,indexInJuz,textArabic,textUthmani,textIndopak,translation);

@override
String toString() {
  return 'JuzVerse(id: $id, surahId: $surahId, surahName: $surahName, verseNumber: $verseNumber, indexInJuz: $indexInJuz, textArabic: $textArabic, textUthmani: $textUthmani, textIndopak: $textIndopak, translation: $translation)';
}


}

/// @nodoc
abstract mixin class $JuzVerseCopyWith<$Res>  {
  factory $JuzVerseCopyWith(JuzVerse value, $Res Function(JuzVerse) _then) = _$JuzVerseCopyWithImpl;
@useResult
$Res call({
 String id, int surahId, String surahName, int verseNumber, int indexInJuz, String textArabic, String? textUthmani, String? textIndopak, String? translation
});




}
/// @nodoc
class _$JuzVerseCopyWithImpl<$Res>
    implements $JuzVerseCopyWith<$Res> {
  _$JuzVerseCopyWithImpl(this._self, this._then);

  final JuzVerse _self;
  final $Res Function(JuzVerse) _then;

/// Create a copy of JuzVerse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? surahId = null,Object? surahName = null,Object? verseNumber = null,Object? indexInJuz = null,Object? textArabic = null,Object? textUthmani = freezed,Object? textIndopak = freezed,Object? translation = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,surahId: null == surahId ? _self.surahId : surahId // ignore: cast_nullable_to_non_nullable
as int,surahName: null == surahName ? _self.surahName : surahName // ignore: cast_nullable_to_non_nullable
as String,verseNumber: null == verseNumber ? _self.verseNumber : verseNumber // ignore: cast_nullable_to_non_nullable
as int,indexInJuz: null == indexInJuz ? _self.indexInJuz : indexInJuz // ignore: cast_nullable_to_non_nullable
as int,textArabic: null == textArabic ? _self.textArabic : textArabic // ignore: cast_nullable_to_non_nullable
as String,textUthmani: freezed == textUthmani ? _self.textUthmani : textUthmani // ignore: cast_nullable_to_non_nullable
as String?,textIndopak: freezed == textIndopak ? _self.textIndopak : textIndopak // ignore: cast_nullable_to_non_nullable
as String?,translation: freezed == translation ? _self.translation : translation // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [JuzVerse].
extension JuzVersePatterns on JuzVerse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JuzVerse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JuzVerse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JuzVerse value)  $default,){
final _that = this;
switch (_that) {
case _JuzVerse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JuzVerse value)?  $default,){
final _that = this;
switch (_that) {
case _JuzVerse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int surahId,  String surahName,  int verseNumber,  int indexInJuz,  String textArabic,  String? textUthmani,  String? textIndopak,  String? translation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JuzVerse() when $default != null:
return $default(_that.id,_that.surahId,_that.surahName,_that.verseNumber,_that.indexInJuz,_that.textArabic,_that.textUthmani,_that.textIndopak,_that.translation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int surahId,  String surahName,  int verseNumber,  int indexInJuz,  String textArabic,  String? textUthmani,  String? textIndopak,  String? translation)  $default,) {final _that = this;
switch (_that) {
case _JuzVerse():
return $default(_that.id,_that.surahId,_that.surahName,_that.verseNumber,_that.indexInJuz,_that.textArabic,_that.textUthmani,_that.textIndopak,_that.translation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int surahId,  String surahName,  int verseNumber,  int indexInJuz,  String textArabic,  String? textUthmani,  String? textIndopak,  String? translation)?  $default,) {final _that = this;
switch (_that) {
case _JuzVerse() when $default != null:
return $default(_that.id,_that.surahId,_that.surahName,_that.verseNumber,_that.indexInJuz,_that.textArabic,_that.textUthmani,_that.textIndopak,_that.translation);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JuzVerse implements JuzVerse {
  const _JuzVerse({required this.id, required this.surahId, required this.surahName, required this.verseNumber, required this.indexInJuz, required this.textArabic, this.textUthmani, this.textIndopak, this.translation});
  factory _JuzVerse.fromJson(Map<String, dynamic> json) => _$JuzVerseFromJson(json);

@override final  String id;
@override final  int surahId;
@override final  String surahName;
@override final  int verseNumber;
@override final  int indexInJuz;
@override final  String textArabic;
@override final  String? textUthmani;
@override final  String? textIndopak;
@override final  String? translation;

/// Create a copy of JuzVerse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JuzVerseCopyWith<_JuzVerse> get copyWith => __$JuzVerseCopyWithImpl<_JuzVerse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JuzVerseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JuzVerse&&(identical(other.id, id) || other.id == id)&&(identical(other.surahId, surahId) || other.surahId == surahId)&&(identical(other.surahName, surahName) || other.surahName == surahName)&&(identical(other.verseNumber, verseNumber) || other.verseNumber == verseNumber)&&(identical(other.indexInJuz, indexInJuz) || other.indexInJuz == indexInJuz)&&(identical(other.textArabic, textArabic) || other.textArabic == textArabic)&&(identical(other.textUthmani, textUthmani) || other.textUthmani == textUthmani)&&(identical(other.textIndopak, textIndopak) || other.textIndopak == textIndopak)&&(identical(other.translation, translation) || other.translation == translation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,surahId,surahName,verseNumber,indexInJuz,textArabic,textUthmani,textIndopak,translation);

@override
String toString() {
  return 'JuzVerse(id: $id, surahId: $surahId, surahName: $surahName, verseNumber: $verseNumber, indexInJuz: $indexInJuz, textArabic: $textArabic, textUthmani: $textUthmani, textIndopak: $textIndopak, translation: $translation)';
}


}

/// @nodoc
abstract mixin class _$JuzVerseCopyWith<$Res> implements $JuzVerseCopyWith<$Res> {
  factory _$JuzVerseCopyWith(_JuzVerse value, $Res Function(_JuzVerse) _then) = __$JuzVerseCopyWithImpl;
@override @useResult
$Res call({
 String id, int surahId, String surahName, int verseNumber, int indexInJuz, String textArabic, String? textUthmani, String? textIndopak, String? translation
});




}
/// @nodoc
class __$JuzVerseCopyWithImpl<$Res>
    implements _$JuzVerseCopyWith<$Res> {
  __$JuzVerseCopyWithImpl(this._self, this._then);

  final _JuzVerse _self;
  final $Res Function(_JuzVerse) _then;

/// Create a copy of JuzVerse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? surahId = null,Object? surahName = null,Object? verseNumber = null,Object? indexInJuz = null,Object? textArabic = null,Object? textUthmani = freezed,Object? textIndopak = freezed,Object? translation = freezed,}) {
  return _then(_JuzVerse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,surahId: null == surahId ? _self.surahId : surahId // ignore: cast_nullable_to_non_nullable
as int,surahName: null == surahName ? _self.surahName : surahName // ignore: cast_nullable_to_non_nullable
as String,verseNumber: null == verseNumber ? _self.verseNumber : verseNumber // ignore: cast_nullable_to_non_nullable
as int,indexInJuz: null == indexInJuz ? _self.indexInJuz : indexInJuz // ignore: cast_nullable_to_non_nullable
as int,textArabic: null == textArabic ? _self.textArabic : textArabic // ignore: cast_nullable_to_non_nullable
as String,textUthmani: freezed == textUthmani ? _self.textUthmani : textUthmani // ignore: cast_nullable_to_non_nullable
as String?,textIndopak: freezed == textIndopak ? _self.textIndopak : textIndopak // ignore: cast_nullable_to_non_nullable
as String?,translation: freezed == translation ? _self.translation : translation // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$JuzPage {

 int get number; int get verseCount; int get page; int get limit; int get totalPages; List<JuzVerse> get verses;
/// Create a copy of JuzPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JuzPageCopyWith<JuzPage> get copyWith => _$JuzPageCopyWithImpl<JuzPage>(this as JuzPage, _$identity);

  /// Serializes this JuzPage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JuzPage&&(identical(other.number, number) || other.number == number)&&(identical(other.verseCount, verseCount) || other.verseCount == verseCount)&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&const DeepCollectionEquality().equals(other.verses, verses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,number,verseCount,page,limit,totalPages,const DeepCollectionEquality().hash(verses));

@override
String toString() {
  return 'JuzPage(number: $number, verseCount: $verseCount, page: $page, limit: $limit, totalPages: $totalPages, verses: $verses)';
}


}

/// @nodoc
abstract mixin class $JuzPageCopyWith<$Res>  {
  factory $JuzPageCopyWith(JuzPage value, $Res Function(JuzPage) _then) = _$JuzPageCopyWithImpl;
@useResult
$Res call({
 int number, int verseCount, int page, int limit, int totalPages, List<JuzVerse> verses
});




}
/// @nodoc
class _$JuzPageCopyWithImpl<$Res>
    implements $JuzPageCopyWith<$Res> {
  _$JuzPageCopyWithImpl(this._self, this._then);

  final JuzPage _self;
  final $Res Function(JuzPage) _then;

/// Create a copy of JuzPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? number = null,Object? verseCount = null,Object? page = null,Object? limit = null,Object? totalPages = null,Object? verses = null,}) {
  return _then(_self.copyWith(
number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,verseCount: null == verseCount ? _self.verseCount : verseCount // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,verses: null == verses ? _self.verses : verses // ignore: cast_nullable_to_non_nullable
as List<JuzVerse>,
  ));
}

}


/// Adds pattern-matching-related methods to [JuzPage].
extension JuzPagePatterns on JuzPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JuzPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JuzPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JuzPage value)  $default,){
final _that = this;
switch (_that) {
case _JuzPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JuzPage value)?  $default,){
final _that = this;
switch (_that) {
case _JuzPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int number,  int verseCount,  int page,  int limit,  int totalPages,  List<JuzVerse> verses)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JuzPage() when $default != null:
return $default(_that.number,_that.verseCount,_that.page,_that.limit,_that.totalPages,_that.verses);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int number,  int verseCount,  int page,  int limit,  int totalPages,  List<JuzVerse> verses)  $default,) {final _that = this;
switch (_that) {
case _JuzPage():
return $default(_that.number,_that.verseCount,_that.page,_that.limit,_that.totalPages,_that.verses);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int number,  int verseCount,  int page,  int limit,  int totalPages,  List<JuzVerse> verses)?  $default,) {final _that = this;
switch (_that) {
case _JuzPage() when $default != null:
return $default(_that.number,_that.verseCount,_that.page,_that.limit,_that.totalPages,_that.verses);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JuzPage implements JuzPage {
  const _JuzPage({required this.number, required this.verseCount, required this.page, required this.limit, required this.totalPages, final  List<JuzVerse> verses = const <JuzVerse>[]}): _verses = verses;
  factory _JuzPage.fromJson(Map<String, dynamic> json) => _$JuzPageFromJson(json);

@override final  int number;
@override final  int verseCount;
@override final  int page;
@override final  int limit;
@override final  int totalPages;
 final  List<JuzVerse> _verses;
@override@JsonKey() List<JuzVerse> get verses {
  if (_verses is EqualUnmodifiableListView) return _verses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_verses);
}


/// Create a copy of JuzPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JuzPageCopyWith<_JuzPage> get copyWith => __$JuzPageCopyWithImpl<_JuzPage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JuzPageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JuzPage&&(identical(other.number, number) || other.number == number)&&(identical(other.verseCount, verseCount) || other.verseCount == verseCount)&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&const DeepCollectionEquality().equals(other._verses, _verses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,number,verseCount,page,limit,totalPages,const DeepCollectionEquality().hash(_verses));

@override
String toString() {
  return 'JuzPage(number: $number, verseCount: $verseCount, page: $page, limit: $limit, totalPages: $totalPages, verses: $verses)';
}


}

/// @nodoc
abstract mixin class _$JuzPageCopyWith<$Res> implements $JuzPageCopyWith<$Res> {
  factory _$JuzPageCopyWith(_JuzPage value, $Res Function(_JuzPage) _then) = __$JuzPageCopyWithImpl;
@override @useResult
$Res call({
 int number, int verseCount, int page, int limit, int totalPages, List<JuzVerse> verses
});




}
/// @nodoc
class __$JuzPageCopyWithImpl<$Res>
    implements _$JuzPageCopyWith<$Res> {
  __$JuzPageCopyWithImpl(this._self, this._then);

  final _JuzPage _self;
  final $Res Function(_JuzPage) _then;

/// Create a copy of JuzPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? number = null,Object? verseCount = null,Object? page = null,Object? limit = null,Object? totalPages = null,Object? verses = null,}) {
  return _then(_JuzPage(
number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,verseCount: null == verseCount ? _self.verseCount : verseCount // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,verses: null == verses ? _self._verses : verses // ignore: cast_nullable_to_non_nullable
as List<JuzVerse>,
  ));
}


}

// dart format on
