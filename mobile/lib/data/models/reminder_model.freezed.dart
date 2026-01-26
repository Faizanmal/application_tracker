// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reminder_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Reminder {

 String get id;@JsonKey(name: 'application_id') String? get applicationId;@JsonKey(name: 'application') ReminderApplicationSummary? get application; String get title; String? get description;@JsonKey(name: 'reminder_type') String get reminderType; String get status;@JsonKey(name: 'due_at') DateTime get dueAt;@JsonKey(name: 'snoozed_until') DateTime? get snoozedUntil;@JsonKey(name: 'completed_at') DateTime? get completedAt;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;
/// Create a copy of Reminder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReminderCopyWith<Reminder> get copyWith => _$ReminderCopyWithImpl<Reminder>(this as Reminder, _$identity);

  /// Serializes this Reminder to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Reminder&&(identical(other.id, id) || other.id == id)&&(identical(other.applicationId, applicationId) || other.applicationId == applicationId)&&(identical(other.application, application) || other.application == application)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.reminderType, reminderType) || other.reminderType == reminderType)&&(identical(other.status, status) || other.status == status)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.snoozedUntil, snoozedUntil) || other.snoozedUntil == snoozedUntil)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,applicationId,application,title,description,reminderType,status,dueAt,snoozedUntil,completedAt,createdAt,updatedAt);

@override
String toString() {
  return 'Reminder(id: $id, applicationId: $applicationId, application: $application, title: $title, description: $description, reminderType: $reminderType, status: $status, dueAt: $dueAt, snoozedUntil: $snoozedUntil, completedAt: $completedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ReminderCopyWith<$Res>  {
  factory $ReminderCopyWith(Reminder value, $Res Function(Reminder) _then) = _$ReminderCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'application_id') String? applicationId,@JsonKey(name: 'application') ReminderApplicationSummary? application, String title, String? description,@JsonKey(name: 'reminder_type') String reminderType, String status,@JsonKey(name: 'due_at') DateTime dueAt,@JsonKey(name: 'snoozed_until') DateTime? snoozedUntil,@JsonKey(name: 'completed_at') DateTime? completedAt,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});


$ReminderApplicationSummaryCopyWith<$Res>? get application;

}
/// @nodoc
class _$ReminderCopyWithImpl<$Res>
    implements $ReminderCopyWith<$Res> {
  _$ReminderCopyWithImpl(this._self, this._then);

  final Reminder _self;
  final $Res Function(Reminder) _then;

/// Create a copy of Reminder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? applicationId = freezed,Object? application = freezed,Object? title = null,Object? description = freezed,Object? reminderType = null,Object? status = null,Object? dueAt = null,Object? snoozedUntil = freezed,Object? completedAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,applicationId: freezed == applicationId ? _self.applicationId : applicationId // ignore: cast_nullable_to_non_nullable
as String?,application: freezed == application ? _self.application : application // ignore: cast_nullable_to_non_nullable
as ReminderApplicationSummary?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,reminderType: null == reminderType ? _self.reminderType : reminderType // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,dueAt: null == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime,snoozedUntil: freezed == snoozedUntil ? _self.snoozedUntil : snoozedUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of Reminder
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReminderApplicationSummaryCopyWith<$Res>? get application {
    if (_self.application == null) {
    return null;
  }

  return $ReminderApplicationSummaryCopyWith<$Res>(_self.application!, (value) {
    return _then(_self.copyWith(application: value));
  });
}
}


