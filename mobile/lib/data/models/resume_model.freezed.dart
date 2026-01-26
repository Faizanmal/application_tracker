// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'resume_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Resume {

 String get id; String get name;@JsonKey(name: 'file_url') String get fileUrl;@JsonKey(name: 'file_name') String get fileName;@JsonKey(name: 'file_size') int? get fileSize;@JsonKey(name: 'file_type') String? get fileType; bool get isDefault;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;
/// Create a copy of Resume
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResumeCopyWith<Resume> get copyWith => _$ResumeCopyWithImpl<Resume>(this as Resume, _$identity);

  /// Serializes this Resume to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Resume&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.fileSize, fileSize) || other.fileSize == fileSize)&&(identical(other.fileType, fileType) || other.fileType == fileType)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,fileUrl,fileName,fileSize,fileType,isDefault,createdAt,updatedAt);

@override
String toString() {
  return 'Resume(id: $id, name: $name, fileUrl: $fileUrl, fileName: $fileName, fileSize: $fileSize, fileType: $fileType, isDefault: $isDefault, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ResumeCopyWith<$Res>  {
  factory $ResumeCopyWith(Resume value, $Res Function(Resume) _then) = _$ResumeCopyWithImpl;
@useResult
$Res call({
 String id, String name,@JsonKey(name: 'file_url') String fileUrl,@JsonKey(name: 'file_name') String fileName,@JsonKey(name: 'file_size') int? fileSize,@JsonKey(name: 'file_type') String? fileType, bool isDefault,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class _$ResumeCopyWithImpl<$Res>
    implements $ResumeCopyWith<$Res> {
  _$ResumeCopyWithImpl(this._self, this._then);

  final Resume _self;
  final $Res Function(Resume) _then;

/// Create a copy of Resume
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? fileUrl = null,Object? fileName = null,Object? fileSize = freezed,Object? fileType = freezed,Object? isDefault = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,fileUrl: null == fileUrl ? _self.fileUrl : fileUrl // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,fileSize: freezed == fileSize ? _self.fileSize : fileSize // ignore: cast_nullable_to_non_nullable
as int?,fileType: freezed == fileType ? _self.fileType : fileType // ignore: cast_nullable_to_non_nullable
as String?,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Resume].
extension ResumePatterns on Resume {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Resume value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Resume() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Resume value)  $default,){
final _that = this;
switch (_that) {
case _Resume():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Resume value)?  $default,){
final _that = this;
switch (_that) {
case _Resume() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(name: 'file_url')  String fileUrl, @JsonKey(name: 'file_name')  String fileName, @JsonKey(name: 'file_size')  int? fileSize, @JsonKey(name: 'file_type')  String? fileType,  bool isDefault, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Resume() when $default != null:
return $default(_that.id,_that.name,_that.fileUrl,_that.fileName,_that.fileSize,_that.fileType,_that.isDefault,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(name: 'file_url')  String fileUrl, @JsonKey(name: 'file_name')  String fileName, @JsonKey(name: 'file_size')  int? fileSize, @JsonKey(name: 'file_type')  String? fileType,  bool isDefault, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Resume():
return $default(_that.id,_that.name,_that.fileUrl,_that.fileName,_that.fileSize,_that.fileType,_that.isDefault,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name, @JsonKey(name: 'file_url')  String fileUrl, @JsonKey(name: 'file_name')  String fileName, @JsonKey(name: 'file_size')  int? fileSize, @JsonKey(name: 'file_type')  String? fileType,  bool isDefault, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Resume() when $default != null:
return $default(_that.id,_that.name,_that.fileUrl,_that.fileName,_that.fileSize,_that.fileType,_that.isDefault,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Resume implements Resume {
  const _Resume({required this.id, required this.name, @JsonKey(name: 'file_url') required this.fileUrl, @JsonKey(name: 'file_name') required this.fileName, @JsonKey(name: 'file_size') this.fileSize, @JsonKey(name: 'file_type') this.fileType, this.isDefault = false, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt});
  factory _Resume.fromJson(Map<String, dynamic> json) => _$ResumeFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey(name: 'file_url') final  String fileUrl;
@override@JsonKey(name: 'file_name') final  String fileName;
@override@JsonKey(name: 'file_size') final  int? fileSize;
@override@JsonKey(name: 'file_type') final  String? fileType;
@override@JsonKey() final  bool isDefault;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;

/// Create a copy of Resume
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResumeCopyWith<_Resume> get copyWith => __$ResumeCopyWithImpl<_Resume>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ResumeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Resume&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.fileSize, fileSize) || other.fileSize == fileSize)&&(identical(other.fileType, fileType) || other.fileType == fileType)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,fileUrl,fileName,fileSize,fileType,isDefault,createdAt,updatedAt);

@override
String toString() {
  return 'Resume(id: $id, name: $name, fileUrl: $fileUrl, fileName: $fileName, fileSize: $fileSize, fileType: $fileType, isDefault: $isDefault, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ResumeCopyWith<$Res> implements $ResumeCopyWith<$Res> {
  factory _$ResumeCopyWith(_Resume value, $Res Function(_Resume) _then) = __$ResumeCopyWithImpl;
@override @useResult
$Res call({
 String id, String name,@JsonKey(name: 'file_url') String fileUrl,@JsonKey(name: 'file_name') String fileName,@JsonKey(name: 'file_size') int? fileSize,@JsonKey(name: 'file_type') String? fileType, bool isDefault,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class __$ResumeCopyWithImpl<$Res>
    implements _$ResumeCopyWith<$Res> {
  __$ResumeCopyWithImpl(this._self, this._then);

  final _Resume _self;
  final $Res Function(_Resume) _then;

/// Create a copy of Resume
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? fileUrl = null,Object? fileName = null,Object? fileSize = freezed,Object? fileType = freezed,Object? isDefault = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Resume(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,fileUrl: null == fileUrl ? _self.fileUrl : fileUrl // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,fileSize: freezed == fileSize ? _self.fileSize : fileSize // ignore: cast_nullable_to_non_nullable
as int?,fileType: freezed == fileType ? _self.fileType : fileType // ignore: cast_nullable_to_non_nullable
as String?,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$ResumeListResponse {

 int get count; String? get next; String? get previous; List<Resume> get results;
/// Create a copy of ResumeListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResumeListResponseCopyWith<ResumeListResponse> get copyWith => _$ResumeListResponseCopyWithImpl<ResumeListResponse>(this as ResumeListResponse, _$identity);

  /// Serializes this ResumeListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResumeListResponse&&(identical(other.count, count) || other.count == count)&&(identical(other.next, next) || other.next == next)&&(identical(other.previous, previous) || other.previous == previous)&&const DeepCollectionEquality().equals(other.results, results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,next,previous,const DeepCollectionEquality().hash(results));

@override
String toString() {
  return 'ResumeListResponse(count: $count, next: $next, previous: $previous, results: $results)';
}


}

/// @nodoc
abstract mixin class $ResumeListResponseCopyWith<$Res>  {
  factory $ResumeListResponseCopyWith(ResumeListResponse value, $Res Function(ResumeListResponse) _then) = _$ResumeListResponseCopyWithImpl;
@useResult
$Res call({
 int count, String? next, String? previous, List<Resume> results
});




}
/// @nodoc
class _$ResumeListResponseCopyWithImpl<$Res>
    implements $ResumeListResponseCopyWith<$Res> {
  _$ResumeListResponseCopyWithImpl(this._self, this._then);

  final ResumeListResponse _self;
  final $Res Function(ResumeListResponse) _then;

/// Create a copy of ResumeListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? count = null,Object? next = freezed,Object? previous = freezed,Object? results = null,}) {
  return _then(_self.copyWith(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,next: freezed == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as String?,previous: freezed == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as String?,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<Resume>,
  ));
}

}


/// Adds pattern-matching-related methods to [ResumeListResponse].
extension ResumeListResponsePatterns on ResumeListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ResumeListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ResumeListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ResumeListResponse value)  $default,){
final _that = this;
switch (_that) {
case _ResumeListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ResumeListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ResumeListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int count,  String? next,  String? previous,  List<Resume> results)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ResumeListResponse() when $default != null:
return $default(_that.count,_that.next,_that.previous,_that.results);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int count,  String? next,  String? previous,  List<Resume> results)  $default,) {final _that = this;
switch (_that) {
case _ResumeListResponse():
return $default(_that.count,_that.next,_that.previous,_that.results);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int count,  String? next,  String? previous,  List<Resume> results)?  $default,) {final _that = this;
switch (_that) {
case _ResumeListResponse() when $default != null:
return $default(_that.count,_that.next,_that.previous,_that.results);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ResumeListResponse implements ResumeListResponse {
  const _ResumeListResponse({required this.count, this.next, this.previous, required final  List<Resume> results}): _results = results;
  factory _ResumeListResponse.fromJson(Map<String, dynamic> json) => _$ResumeListResponseFromJson(json);

@override final  int count;
@override final  String? next;
@override final  String? previous;
 final  List<Resume> _results;
@override List<Resume> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}


/// Create a copy of ResumeListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResumeListResponseCopyWith<_ResumeListResponse> get copyWith => __$ResumeListResponseCopyWithImpl<_ResumeListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ResumeListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResumeListResponse&&(identical(other.count, count) || other.count == count)&&(identical(other.next, next) || other.next == next)&&(identical(other.previous, previous) || other.previous == previous)&&const DeepCollectionEquality().equals(other._results, _results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,next,previous,const DeepCollectionEquality().hash(_results));

@override
String toString() {
  return 'ResumeListResponse(count: $count, next: $next, previous: $previous, results: $results)';
}


}

/// @nodoc
abstract mixin class _$ResumeListResponseCopyWith<$Res> implements $ResumeListResponseCopyWith<$Res> {
  factory _$ResumeListResponseCopyWith(_ResumeListResponse value, $Res Function(_ResumeListResponse) _then) = __$ResumeListResponseCopyWithImpl;
@override @useResult
$Res call({
 int count, String? next, String? previous, List<Resume> results
});




}
/// @nodoc
class __$ResumeListResponseCopyWithImpl<$Res>
    implements _$ResumeListResponseCopyWith<$Res> {
  __$ResumeListResponseCopyWithImpl(this._self, this._then);

  final _ResumeListResponse _self;
  final $Res Function(_ResumeListResponse) _then;

/// Create a copy of ResumeListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? count = null,Object? next = freezed,Object? previous = freezed,Object? results = null,}) {
  return _then(_ResumeListResponse(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,next: freezed == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as String?,previous: freezed == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as String?,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<Resume>,
  ));
}


}


/// @nodoc
mixin _$UpdateResumeRequest {

 String? get name;@JsonKey(name: 'is_default') bool? get isDefault;
/// Create a copy of UpdateResumeRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateResumeRequestCopyWith<UpdateResumeRequest> get copyWith => _$UpdateResumeRequestCopyWithImpl<UpdateResumeRequest>(this as UpdateResumeRequest, _$identity);

  /// Serializes this UpdateResumeRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateResumeRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,isDefault);

@override
String toString() {
  return 'UpdateResumeRequest(name: $name, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class $UpdateResumeRequestCopyWith<$Res>  {
  factory $UpdateResumeRequestCopyWith(UpdateResumeRequest value, $Res Function(UpdateResumeRequest) _then) = _$UpdateResumeRequestCopyWithImpl;
@useResult
$Res call({
 String? name,@JsonKey(name: 'is_default') bool? isDefault
});




}
/// @nodoc
class _$UpdateResumeRequestCopyWithImpl<$Res>
    implements $UpdateResumeRequestCopyWith<$Res> {
  _$UpdateResumeRequestCopyWithImpl(this._self, this._then);

  final UpdateResumeRequest _self;
  final $Res Function(UpdateResumeRequest) _then;

/// Create a copy of UpdateResumeRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? isDefault = freezed,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,isDefault: freezed == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateResumeRequest].
extension UpdateResumeRequestPatterns on UpdateResumeRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateResumeRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateResumeRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateResumeRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateResumeRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateResumeRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateResumeRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name, @JsonKey(name: 'is_default')  bool? isDefault)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateResumeRequest() when $default != null:
return $default(_that.name,_that.isDefault);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name, @JsonKey(name: 'is_default')  bool? isDefault)  $default,) {final _that = this;
switch (_that) {
case _UpdateResumeRequest():
return $default(_that.name,_that.isDefault);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name, @JsonKey(name: 'is_default')  bool? isDefault)?  $default,) {final _that = this;
switch (_that) {
case _UpdateResumeRequest() when $default != null:
return $default(_that.name,_that.isDefault);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateResumeRequest implements UpdateResumeRequest {
  const _UpdateResumeRequest({this.name, @JsonKey(name: 'is_default') this.isDefault});
  factory _UpdateResumeRequest.fromJson(Map<String, dynamic> json) => _$UpdateResumeRequestFromJson(json);

@override final  String? name;
@override@JsonKey(name: 'is_default') final  bool? isDefault;

/// Create a copy of UpdateResumeRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateResumeRequestCopyWith<_UpdateResumeRequest> get copyWith => __$UpdateResumeRequestCopyWithImpl<_UpdateResumeRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateResumeRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateResumeRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,isDefault);

@override
String toString() {
  return 'UpdateResumeRequest(name: $name, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class _$UpdateResumeRequestCopyWith<$Res> implements $UpdateResumeRequestCopyWith<$Res> {
  factory _$UpdateResumeRequestCopyWith(_UpdateResumeRequest value, $Res Function(_UpdateResumeRequest) _then) = __$UpdateResumeRequestCopyWithImpl;
@override @useResult
$Res call({
 String? name,@JsonKey(name: 'is_default') bool? isDefault
});




}
/// @nodoc
class __$UpdateResumeRequestCopyWithImpl<$Res>
    implements _$UpdateResumeRequestCopyWith<$Res> {
  __$UpdateResumeRequestCopyWithImpl(this._self, this._then);

  final _UpdateResumeRequest _self;
  final $Res Function(_UpdateResumeRequest) _then;

/// Create a copy of UpdateResumeRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? isDefault = freezed,}) {
  return _then(_UpdateResumeRequest(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,isDefault: freezed == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
