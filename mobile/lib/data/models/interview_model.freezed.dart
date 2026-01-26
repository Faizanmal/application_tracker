// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'interview_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Interview {

 String get id;@JsonKey(name: 'application_id') String get applicationId;@JsonKey(name: 'application') ApplicationSummary? get application;@JsonKey(name: 'interview_type') String get interviewType; String get status;@JsonKey(name: 'scheduled_at') DateTime get scheduledAt;@JsonKey(name: 'duration_minutes') int? get durationMinutes; String? get location;@JsonKey(name: 'meeting_link') String? get meetingLink;@JsonKey(name: 'interviewer_names') String? get interviewerNames; String? get notes;@JsonKey(name: 'preparation_notes') String? get preparationNotes; int? get rating; String? get feedback;@JsonKey(name: 'send_calendar_invite') bool get sendCalendarInvite;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;
/// Create a copy of Interview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InterviewCopyWith<Interview> get copyWith => _$InterviewCopyWithImpl<Interview>(this as Interview, _$identity);

  /// Serializes this Interview to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Interview&&(identical(other.id, id) || other.id == id)&&(identical(other.applicationId, applicationId) || other.applicationId == applicationId)&&(identical(other.application, application) || other.application == application)&&(identical(other.interviewType, interviewType) || other.interviewType == interviewType)&&(identical(other.status, status) || other.status == status)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.location, location) || other.location == location)&&(identical(other.meetingLink, meetingLink) || other.meetingLink == meetingLink)&&(identical(other.interviewerNames, interviewerNames) || other.interviewerNames == interviewerNames)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.preparationNotes, preparationNotes) || other.preparationNotes == preparationNotes)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.feedback, feedback) || other.feedback == feedback)&&(identical(other.sendCalendarInvite, sendCalendarInvite) || other.sendCalendarInvite == sendCalendarInvite)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,applicationId,application,interviewType,status,scheduledAt,durationMinutes,location,meetingLink,interviewerNames,notes,preparationNotes,rating,feedback,sendCalendarInvite,createdAt,updatedAt);

@override
String toString() {
  return 'Interview(id: $id, applicationId: $applicationId, application: $application, interviewType: $interviewType, status: $status, scheduledAt: $scheduledAt, durationMinutes: $durationMinutes, location: $location, meetingLink: $meetingLink, interviewerNames: $interviewerNames, notes: $notes, preparationNotes: $preparationNotes, rating: $rating, feedback: $feedback, sendCalendarInvite: $sendCalendarInvite, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $InterviewCopyWith<$Res>  {
  factory $InterviewCopyWith(Interview value, $Res Function(Interview) _then) = _$InterviewCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'application_id') String applicationId,@JsonKey(name: 'application') ApplicationSummary? application,@JsonKey(name: 'interview_type') String interviewType, String status,@JsonKey(name: 'scheduled_at') DateTime scheduledAt,@JsonKey(name: 'duration_minutes') int? durationMinutes, String? location,@JsonKey(name: 'meeting_link') String? meetingLink,@JsonKey(name: 'interviewer_names') String? interviewerNames, String? notes,@JsonKey(name: 'preparation_notes') String? preparationNotes, int? rating, String? feedback,@JsonKey(name: 'send_calendar_invite') bool sendCalendarInvite,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});


$ApplicationSummaryCopyWith<$Res>? get application;

}
/// @nodoc
class _$InterviewCopyWithImpl<$Res>
    implements $InterviewCopyWith<$Res> {
  _$InterviewCopyWithImpl(this._self, this._then);

  final Interview _self;
  final $Res Function(Interview) _then;

/// Create a copy of Interview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? applicationId = null,Object? application = freezed,Object? interviewType = null,Object? status = null,Object? scheduledAt = null,Object? durationMinutes = freezed,Object? location = freezed,Object? meetingLink = freezed,Object? interviewerNames = freezed,Object? notes = freezed,Object? preparationNotes = freezed,Object? rating = freezed,Object? feedback = freezed,Object? sendCalendarInvite = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,applicationId: null == applicationId ? _self.applicationId : applicationId // ignore: cast_nullable_to_non_nullable
as String,application: freezed == application ? _self.application : application // ignore: cast_nullable_to_non_nullable
as ApplicationSummary?,interviewType: null == interviewType ? _self.interviewType : interviewType // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,scheduledAt: null == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime,durationMinutes: freezed == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,meetingLink: freezed == meetingLink ? _self.meetingLink : meetingLink // ignore: cast_nullable_to_non_nullable
as String?,interviewerNames: freezed == interviewerNames ? _self.interviewerNames : interviewerNames // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,preparationNotes: freezed == preparationNotes ? _self.preparationNotes : preparationNotes // ignore: cast_nullable_to_non_nullable
as String?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int?,feedback: freezed == feedback ? _self.feedback : feedback // ignore: cast_nullable_to_non_nullable
as String?,sendCalendarInvite: null == sendCalendarInvite ? _self.sendCalendarInvite : sendCalendarInvite // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of Interview
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApplicationSummaryCopyWith<$Res>? get application {
    if (_self.application == null) {
    return null;
  }

  return $ApplicationSummaryCopyWith<$Res>(_self.application!, (value) {
    return _then(_self.copyWith(application: value));
  });
}
}