/// Adds pattern-matching-related methods to [Reminder].
extension ReminderPatterns on Reminder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Reminder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Reminder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Reminder value)  $default,){
final _that = this;
switch (_that) {
case _Reminder():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Reminder value)?  $default,){
final _that = this;
switch (_that) {
case _Reminder() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'application_id')  String? applicationId, @JsonKey(name: 'application')  ReminderApplicationSummary? application,  String title,  String? description, @JsonKey(name: 'reminder_type')  String reminderType,  String status, @JsonKey(name: 'due_at')  DateTime dueAt, @JsonKey(name: 'snoozed_until')  DateTime? snoozedUntil, @JsonKey(name: 'completed_at')  DateTime? completedAt, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Reminder() when $default != null:
return $default(_that.id,_that.applicationId,_that.application,_that.title,_that.description,_that.reminderType,_that.status,_that.dueAt,_that.snoozedUntil,_that.completedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'application_id')  String? applicationId, @JsonKey(name: 'application')  ReminderApplicationSummary? application,  String title,  String? description, @JsonKey(name: 'reminder_type')  String reminderType,  String status, @JsonKey(name: 'due_at')  DateTime dueAt, @JsonKey(name: 'snoozed_until')  DateTime? snoozedUntil, @JsonKey(name: 'completed_at')  DateTime? completedAt, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Reminder():
return $default(_that.id,_that.applicationId,_that.application,_that.title,_that.description,_that.reminderType,_that.status,_that.dueAt,_that.snoozedUntil,_that.completedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'application_id')  String? applicationId, @JsonKey(name: 'application')  ReminderApplicationSummary? application,  String title,  String? description, @JsonKey(name: 'reminder_type')  String reminderType,  String status, @JsonKey(name: 'due_at')  DateTime dueAt, @JsonKey(name: 'snoozed_until')  DateTime? snoozedUntil, @JsonKey(name: 'completed_at')  DateTime? completedAt, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Reminder() when $default != null:
return $default(_that.id,_that.applicationId,_that.application,_that.title,_that.description,_that.reminderType,_that.status,_that.dueAt,_that.snoozedUntil,_that.completedAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Reminder implements Reminder {
  const _Reminder({required this.id, @JsonKey(name: 'application_id') this.applicationId, @JsonKey(name: 'application') this.application, required this.title, this.description, @JsonKey(name: 'reminder_type') required this.reminderType, required this.status, @JsonKey(name: 'due_at') required this.dueAt, @JsonKey(name: 'snoozed_until') this.snoozedUntil, @JsonKey(name: 'completed_at') this.completedAt, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt});
  factory _Reminder.fromJson(Map<String, dynamic> json) => _$ReminderFromJson(json);

@override final  String id;
@override@JsonKey(name: 'application_id') final  String? applicationId;
@override@JsonKey(name: 'application') final  ReminderApplicationSummary? application;
@override final  String title;
@override final  String? description;
@override@JsonKey(name: 'reminder_type') final  String reminderType;
@override final  String status;
@override@JsonKey(name: 'due_at') final  DateTime dueAt;
@override@JsonKey(name: 'snoozed_until') final  DateTime? snoozedUntil;
@override@JsonKey(name: 'completed_at') final  DateTime? completedAt;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;

/// Create a copy of Reminder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReminderCopyWith<_Reminder> get copyWith => __$ReminderCopyWithImpl<_Reminder>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReminderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Reminder&&(identical(other.id, id) || other.id == id)&&(identical(other.applicationId, applicationId) || other.applicationId == applicationId)&&(identical(other.application, application) || other.application == application)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.reminderType, reminderType) || other.reminderType == reminderType)&&(identical(other.status, status) || other.status == status)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.snoozedUntil, snoozedUntil) || other.snoozedUntil == snoozedUntil)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,applicationId,application,title,description,reminderType,status,dueAt,snoozedUntil,completedAt,createdAt,updatedAt);

@override
String toString() {
  return 'Reminder(id: $id, applicationId: $applicationId, application: $application, title: $title, description: $description, reminderType: $reminderType, status: $status, dueAt: $dueAt, snoozedUntil: $snoozedUntil, completedAt: $completedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ReminderCopyWith<$Res> implements $ReminderCopyWith<$Res> {
  factory _$ReminderCopyWith(_Reminder value, $Res Function(_Reminder) _then) = __$ReminderCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'application_id') String? applicationId,@JsonKey(name: 'application') ReminderApplicationSummary? application, String title, String? description,@JsonKey(name: 'reminder_type') String reminderType, String status,@JsonKey(name: 'due_at') DateTime dueAt,@JsonKey(name: 'snoozed_until') DateTime? snoozedUntil,@JsonKey(name: 'completed_at') DateTime? completedAt,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});


@override $ReminderApplicationSummaryCopyWith<$Res>? get application;

}
/// @nodoc
class __$ReminderCopyWithImpl<$Res>
    implements _$ReminderCopyWith<$Res> {
  __$ReminderCopyWithImpl(this._self, this._then);

  final _Reminder _self;
  final $Res Function(_Reminder) _then;

/// Create a copy of Reminder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? applicationId = freezed,Object? application = freezed,Object? title = null,Object? description = freezed,Object? reminderType = null,Object? status = null,Object? dueAt = null,Object? snoozedUntil = freezed,Object? completedAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Reminder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,applicationId: freezed == applicationId ? _self.applicationId : applicationId // ignore: cast_nullable_to_non_nullable
as String?,application: freezed == application ? _self.application : application // ignore: cast_nullable_to_non_nullable
as ReminderApplicationSummary?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,reminderType: null == reminderType ? _self.reminderType : reminderType // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,dueAt: null == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime,snoozedUntil: freezed == snoozedUntil ? _self.snoozedUntil : snoozedUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of Reminder
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReminderApplicationSummaryCopyWith<$Res>? get application {
    if (_self.application == null) {
    return null;
  }

  return $ReminderApplicationSummaryCopyWith<$Res>(_self.application!, (value) {
    return _then(_self.copyWith(application: value));
  });
}
}


/// @nodoc
mixin _$ReminderApplicationSummary {

 String get id;@JsonKey(name: 'company_name') String get companyName;@JsonKey(name: 'job_title') String get jobTitle;
/// Create a copy of ReminderApplicationSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReminderApplicationSummaryCopyWith<ReminderApplicationSummary> get copyWith => _$ReminderApplicationSummaryCopyWithImpl<ReminderApplicationSummary>(this as ReminderApplicationSummary, _$identity);

  /// Serializes this ReminderApplicationSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReminderApplicationSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.jobTitle, jobTitle) || other.jobTitle == jobTitle));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,companyName,jobTitle);

@override
String toString() {
  return 'ReminderApplicationSummary(id: $id, companyName: $companyName, jobTitle: $jobTitle)';
}


}

/// @nodoc
abstract mixin class $ReminderApplicationSummaryCopyWith<$Res>  {
  factory $ReminderApplicationSummaryCopyWith(ReminderApplicationSummary value, $Res Function(ReminderApplicationSummary) _then) = _$ReminderApplicationSummaryCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'company_name') String companyName,@JsonKey(name: 'job_title') String jobTitle
});




}
/// @nodoc
class _$ReminderApplicationSummaryCopyWithImpl<$Res>
    implements $ReminderApplicationSummaryCopyWith<$Res> {
  _$ReminderApplicationSummaryCopyWithImpl(this._self, this._then);

  final ReminderApplicationSummary _self;
  final $Res Function(ReminderApplicationSummary) _then;

/// Create a copy of ReminderApplicationSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? companyName = null,Object? jobTitle = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,companyName: null == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String,jobTitle: null == jobTitle ? _self.jobTitle : jobTitle // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ReminderApplicationSummary].
extension ReminderApplicationSummaryPatterns on ReminderApplicationSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReminderApplicationSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReminderApplicationSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReminderApplicationSummary value)  $default,){
final _that = this;
switch (_that) {
case _ReminderApplicationSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReminderApplicationSummary value)?  $default,){
final _that = this;
switch (_that) {
case _ReminderApplicationSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'company_name')  String companyName, @JsonKey(name: 'job_title')  String jobTitle)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReminderApplicationSummary() when $default != null:
return $default(_that.id,_that.companyName,_that.jobTitle);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'company_name')  String companyName, @JsonKey(name: 'job_title')  String jobTitle)  $default,) {final _that = this;
switch (_that) {
case _ReminderApplicationSummary():
return $default(_that.id,_that.companyName,_that.jobTitle);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'company_name')  String companyName, @JsonKey(name: 'job_title')  String jobTitle)?  $default,) {final _that = this;
switch (_that) {
case _ReminderApplicationSummary() when $default != null:
return $default(_that.id,_that.companyName,_that.jobTitle);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReminderApplicationSummary implements ReminderApplicationSummary {
  const _ReminderApplicationSummary({required this.id, @JsonKey(name: 'company_name') required this.companyName, @JsonKey(name: 'job_title') required this.jobTitle});
  factory _ReminderApplicationSummary.fromJson(Map<String, dynamic> json) => _$ReminderApplicationSummaryFromJson(json);

@override final  String id;
@override@JsonKey(name: 'company_name') final  String companyName;
@override@JsonKey(name: 'job_title') final  String jobTitle;

/// Create a copy of ReminderApplicationSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReminderApplicationSummaryCopyWith<_ReminderApplicationSummary> get copyWith => __$ReminderApplicationSummaryCopyWithImpl<_ReminderApplicationSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReminderApplicationSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReminderApplicationSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.jobTitle, jobTitle) || other.jobTitle == jobTitle));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,companyName,jobTitle);

@override
String toString() {
  return 'ReminderApplicationSummary(id: $id, companyName: $companyName, jobTitle: $jobTitle)';
}


}

/// @nodoc
abstract mixin class _$ReminderApplicationSummaryCopyWith<$Res> implements $ReminderApplicationSummaryCopyWith<$Res> {
  factory _$ReminderApplicationSummaryCopyWith(_ReminderApplicationSummary value, $Res Function(_ReminderApplicationSummary) _then) = __$ReminderApplicationSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'company_name') String companyName,@JsonKey(name: 'job_title') String jobTitle
});




}
/// @nodoc
class __$ReminderApplicationSummaryCopyWithImpl<$Res>
    implements _$ReminderApplicationSummaryCopyWith<$Res> {
  __$ReminderApplicationSummaryCopyWithImpl(this._self, this._then);

  final _ReminderApplicationSummary _self;
  final $Res Function(_ReminderApplicationSummary) _then;

/// Create a copy of ReminderApplicationSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? companyName = null,Object? jobTitle = null,}) {
  return _then(_ReminderApplicationSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,companyName: null == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String,jobTitle: null == jobTitle ? _self.jobTitle : jobTitle // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CreateReminderRequest {

@JsonKey(name: 'application_id') String? get applicationId; String get title; String? get description;@JsonKey(name: 'reminder_type') String get reminderType;@JsonKey(name: 'due_at') DateTime get dueAt;
/// Create a copy of CreateReminderRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateReminderRequestCopyWith<CreateReminderRequest> get copyWith => _$CreateReminderRequestCopyWithImpl<CreateReminderRequest>(this as CreateReminderRequest, _$identity);

  /// Serializes this CreateReminderRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateReminderRequest&&(identical(other.applicationId, applicationId) || other.applicationId == applicationId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.reminderType, reminderType) || other.reminderType == reminderType)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,applicationId,title,description,reminderType,dueAt);

@override
String toString() {
  return 'CreateReminderRequest(applicationId: $applicationId, title: $title, description: $description, reminderType: $reminderType, dueAt: $dueAt)';
}


}

/// @nodoc
abstract mixin class $CreateReminderRequestCopyWith<$Res>  {
  factory $CreateReminderRequestCopyWith(CreateReminderRequest value, $Res Function(CreateReminderRequest) _then) = _$CreateReminderRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'application_id') String? applicationId, String title, String? description,@JsonKey(name: 'reminder_type') String reminderType,@JsonKey(name: 'due_at') DateTime dueAt
});




}
/// @nodoc
class _$CreateReminderRequestCopyWithImpl<$Res>
    implements $CreateReminderRequestCopyWith<$Res> {
  _$CreateReminderRequestCopyWithImpl(this._self, this._then);

  final CreateReminderRequest _self;
  final $Res Function(CreateReminderRequest) _then;

/// Create a copy of CreateReminderRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? applicationId = freezed,Object? title = null,Object? description = freezed,Object? reminderType = null,Object? dueAt = null,}) {
  return _then(_self.copyWith(
applicationId: freezed == applicationId ? _self.applicationId : applicationId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,reminderType: null == reminderType ? _self.reminderType : reminderType // ignore: cast_nullable_to_non_nullable
as String,dueAt: null == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateReminderRequest].
extension CreateReminderRequestPatterns on CreateReminderRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateReminderRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateReminderRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateReminderRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateReminderRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateReminderRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateReminderRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'application_id')  String? applicationId,  String title,  String? description, @JsonKey(name: 'reminder_type')  String reminderType, @JsonKey(name: 'due_at')  DateTime dueAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateReminderRequest() when $default != null:
return $default(_that.applicationId,_that.title,_that.description,_that.reminderType,_that.dueAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'application_id')  String? applicationId,  String title,  String? description, @JsonKey(name: 'reminder_type')  String reminderType, @JsonKey(name: 'due_at')  DateTime dueAt)  $default,) {final _that = this;
switch (_that) {
case _CreateReminderRequest():
return $default(_that.applicationId,_that.title,_that.description,_that.reminderType,_that.dueAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'application_id')  String? applicationId,  String title,  String? description, @JsonKey(name: 'reminder_type')  String reminderType, @JsonKey(name: 'due_at')  DateTime dueAt)?  $default,) {final _that = this;
switch (_that) {
case _CreateReminderRequest() when $default != null:
return $default(_that.applicationId,_that.title,_that.description,_that.reminderType,_that.dueAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateReminderRequest implements CreateReminderRequest {
  const _CreateReminderRequest({@JsonKey(name: 'application_id') this.applicationId, required this.title, this.description, @JsonKey(name: 'reminder_type') required this.reminderType, @JsonKey(name: 'due_at') required this.dueAt});
  factory _CreateReminderRequest.fromJson(Map<String, dynamic> json) => _$CreateReminderRequestFromJson(json);

@override@JsonKey(name: 'application_id') final  String? applicationId;
@override final  String title;
@override final  String? description;
@override@JsonKey(name: 'reminder_type') final  String reminderType;
@override@JsonKey(name: 'due_at') final  DateTime dueAt;

/// Create a copy of CreateReminderRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateReminderRequestCopyWith<_CreateReminderRequest> get copyWith => __$CreateReminderRequestCopyWithImpl<_CreateReminderRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateReminderRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateReminderRequest&&(identical(other.applicationId, applicationId) || other.applicationId == applicationId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.reminderType, reminderType) || other.reminderType == reminderType)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,applicationId,title,description,reminderType,dueAt);

@override
String toString() {
  return 'CreateReminderRequest(applicationId: $applicationId, title: $title, description: $description, reminderType: $reminderType, dueAt: $dueAt)';
}


}

/// @nodoc
abstract mixin class _$CreateReminderRequestCopyWith<$Res> implements $CreateReminderRequestCopyWith<$Res> {
  factory _$CreateReminderRequestCopyWith(_CreateReminderRequest value, $Res Function(_CreateReminderRequest) _then) = __$CreateReminderRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'application_id') String? applicationId, String title, String? description,@JsonKey(name: 'reminder_type') String reminderType,@JsonKey(name: 'due_at') DateTime dueAt
});




}
/// @nodoc
class __$CreateReminderRequestCopyWithImpl<$Res>
    implements _$CreateReminderRequestCopyWith<$Res> {
  __$CreateReminderRequestCopyWithImpl(this._self, this._then);

  final _CreateReminderRequest _self;
  final $Res Function(_CreateReminderRequest) _then;

/// Create a copy of CreateReminderRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? applicationId = freezed,Object? title = null,Object? description = freezed,Object? reminderType = null,Object? dueAt = null,}) {
  return _then(_CreateReminderRequest(
applicationId: freezed == applicationId ? _self.applicationId : applicationId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,reminderType: null == reminderType ? _self.reminderType : reminderType // ignore: cast_nullable_to_non_nullable
as String,dueAt: null == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$UpdateReminderRequest {

 String? get title; String? get description;@JsonKey(name: 'reminder_type') String? get reminderType;@JsonKey(name: 'due_at') DateTime? get dueAt; String? get status;
/// Create a copy of UpdateReminderRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateReminderRequestCopyWith<UpdateReminderRequest> get copyWith => _$UpdateReminderRequestCopyWithImpl<UpdateReminderRequest>(this as UpdateReminderRequest, _$identity);

  /// Serializes this UpdateReminderRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateReminderRequest&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.reminderType, reminderType) || other.reminderType == reminderType)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,reminderType,dueAt,status);

@override
String toString() {
  return 'UpdateReminderRequest(title: $title, description: $description, reminderType: $reminderType, dueAt: $dueAt, status: $status)';
}


}

/// @nodoc
abstract mixin class $UpdateReminderRequestCopyWith<$Res>  {
  factory $UpdateReminderRequestCopyWith(UpdateReminderRequest value, $Res Function(UpdateReminderRequest) _then) = _$UpdateReminderRequestCopyWithImpl;
@useResult
$Res call({
 String? title, String? description,@JsonKey(name: 'reminder_type') String? reminderType,@JsonKey(name: 'due_at') DateTime? dueAt, String? status
});




}
/// @nodoc
class _$UpdateReminderRequestCopyWithImpl<$Res>
    implements $UpdateReminderRequestCopyWith<$Res> {
  _$UpdateReminderRequestCopyWithImpl(this._self, this._then);

  final UpdateReminderRequest _self;
  final $Res Function(UpdateReminderRequest) _then;

/// Create a copy of UpdateReminderRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = freezed,Object? description = freezed,Object? reminderType = freezed,Object? dueAt = freezed,Object? status = freezed,}) {
  return _then(_self.copyWith(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,reminderType: freezed == reminderType ? _self.reminderType : reminderType // ignore: cast_nullable_to_non_nullable
as String?,dueAt: freezed == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateReminderRequest].
extension UpdateReminderRequestPatterns on UpdateReminderRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateReminderRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateReminderRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateReminderRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateReminderRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateReminderRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateReminderRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? title,  String? description, @JsonKey(name: 'reminder_type')  String? reminderType, @JsonKey(name: 'due_at')  DateTime? dueAt,  String? status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateReminderRequest() when $default != null:
return $default(_that.title,_that.description,_that.reminderType,_that.dueAt,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? title,  String? description, @JsonKey(name: 'reminder_type')  String? reminderType, @JsonKey(name: 'due_at')  DateTime? dueAt,  String? status)  $default,) {final _that = this;
switch (_that) {
case _UpdateReminderRequest():
return $default(_that.title,_that.description,_that.reminderType,_that.dueAt,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? title,  String? description, @JsonKey(name: 'reminder_type')  String? reminderType, @JsonKey(name: 'due_at')  DateTime? dueAt,  String? status)?  $default,) {final _that = this;
switch (_that) {
case _UpdateReminderRequest() when $default != null:
return $default(_that.title,_that.description,_that.reminderType,_that.dueAt,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateReminderRequest implements UpdateReminderRequest {
  const _UpdateReminderRequest({this.title, this.description, @JsonKey(name: 'reminder_type') this.reminderType, @JsonKey(name: 'due_at') this.dueAt, this.status});
  factory _UpdateReminderRequest.fromJson(Map<String, dynamic> json) => _$UpdateReminderRequestFromJson(json);

@override final  String? title;
@override final  String? description;
@override@JsonKey(name: 'reminder_type') final  String? reminderType;
@override@JsonKey(name: 'due_at') final  DateTime? dueAt;
@override final  String? status;

/// Create a copy of UpdateReminderRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateReminderRequestCopyWith<_UpdateReminderRequest> get copyWith => __$UpdateReminderRequestCopyWithImpl<_UpdateReminderRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateReminderRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateReminderRequest&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.reminderType, reminderType) || other.reminderType == reminderType)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,reminderType,dueAt,status);

@override
String toString() {
  return 'UpdateReminderRequest(title: $title, description: $description, reminderType: $reminderType, dueAt: $dueAt, status: $status)';
}


}

/// @nodoc
abstract mixin class _$UpdateReminderRequestCopyWith<$Res> implements $UpdateReminderRequestCopyWith<$Res> {
  factory _$UpdateReminderRequestCopyWith(_UpdateReminderRequest value, $Res Function(_UpdateReminderRequest) _then) = __$UpdateReminderRequestCopyWithImpl;
@override @useResult
$Res call({
 String? title, String? description,@JsonKey(name: 'reminder_type') String? reminderType,@JsonKey(name: 'due_at') DateTime? dueAt, String? status
});




}
/// @nodoc
class __$UpdateReminderRequestCopyWithImpl<$Res>
    implements _$UpdateReminderRequestCopyWith<$Res> {
  __$UpdateReminderRequestCopyWithImpl(this._self, this._then);

  final _UpdateReminderRequest _self;
  final $Res Function(_UpdateReminderRequest) _then;

/// Create a copy of UpdateReminderRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = freezed,Object? description = freezed,Object? reminderType = freezed,Object? dueAt = freezed,Object? status = freezed,}) {
  return _then(_UpdateReminderRequest(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,reminderType: freezed == reminderType ? _self.reminderType : reminderType // ignore: cast_nullable_to_non_nullable
as String?,dueAt: freezed == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$SnoozeReminderRequest {

@JsonKey(name: 'snooze_until') DateTime get snoozeUntil;
/// Create a copy of SnoozeReminderRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SnoozeReminderRequestCopyWith<SnoozeReminderRequest> get copyWith => _$SnoozeReminderRequestCopyWithImpl<SnoozeReminderRequest>(this as SnoozeReminderRequest, _$identity);

  /// Serializes this SnoozeReminderRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SnoozeReminderRequest&&(identical(other.snoozeUntil, snoozeUntil) || other.snoozeUntil == snoozeUntil));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,snoozeUntil);

@override
String toString() {
  return 'SnoozeReminderRequest(snoozeUntil: $snoozeUntil)';
}


}

/// @nodoc
abstract mixin class $SnoozeReminderRequestCopyWith<$Res>  {
  factory $SnoozeReminderRequestCopyWith(SnoozeReminderRequest value, $Res Function(SnoozeReminderRequest) _then) = _$SnoozeReminderRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'snooze_until') DateTime snoozeUntil
});




}
/// @nodoc
class _$SnoozeReminderRequestCopyWithImpl<$Res>
    implements $SnoozeReminderRequestCopyWith<$Res> {
  _$SnoozeReminderRequestCopyWithImpl(this._self, this._then);

  final SnoozeReminderRequest _self;
  final $Res Function(SnoozeReminderRequest) _then;

/// Create a copy of SnoozeReminderRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? snoozeUntil = null,}) {
  return _then(_self.copyWith(
snoozeUntil: null == snoozeUntil ? _self.snoozeUntil : snoozeUntil // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SnoozeReminderRequest].
extension SnoozeReminderRequestPatterns on SnoozeReminderRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SnoozeReminderRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SnoozeReminderRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SnoozeReminderRequest value)  $default,){
final _that = this;
switch (_that) {
case _SnoozeReminderRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SnoozeReminderRequest value)?  $default,){
final _that = this;
switch (_that) {
case _SnoozeReminderRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'snooze_until')  DateTime snoozeUntil)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SnoozeReminderRequest() when $default != null:
return $default(_that.snoozeUntil);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'snooze_until')  DateTime snoozeUntil)  $default,) {final _that = this;
switch (_that) {
case _SnoozeReminderRequest():
return $default(_that.snoozeUntil);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'snooze_until')  DateTime snoozeUntil)?  $default,) {final _that = this;
switch (_that) {
case _SnoozeReminderRequest() when $default != null:
return $default(_that.snoozeUntil);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SnoozeReminderRequest implements SnoozeReminderRequest {
  const _SnoozeReminderRequest({@JsonKey(name: 'snooze_until') required this.snoozeUntil});
  factory _SnoozeReminderRequest.fromJson(Map<String, dynamic> json) => _$SnoozeReminderRequestFromJson(json);

@override@JsonKey(name: 'snooze_until') final  DateTime snoozeUntil;

/// Create a copy of SnoozeReminderRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SnoozeReminderRequestCopyWith<_SnoozeReminderRequest> get copyWith => __$SnoozeReminderRequestCopyWithImpl<_SnoozeReminderRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SnoozeReminderRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SnoozeReminderRequest&&(identical(other.snoozeUntil, snoozeUntil) || other.snoozeUntil == snoozeUntil));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,snoozeUntil);

@override
String toString() {
  return 'SnoozeReminderRequest(snoozeUntil: $snoozeUntil)';
}


}

/// @nodoc
abstract mixin class _$SnoozeReminderRequestCopyWith<$Res> implements $SnoozeReminderRequestCopyWith<$Res> {
  factory _$SnoozeReminderRequestCopyWith(_SnoozeReminderRequest value, $Res Function(_SnoozeReminderRequest) _then) = __$SnoozeReminderRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'snooze_until') DateTime snoozeUntil
});




}
/// @nodoc
class __$SnoozeReminderRequestCopyWithImpl<$Res>
    implements _$SnoozeReminderRequestCopyWith<$Res> {
  __$SnoozeReminderRequestCopyWithImpl(this._self, this._then);

  final _SnoozeReminderRequest _self;
  final $Res Function(_SnoozeReminderRequest) _then;

/// Create a copy of SnoozeReminderRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? snoozeUntil = null,}) {
  return _then(_SnoozeReminderRequest(
snoozeUntil: null == snoozeUntil ? _self.snoozeUntil : snoozeUntil // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$ReminderListResponse {

 int get count; String? get next; String? get previous; List<Reminder> get results;
/// Create a copy of ReminderListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReminderListResponseCopyWith<ReminderListResponse> get copyWith => _$ReminderListResponseCopyWithImpl<ReminderListResponse>(this as ReminderListResponse, _$identity);

  /// Serializes this ReminderListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReminderListResponse&&(identical(other.count, count) || other.count == count)&&(identical(other.next, next) || other.next == next)&&(identical(other.previous, previous) || other.previous == previous)&&const DeepCollectionEquality().equals(other.results, results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,next,previous,const DeepCollectionEquality().hash(results));

@override
String toString() {
  return 'ReminderListResponse(count: $count, next: $next, previous: $previous, results: $results)';
}


}

/// @nodoc
abstract mixin class $ReminderListResponseCopyWith<$Res>  {
  factory $ReminderListResponseCopyWith(ReminderListResponse value, $Res Function(ReminderListResponse) _then) = _$ReminderListResponseCopyWithImpl;
@useResult
$Res call({
 int count, String? next, String? previous, List<Reminder> results
});




}
/// @nodoc
class _$ReminderListResponseCopyWithImpl<$Res>
    implements $ReminderListResponseCopyWith<$Res> {
  _$ReminderListResponseCopyWithImpl(this._self, this._then);

  final ReminderListResponse _self;
  final $Res Function(ReminderListResponse) _then;

/// Create a copy of ReminderListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? count = null,Object? next = freezed,Object? previous = freezed,Object? results = null,}) {
  return _then(_self.copyWith(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,next: freezed == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as String?,previous: freezed == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as String?,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<Reminder>,
  ));
}

}


/// Adds pattern-matching-related methods to [ReminderListResponse].
extension ReminderListResponsePatterns on ReminderListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReminderListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReminderListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReminderListResponse value)  $default,){
final _that = this;
switch (_that) {
case _ReminderListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReminderListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ReminderListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int count,  String? next,  String? previous,  List<Reminder> results)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReminderListResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int count,  String? next,  String? previous,  List<Reminder> results)  $default,) {final _that = this;
switch (_that) {
case _ReminderListResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int count,  String? next,  String? previous,  List<Reminder> results)?  $default,) {final _that = this;
switch (_that) {
case _ReminderListResponse() when $default != null:
return $default(_that.count,_that.next,_that.previous,_that.results);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReminderListResponse implements ReminderListResponse {
  const _ReminderListResponse({required this.count, this.next, this.previous, required final  List<Reminder> results}): _results = results;
  factory _ReminderListResponse.fromJson(Map<String, dynamic> json) => _$ReminderListResponseFromJson(json);

@override final  int count;
@override final  String? next;
@override final  String? previous;
 final  List<Reminder> _results;
@override List<Reminder> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}


/// Create a copy of ReminderListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReminderListResponseCopyWith<_ReminderListResponse> get copyWith => __$ReminderListResponseCopyWithImpl<_ReminderListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReminderListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReminderListResponse&&(identical(other.count, count) || other.count == count)&&(identical(other.next, next) || other.next == next)&&(identical(other.previous, previous) || other.previous == previous)&&const DeepCollectionEquality().equals(other._results, _results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,next,previous,const DeepCollectionEquality().hash(_results));

@override
String toString() {
  return 'ReminderListResponse(count: $count, next: $next, previous: $previous, results: $results)';
}


}

/// @nodoc
abstract mixin class _$ReminderListResponseCopyWith<$Res> implements $ReminderListResponseCopyWith<$Res> {
  factory _$ReminderListResponseCopyWith(_ReminderListResponse value, $Res Function(_ReminderListResponse) _then) = __$ReminderListResponseCopyWithImpl;
@override @useResult
$Res call({
 int count, String? next, String? previous, List<Reminder> results
});




}
/// @nodoc
class __$ReminderListResponseCopyWithImpl<$Res>
    implements _$ReminderListResponseCopyWith<$Res> {
  __$ReminderListResponseCopyWithImpl(this._self, this._then);

  final _ReminderListResponse _self;
  final $Res Function(_ReminderListResponse) _then;

/// Create a copy of ReminderListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? count = null,Object? next = freezed,Object? previous = freezed,Object? results = null,}) {
  return _then(_ReminderListResponse(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,next: freezed == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as String?,previous: freezed == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as String?,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<Reminder>,
  ));
}


}

// dart format on