/// Adds pattern-matching-related methods to [Interview].
extension InterviewPatterns on Interview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Interview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Interview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Interview value)  $default,){
final _that = this;
switch (_that) {
case _Interview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Interview value)?  $default,){
final _that = this;
switch (_that) {
case _Interview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'application_id')  String applicationId, @JsonKey(name: 'application')  ApplicationSummary? application, @JsonKey(name: 'interview_type')  String interviewType,  String status, @JsonKey(name: 'scheduled_at')  DateTime scheduledAt, @JsonKey(name: 'duration_minutes')  int? durationMinutes,  String? location, @JsonKey(name: 'meeting_link')  String? meetingLink, @JsonKey(name: 'interviewer_names')  String? interviewerNames,  String? notes, @JsonKey(name: 'preparation_notes')  String? preparationNotes,  int? rating,  String? feedback, @JsonKey(name: 'send_calendar_invite')  bool sendCalendarInvite, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Interview() when $default != null:
return $default(_that.id,_that.applicationId,_that.application,_that.interviewType,_that.status,_that.scheduledAt,_that.durationMinutes,_that.location,_that.meetingLink,_that.interviewerNames,_that.notes,_that.preparationNotes,_that.rating,_that.feedback,_that.sendCalendarInvite,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'application_id')  String applicationId, @JsonKey(name: 'application')  ApplicationSummary? application, @JsonKey(name: 'interview_type')  String interviewType,  String status, @JsonKey(name: 'scheduled_at')  DateTime scheduledAt, @JsonKey(name: 'duration_minutes')  int? durationMinutes,  String? location, @JsonKey(name: 'meeting_link')  String? meetingLink, @JsonKey(name: 'interviewer_names')  String? interviewerNames,  String? notes, @JsonKey(name: 'preparation_notes')  String? preparationNotes,  int? rating,  String? feedback, @JsonKey(name: 'send_calendar_invite')  bool sendCalendarInvite, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Interview():
return $default(_that.id,_that.applicationId,_that.application,_that.interviewType,_that.status,_that.scheduledAt,_that.durationMinutes,_that.location,_that.meetingLink,_that.interviewerNames,_that.notes,_that.preparationNotes,_that.rating,_that.feedback,_that.sendCalendarInvite,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'application_id')  String applicationId, @JsonKey(name: 'application')  ApplicationSummary? application, @JsonKey(name: 'interview_type')  String interviewType,  String status, @JsonKey(name: 'scheduled_at')  DateTime scheduledAt, @JsonKey(name: 'duration_minutes')  int? durationMinutes,  String? location, @JsonKey(name: 'meeting_link')  String? meetingLink, @JsonKey(name: 'interviewer_names')  String? interviewerNames,  String? notes, @JsonKey(name: 'preparation_notes')  String? preparationNotes,  int? rating,  String? feedback, @JsonKey(name: 'send_calendar_invite')  bool sendCalendarInvite, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Interview() when $default != null:
return $default(_that.id,_that.applicationId,_that.application,_that.interviewType,_that.status,_that.scheduledAt,_that.durationMinutes,_that.location,_that.meetingLink,_that.interviewerNames,_that.notes,_that.preparationNotes,_that.rating,_that.feedback,_that.sendCalendarInvite,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Interview implements Interview {
  const _Interview({required this.id, @JsonKey(name: 'application_id') required this.applicationId, @JsonKey(name: 'application') this.application, @JsonKey(name: 'interview_type') required this.interviewType, required this.status, @JsonKey(name: 'scheduled_at') required this.scheduledAt, @JsonKey(name: 'duration_minutes') this.durationMinutes, this.location, @JsonKey(name: 'meeting_link') this.meetingLink, @JsonKey(name: 'interviewer_names') this.interviewerNames, this.notes, @JsonKey(name: 'preparation_notes') this.preparationNotes, this.rating, this.feedback, @JsonKey(name: 'send_calendar_invite') this.sendCalendarInvite = false, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt});
  factory _Interview.fromJson(Map<String, dynamic> json) => _$InterviewFromJson(json);

@override final  String id;
@override@JsonKey(name: 'application_id') final  String applicationId;
@override@JsonKey(name: 'application') final  ApplicationSummary? application;
@override@JsonKey(name: 'interview_type') final  String interviewType;
@override final  String status;
@override@JsonKey(name: 'scheduled_at') final  DateTime scheduledAt;
@override@JsonKey(name: 'duration_minutes') final  int? durationMinutes;
@override final  String? location;
@override@JsonKey(name: 'meeting_link') final  String? meetingLink;
@override@JsonKey(name: 'interviewer_names') final  String? interviewerNames;
@override final  String? notes;
@override@JsonKey(name: 'preparation_notes') final  String? preparationNotes;
@override final  int? rating;
@override final  String? feedback;
@override@JsonKey(name: 'send_calendar_invite') final  bool sendCalendarInvite;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;

/// Create a copy of Interview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InterviewCopyWith<_Interview> get copyWith => __$InterviewCopyWithImpl<_Interview>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InterviewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Interview&&(identical(other.id, id) || other.id == id)&&(identical(other.applicationId, applicationId) || other.applicationId == applicationId)&&(identical(other.application, application) || other.application == application)&&(identical(other.interviewType, interviewType) || other.interviewType == interviewType)&&(identical(other.status, status) || other.status == status)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.location, location) || other.location == location)&&(identical(other.meetingLink, meetingLink) || other.meetingLink == meetingLink)&&(identical(other.interviewerNames, interviewerNames) || other.interviewerNames == interviewerNames)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.preparationNotes, preparationNotes) || other.preparationNotes == preparationNotes)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.feedback, feedback) || other.feedback == feedback)&&(identical(other.sendCalendarInvite, sendCalendarInvite) || other.sendCalendarInvite == sendCalendarInvite)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,applicationId,application,interviewType,status,scheduledAt,durationMinutes,location,meetingLink,interviewerNames,notes,preparationNotes,rating,feedback,sendCalendarInvite,createdAt,updatedAt);

@override
String toString() {
  return 'Interview(id: $id, applicationId: $applicationId, application: $application, interviewType: $interviewType, status: $status, scheduledAt: $scheduledAt, durationMinutes: $durationMinutes, location: $location, meetingLink: $meetingLink, interviewerNames: $interviewerNames, notes: $notes, preparationNotes: $preparationNotes, rating: $rating, feedback: $feedback, sendCalendarInvite: $sendCalendarInvite, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$InterviewCopyWith<$Res> implements $InterviewCopyWith<$Res> {
  factory _$InterviewCopyWith(_Interview value, $Res Function(_Interview) _then) = __$InterviewCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'application_id') String applicationId,@JsonKey(name: 'application') ApplicationSummary? application,@JsonKey(name: 'interview_type') String interviewType, String status,@JsonKey(name: 'scheduled_at') DateTime scheduledAt,@JsonKey(name: 'duration_minutes') int? durationMinutes, String? location,@JsonKey(name: 'meeting_link') String? meetingLink,@JsonKey(name: 'interviewer_names') String? interviewerNames, String? notes,@JsonKey(name: 'preparation_notes') String? preparationNotes, int? rating, String? feedback,@JsonKey(name: 'send_calendar_invite') bool sendCalendarInvite,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});


@override $ApplicationSummaryCopyWith<$Res>? get application;

}
/// @nodoc
class __$InterviewCopyWithImpl<$Res>
    implements _$InterviewCopyWith<$Res> {
  __$InterviewCopyWithImpl(this._self, this._then);

  final _Interview _self;
  final $Res Function(_Interview) _then;

/// Create a copy of Interview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? applicationId = null,Object? application = freezed,Object? interviewType = null,Object? status = null,Object? scheduledAt = null,Object? durationMinutes = freezed,Object? location = freezed,Object? meetingLink = freezed,Object? interviewerNames = freezed,Object? notes = freezed,Object? preparationNotes = freezed,Object? rating = freezed,Object? feedback = freezed,Object? sendCalendarInvite = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Interview(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,applicationId: null == applicationId ? _self.applicationId : applicationId // ignore: cast_nullable_to_non_nullable
as String,application: freezed == application ? _self.application : application // ignore: cast_nullable_to_non_nullable
as ApplicationSummary?,interviewType: null == interviewType ? _self.interviewType : interviewType // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,scheduledAt: null == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime,durationMinutes: freezed == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,meetingLink: freezed == meetingLink ? _self.meetingLink : meetingLink // ignore: cast_nullable_to_non_nullable
as String?,interviewerNames: freezed == interviewerNames ? _self.interviewerNames : interviewerNames // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,preparationNotes: freezed == preparationNotes ? _self.preparationNotes : preparationNotes // ignore: cast_nullable_to_non_nullable
as String?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int?,feedback: freezed == feedback ? _self.feedback : feedback // ignore: cast_nullable_to_non_nullable
as String?,sendCalendarInvite: null == sendCalendarInvite ? _self.sendCalendarInvite : sendCalendarInvite // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of Interview
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApplicationSummaryCopyWith<$Res>? get application {
    if (_self.application == null) {
    return null;
  }

  return $ApplicationSummaryCopyWith<$Res>(_self.application!, (value) {
    return _then(_self.copyWith(application: value));
  });
}
}


/// @nodoc
mixin _$ApplicationSummary {

 String get id;@JsonKey(name: 'company_name') String get companyName;@JsonKey(name: 'job_title') String get jobTitle;@JsonKey(name: 'company_logo') String? get companyLogo;
/// Create a copy of ApplicationSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApplicationSummaryCopyWith<ApplicationSummary> get copyWith => _$ApplicationSummaryCopyWithImpl<ApplicationSummary>(this as ApplicationSummary, _$identity);

  /// Serializes this ApplicationSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApplicationSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.jobTitle, jobTitle) || other.jobTitle == jobTitle)&&(identical(other.companyLogo, companyLogo) || other.companyLogo == companyLogo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,companyName,jobTitle,companyLogo);

@override
String toString() {
  return 'ApplicationSummary(id: $id, companyName: $companyName, jobTitle: $jobTitle, companyLogo: $companyLogo)';
}


}

/// @nodoc
abstract mixin class $ApplicationSummaryCopyWith<$Res>  {
  factory $ApplicationSummaryCopyWith(ApplicationSummary value, $Res Function(ApplicationSummary) _then) = _$ApplicationSummaryCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'company_name') String companyName,@JsonKey(name: 'job_title') String jobTitle,@JsonKey(name: 'company_logo') String? companyLogo
});




}
/// @nodoc
class _$ApplicationSummaryCopyWithImpl<$Res>
    implements $ApplicationSummaryCopyWith<$Res> {
  _$ApplicationSummaryCopyWithImpl(this._self, this._then);

  final ApplicationSummary _self;
  final $Res Function(ApplicationSummary) _then;

/// Create a copy of ApplicationSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? companyName = null,Object? jobTitle = null,Object? companyLogo = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,companyName: null == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String,jobTitle: null == jobTitle ? _self.jobTitle : jobTitle // ignore: cast_nullable_to_non_nullable
as String,companyLogo: freezed == companyLogo ? _self.companyLogo : companyLogo // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ApplicationSummary].
extension ApplicationSummaryPatterns on ApplicationSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApplicationSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApplicationSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApplicationSummary value)  $default,){
final _that = this;
switch (_that) {
case _ApplicationSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApplicationSummary value)?  $default,){
final _that = this;
switch (_that) {
case _ApplicationSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'company_name')  String companyName, @JsonKey(name: 'job_title')  String jobTitle, @JsonKey(name: 'company_logo')  String? companyLogo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApplicationSummary() when $default != null:
return $default(_that.id,_that.companyName,_that.jobTitle,_that.companyLogo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'company_name')  String companyName, @JsonKey(name: 'job_title')  String jobTitle, @JsonKey(name: 'company_logo')  String? companyLogo)  $default,) {final _that = this;
switch (_that) {
case _ApplicationSummary():
return $default(_that.id,_that.companyName,_that.jobTitle,_that.companyLogo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'company_name')  String companyName, @JsonKey(name: 'job_title')  String jobTitle, @JsonKey(name: 'company_logo')  String? companyLogo)?  $default,) {final _that = this;
switch (_that) {
case _ApplicationSummary() when $default != null:
return $default(_that.id,_that.companyName,_that.jobTitle,_that.companyLogo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApplicationSummary implements ApplicationSummary {
  const _ApplicationSummary({required this.id, @JsonKey(name: 'company_name') required this.companyName, @JsonKey(name: 'job_title') required this.jobTitle, @JsonKey(name: 'company_logo') this.companyLogo});
  factory _ApplicationSummary.fromJson(Map<String, dynamic> json) => _$ApplicationSummaryFromJson(json);

@override final  String id;
@override@JsonKey(name: 'company_name') final  String companyName;
@override@JsonKey(name: 'job_title') final  String jobTitle;
@override@JsonKey(name: 'company_logo') final  String? companyLogo;

/// Create a copy of ApplicationSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApplicationSummaryCopyWith<_ApplicationSummary> get copyWith => __$ApplicationSummaryCopyWithImpl<_ApplicationSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApplicationSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApplicationSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.jobTitle, jobTitle) || other.jobTitle == jobTitle)&&(identical(other.companyLogo, companyLogo) || other.companyLogo == companyLogo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,companyName,jobTitle,companyLogo);

@override
String toString() {
  return 'ApplicationSummary(id: $id, companyName: $companyName, jobTitle: $jobTitle, companyLogo: $companyLogo)';
}


}

/// @nodoc
abstract mixin class _$ApplicationSummaryCopyWith<$Res> implements $ApplicationSummaryCopyWith<$Res> {
  factory _$ApplicationSummaryCopyWith(_ApplicationSummary value, $Res Function(_ApplicationSummary) _then) = __$ApplicationSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'company_name') String companyName,@JsonKey(name: 'job_title') String jobTitle,@JsonKey(name: 'company_logo') String? companyLogo
});




}
/// @nodoc
class __$ApplicationSummaryCopyWithImpl<$Res>
    implements _$ApplicationSummaryCopyWith<$Res> {
  __$ApplicationSummaryCopyWithImpl(this._self, this._then);

  final _ApplicationSummary _self;
  final $Res Function(_ApplicationSummary) _then;

/// Create a copy of ApplicationSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? companyName = null,Object? jobTitle = null,Object? companyLogo = freezed,}) {
  return _then(_ApplicationSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,companyName: null == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String,jobTitle: null == jobTitle ? _self.jobTitle : jobTitle // ignore: cast_nullable_to_non_nullable
as String,companyLogo: freezed == companyLogo ? _self.companyLogo : companyLogo // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CreateInterviewRequest {

@JsonKey(name: 'application_id') String get applicationId;@JsonKey(name: 'interview_type') String get interviewType;@JsonKey(name: 'scheduled_at') DateTime get scheduledAt;@JsonKey(name: 'duration_minutes') int? get durationMinutes; String? get location;@JsonKey(name: 'meeting_link') String? get meetingLink;@JsonKey(name: 'interviewer_names') String? get interviewerNames; String? get notes;@JsonKey(name: 'send_calendar_invite') bool get sendCalendarInvite;
/// Create a copy of CreateInterviewRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateInterviewRequestCopyWith<CreateInterviewRequest> get copyWith => _$CreateInterviewRequestCopyWithImpl<CreateInterviewRequest>(this as CreateInterviewRequest, _$identity);

  /// Serializes this CreateInterviewRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateInterviewRequest&&(identical(other.applicationId, applicationId) || other.applicationId == applicationId)&&(identical(other.interviewType, interviewType) || other.interviewType == interviewType)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.location, location) || other.location == location)&&(identical(other.meetingLink, meetingLink) || other.meetingLink == meetingLink)&&(identical(other.interviewerNames, interviewerNames) || other.interviewerNames == interviewerNames)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.sendCalendarInvite, sendCalendarInvite) || other.sendCalendarInvite == sendCalendarInvite));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,applicationId,interviewType,scheduledAt,durationMinutes,location,meetingLink,interviewerNames,notes,sendCalendarInvite);

@override
String toString() {
  return 'CreateInterviewRequest(applicationId: $applicationId, interviewType: $interviewType, scheduledAt: $scheduledAt, durationMinutes: $durationMinutes, location: $location, meetingLink: $meetingLink, interviewerNames: $interviewerNames, notes: $notes, sendCalendarInvite: $sendCalendarInvite)';
}


}

/// @nodoc
abstract mixin class $CreateInterviewRequestCopyWith<$Res>  {
  factory $CreateInterviewRequestCopyWith(CreateInterviewRequest value, $Res Function(CreateInterviewRequest) _then) = _$CreateInterviewRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'application_id') String applicationId,@JsonKey(name: 'interview_type') String interviewType,@JsonKey(name: 'scheduled_at') DateTime scheduledAt,@JsonKey(name: 'duration_minutes') int? durationMinutes, String? location,@JsonKey(name: 'meeting_link') String? meetingLink,@JsonKey(name: 'interviewer_names') String? interviewerNames, String? notes,@JsonKey(name: 'send_calendar_invite') bool sendCalendarInvite
});




}
/// @nodoc
class _$CreateInterviewRequestCopyWithImpl<$Res>
    implements $CreateInterviewRequestCopyWith<$Res> {
  _$CreateInterviewRequestCopyWithImpl(this._self, this._then);

  final CreateInterviewRequest _self;
  final $Res Function(CreateInterviewRequest) _then;

/// Create a copy of CreateInterviewRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? applicationId = null,Object? interviewType = null,Object? scheduledAt = null,Object? durationMinutes = freezed,Object? location = freezed,Object? meetingLink = freezed,Object? interviewerNames = freezed,Object? notes = freezed,Object? sendCalendarInvite = null,}) {
  return _then(_self.copyWith(
applicationId: null == applicationId ? _self.applicationId : applicationId // ignore: cast_nullable_to_non_nullable
as String,interviewType: null == interviewType ? _self.interviewType : interviewType // ignore: cast_nullable_to_non_nullable
as String,scheduledAt: null == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime,durationMinutes: freezed == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,meetingLink: freezed == meetingLink ? _self.meetingLink : meetingLink // ignore: cast_nullable_to_non_nullable
as String?,interviewerNames: freezed == interviewerNames ? _self.interviewerNames : interviewerNames // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,sendCalendarInvite: null == sendCalendarInvite ? _self.sendCalendarInvite : sendCalendarInvite // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateInterviewRequest].
extension CreateInterviewRequestPatterns on CreateInterviewRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateInterviewRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateInterviewRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateInterviewRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateInterviewRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateInterviewRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateInterviewRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'application_id')  String applicationId, @JsonKey(name: 'interview_type')  String interviewType, @JsonKey(name: 'scheduled_at')  DateTime scheduledAt, @JsonKey(name: 'duration_minutes')  int? durationMinutes,  String? location, @JsonKey(name: 'meeting_link')  String? meetingLink, @JsonKey(name: 'interviewer_names')  String? interviewerNames,  String? notes, @JsonKey(name: 'send_calendar_invite')  bool sendCalendarInvite)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateInterviewRequest() when $default != null:
return $default(_that.applicationId,_that.interviewType,_that.scheduledAt,_that.durationMinutes,_that.location,_that.meetingLink,_that.interviewerNames,_that.notes,_that.sendCalendarInvite);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'application_id')  String applicationId, @JsonKey(name: 'interview_type')  String interviewType, @JsonKey(name: 'scheduled_at')  DateTime scheduledAt, @JsonKey(name: 'duration_minutes')  int? durationMinutes,  String? location, @JsonKey(name: 'meeting_link')  String? meetingLink, @JsonKey(name: 'interviewer_names')  String? interviewerNames,  String? notes, @JsonKey(name: 'send_calendar_invite')  bool sendCalendarInvite)  $default,) {final _that = this;
switch (_that) {
case _CreateInterviewRequest():
return $default(_that.applicationId,_that.interviewType,_that.scheduledAt,_that.durationMinutes,_that.location,_that.meetingLink,_that.interviewerNames,_that.notes,_that.sendCalendarInvite);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'application_id')  String applicationId, @JsonKey(name: 'interview_type')  String interviewType, @JsonKey(name: 'scheduled_at')  DateTime scheduledAt, @JsonKey(name: 'duration_minutes')  int? durationMinutes,  String? location, @JsonKey(name: 'meeting_link')  String? meetingLink, @JsonKey(name: 'interviewer_names')  String? interviewerNames,  String? notes, @JsonKey(name: 'send_calendar_invite')  bool sendCalendarInvite)?  $default,) {final _that = this;
switch (_that) {
case _CreateInterviewRequest() when $default != null:
return $default(_that.applicationId,_that.interviewType,_that.scheduledAt,_that.durationMinutes,_that.location,_that.meetingLink,_that.interviewerNames,_that.notes,_that.sendCalendarInvite);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateInterviewRequest implements CreateInterviewRequest {
  const _CreateInterviewRequest({@JsonKey(name: 'application_id') required this.applicationId, @JsonKey(name: 'interview_type') required this.interviewType, @JsonKey(name: 'scheduled_at') required this.scheduledAt, @JsonKey(name: 'duration_minutes') this.durationMinutes, this.location, @JsonKey(name: 'meeting_link') this.meetingLink, @JsonKey(name: 'interviewer_names') this.interviewerNames, this.notes, @JsonKey(name: 'send_calendar_invite') this.sendCalendarInvite = false});
  factory _CreateInterviewRequest.fromJson(Map<String, dynamic> json) => _$CreateInterviewRequestFromJson(json);

@override@JsonKey(name: 'application_id') final  String applicationId;
@override@JsonKey(name: 'interview_type') final  String interviewType;
@override@JsonKey(name: 'scheduled_at') final  DateTime scheduledAt;
@override@JsonKey(name: 'duration_minutes') final  int? durationMinutes;
@override final  String? location;
@override@JsonKey(name: 'meeting_link') final  String? meetingLink;
@override@JsonKey(name: 'interviewer_names') final  String? interviewerNames;
@override final  String? notes;
@override@JsonKey(name: 'send_calendar_invite') final  bool sendCalendarInvite;

/// Create a copy of CreateInterviewRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateInterviewRequestCopyWith<_CreateInterviewRequest> get copyWith => __$CreateInterviewRequestCopyWithImpl<_CreateInterviewRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateInterviewRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateInterviewRequest&&(identical(other.applicationId, applicationId) || other.applicationId == applicationId)&&(identical(other.interviewType, interviewType) || other.interviewType == interviewType)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.location, location) || other.location == location)&&(identical(other.meetingLink, meetingLink) || other.meetingLink == meetingLink)&&(identical(other.interviewerNames, interviewerNames) || other.interviewerNames == interviewerNames)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.sendCalendarInvite, sendCalendarInvite) || other.sendCalendarInvite == sendCalendarInvite));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,applicationId,interviewType,scheduledAt,durationMinutes,location,meetingLink,interviewerNames,notes,sendCalendarInvite);

@override
String toString() {
  return 'CreateInterviewRequest(applicationId: $applicationId, interviewType: $interviewType, scheduledAt: $scheduledAt, durationMinutes: $durationMinutes, location: $location, meetingLink: $meetingLink, interviewerNames: $interviewerNames, notes: $notes, sendCalendarInvite: $sendCalendarInvite)';
}


}

/// @nodoc
abstract mixin class _$CreateInterviewRequestCopyWith<$Res> implements $CreateInterviewRequestCopyWith<$Res> {
  factory _$CreateInterviewRequestCopyWith(_CreateInterviewRequest value, $Res Function(_CreateInterviewRequest) _then) = __$CreateInterviewRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'application_id') String applicationId,@JsonKey(name: 'interview_type') String interviewType,@JsonKey(name: 'scheduled_at') DateTime scheduledAt,@JsonKey(name: 'duration_minutes') int? durationMinutes, String? location,@JsonKey(name: 'meeting_link') String? meetingLink,@JsonKey(name: 'interviewer_names') String? interviewerNames, String? notes,@JsonKey(name: 'send_calendar_invite') bool sendCalendarInvite
});




}
/// @nodoc
class __$CreateInterviewRequestCopyWithImpl<$Res>
    implements _$CreateInterviewRequestCopyWith<$Res> {
  __$CreateInterviewRequestCopyWithImpl(this._self, this._then);

  final _CreateInterviewRequest _self;
  final $Res Function(_CreateInterviewRequest) _then;

/// Create a copy of CreateInterviewRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? applicationId = null,Object? interviewType = null,Object? scheduledAt = null,Object? durationMinutes = freezed,Object? location = freezed,Object? meetingLink = freezed,Object? interviewerNames = freezed,Object? notes = freezed,Object? sendCalendarInvite = null,}) {
  return _then(_CreateInterviewRequest(
applicationId: null == applicationId ? _self.applicationId : applicationId // ignore: cast_nullable_to_non_nullable
as String,interviewType: null == interviewType ? _self.interviewType : interviewType // ignore: cast_nullable_to_non_nullable
as String,scheduledAt: null == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime,durationMinutes: freezed == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,meetingLink: freezed == meetingLink ? _self.meetingLink : meetingLink // ignore: cast_nullable_to_non_nullable
as String?,interviewerNames: freezed == interviewerNames ? _self.interviewerNames : interviewerNames // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,sendCalendarInvite: null == sendCalendarInvite ? _self.sendCalendarInvite : sendCalendarInvite // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$UpdateInterviewRequest {

@JsonKey(name: 'interview_type') String? get interviewType; String? get status;@JsonKey(name: 'scheduled_at') DateTime? get scheduledAt;@JsonKey(name: 'duration_minutes') int? get durationMinutes; String? get location;@JsonKey(name: 'meeting_link') String? get meetingLink;@JsonKey(name: 'interviewer_names') String? get interviewerNames; String? get notes;@JsonKey(name: 'preparation_notes') String? get preparationNotes; int? get rating; String? get feedback;
/// Create a copy of UpdateInterviewRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateInterviewRequestCopyWith<UpdateInterviewRequest> get copyWith => _$UpdateInterviewRequestCopyWithImpl<UpdateInterviewRequest>(this as UpdateInterviewRequest, _$identity);

  /// Serializes this UpdateInterviewRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateInterviewRequest&&(identical(other.interviewType, interviewType) || other.interviewType == interviewType)&&(identical(other.status, status) || other.status == status)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.location, location) || other.location == location)&&(identical(other.meetingLink, meetingLink) || other.meetingLink == meetingLink)&&(identical(other.interviewerNames, interviewerNames) || other.interviewerNames == interviewerNames)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.preparationNotes, preparationNotes) || other.preparationNotes == preparationNotes)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.feedback, feedback) || other.feedback == feedback));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,interviewType,status,scheduledAt,durationMinutes,location,meetingLink,interviewerNames,notes,preparationNotes,rating,feedback);

@override
String toString() {
  return 'UpdateInterviewRequest(interviewType: $interviewType, status: $status, scheduledAt: $scheduledAt, durationMinutes: $durationMinutes, location: $location, meetingLink: $meetingLink, interviewerNames: $interviewerNames, notes: $notes, preparationNotes: $preparationNotes, rating: $rating, feedback: $feedback)';
}


}

/// @nodoc
abstract mixin class $UpdateInterviewRequestCopyWith<$Res>  {
  factory $UpdateInterviewRequestCopyWith(UpdateInterviewRequest value, $Res Function(UpdateInterviewRequest) _then) = _$UpdateInterviewRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'interview_type') String? interviewType, String? status,@JsonKey(name: 'scheduled_at') DateTime? scheduledAt,@JsonKey(name: 'duration_minutes') int? durationMinutes, String? location,@JsonKey(name: 'meeting_link') String? meetingLink,@JsonKey(name: 'interviewer_names') String? interviewerNames, String? notes,@JsonKey(name: 'preparation_notes') String? preparationNotes, int? rating, String? feedback
});




}
/// @nodoc
class _$UpdateInterviewRequestCopyWithImpl<$Res>
    implements $UpdateInterviewRequestCopyWith<$Res> {
  _$UpdateInterviewRequestCopyWithImpl(this._self, this._then);

  final UpdateInterviewRequest _self;
  final $Res Function(UpdateInterviewRequest) _then;

/// Create a copy of UpdateInterviewRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? interviewType = freezed,Object? status = freezed,Object? scheduledAt = freezed,Object? durationMinutes = freezed,Object? location = freezed,Object? meetingLink = freezed,Object? interviewerNames = freezed,Object? notes = freezed,Object? preparationNotes = freezed,Object? rating = freezed,Object? feedback = freezed,}) {
  return _then(_self.copyWith(
interviewType: freezed == interviewType ? _self.interviewType : interviewType // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,scheduledAt: freezed == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,durationMinutes: freezed == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,meetingLink: freezed == meetingLink ? _self.meetingLink : meetingLink // ignore: cast_nullable_to_non_nullable
as String?,interviewerNames: freezed == interviewerNames ? _self.interviewerNames : interviewerNames // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,preparationNotes: freezed == preparationNotes ? _self.preparationNotes : preparationNotes // ignore: cast_nullable_to_non_nullable
as String?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int?,feedback: freezed == feedback ? _self.feedback : feedback // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateInterviewRequest].
extension UpdateInterviewRequestPatterns on UpdateInterviewRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateInterviewRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateInterviewRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateInterviewRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateInterviewRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateInterviewRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateInterviewRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'interview_type')  String? interviewType,  String? status, @JsonKey(name: 'scheduled_at')  DateTime? scheduledAt, @JsonKey(name: 'duration_minutes')  int? durationMinutes,  String? location, @JsonKey(name: 'meeting_link')  String? meetingLink, @JsonKey(name: 'interviewer_names')  String? interviewerNames,  String? notes, @JsonKey(name: 'preparation_notes')  String? preparationNotes,  int? rating,  String? feedback)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateInterviewRequest() when $default != null:
return $default(_that.interviewType,_that.status,_that.scheduledAt,_that.durationMinutes,_that.location,_that.meetingLink,_that.interviewerNames,_that.notes,_that.preparationNotes,_that.rating,_that.feedback);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'interview_type')  String? interviewType,  String? status, @JsonKey(name: 'scheduled_at')  DateTime? scheduledAt, @JsonKey(name: 'duration_minutes')  int? durationMinutes,  String? location, @JsonKey(name: 'meeting_link')  String? meetingLink, @JsonKey(name: 'interviewer_names')  String? interviewerNames,  String? notes, @JsonKey(name: 'preparation_notes')  String? preparationNotes,  int? rating,  String? feedback)  $default,) {final _that = this;
switch (_that) {
case _UpdateInterviewRequest():
return $default(_that.interviewType,_that.status,_that.scheduledAt,_that.durationMinutes,_that.location,_that.meetingLink,_that.interviewerNames,_that.notes,_that.preparationNotes,_that.rating,_that.feedback);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'interview_type')  String? interviewType,  String? status, @JsonKey(name: 'scheduled_at')  DateTime? scheduledAt, @JsonKey(name: 'duration_minutes')  int? durationMinutes,  String? location, @JsonKey(name: 'meeting_link')  String? meetingLink, @JsonKey(name: 'interviewer_names')  String? interviewerNames,  String? notes, @JsonKey(name: 'preparation_notes')  String? preparationNotes,  int? rating,  String? feedback)?  $default,) {final _that = this;
switch (_that) {
case _UpdateInterviewRequest() when $default != null:
return $default(_that.interviewType,_that.status,_that.scheduledAt,_that.durationMinutes,_that.location,_that.meetingLink,_that.interviewerNames,_that.notes,_that.preparationNotes,_that.rating,_that.feedback);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateInterviewRequest implements UpdateInterviewRequest {
  const _UpdateInterviewRequest({@JsonKey(name: 'interview_type') this.interviewType, this.status, @JsonKey(name: 'scheduled_at') this.scheduledAt, @JsonKey(name: 'duration_minutes') this.durationMinutes, this.location, @JsonKey(name: 'meeting_link') this.meetingLink, @JsonKey(name: 'interviewer_names') this.interviewerNames, this.notes, @JsonKey(name: 'preparation_notes') this.preparationNotes, this.rating, this.feedback});
  factory _UpdateInterviewRequest.fromJson(Map<String, dynamic> json) => _$UpdateInterviewRequestFromJson(json);

@override@JsonKey(name: 'interview_type') final  String? interviewType;
@override final  String? status;
@override@JsonKey(name: 'scheduled_at') final  DateTime? scheduledAt;
@override@JsonKey(name: 'duration_minutes') final  int? durationMinutes;
@override final  String? location;
@override@JsonKey(name: 'meeting_link') final  String? meetingLink;
@override@JsonKey(name: 'interviewer_names') final  String? interviewerNames;
@override final  String? notes;
@override@JsonKey(name: 'preparation_notes') final  String? preparationNotes;
@override final  int? rating;
@override final  String? feedback;

/// Create a copy of UpdateInterviewRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateInterviewRequestCopyWith<_UpdateInterviewRequest> get copyWith => __$UpdateInterviewRequestCopyWithImpl<_UpdateInterviewRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateInterviewRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateInterviewRequest&&(identical(other.interviewType, interviewType) || other.interviewType == interviewType)&&(identical(other.status, status) || other.status == status)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.location, location) || other.location == location)&&(identical(other.meetingLink, meetingLink) || other.meetingLink == meetingLink)&&(identical(other.interviewerNames, interviewerNames) || other.interviewerNames == interviewerNames)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.preparationNotes, preparationNotes) || other.preparationNotes == preparationNotes)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.feedback, feedback) || other.feedback == feedback));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,interviewType,status,scheduledAt,durationMinutes,location,meetingLink,interviewerNames,notes,preparationNotes,rating,feedback);

@override
String toString() {
  return 'UpdateInterviewRequest(interviewType: $interviewType, status: $status, scheduledAt: $scheduledAt, durationMinutes: $durationMinutes, location: $location, meetingLink: $meetingLink, interviewerNames: $interviewerNames, notes: $notes, preparationNotes: $preparationNotes, rating: $rating, feedback: $feedback)';
}


}

/// @nodoc
abstract mixin class _$UpdateInterviewRequestCopyWith<$Res> implements $UpdateInterviewRequestCopyWith<$Res> {
  factory _$UpdateInterviewRequestCopyWith(_UpdateInterviewRequest value, $Res Function(_UpdateInterviewRequest) _then) = __$UpdateInterviewRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'interview_type') String? interviewType, String? status,@JsonKey(name: 'scheduled_at') DateTime? scheduledAt,@JsonKey(name: 'duration_minutes') int? durationMinutes, String? location,@JsonKey(name: 'meeting_link') String? meetingLink,@JsonKey(name: 'interviewer_names') String? interviewerNames, String? notes,@JsonKey(name: 'preparation_notes') String? preparationNotes, int? rating, String? feedback
});




}
/// @nodoc
class __$UpdateInterviewRequestCopyWithImpl<$Res>
    implements _$UpdateInterviewRequestCopyWith<$Res> {
  __$UpdateInterviewRequestCopyWithImpl(this._self, this._then);

  final _UpdateInterviewRequest _self;
  final $Res Function(_UpdateInterviewRequest) _then;

/// Create a copy of UpdateInterviewRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? interviewType = freezed,Object? status = freezed,Object? scheduledAt = freezed,Object? durationMinutes = freezed,Object? location = freezed,Object? meetingLink = freezed,Object? interviewerNames = freezed,Object? notes = freezed,Object? preparationNotes = freezed,Object? rating = freezed,Object? feedback = freezed,}) {
  return _then(_UpdateInterviewRequest(
interviewType: freezed == interviewType ? _self.interviewType : interviewType // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,scheduledAt: freezed == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,durationMinutes: freezed == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,meetingLink: freezed == meetingLink ? _self.meetingLink : meetingLink // ignore: cast_nullable_to_non_nullable
as String?,interviewerNames: freezed == interviewerNames ? _self.interviewerNames : interviewerNames // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,preparationNotes: freezed == preparationNotes ? _self.preparationNotes : preparationNotes // ignore: cast_nullable_to_non_nullable
as String?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int?,feedback: freezed == feedback ? _self.feedback : feedback // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CompleteInterviewRequest {

 int get rating; String? get feedback; String? get notes;
/// Create a copy of CompleteInterviewRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CompleteInterviewRequestCopyWith<CompleteInterviewRequest> get copyWith => _$CompleteInterviewRequestCopyWithImpl<CompleteInterviewRequest>(this as CompleteInterviewRequest, _$identity);

  /// Serializes this CompleteInterviewRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CompleteInterviewRequest&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.feedback, feedback) || other.feedback == feedback)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rating,feedback,notes);

@override
String toString() {
  return 'CompleteInterviewRequest(rating: $rating, feedback: $feedback, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $CompleteInterviewRequestCopyWith<$Res>  {
  factory $CompleteInterviewRequestCopyWith(CompleteInterviewRequest value, $Res Function(CompleteInterviewRequest) _then) = _$CompleteInterviewRequestCopyWithImpl;
@useResult
$Res call({
 int rating, String? feedback, String? notes
});




}
/// @nodoc
class _$CompleteInterviewRequestCopyWithImpl<$Res>
    implements $CompleteInterviewRequestCopyWith<$Res> {
  _$CompleteInterviewRequestCopyWithImpl(this._self, this._then);

  final CompleteInterviewRequest _self;
  final $Res Function(CompleteInterviewRequest) _then;

/// Create a copy of CompleteInterviewRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rating = null,Object? feedback = freezed,Object? notes = freezed,}) {
  return _then(_self.copyWith(
rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,feedback: freezed == feedback ? _self.feedback : feedback // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CompleteInterviewRequest].
extension CompleteInterviewRequestPatterns on CompleteInterviewRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CompleteInterviewRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CompleteInterviewRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CompleteInterviewRequest value)  $default,){
final _that = this;
switch (_that) {
case _CompleteInterviewRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CompleteInterviewRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CompleteInterviewRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int rating,  String? feedback,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CompleteInterviewRequest() when $default != null:
return $default(_that.rating,_that.feedback,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int rating,  String? feedback,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _CompleteInterviewRequest():
return $default(_that.rating,_that.feedback,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int rating,  String? feedback,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _CompleteInterviewRequest() when $default != null:
return $default(_that.rating,_that.feedback,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CompleteInterviewRequest implements CompleteInterviewRequest {
  const _CompleteInterviewRequest({required this.rating, this.feedback, this.notes});
  factory _CompleteInterviewRequest.fromJson(Map<String, dynamic> json) => _$CompleteInterviewRequestFromJson(json);

@override final  int rating;
@override final  String? feedback;
@override final  String? notes;

/// Create a copy of CompleteInterviewRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CompleteInterviewRequestCopyWith<_CompleteInterviewRequest> get copyWith => __$CompleteInterviewRequestCopyWithImpl<_CompleteInterviewRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CompleteInterviewRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CompleteInterviewRequest&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.feedback, feedback) || other.feedback == feedback)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rating,feedback,notes);

@override
String toString() {
  return 'CompleteInterviewRequest(rating: $rating, feedback: $feedback, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$CompleteInterviewRequestCopyWith<$Res> implements $CompleteInterviewRequestCopyWith<$Res> {
  factory _$CompleteInterviewRequestCopyWith(_CompleteInterviewRequest value, $Res Function(_CompleteInterviewRequest) _then) = __$CompleteInterviewRequestCopyWithImpl;
@override @useResult
$Res call({
 int rating, String? feedback, String? notes
});




}
/// @nodoc
class __$CompleteInterviewRequestCopyWithImpl<$Res>
    implements _$CompleteInterviewRequestCopyWith<$Res> {
  __$CompleteInterviewRequestCopyWithImpl(this._self, this._then);

  final _CompleteInterviewRequest _self;
  final $Res Function(_CompleteInterviewRequest) _then;

/// Create a copy of CompleteInterviewRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rating = null,Object? feedback = freezed,Object? notes = freezed,}) {
  return _then(_CompleteInterviewRequest(
rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,feedback: freezed == feedback ? _self.feedback : feedback // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$InterviewListResponse {

 int get count; String? get next; String? get previous; List<Interview> get results;
/// Create a copy of InterviewListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InterviewListResponseCopyWith<InterviewListResponse> get copyWith => _$InterviewListResponseCopyWithImpl<InterviewListResponse>(this as InterviewListResponse, _$identity);

  /// Serializes this InterviewListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InterviewListResponse&&(identical(other.count, count) || other.count == count)&&(identical(other.next, next) || other.next == next)&&(identical(other.previous, previous) || other.previous == previous)&&const DeepCollectionEquality().equals(other.results, results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,next,previous,const DeepCollectionEquality().hash(results));

@override
String toString() {
  return 'InterviewListResponse(count: $count, next: $next, previous: $previous, results: $results)';
}


}

/// @nodoc
abstract mixin class $InterviewListResponseCopyWith<$Res>  {
  factory $InterviewListResponseCopyWith(InterviewListResponse value, $Res Function(InterviewListResponse) _then) = _$InterviewListResponseCopyWithImpl;
@useResult
$Res call({
 int count, String? next, String? previous, List<Interview> results
});




}
/// @nodoc
class _$InterviewListResponseCopyWithImpl<$Res>
    implements $InterviewListResponseCopyWith<$Res> {
  _$InterviewListResponseCopyWithImpl(this._self, this._then);

  final InterviewListResponse _self;
  final $Res Function(InterviewListResponse) _then;

/// Create a copy of InterviewListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? count = null,Object? next = freezed,Object? previous = freezed,Object? results = null,}) {
  return _then(_self.copyWith(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,next: freezed == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as String?,previous: freezed == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as String?,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<Interview>,
  ));
}

}


/// Adds pattern-matching-related methods to [InterviewListResponse].
extension InterviewListResponsePatterns on InterviewListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InterviewListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InterviewListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InterviewListResponse value)  $default,){
final _that = this;
switch (_that) {
case _InterviewListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InterviewListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _InterviewListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int count,  String? next,  String? previous,  List<Interview> results)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InterviewListResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int count,  String? next,  String? previous,  List<Interview> results)  $default,) {final _that = this;
switch (_that) {
case _InterviewListResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int count,  String? next,  String? previous,  List<Interview> results)?  $default,) {final _that = this;
switch (_that) {
case _InterviewListResponse() when $default != null:
return $default(_that.count,_that.next,_that.previous,_that.results);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InterviewListResponse implements InterviewListResponse {
  const _InterviewListResponse({required this.count, this.next, this.previous, required final  List<Interview> results}): _results = results;
  factory _InterviewListResponse.fromJson(Map<String, dynamic> json) => _$InterviewListResponseFromJson(json);

@override final  int count;
@override final  String? next;
@override final  String? previous;
 final  List<Interview> _results;
@override List<Interview> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}


/// Create a copy of InterviewListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InterviewListResponseCopyWith<_InterviewListResponse> get copyWith => __$InterviewListResponseCopyWithImpl<_InterviewListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InterviewListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InterviewListResponse&&(identical(other.count, count) || other.count == count)&&(identical(other.next, next) || other.next == next)&&(identical(other.previous, previous) || other.previous == previous)&&const DeepCollectionEquality().equals(other._results, _results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,next,previous,const DeepCollectionEquality().hash(_results));

@override
String toString() {
  return 'InterviewListResponse(count: $count, next: $next, previous: $previous, results: $results)';
}


}

/// @nodoc
abstract mixin class _$InterviewListResponseCopyWith<$Res> implements $InterviewListResponseCopyWith<$Res> {
  factory _$InterviewListResponseCopyWith(_InterviewListResponse value, $Res Function(_InterviewListResponse) _then) = __$InterviewListResponseCopyWithImpl;
@override @useResult
$Res call({
 int count, String? next, String? previous, List<Interview> results
});




}
/// @nodoc
class __$InterviewListResponseCopyWithImpl<$Res>
    implements _$InterviewListResponseCopyWith<$Res> {
  __$InterviewListResponseCopyWithImpl(this._self, this._then);

  final _InterviewListResponse _self;
  final $Res Function(_InterviewListResponse) _then;

/// Create a copy of InterviewListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? count = null,Object? next = freezed,Object? previous = freezed,Object? results = null,}) {
  return _then(_InterviewListResponse(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,next: freezed == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as String?,previous: freezed == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as String?,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<Interview>,
  ));
}


}


/// @nodoc
mixin _$StarResponse {

 String get id; String get question; String? get situation; String? get task; String? get action; String? get result;
/// Create a copy of StarResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StarResponseCopyWith<StarResponse> get copyWith => _$StarResponseCopyWithImpl<StarResponse>(this as StarResponse, _$identity);

  /// Serializes this StarResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StarResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.question, question) || other.question == question)&&(identical(other.situation, situation) || other.situation == situation)&&(identical(other.task, task) || other.task == task)&&(identical(other.action, action) || other.action == action)&&(identical(other.result, result) || other.result == result));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,question,situation,task,action,result);

@override
String toString() {
  return 'StarResponse(id: $id, question: $question, situation: $situation, task: $task, action: $action, result: $result)';
}


}

/// @nodoc
abstract mixin class $StarResponseCopyWith<$Res>  {
  factory $StarResponseCopyWith(StarResponse value, $Res Function(StarResponse) _then) = _$StarResponseCopyWithImpl;
@useResult
$Res call({
 String id, String question, String? situation, String? task, String? action, String? result
});




}
/// @nodoc
class _$StarResponseCopyWithImpl<$Res>
    implements $StarResponseCopyWith<$Res> {
  _$StarResponseCopyWithImpl(this._self, this._then);

  final StarResponse _self;
  final $Res Function(StarResponse) _then;

/// Create a copy of StarResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? question = null,Object? situation = freezed,Object? task = freezed,Object? action = freezed,Object? result = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,situation: freezed == situation ? _self.situation : situation // ignore: cast_nullable_to_non_nullable
as String?,task: freezed == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as String?,action: freezed == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String?,result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StarResponse].
extension StarResponsePatterns on StarResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StarResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StarResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StarResponse value)  $default,){
final _that = this;
switch (_that) {
case _StarResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StarResponse value)?  $default,){
final _that = this;
switch (_that) {
case _StarResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String question,  String? situation,  String? task,  String? action,  String? result)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StarResponse() when $default != null:
return $default(_that.id,_that.question,_that.situation,_that.task,_that.action,_that.result);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String question,  String? situation,  String? task,  String? action,  String? result)  $default,) {final _that = this;
switch (_that) {
case _StarResponse():
return $default(_that.id,_that.question,_that.situation,_that.task,_that.action,_that.result);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String question,  String? situation,  String? task,  String? action,  String? result)?  $default,) {final _that = this;
switch (_that) {
case _StarResponse() when $default != null:
return $default(_that.id,_that.question,_that.situation,_that.task,_that.action,_that.result);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StarResponse implements StarResponse {
  const _StarResponse({required this.id, required this.question, this.situation, this.task, this.action, this.result});
  factory _StarResponse.fromJson(Map<String, dynamic> json) => _$StarResponseFromJson(json);

@override final  String id;
@override final  String question;
@override final  String? situation;
@override final  String? task;
@override final  String? action;
@override final  String? result;

/// Create a copy of StarResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StarResponseCopyWith<_StarResponse> get copyWith => __$StarResponseCopyWithImpl<_StarResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StarResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StarResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.question, question) || other.question == question)&&(identical(other.situation, situation) || other.situation == situation)&&(identical(other.task, task) || other.task == task)&&(identical(other.action, action) || other.action == action)&&(identical(other.result, result) || other.result == result));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,question,situation,task,action,result);

@override
String toString() {
  return 'StarResponse(id: $id, question: $question, situation: $situation, task: $task, action: $action, result: $result)';
}


}

/// @nodoc
abstract mixin class _$StarResponseCopyWith<$Res> implements $StarResponseCopyWith<$Res> {
  factory _$StarResponseCopyWith(_StarResponse value, $Res Function(_StarResponse) _then) = __$StarResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String question, String? situation, String? task, String? action, String? result
});




}
/// @nodoc
class __$StarResponseCopyWithImpl<$Res>
    implements _$StarResponseCopyWith<$Res> {
  __$StarResponseCopyWithImpl(this._self, this._then);

  final _StarResponse _self;
  final $Res Function(_StarResponse) _then;

/// Create a copy of StarResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? question = null,Object? situation = freezed,Object? task = freezed,Object? action = freezed,Object? result = freezed,}) {
  return _then(_StarResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,situation: freezed == situation ? _self.situation : situation // ignore: cast_nullable_to_non_nullable
as String?,task: freezed == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as String?,action: freezed == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String?,result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
