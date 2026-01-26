// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'application_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Application {

 String get id;@JsonKey(name: 'company_name') String get companyName;@JsonKey(name: 'job_title') String get jobTitle; String get status;@JsonKey(name: 'job_url') String? get jobUrl; String? get location;@JsonKey(name: 'work_mode') String? get workMode;@JsonKey(name: 'job_type') String? get jobType;@JsonKey(name: 'salary_min') int? get salaryMin;@JsonKey(name: 'salary_max') int? get salaryMax;@JsonKey(name: 'salary_currency') String get salaryCurrency; String? get description; String? get notes;@JsonKey(name: 'company_website') String? get companyWebsite;@JsonKey(name: 'company_logo') String? get companyLogo;@JsonKey(name: 'contact_name') String? get contactName;@JsonKey(name: 'contact_email') String? get contactEmail;@JsonKey(name: 'contact_phone') String? get contactPhone;@JsonKey(name: 'applied_at') DateTime? get appliedAt;@JsonKey(name: 'deadline') DateTime? get deadline;@JsonKey(name: 'resume_id') String? get resumeId;@JsonKey(name: 'source') String? get source; int get priority; bool get starred;@JsonKey(name: 'interview_count') int get interviewCount;@JsonKey(name: 'reminder_count') int get reminderCount;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;
/// Create a copy of Application
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApplicationCopyWith<Application> get copyWith => _$ApplicationCopyWithImpl<Application>(this as Application, _$identity);

  /// Serializes this Application to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Application&&(identical(other.id, id) || other.id == id)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.jobTitle, jobTitle) || other.jobTitle == jobTitle)&&(identical(other.status, status) || other.status == status)&&(identical(other.jobUrl, jobUrl) || other.jobUrl == jobUrl)&&(identical(other.location, location) || other.location == location)&&(identical(other.workMode, workMode) || other.workMode == workMode)&&(identical(other.jobType, jobType) || other.jobType == jobType)&&(identical(other.salaryMin, salaryMin) || other.salaryMin == salaryMin)&&(identical(other.salaryMax, salaryMax) || other.salaryMax == salaryMax)&&(identical(other.salaryCurrency, salaryCurrency) || other.salaryCurrency == salaryCurrency)&&(identical(other.description, description) || other.description == description)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.companyWebsite, companyWebsite) || other.companyWebsite == companyWebsite)&&(identical(other.companyLogo, companyLogo) || other.companyLogo == companyLogo)&&(identical(other.contactName, contactName) || other.contactName == contactName)&&(identical(other.contactEmail, contactEmail) || other.contactEmail == contactEmail)&&(identical(other.contactPhone, contactPhone) || other.contactPhone == contactPhone)&&(identical(other.appliedAt, appliedAt) || other.appliedAt == appliedAt)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.resumeId, resumeId) || other.resumeId == resumeId)&&(identical(other.source, source) || other.source == source)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.starred, starred) || other.starred == starred)&&(identical(other.interviewCount, interviewCount) || other.interviewCount == interviewCount)&&(identical(other.reminderCount, reminderCount) || other.reminderCount == reminderCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,companyName,jobTitle,status,jobUrl,location,workMode,jobType,salaryMin,salaryMax,salaryCurrency,description,notes,companyWebsite,companyLogo,contactName,contactEmail,contactPhone,appliedAt,deadline,resumeId,source,priority,starred,interviewCount,reminderCount,createdAt,updatedAt]);

@override
String toString() {
  return 'Application(id: $id, companyName: $companyName, jobTitle: $jobTitle, status: $status, jobUrl: $jobUrl, location: $location, workMode: $workMode, jobType: $jobType, salaryMin: $salaryMin, salaryMax: $salaryMax, salaryCurrency: $salaryCurrency, description: $description, notes: $notes, companyWebsite: $companyWebsite, companyLogo: $companyLogo, contactName: $contactName, contactEmail: $contactEmail, contactPhone: $contactPhone, appliedAt: $appliedAt, deadline: $deadline, resumeId: $resumeId, source: $source, priority: $priority, starred: $starred, interviewCount: $interviewCount, reminderCount: $reminderCount, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ApplicationCopyWith<$Res>  {
  factory $ApplicationCopyWith(Application value, $Res Function(Application) _then) = _$ApplicationCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'company_name') String companyName,@JsonKey(name: 'job_title') String jobTitle, String status,@JsonKey(name: 'job_url') String? jobUrl, String? location,@JsonKey(name: 'work_mode') String? workMode,@JsonKey(name: 'job_type') String? jobType,@JsonKey(name: 'salary_min') int? salaryMin,@JsonKey(name: 'salary_max') int? salaryMax,@JsonKey(name: 'salary_currency') String salaryCurrency, String? description, String? notes,@JsonKey(name: 'company_website') String? companyWebsite,@JsonKey(name: 'company_logo') String? companyLogo,@JsonKey(name: 'contact_name') String? contactName,@JsonKey(name: 'contact_email') String? contactEmail,@JsonKey(name: 'contact_phone') String? contactPhone,@JsonKey(name: 'applied_at') DateTime? appliedAt,@JsonKey(name: 'deadline') DateTime? deadline,@JsonKey(name: 'resume_id') String? resumeId,@JsonKey(name: 'source') String? source, int priority, bool starred,@JsonKey(name: 'interview_count') int interviewCount,@JsonKey(name: 'reminder_count') int reminderCount,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class _$ApplicationCopyWithImpl<$Res>
    implements $ApplicationCopyWith<$Res> {
  _$ApplicationCopyWithImpl(this._self, this._then);

  final Application _self;
  final $Res Function(Application) _then;

/// Create a copy of Application
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? companyName = null,Object? jobTitle = null,Object? status = null,Object? jobUrl = freezed,Object? location = freezed,Object? workMode = freezed,Object? jobType = freezed,Object? salaryMin = freezed,Object? salaryMax = freezed,Object? salaryCurrency = null,Object? description = freezed,Object? notes = freezed,Object? companyWebsite = freezed,Object? companyLogo = freezed,Object? contactName = freezed,Object? contactEmail = freezed,Object? contactPhone = freezed,Object? appliedAt = freezed,Object? deadline = freezed,Object? resumeId = freezed,Object? source = freezed,Object? priority = null,Object? starred = null,Object? interviewCount = null,Object? reminderCount = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,companyName: null == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String,jobTitle: null == jobTitle ? _self.jobTitle : jobTitle // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,jobUrl: freezed == jobUrl ? _self.jobUrl : jobUrl // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,workMode: freezed == workMode ? _self.workMode : workMode // ignore: cast_nullable_to_non_nullable
as String?,jobType: freezed == jobType ? _self.jobType : jobType // ignore: cast_nullable_to_non_nullable
as String?,salaryMin: freezed == salaryMin ? _self.salaryMin : salaryMin // ignore: cast_nullable_to_non_nullable
as int?,salaryMax: freezed == salaryMax ? _self.salaryMax : salaryMax // ignore: cast_nullable_to_non_nullable
as int?,salaryCurrency: null == salaryCurrency ? _self.salaryCurrency : salaryCurrency // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,companyWebsite: freezed == companyWebsite ? _self.companyWebsite : companyWebsite // ignore: cast_nullable_to_non_nullable
as String?,companyLogo: freezed == companyLogo ? _self.companyLogo : companyLogo // ignore: cast_nullable_to_non_nullable
as String?,contactName: freezed == contactName ? _self.contactName : contactName // ignore: cast_nullable_to_non_nullable
as String?,contactEmail: freezed == contactEmail ? _self.contactEmail : contactEmail // ignore: cast_nullable_to_non_nullable
as String?,contactPhone: freezed == contactPhone ? _self.contactPhone : contactPhone // ignore: cast_nullable_to_non_nullable
as String?,appliedAt: freezed == appliedAt ? _self.appliedAt : appliedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deadline: freezed == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as DateTime?,resumeId: freezed == resumeId ? _self.resumeId : resumeId // ignore: cast_nullable_to_non_nullable
as String?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,starred: null == starred ? _self.starred : starred // ignore: cast_nullable_to_non_nullable
as bool,interviewCount: null == interviewCount ? _self.interviewCount : interviewCount // ignore: cast_nullable_to_non_nullable
as int,reminderCount: null == reminderCount ? _self.reminderCount : reminderCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Application].
extension ApplicationPatterns on Application {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Application value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Application() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Application value)  $default,){
final _that = this;
switch (_that) {
case _Application():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Application value)?  $default,){
final _that = this;
switch (_that) {
case _Application() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'company_name')  String companyName, @JsonKey(name: 'job_title')  String jobTitle,  String status, @JsonKey(name: 'job_url')  String? jobUrl,  String? location, @JsonKey(name: 'work_mode')  String? workMode, @JsonKey(name: 'job_type')  String? jobType, @JsonKey(name: 'salary_min')  int? salaryMin, @JsonKey(name: 'salary_max')  int? salaryMax, @JsonKey(name: 'salary_currency')  String salaryCurrency,  String? description,  String? notes, @JsonKey(name: 'company_website')  String? companyWebsite, @JsonKey(name: 'company_logo')  String? companyLogo, @JsonKey(name: 'contact_name')  String? contactName, @JsonKey(name: 'contact_email')  String? contactEmail, @JsonKey(name: 'contact_phone')  String? contactPhone, @JsonKey(name: 'applied_at')  DateTime? appliedAt, @JsonKey(name: 'deadline')  DateTime? deadline, @JsonKey(name: 'resume_id')  String? resumeId, @JsonKey(name: 'source')  String? source,  int priority,  bool starred, @JsonKey(name: 'interview_count')  int interviewCount, @JsonKey(name: 'reminder_count')  int reminderCount, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Application() when $default != null:
return $default(_that.id,_that.companyName,_that.jobTitle,_that.status,_that.jobUrl,_that.location,_that.workMode,_that.jobType,_that.salaryMin,_that.salaryMax,_that.salaryCurrency,_that.description,_that.notes,_that.companyWebsite,_that.companyLogo,_that.contactName,_that.contactEmail,_that.contactPhone,_that.appliedAt,_that.deadline,_that.resumeId,_that.source,_that.priority,_that.starred,_that.interviewCount,_that.reminderCount,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'company_name')  String companyName, @JsonKey(name: 'job_title')  String jobTitle,  String status, @JsonKey(name: 'job_url')  String? jobUrl,  String? location, @JsonKey(name: 'work_mode')  String? workMode, @JsonKey(name: 'job_type')  String? jobType, @JsonKey(name: 'salary_min')  int? salaryMin, @JsonKey(name: 'salary_max')  int? salaryMax, @JsonKey(name: 'salary_currency')  String salaryCurrency,  String? description,  String? notes, @JsonKey(name: 'company_website')  String? companyWebsite, @JsonKey(name: 'company_logo')  String? companyLogo, @JsonKey(name: 'contact_name')  String? contactName, @JsonKey(name: 'contact_email')  String? contactEmail, @JsonKey(name: 'contact_phone')  String? contactPhone, @JsonKey(name: 'applied_at')  DateTime? appliedAt, @JsonKey(name: 'deadline')  DateTime? deadline, @JsonKey(name: 'resume_id')  String? resumeId, @JsonKey(name: 'source')  String? source,  int priority,  bool starred, @JsonKey(name: 'interview_count')  int interviewCount, @JsonKey(name: 'reminder_count')  int reminderCount, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Application():
return $default(_that.id,_that.companyName,_that.jobTitle,_that.status,_that.jobUrl,_that.location,_that.workMode,_that.jobType,_that.salaryMin,_that.salaryMax,_that.salaryCurrency,_that.description,_that.notes,_that.companyWebsite,_that.companyLogo,_that.contactName,_that.contactEmail,_that.contactPhone,_that.appliedAt,_that.deadline,_that.resumeId,_that.source,_that.priority,_that.starred,_that.interviewCount,_that.reminderCount,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'company_name')  String companyName, @JsonKey(name: 'job_title')  String jobTitle,  String status, @JsonKey(name: 'job_url')  String? jobUrl,  String? location, @JsonKey(name: 'work_mode')  String? workMode, @JsonKey(name: 'job_type')  String? jobType, @JsonKey(name: 'salary_min')  int? salaryMin, @JsonKey(name: 'salary_max')  int? salaryMax, @JsonKey(name: 'salary_currency')  String salaryCurrency,  String? description,  String? notes, @JsonKey(name: 'company_website')  String? companyWebsite, @JsonKey(name: 'company_logo')  String? companyLogo, @JsonKey(name: 'contact_name')  String? contactName, @JsonKey(name: 'contact_email')  String? contactEmail, @JsonKey(name: 'contact_phone')  String? contactPhone, @JsonKey(name: 'applied_at')  DateTime? appliedAt, @JsonKey(name: 'deadline')  DateTime? deadline, @JsonKey(name: 'resume_id')  String? resumeId, @JsonKey(name: 'source')  String? source,  int priority,  bool starred, @JsonKey(name: 'interview_count')  int interviewCount, @JsonKey(name: 'reminder_count')  int reminderCount, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Application() when $default != null:
return $default(_that.id,_that.companyName,_that.jobTitle,_that.status,_that.jobUrl,_that.location,_that.workMode,_that.jobType,_that.salaryMin,_that.salaryMax,_that.salaryCurrency,_that.description,_that.notes,_that.companyWebsite,_that.companyLogo,_that.contactName,_that.contactEmail,_that.contactPhone,_that.appliedAt,_that.deadline,_that.resumeId,_that.source,_that.priority,_that.starred,_that.interviewCount,_that.reminderCount,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Application implements Application {
  const _Application({required this.id, @JsonKey(name: 'company_name') required this.companyName, @JsonKey(name: 'job_title') required this.jobTitle, required this.status, @JsonKey(name: 'job_url') this.jobUrl, this.location, @JsonKey(name: 'work_mode') this.workMode, @JsonKey(name: 'job_type') this.jobType, @JsonKey(name: 'salary_min') this.salaryMin, @JsonKey(name: 'salary_max') this.salaryMax, @JsonKey(name: 'salary_currency') this.salaryCurrency = 'USD', this.description, this.notes, @JsonKey(name: 'company_website') this.companyWebsite, @JsonKey(name: 'company_logo') this.companyLogo, @JsonKey(name: 'contact_name') this.contactName, @JsonKey(name: 'contact_email') this.contactEmail, @JsonKey(name: 'contact_phone') this.contactPhone, @JsonKey(name: 'applied_at') this.appliedAt, @JsonKey(name: 'deadline') this.deadline, @JsonKey(name: 'resume_id') this.resumeId, @JsonKey(name: 'source') this.source, this.priority = 0, this.starred = false, @JsonKey(name: 'interview_count') this.interviewCount = 0, @JsonKey(name: 'reminder_count') this.reminderCount = 0, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt});
  factory _Application.fromJson(Map<String, dynamic> json) => _$ApplicationFromJson(json);

@override final  String id;
@override@JsonKey(name: 'company_name') final  String companyName;
@override@JsonKey(name: 'job_title') final  String jobTitle;
@override final  String status;
@override@JsonKey(name: 'job_url') final  String? jobUrl;
@override final  String? location;
@override@JsonKey(name: 'work_mode') final  String? workMode;
@override@JsonKey(name: 'job_type') final  String? jobType;
@override@JsonKey(name: 'salary_min') final  int? salaryMin;
@override@JsonKey(name: 'salary_max') final  int? salaryMax;
@override@JsonKey(name: 'salary_currency') final  String salaryCurrency;
@override final  String? description;
@override final  String? notes;
@override@JsonKey(name: 'company_website') final  String? companyWebsite;
@override@JsonKey(name: 'company_logo') final  String? companyLogo;
@override@JsonKey(name: 'contact_name') final  String? contactName;
@override@JsonKey(name: 'contact_email') final  String? contactEmail;
@override@JsonKey(name: 'contact_phone') final  String? contactPhone;
@override@JsonKey(name: 'applied_at') final  DateTime? appliedAt;
@override@JsonKey(name: 'deadline') final  DateTime? deadline;
@override@JsonKey(name: 'resume_id') final  String? resumeId;
@override@JsonKey(name: 'source') final  String? source;
@override@JsonKey() final  int priority;
@override@JsonKey() final  bool starred;
@override@JsonKey(name: 'interview_count') final  int interviewCount;
@override@JsonKey(name: 'reminder_count') final  int reminderCount;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;

/// Create a copy of Application
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApplicationCopyWith<_Application> get copyWith => __$ApplicationCopyWithImpl<_Application>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApplicationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Application&&(identical(other.id, id) || other.id == id)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.jobTitle, jobTitle) || other.jobTitle == jobTitle)&&(identical(other.status, status) || other.status == status)&&(identical(other.jobUrl, jobUrl) || other.jobUrl == jobUrl)&&(identical(other.location, location) || other.location == location)&&(identical(other.workMode, workMode) || other.workMode == workMode)&&(identical(other.jobType, jobType) || other.jobType == jobType)&&(identical(other.salaryMin, salaryMin) || other.salaryMin == salaryMin)&&(identical(other.salaryMax, salaryMax) || other.salaryMax == salaryMax)&&(identical(other.salaryCurrency, salaryCurrency) || other.salaryCurrency == salaryCurrency)&&(identical(other.description, description) || other.description == description)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.companyWebsite, companyWebsite) || other.companyWebsite == companyWebsite)&&(identical(other.companyLogo, companyLogo) || other.companyLogo == companyLogo)&&(identical(other.contactName, contactName) || other.contactName == contactName)&&(identical(other.contactEmail, contactEmail) || other.contactEmail == contactEmail)&&(identical(other.contactPhone, contactPhone) || other.contactPhone == contactPhone)&&(identical(other.appliedAt, appliedAt) || other.appliedAt == appliedAt)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.resumeId, resumeId) || other.resumeId == resumeId)&&(identical(other.source, source) || other.source == source)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.starred, starred) || other.starred == starred)&&(identical(other.interviewCount, interviewCount) || other.interviewCount == interviewCount)&&(identical(other.reminderCount, reminderCount) || other.reminderCount == reminderCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,companyName,jobTitle,status,jobUrl,location,workMode,jobType,salaryMin,salaryMax,salaryCurrency,description,notes,companyWebsite,companyLogo,contactName,contactEmail,contactPhone,appliedAt,deadline,resumeId,source,priority,starred,interviewCount,reminderCount,createdAt,updatedAt]);

@override
String toString() {
  return 'Application(id: $id, companyName: $companyName, jobTitle: $jobTitle, status: $status, jobUrl: $jobUrl, location: $location, workMode: $workMode, jobType: $jobType, salaryMin: $salaryMin, salaryMax: $salaryMax, salaryCurrency: $salaryCurrency, description: $description, notes: $notes, companyWebsite: $companyWebsite, companyLogo: $companyLogo, contactName: $contactName, contactEmail: $contactEmail, contactPhone: $contactPhone, appliedAt: $appliedAt, deadline: $deadline, resumeId: $resumeId, source: $source, priority: $priority, starred: $starred, interviewCount: $interviewCount, reminderCount: $reminderCount, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ApplicationCopyWith<$Res> implements $ApplicationCopyWith<$Res> {
  factory _$ApplicationCopyWith(_Application value, $Res Function(_Application) _then) = __$ApplicationCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'company_name') String companyName,@JsonKey(name: 'job_title') String jobTitle, String status,@JsonKey(name: 'job_url') String? jobUrl, String? location,@JsonKey(name: 'work_mode') String? workMode,@JsonKey(name: 'job_type') String? jobType,@JsonKey(name: 'salary_min') int? salaryMin,@JsonKey(name: 'salary_max') int? salaryMax,@JsonKey(name: 'salary_currency') String salaryCurrency, String? description, String? notes,@JsonKey(name: 'company_website') String? companyWebsite,@JsonKey(name: 'company_logo') String? companyLogo,@JsonKey(name: 'contact_name') String? contactName,@JsonKey(name: 'contact_email') String? contactEmail,@JsonKey(name: 'contact_phone') String? contactPhone,@JsonKey(name: 'applied_at') DateTime? appliedAt,@JsonKey(name: 'deadline') DateTime? deadline,@JsonKey(name: 'resume_id') String? resumeId,@JsonKey(name: 'source') String? source, int priority, bool starred,@JsonKey(name: 'interview_count') int interviewCount,@JsonKey(name: 'reminder_count') int reminderCount,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class __$ApplicationCopyWithImpl<$Res>
    implements _$ApplicationCopyWith<$Res> {
  __$ApplicationCopyWithImpl(this._self, this._then);

  final _Application _self;
  final $Res Function(_Application) _then;

/// Create a copy of Application
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? companyName = null,Object? jobTitle = null,Object? status = null,Object? jobUrl = freezed,Object? location = freezed,Object? workMode = freezed,Object? jobType = freezed,Object? salaryMin = freezed,Object? salaryMax = freezed,Object? salaryCurrency = null,Object? description = freezed,Object? notes = freezed,Object? companyWebsite = freezed,Object? companyLogo = freezed,Object? contactName = freezed,Object? contactEmail = freezed,Object? contactPhone = freezed,Object? appliedAt = freezed,Object? deadline = freezed,Object? resumeId = freezed,Object? source = freezed,Object? priority = null,Object? starred = null,Object? interviewCount = null,Object? reminderCount = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Application(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,companyName: null == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String,jobTitle: null == jobTitle ? _self.jobTitle : jobTitle // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,jobUrl: freezed == jobUrl ? _self.jobUrl : jobUrl // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,workMode: freezed == workMode ? _self.workMode : workMode // ignore: cast_nullable_to_non_nullable
as String?,jobType: freezed == jobType ? _self.jobType : jobType // ignore: cast_nullable_to_non_nullable
as String?,salaryMin: freezed == salaryMin ? _self.salaryMin : salaryMin // ignore: cast_nullable_to_non_nullable
as int?,salaryMax: freezed == salaryMax ? _self.salaryMax : salaryMax // ignore: cast_nullable_to_non_nullable
as int?,salaryCurrency: null == salaryCurrency ? _self.salaryCurrency : salaryCurrency // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,companyWebsite: freezed == companyWebsite ? _self.companyWebsite : companyWebsite // ignore: cast_nullable_to_non_nullable
as String?,companyLogo: freezed == companyLogo ? _self.companyLogo : companyLogo // ignore: cast_nullable_to_non_nullable
as String?,contactName: freezed == contactName ? _self.contactName : contactName // ignore: cast_nullable_to_non_nullable
as String?,contactEmail: freezed == contactEmail ? _self.contactEmail : contactEmail // ignore: cast_nullable_to_non_nullable
as String?,contactPhone: freezed == contactPhone ? _self.contactPhone : contactPhone // ignore: cast_nullable_to_non_nullable
as String?,appliedAt: freezed == appliedAt ? _self.appliedAt : appliedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deadline: freezed == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as DateTime?,resumeId: freezed == resumeId ? _self.resumeId : resumeId // ignore: cast_nullable_to_non_nullable
as String?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,starred: null == starred ? _self.starred : starred // ignore: cast_nullable_to_non_nullable
as bool,interviewCount: null == interviewCount ? _self.interviewCount : interviewCount // ignore: cast_nullable_to_non_nullable
as int,reminderCount: null == reminderCount ? _self.reminderCount : reminderCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$CreateApplicationRequest {

@JsonKey(name: 'company_name') String get companyName;@JsonKey(name: 'job_title') String get jobTitle; String? get status;@JsonKey(name: 'job_url') String? get jobUrl; String? get location;@JsonKey(name: 'work_mode') String? get workMode;@JsonKey(name: 'job_type') String? get jobType;@JsonKey(name: 'salary_min') int? get salaryMin;@JsonKey(name: 'salary_max') int? get salaryMax; String? get description; String? get notes;@JsonKey(name: 'company_website') String? get companyWebsite;@JsonKey(name: 'contact_name') String? get contactName;@JsonKey(name: 'contact_email') String? get contactEmail;@JsonKey(name: 'contact_phone') String? get contactPhone;@JsonKey(name: 'applied_at') DateTime? get appliedAt;@JsonKey(name: 'deadline') DateTime? get deadline;@JsonKey(name: 'resume_id') String? get resumeId; String? get source; int? get priority;
/// Create a copy of CreateApplicationRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateApplicationRequestCopyWith<CreateApplicationRequest> get copyWith => _$CreateApplicationRequestCopyWithImpl<CreateApplicationRequest>(this as CreateApplicationRequest, _$identity);

  /// Serializes this CreateApplicationRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateApplicationRequest&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.jobTitle, jobTitle) || other.jobTitle == jobTitle)&&(identical(other.status, status) || other.status == status)&&(identical(other.jobUrl, jobUrl) || other.jobUrl == jobUrl)&&(identical(other.location, location) || other.location == location)&&(identical(other.workMode, workMode) || other.workMode == workMode)&&(identical(other.jobType, jobType) || other.jobType == jobType)&&(identical(other.salaryMin, salaryMin) || other.salaryMin == salaryMin)&&(identical(other.salaryMax, salaryMax) || other.salaryMax == salaryMax)&&(identical(other.description, description) || other.description == description)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.companyWebsite, companyWebsite) || other.companyWebsite == companyWebsite)&&(identical(other.contactName, contactName) || other.contactName == contactName)&&(identical(other.contactEmail, contactEmail) || other.contactEmail == contactEmail)&&(identical(other.contactPhone, contactPhone) || other.contactPhone == contactPhone)&&(identical(other.appliedAt, appliedAt) || other.appliedAt == appliedAt)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.resumeId, resumeId) || other.resumeId == resumeId)&&(identical(other.source, source) || other.source == source)&&(identical(other.priority, priority) || other.priority == priority));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,companyName,jobTitle,status,jobUrl,location,workMode,jobType,salaryMin,salaryMax,description,notes,companyWebsite,contactName,contactEmail,contactPhone,appliedAt,deadline,resumeId,source,priority]);

@override
String toString() {
  return 'CreateApplicationRequest(companyName: $companyName, jobTitle: $jobTitle, status: $status, jobUrl: $jobUrl, location: $location, workMode: $workMode, jobType: $jobType, salaryMin: $salaryMin, salaryMax: $salaryMax, description: $description, notes: $notes, companyWebsite: $companyWebsite, contactName: $contactName, contactEmail: $contactEmail, contactPhone: $contactPhone, appliedAt: $appliedAt, deadline: $deadline, resumeId: $resumeId, source: $source, priority: $priority)';
}


}

/// @nodoc
abstract mixin class $CreateApplicationRequestCopyWith<$Res>  {
  factory $CreateApplicationRequestCopyWith(CreateApplicationRequest value, $Res Function(CreateApplicationRequest) _then) = _$CreateApplicationRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'company_name') String companyName,@JsonKey(name: 'job_title') String jobTitle, String? status,@JsonKey(name: 'job_url') String? jobUrl, String? location,@JsonKey(name: 'work_mode') String? workMode,@JsonKey(name: 'job_type') String? jobType,@JsonKey(name: 'salary_min') int? salaryMin,@JsonKey(name: 'salary_max') int? salaryMax, String? description, String? notes,@JsonKey(name: 'company_website') String? companyWebsite,@JsonKey(name: 'contact_name') String? contactName,@JsonKey(name: 'contact_email') String? contactEmail,@JsonKey(name: 'contact_phone') String? contactPhone,@JsonKey(name: 'applied_at') DateTime? appliedAt,@JsonKey(name: 'deadline') DateTime? deadline,@JsonKey(name: 'resume_id') String? resumeId, String? source, int? priority
});




}
/// @nodoc
class _$CreateApplicationRequestCopyWithImpl<$Res>
    implements $CreateApplicationRequestCopyWith<$Res> {
  _$CreateApplicationRequestCopyWithImpl(this._self, this._then);

  final CreateApplicationRequest _self;
  final $Res Function(CreateApplicationRequest) _then;

/// Create a copy of CreateApplicationRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? companyName = null,Object? jobTitle = null,Object? status = freezed,Object? jobUrl = freezed,Object? location = freezed,Object? workMode = freezed,Object? jobType = freezed,Object? salaryMin = freezed,Object? salaryMax = freezed,Object? description = freezed,Object? notes = freezed,Object? companyWebsite = freezed,Object? contactName = freezed,Object? contactEmail = freezed,Object? contactPhone = freezed,Object? appliedAt = freezed,Object? deadline = freezed,Object? resumeId = freezed,Object? source = freezed,Object? priority = freezed,}) {
  return _then(_self.copyWith(
companyName: null == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String,jobTitle: null == jobTitle ? _self.jobTitle : jobTitle // ignore: cast_nullable_to_non_nullable
as String,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,jobUrl: freezed == jobUrl ? _self.jobUrl : jobUrl // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,workMode: freezed == workMode ? _self.workMode : workMode // ignore: cast_nullable_to_non_nullable
as String?,jobType: freezed == jobType ? _self.jobType : jobType // ignore: cast_nullable_to_non_nullable
as String?,salaryMin: freezed == salaryMin ? _self.salaryMin : salaryMin // ignore: cast_nullable_to_non_nullable
as int?,salaryMax: freezed == salaryMax ? _self.salaryMax : salaryMax // ignore: cast_nullable_to_non_nullable
as int?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,companyWebsite: freezed == companyWebsite ? _self.companyWebsite : companyWebsite // ignore: cast_nullable_to_non_nullable
as String?,contactName: freezed == contactName ? _self.contactName : contactName // ignore: cast_nullable_to_non_nullable
as String?,contactEmail: freezed == contactEmail ? _self.contactEmail : contactEmail // ignore: cast_nullable_to_non_nullable
as String?,contactPhone: freezed == contactPhone ? _self.contactPhone : contactPhone // ignore: cast_nullable_to_non_nullable
as String?,appliedAt: freezed == appliedAt ? _self.appliedAt : appliedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deadline: freezed == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as DateTime?,resumeId: freezed == resumeId ? _self.resumeId : resumeId // ignore: cast_nullable_to_non_nullable
as String?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateApplicationRequest].
extension CreateApplicationRequestPatterns on CreateApplicationRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateApplicationRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateApplicationRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateApplicationRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateApplicationRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateApplicationRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateApplicationRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'company_name')  String companyName, @JsonKey(name: 'job_title')  String jobTitle,  String? status, @JsonKey(name: 'job_url')  String? jobUrl,  String? location, @JsonKey(name: 'work_mode')  String? workMode, @JsonKey(name: 'job_type')  String? jobType, @JsonKey(name: 'salary_min')  int? salaryMin, @JsonKey(name: 'salary_max')  int? salaryMax,  String? description,  String? notes, @JsonKey(name: 'company_website')  String? companyWebsite, @JsonKey(name: 'contact_name')  String? contactName, @JsonKey(name: 'contact_email')  String? contactEmail, @JsonKey(name: 'contact_phone')  String? contactPhone, @JsonKey(name: 'applied_at')  DateTime? appliedAt, @JsonKey(name: 'deadline')  DateTime? deadline, @JsonKey(name: 'resume_id')  String? resumeId,  String? source,  int? priority)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateApplicationRequest() when $default != null:
return $default(_that.companyName,_that.jobTitle,_that.status,_that.jobUrl,_that.location,_that.workMode,_that.jobType,_that.salaryMin,_that.salaryMax,_that.description,_that.notes,_that.companyWebsite,_that.contactName,_that.contactEmail,_that.contactPhone,_that.appliedAt,_that.deadline,_that.resumeId,_that.source,_that.priority);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'company_name')  String companyName, @JsonKey(name: 'job_title')  String jobTitle,  String? status, @JsonKey(name: 'job_url')  String? jobUrl,  String? location, @JsonKey(name: 'work_mode')  String? workMode, @JsonKey(name: 'job_type')  String? jobType, @JsonKey(name: 'salary_min')  int? salaryMin, @JsonKey(name: 'salary_max')  int? salaryMax,  String? description,  String? notes, @JsonKey(name: 'company_website')  String? companyWebsite, @JsonKey(name: 'contact_name')  String? contactName, @JsonKey(name: 'contact_email')  String? contactEmail, @JsonKey(name: 'contact_phone')  String? contactPhone, @JsonKey(name: 'applied_at')  DateTime? appliedAt, @JsonKey(name: 'deadline')  DateTime? deadline, @JsonKey(name: 'resume_id')  String? resumeId,  String? source,  int? priority)  $default,) {final _that = this;
switch (_that) {
case _CreateApplicationRequest():
return $default(_that.companyName,_that.jobTitle,_that.status,_that.jobUrl,_that.location,_that.workMode,_that.jobType,_that.salaryMin,_that.salaryMax,_that.description,_that.notes,_that.companyWebsite,_that.contactName,_that.contactEmail,_that.contactPhone,_that.appliedAt,_that.deadline,_that.resumeId,_that.source,_that.priority);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'company_name')  String companyName, @JsonKey(name: 'job_title')  String jobTitle,  String? status, @JsonKey(name: 'job_url')  String? jobUrl,  String? location, @JsonKey(name: 'work_mode')  String? workMode, @JsonKey(name: 'job_type')  String? jobType, @JsonKey(name: 'salary_min')  int? salaryMin, @JsonKey(name: 'salary_max')  int? salaryMax,  String? description,  String? notes, @JsonKey(name: 'company_website')  String? companyWebsite, @JsonKey(name: 'contact_name')  String? contactName, @JsonKey(name: 'contact_email')  String? contactEmail, @JsonKey(name: 'contact_phone')  String? contactPhone, @JsonKey(name: 'applied_at')  DateTime? appliedAt, @JsonKey(name: 'deadline')  DateTime? deadline, @JsonKey(name: 'resume_id')  String? resumeId,  String? source,  int? priority)?  $default,) {final _that = this;
switch (_that) {
case _CreateApplicationRequest() when $default != null:
return $default(_that.companyName,_that.jobTitle,_that.status,_that.jobUrl,_that.location,_that.workMode,_that.jobType,_that.salaryMin,_that.salaryMax,_that.description,_that.notes,_that.companyWebsite,_that.contactName,_that.contactEmail,_that.contactPhone,_that.appliedAt,_that.deadline,_that.resumeId,_that.source,_that.priority);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateApplicationRequest implements CreateApplicationRequest {
  const _CreateApplicationRequest({@JsonKey(name: 'company_name') required this.companyName, @JsonKey(name: 'job_title') required this.jobTitle, this.status, @JsonKey(name: 'job_url') this.jobUrl, this.location, @JsonKey(name: 'work_mode') this.workMode, @JsonKey(name: 'job_type') this.jobType, @JsonKey(name: 'salary_min') this.salaryMin, @JsonKey(name: 'salary_max') this.salaryMax, this.description, this.notes, @JsonKey(name: 'company_website') this.companyWebsite, @JsonKey(name: 'contact_name') this.contactName, @JsonKey(name: 'contact_email') this.contactEmail, @JsonKey(name: 'contact_phone') this.contactPhone, @JsonKey(name: 'applied_at') this.appliedAt, @JsonKey(name: 'deadline') this.deadline, @JsonKey(name: 'resume_id') this.resumeId, this.source, this.priority});
  factory _CreateApplicationRequest.fromJson(Map<String, dynamic> json) => _$CreateApplicationRequestFromJson(json);

@override@JsonKey(name: 'company_name') final  String companyName;
@override@JsonKey(name: 'job_title') final  String jobTitle;
@override final  String? status;
@override@JsonKey(name: 'job_url') final  String? jobUrl;
@override final  String? location;
@override@JsonKey(name: 'work_mode') final  String? workMode;
@override@JsonKey(name: 'job_type') final  String? jobType;
@override@JsonKey(name: 'salary_min') final  int? salaryMin;
@override@JsonKey(name: 'salary_max') final  int? salaryMax;
@override final  String? description;
@override final  String? notes;
@override@JsonKey(name: 'company_website') final  String? companyWebsite;
@override@JsonKey(name: 'contact_name') final  String? contactName;
@override@JsonKey(name: 'contact_email') final  String? contactEmail;
@override@JsonKey(name: 'contact_phone') final  String? contactPhone;
@override@JsonKey(name: 'applied_at') final  DateTime? appliedAt;
@override@JsonKey(name: 'deadline') final  DateTime? deadline;
@override@JsonKey(name: 'resume_id') final  String? resumeId;
@override final  String? source;
@override final  int? priority;

/// Create a copy of CreateApplicationRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateApplicationRequestCopyWith<_CreateApplicationRequest> get copyWith => __$CreateApplicationRequestCopyWithImpl<_CreateApplicationRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateApplicationRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateApplicationRequest&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.jobTitle, jobTitle) || other.jobTitle == jobTitle)&&(identical(other.status, status) || other.status == status)&&(identical(other.jobUrl, jobUrl) || other.jobUrl == jobUrl)&&(identical(other.location, location) || other.location == location)&&(identical(other.workMode, workMode) || other.workMode == workMode)&&(identical(other.jobType, jobType) || other.jobType == jobType)&&(identical(other.salaryMin, salaryMin) || other.salaryMin == salaryMin)&&(identical(other.salaryMax, salaryMax) || other.salaryMax == salaryMax)&&(identical(other.description, description) || other.description == description)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.companyWebsite, companyWebsite) || other.companyWebsite == companyWebsite)&&(identical(other.contactName, contactName) || other.contactName == contactName)&&(identical(other.contactEmail, contactEmail) || other.contactEmail == contactEmail)&&(identical(other.contactPhone, contactPhone) || other.contactPhone == contactPhone)&&(identical(other.appliedAt, appliedAt) || other.appliedAt == appliedAt)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.resumeId, resumeId) || other.resumeId == resumeId)&&(identical(other.source, source) || other.source == source)&&(identical(other.priority, priority) || other.priority == priority));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,companyName,jobTitle,status,jobUrl,location,workMode,jobType,salaryMin,salaryMax,description,notes,companyWebsite,contactName,contactEmail,contactPhone,appliedAt,deadline,resumeId,source,priority]);

@override
String toString() {
  return 'CreateApplicationRequest(companyName: $companyName, jobTitle: $jobTitle, status: $status, jobUrl: $jobUrl, location: $location, workMode: $workMode, jobType: $jobType, salaryMin: $salaryMin, salaryMax: $salaryMax, description: $description, notes: $notes, companyWebsite: $companyWebsite, contactName: $contactName, contactEmail: $contactEmail, contactPhone: $contactPhone, appliedAt: $appliedAt, deadline: $deadline, resumeId: $resumeId, source: $source, priority: $priority)';
}


}

/// @nodoc
abstract mixin class _$CreateApplicationRequestCopyWith<$Res> implements $CreateApplicationRequestCopyWith<$Res> {
  factory _$CreateApplicationRequestCopyWith(_CreateApplicationRequest value, $Res Function(_CreateApplicationRequest) _then) = __$CreateApplicationRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'company_name') String companyName,@JsonKey(name: 'job_title') String jobTitle, String? status,@JsonKey(name: 'job_url') String? jobUrl, String? location,@JsonKey(name: 'work_mode') String? workMode,@JsonKey(name: 'job_type') String? jobType,@JsonKey(name: 'salary_min') int? salaryMin,@JsonKey(name: 'salary_max') int? salaryMax, String? description, String? notes,@JsonKey(name: 'company_website') String? companyWebsite,@JsonKey(name: 'contact_name') String? contactName,@JsonKey(name: 'contact_email') String? contactEmail,@JsonKey(name: 'contact_phone') String? contactPhone,@JsonKey(name: 'applied_at') DateTime? appliedAt,@JsonKey(name: 'deadline') DateTime? deadline,@JsonKey(name: 'resume_id') String? resumeId, String? source, int? priority
});




}
/// @nodoc
class __$CreateApplicationRequestCopyWithImpl<$Res>
    implements _$CreateApplicationRequestCopyWith<$Res> {
  __$CreateApplicationRequestCopyWithImpl(this._self, this._then);

  final _CreateApplicationRequest _self;
  final $Res Function(_CreateApplicationRequest) _then;

/// Create a copy of CreateApplicationRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? companyName = null,Object? jobTitle = null,Object? status = freezed,Object? jobUrl = freezed,Object? location = freezed,Object? workMode = freezed,Object? jobType = freezed,Object? salaryMin = freezed,Object? salaryMax = freezed,Object? description = freezed,Object? notes = freezed,Object? companyWebsite = freezed,Object? contactName = freezed,Object? contactEmail = freezed,Object? contactPhone = freezed,Object? appliedAt = freezed,Object? deadline = freezed,Object? resumeId = freezed,Object? source = freezed,Object? priority = freezed,}) {
  return _then(_CreateApplicationRequest(
companyName: null == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String,jobTitle: null == jobTitle ? _self.jobTitle : jobTitle // ignore: cast_nullable_to_non_nullable
as String,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,jobUrl: freezed == jobUrl ? _self.jobUrl : jobUrl // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,workMode: freezed == workMode ? _self.workMode : workMode // ignore: cast_nullable_to_non_nullable
as String?,jobType: freezed == jobType ? _self.jobType : jobType // ignore: cast_nullable_to_non_nullable
as String?,salaryMin: freezed == salaryMin ? _self.salaryMin : salaryMin // ignore: cast_nullable_to_non_nullable
as int?,salaryMax: freezed == salaryMax ? _self.salaryMax : salaryMax // ignore: cast_nullable_to_non_nullable
as int?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,companyWebsite: freezed == companyWebsite ? _self.companyWebsite : companyWebsite // ignore: cast_nullable_to_non_nullable
as String?,contactName: freezed == contactName ? _self.contactName : contactName // ignore: cast_nullable_to_non_nullable
as String?,contactEmail: freezed == contactEmail ? _self.contactEmail : contactEmail // ignore: cast_nullable_to_non_nullable
as String?,contactPhone: freezed == contactPhone ? _self.contactPhone : contactPhone // ignore: cast_nullable_to_non_nullable
as String?,appliedAt: freezed == appliedAt ? _self.appliedAt : appliedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deadline: freezed == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as DateTime?,resumeId: freezed == resumeId ? _self.resumeId : resumeId // ignore: cast_nullable_to_non_nullable
as String?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$UpdateApplicationRequest {

@JsonKey(name: 'company_name') String? get companyName;@JsonKey(name: 'job_title') String? get jobTitle; String? get status;@JsonKey(name: 'job_url') String? get jobUrl; String? get location;@JsonKey(name: 'work_mode') String? get workMode;@JsonKey(name: 'job_type') String? get jobType;@JsonKey(name: 'salary_min') int? get salaryMin;@JsonKey(name: 'salary_max') int? get salaryMax; String? get description; String? get notes;@JsonKey(name: 'company_website') String? get companyWebsite;@JsonKey(name: 'contact_name') String? get contactName;@JsonKey(name: 'contact_email') String? get contactEmail;@JsonKey(name: 'contact_phone') String? get contactPhone;@JsonKey(name: 'deadline') DateTime? get deadline;@JsonKey(name: 'resume_id') String? get resumeId; String? get source; int? get priority; bool? get starred;
/// Create a copy of UpdateApplicationRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateApplicationRequestCopyWith<UpdateApplicationRequest> get copyWith => _$UpdateApplicationRequestCopyWithImpl<UpdateApplicationRequest>(this as UpdateApplicationRequest, _$identity);

  /// Serializes this UpdateApplicationRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateApplicationRequest&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.jobTitle, jobTitle) || other.jobTitle == jobTitle)&&(identical(other.status, status) || other.status == status)&&(identical(other.jobUrl, jobUrl) || other.jobUrl == jobUrl)&&(identical(other.location, location) || other.location == location)&&(identical(other.workMode, workMode) || other.workMode == workMode)&&(identical(other.jobType, jobType) || other.jobType == jobType)&&(identical(other.salaryMin, salaryMin) || other.salaryMin == salaryMin)&&(identical(other.salaryMax, salaryMax) || other.salaryMax == salaryMax)&&(identical(other.description, description) || other.description == description)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.companyWebsite, companyWebsite) || other.companyWebsite == companyWebsite)&&(identical(other.contactName, contactName) || other.contactName == contactName)&&(identical(other.contactEmail, contactEmail) || other.contactEmail == contactEmail)&&(identical(other.contactPhone, contactPhone) || other.contactPhone == contactPhone)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.resumeId, resumeId) || other.resumeId == resumeId)&&(identical(other.source, source) || other.source == source)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.starred, starred) || other.starred == starred));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,companyName,jobTitle,status,jobUrl,location,workMode,jobType,salaryMin,salaryMax,description,notes,companyWebsite,contactName,contactEmail,contactPhone,deadline,resumeId,source,priority,starred]);

@override
String toString() {
  return 'UpdateApplicationRequest(companyName: $companyName, jobTitle: $jobTitle, status: $status, jobUrl: $jobUrl, location: $location, workMode: $workMode, jobType: $jobType, salaryMin: $salaryMin, salaryMax: $salaryMax, description: $description, notes: $notes, companyWebsite: $companyWebsite, contactName: $contactName, contactEmail: $contactEmail, contactPhone: $contactPhone, deadline: $deadline, resumeId: $resumeId, source: $source, priority: $priority, starred: $starred)';
}


}

/// @nodoc
abstract mixin class $UpdateApplicationRequestCopyWith<$Res>  {
  factory $UpdateApplicationRequestCopyWith(UpdateApplicationRequest value, $Res Function(UpdateApplicationRequest) _then) = _$UpdateApplicationRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'company_name') String? companyName,@JsonKey(name: 'job_title') String? jobTitle, String? status,@JsonKey(name: 'job_url') String? jobUrl, String? location,@JsonKey(name: 'work_mode') String? workMode,@JsonKey(name: 'job_type') String? jobType,@JsonKey(name: 'salary_min') int? salaryMin,@JsonKey(name: 'salary_max') int? salaryMax, String? description, String? notes,@JsonKey(name: 'company_website') String? companyWebsite,@JsonKey(name: 'contact_name') String? contactName,@JsonKey(name: 'contact_email') String? contactEmail,@JsonKey(name: 'contact_phone') String? contactPhone,@JsonKey(name: 'deadline') DateTime? deadline,@JsonKey(name: 'resume_id') String? resumeId, String? source, int? priority, bool? starred
});




}
/// @nodoc
class _$UpdateApplicationRequestCopyWithImpl<$Res>
    implements $UpdateApplicationRequestCopyWith<$Res> {
  _$UpdateApplicationRequestCopyWithImpl(this._self, this._then);

  final UpdateApplicationRequest _self;
  final $Res Function(UpdateApplicationRequest) _then;

/// Create a copy of UpdateApplicationRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? companyName = freezed,Object? jobTitle = freezed,Object? status = freezed,Object? jobUrl = freezed,Object? location = freezed,Object? workMode = freezed,Object? jobType = freezed,Object? salaryMin = freezed,Object? salaryMax = freezed,Object? description = freezed,Object? notes = freezed,Object? companyWebsite = freezed,Object? contactName = freezed,Object? contactEmail = freezed,Object? contactPhone = freezed,Object? deadline = freezed,Object? resumeId = freezed,Object? source = freezed,Object? priority = freezed,Object? starred = freezed,}) {
  return _then(_self.copyWith(
companyName: freezed == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String?,jobTitle: freezed == jobTitle ? _self.jobTitle : jobTitle // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,jobUrl: freezed == jobUrl ? _self.jobUrl : jobUrl // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,workMode: freezed == workMode ? _self.workMode : workMode // ignore: cast_nullable_to_non_nullable
as String?,jobType: freezed == jobType ? _self.jobType : jobType // ignore: cast_nullable_to_non_nullable
as String?,salaryMin: freezed == salaryMin ? _self.salaryMin : salaryMin // ignore: cast_nullable_to_non_nullable
as int?,salaryMax: freezed == salaryMax ? _self.salaryMax : salaryMax // ignore: cast_nullable_to_non_nullable
as int?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,companyWebsite: freezed == companyWebsite ? _self.companyWebsite : companyWebsite // ignore: cast_nullable_to_non_nullable
as String?,contactName: freezed == contactName ? _self.contactName : contactName // ignore: cast_nullable_to_non_nullable
as String?,contactEmail: freezed == contactEmail ? _self.contactEmail : contactEmail // ignore: cast_nullable_to_non_nullable
as String?,contactPhone: freezed == contactPhone ? _self.contactPhone : contactPhone // ignore: cast_nullable_to_non_nullable
as String?,deadline: freezed == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as DateTime?,resumeId: freezed == resumeId ? _self.resumeId : resumeId // ignore: cast_nullable_to_non_nullable
as String?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int?,starred: freezed == starred ? _self.starred : starred // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateApplicationRequest].
extension UpdateApplicationRequestPatterns on UpdateApplicationRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateApplicationRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateApplicationRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateApplicationRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateApplicationRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateApplicationRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateApplicationRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'company_name')  String? companyName, @JsonKey(name: 'job_title')  String? jobTitle,  String? status, @JsonKey(name: 'job_url')  String? jobUrl,  String? location, @JsonKey(name: 'work_mode')  String? workMode, @JsonKey(name: 'job_type')  String? jobType, @JsonKey(name: 'salary_min')  int? salaryMin, @JsonKey(name: 'salary_max')  int? salaryMax,  String? description,  String? notes, @JsonKey(name: 'company_website')  String? companyWebsite, @JsonKey(name: 'contact_name')  String? contactName, @JsonKey(name: 'contact_email')  String? contactEmail, @JsonKey(name: 'contact_phone')  String? contactPhone, @JsonKey(name: 'deadline')  DateTime? deadline, @JsonKey(name: 'resume_id')  String? resumeId,  String? source,  int? priority,  bool? starred)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateApplicationRequest() when $default != null:
return $default(_that.companyName,_that.jobTitle,_that.status,_that.jobUrl,_that.location,_that.workMode,_that.jobType,_that.salaryMin,_that.salaryMax,_that.description,_that.notes,_that.companyWebsite,_that.contactName,_that.contactEmail,_that.contactPhone,_that.deadline,_that.resumeId,_that.source,_that.priority,_that.starred);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'company_name')  String? companyName, @JsonKey(name: 'job_title')  String? jobTitle,  String? status, @JsonKey(name: 'job_url')  String? jobUrl,  String? location, @JsonKey(name: 'work_mode')  String? workMode, @JsonKey(name: 'job_type')  String? jobType, @JsonKey(name: 'salary_min')  int? salaryMin, @JsonKey(name: 'salary_max')  int? salaryMax,  String? description,  String? notes, @JsonKey(name: 'company_website')  String? companyWebsite, @JsonKey(name: 'contact_name')  String? contactName, @JsonKey(name: 'contact_email')  String? contactEmail, @JsonKey(name: 'contact_phone')  String? contactPhone, @JsonKey(name: 'deadline')  DateTime? deadline, @JsonKey(name: 'resume_id')  String? resumeId,  String? source,  int? priority,  bool? starred)  $default,) {final _that = this;
switch (_that) {
case _UpdateApplicationRequest():
return $default(_that.companyName,_that.jobTitle,_that.status,_that.jobUrl,_that.location,_that.workMode,_that.jobType,_that.salaryMin,_that.salaryMax,_that.description,_that.notes,_that.companyWebsite,_that.contactName,_that.contactEmail,_that.contactPhone,_that.deadline,_that.resumeId,_that.source,_that.priority,_that.starred);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'company_name')  String? companyName, @JsonKey(name: 'job_title')  String? jobTitle,  String? status, @JsonKey(name: 'job_url')  String? jobUrl,  String? location, @JsonKey(name: 'work_mode')  String? workMode, @JsonKey(name: 'job_type')  String? jobType, @JsonKey(name: 'salary_min')  int? salaryMin, @JsonKey(name: 'salary_max')  int? salaryMax,  String? description,  String? notes, @JsonKey(name: 'company_website')  String? companyWebsite, @JsonKey(name: 'contact_name')  String? contactName, @JsonKey(name: 'contact_email')  String? contactEmail, @JsonKey(name: 'contact_phone')  String? contactPhone, @JsonKey(name: 'deadline')  DateTime? deadline, @JsonKey(name: 'resume_id')  String? resumeId,  String? source,  int? priority,  bool? starred)?  $default,) {final _that = this;
switch (_that) {
case _UpdateApplicationRequest() when $default != null:
return $default(_that.companyName,_that.jobTitle,_that.status,_that.jobUrl,_that.location,_that.workMode,_that.jobType,_that.salaryMin,_that.salaryMax,_that.description,_that.notes,_that.companyWebsite,_that.contactName,_that.contactEmail,_that.contactPhone,_that.deadline,_that.resumeId,_that.source,_that.priority,_that.starred);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateApplicationRequest implements UpdateApplicationRequest {
  const _UpdateApplicationRequest({@JsonKey(name: 'company_name') this.companyName, @JsonKey(name: 'job_title') this.jobTitle, this.status, @JsonKey(name: 'job_url') this.jobUrl, this.location, @JsonKey(name: 'work_mode') this.workMode, @JsonKey(name: 'job_type') this.jobType, @JsonKey(name: 'salary_min') this.salaryMin, @JsonKey(name: 'salary_max') this.salaryMax, this.description, this.notes, @JsonKey(name: 'company_website') this.companyWebsite, @JsonKey(name: 'contact_name') this.contactName, @JsonKey(name: 'contact_email') this.contactEmail, @JsonKey(name: 'contact_phone') this.contactPhone, @JsonKey(name: 'deadline') this.deadline, @JsonKey(name: 'resume_id') this.resumeId, this.source, this.priority, this.starred});
  factory _UpdateApplicationRequest.fromJson(Map<String, dynamic> json) => _$UpdateApplicationRequestFromJson(json);

@override@JsonKey(name: 'company_name') final  String? companyName;
@override@JsonKey(name: 'job_title') final  String? jobTitle;
@override final  String? status;
@override@JsonKey(name: 'job_url') final  String? jobUrl;
@override final  String? location;
@override@JsonKey(name: 'work_mode') final  String? workMode;
@override@JsonKey(name: 'job_type') final  String? jobType;
@override@JsonKey(name: 'salary_min') final  int? salaryMin;
@override@JsonKey(name: 'salary_max') final  int? salaryMax;
@override final  String? description;
@override final  String? notes;
@override@JsonKey(name: 'company_website') final  String? companyWebsite;
@override@JsonKey(name: 'contact_name') final  String? contactName;
@override@JsonKey(name: 'contact_email') final  String? contactEmail;
@override@JsonKey(name: 'contact_phone') final  String? contactPhone;
@override@JsonKey(name: 'deadline') final  DateTime? deadline;
@override@JsonKey(name: 'resume_id') final  String? resumeId;
@override final  String? source;
@override final  int? priority;
@override final  bool? starred;

/// Create a copy of UpdateApplicationRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateApplicationRequestCopyWith<_UpdateApplicationRequest> get copyWith => __$UpdateApplicationRequestCopyWithImpl<_UpdateApplicationRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateApplicationRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateApplicationRequest&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.jobTitle, jobTitle) || other.jobTitle == jobTitle)&&(identical(other.status, status) || other.status == status)&&(identical(other.jobUrl, jobUrl) || other.jobUrl == jobUrl)&&(identical(other.location, location) || other.location == location)&&(identical(other.workMode, workMode) || other.workMode == workMode)&&(identical(other.jobType, jobType) || other.jobType == jobType)&&(identical(other.salaryMin, salaryMin) || other.salaryMin == salaryMin)&&(identical(other.salaryMax, salaryMax) || other.salaryMax == salaryMax)&&(identical(other.description, description) || other.description == description)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.companyWebsite, companyWebsite) || other.companyWebsite == companyWebsite)&&(identical(other.contactName, contactName) || other.contactName == contactName)&&(identical(other.contactEmail, contactEmail) || other.contactEmail == contactEmail)&&(identical(other.contactPhone, contactPhone) || other.contactPhone == contactPhone)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.resumeId, resumeId) || other.resumeId == resumeId)&&(identical(other.source, source) || other.source == source)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.starred, starred) || other.starred == starred));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,companyName,jobTitle,status,jobUrl,location,workMode,jobType,salaryMin,salaryMax,description,notes,companyWebsite,contactName,contactEmail,contactPhone,deadline,resumeId,source,priority,starred]);

@override
String toString() {
  return 'UpdateApplicationRequest(companyName: $companyName, jobTitle: $jobTitle, status: $status, jobUrl: $jobUrl, location: $location, workMode: $workMode, jobType: $jobType, salaryMin: $salaryMin, salaryMax: $salaryMax, description: $description, notes: $notes, companyWebsite: $companyWebsite, contactName: $contactName, contactEmail: $contactEmail, contactPhone: $contactPhone, deadline: $deadline, resumeId: $resumeId, source: $source, priority: $priority, starred: $starred)';
}


}

/// @nodoc
abstract mixin class _$UpdateApplicationRequestCopyWith<$Res> implements $UpdateApplicationRequestCopyWith<$Res> {
  factory _$UpdateApplicationRequestCopyWith(_UpdateApplicationRequest value, $Res Function(_UpdateApplicationRequest) _then) = __$UpdateApplicationRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'company_name') String? companyName,@JsonKey(name: 'job_title') String? jobTitle, String? status,@JsonKey(name: 'job_url') String? jobUrl, String? location,@JsonKey(name: 'work_mode') String? workMode,@JsonKey(name: 'job_type') String? jobType,@JsonKey(name: 'salary_min') int? salaryMin,@JsonKey(name: 'salary_max') int? salaryMax, String? description, String? notes,@JsonKey(name: 'company_website') String? companyWebsite,@JsonKey(name: 'contact_name') String? contactName,@JsonKey(name: 'contact_email') String? contactEmail,@JsonKey(name: 'contact_phone') String? contactPhone,@JsonKey(name: 'deadline') DateTime? deadline,@JsonKey(name: 'resume_id') String? resumeId, String? source, int? priority, bool? starred
});




}
/// @nodoc
class __$UpdateApplicationRequestCopyWithImpl<$Res>
    implements _$UpdateApplicationRequestCopyWith<$Res> {
  __$UpdateApplicationRequestCopyWithImpl(this._self, this._then);

  final _UpdateApplicationRequest _self;
  final $Res Function(_UpdateApplicationRequest) _then;

/// Create a copy of UpdateApplicationRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? companyName = freezed,Object? jobTitle = freezed,Object? status = freezed,Object? jobUrl = freezed,Object? location = freezed,Object? workMode = freezed,Object? jobType = freezed,Object? salaryMin = freezed,Object? salaryMax = freezed,Object? description = freezed,Object? notes = freezed,Object? companyWebsite = freezed,Object? contactName = freezed,Object? contactEmail = freezed,Object? contactPhone = freezed,Object? deadline = freezed,Object? resumeId = freezed,Object? source = freezed,Object? priority = freezed,Object? starred = freezed,}) {
  return _then(_UpdateApplicationRequest(
companyName: freezed == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String?,jobTitle: freezed == jobTitle ? _self.jobTitle : jobTitle // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,jobUrl: freezed == jobUrl ? _self.jobUrl : jobUrl // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,workMode: freezed == workMode ? _self.workMode : workMode // ignore: cast_nullable_to_non_nullable
as String?,jobType: freezed == jobType ? _self.jobType : jobType // ignore: cast_nullable_to_non_nullable
as String?,salaryMin: freezed == salaryMin ? _self.salaryMin : salaryMin // ignore: cast_nullable_to_non_nullable
as int?,salaryMax: freezed == salaryMax ? _self.salaryMax : salaryMax // ignore: cast_nullable_to_non_nullable
as int?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,companyWebsite: freezed == companyWebsite ? _self.companyWebsite : companyWebsite // ignore: cast_nullable_to_non_nullable
as String?,contactName: freezed == contactName ? _self.contactName : contactName // ignore: cast_nullable_to_non_nullable
as String?,contactEmail: freezed == contactEmail ? _self.contactEmail : contactEmail // ignore: cast_nullable_to_non_nullable
as String?,contactPhone: freezed == contactPhone ? _self.contactPhone : contactPhone // ignore: cast_nullable_to_non_nullable
as String?,deadline: freezed == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as DateTime?,resumeId: freezed == resumeId ? _self.resumeId : resumeId // ignore: cast_nullable_to_non_nullable
as String?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int?,starred: freezed == starred ? _self.starred : starred // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$UpdateStatusRequest {

 String get status;
/// Create a copy of UpdateStatusRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateStatusRequestCopyWith<UpdateStatusRequest> get copyWith => _$UpdateStatusRequestCopyWithImpl<UpdateStatusRequest>(this as UpdateStatusRequest, _$identity);

  /// Serializes this UpdateStatusRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateStatusRequest&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status);

@override
String toString() {
  return 'UpdateStatusRequest(status: $status)';
}


}

/// @nodoc
abstract mixin class $UpdateStatusRequestCopyWith<$Res>  {
  factory $UpdateStatusRequestCopyWith(UpdateStatusRequest value, $Res Function(UpdateStatusRequest) _then) = _$UpdateStatusRequestCopyWithImpl;
@useResult
$Res call({
 String status
});




}
/// @nodoc
class _$UpdateStatusRequestCopyWithImpl<$Res>
    implements $UpdateStatusRequestCopyWith<$Res> {
  _$UpdateStatusRequestCopyWithImpl(this._self, this._then);

  final UpdateStatusRequest _self;
  final $Res Function(UpdateStatusRequest) _then;

/// Create a copy of UpdateStatusRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateStatusRequest].
extension UpdateStatusRequestPatterns on UpdateStatusRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateStatusRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateStatusRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateStatusRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateStatusRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateStatusRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateStatusRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateStatusRequest() when $default != null:
return $default(_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String status)  $default,) {final _that = this;
switch (_that) {
case _UpdateStatusRequest():
return $default(_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String status)?  $default,) {final _that = this;
switch (_that) {
case _UpdateStatusRequest() when $default != null:
return $default(_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateStatusRequest implements UpdateStatusRequest {
  const _UpdateStatusRequest({required this.status});
  factory _UpdateStatusRequest.fromJson(Map<String, dynamic> json) => _$UpdateStatusRequestFromJson(json);

@override final  String status;

/// Create a copy of UpdateStatusRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateStatusRequestCopyWith<_UpdateStatusRequest> get copyWith => __$UpdateStatusRequestCopyWithImpl<_UpdateStatusRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateStatusRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateStatusRequest&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status);

@override
String toString() {
  return 'UpdateStatusRequest(status: $status)';
}


}

/// @nodoc
abstract mixin class _$UpdateStatusRequestCopyWith<$Res> implements $UpdateStatusRequestCopyWith<$Res> {
  factory _$UpdateStatusRequestCopyWith(_UpdateStatusRequest value, $Res Function(_UpdateStatusRequest) _then) = __$UpdateStatusRequestCopyWithImpl;
@override @useResult
$Res call({
 String status
});




}
/// @nodoc
class __$UpdateStatusRequestCopyWithImpl<$Res>
    implements _$UpdateStatusRequestCopyWith<$Res> {
  __$UpdateStatusRequestCopyWithImpl(this._self, this._then);

  final _UpdateStatusRequest _self;
  final $Res Function(_UpdateStatusRequest) _then;

/// Create a copy of UpdateStatusRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,}) {
  return _then(_UpdateStatusRequest(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ApplicationListResponse {

 int get count; String? get next; String? get previous; List<Application> get results;
/// Create a copy of ApplicationListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApplicationListResponseCopyWith<ApplicationListResponse> get copyWith => _$ApplicationListResponseCopyWithImpl<ApplicationListResponse>(this as ApplicationListResponse, _$identity);

  /// Serializes this ApplicationListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApplicationListResponse&&(identical(other.count, count) || other.count == count)&&(identical(other.next, next) || other.next == next)&&(identical(other.previous, previous) || other.previous == previous)&&const DeepCollectionEquality().equals(other.results, results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,next,previous,const DeepCollectionEquality().hash(results));

@override
String toString() {
  return 'ApplicationListResponse(count: $count, next: $next, previous: $previous, results: $results)';
}


}

/// @nodoc
abstract mixin class $ApplicationListResponseCopyWith<$Res>  {
  factory $ApplicationListResponseCopyWith(ApplicationListResponse value, $Res Function(ApplicationListResponse) _then) = _$ApplicationListResponseCopyWithImpl;
@useResult
$Res call({
 int count, String? next, String? previous, List<Application> results
});




}
/// @nodoc
class _$ApplicationListResponseCopyWithImpl<$Res>
    implements $ApplicationListResponseCopyWith<$Res> {
  _$ApplicationListResponseCopyWithImpl(this._self, this._then);

  final ApplicationListResponse _self;
  final $Res Function(ApplicationListResponse) _then;

/// Create a copy of ApplicationListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? count = null,Object? next = freezed,Object? previous = freezed,Object? results = null,}) {
  return _then(_self.copyWith(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,next: freezed == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as String?,previous: freezed == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as String?,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<Application>,
  ));
}

}


/// Adds pattern-matching-related methods to [ApplicationListResponse].
extension ApplicationListResponsePatterns on ApplicationListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApplicationListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApplicationListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApplicationListResponse value)  $default,){
final _that = this;
switch (_that) {
case _ApplicationListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApplicationListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ApplicationListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int count,  String? next,  String? previous,  List<Application> results)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApplicationListResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int count,  String? next,  String? previous,  List<Application> results)  $default,) {final _that = this;
switch (_that) {
case _ApplicationListResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int count,  String? next,  String? previous,  List<Application> results)?  $default,) {final _that = this;
switch (_that) {
case _ApplicationListResponse() when $default != null:
return $default(_that.count,_that.next,_that.previous,_that.results);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApplicationListResponse implements ApplicationListResponse {
  const _ApplicationListResponse({required this.count, this.next, this.previous, required final  List<Application> results}): _results = results;
  factory _ApplicationListResponse.fromJson(Map<String, dynamic> json) => _$ApplicationListResponseFromJson(json);

@override final  int count;
@override final  String? next;
@override final  String? previous;
 final  List<Application> _results;
@override List<Application> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}


/// Create a copy of ApplicationListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApplicationListResponseCopyWith<_ApplicationListResponse> get copyWith => __$ApplicationListResponseCopyWithImpl<_ApplicationListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApplicationListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApplicationListResponse&&(identical(other.count, count) || other.count == count)&&(identical(other.next, next) || other.next == next)&&(identical(other.previous, previous) || other.previous == previous)&&const DeepCollectionEquality().equals(other._results, _results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,next,previous,const DeepCollectionEquality().hash(_results));

@override
String toString() {
  return 'ApplicationListResponse(count: $count, next: $next, previous: $previous, results: $results)';
}


}

/// @nodoc
abstract mixin class _$ApplicationListResponseCopyWith<$Res> implements $ApplicationListResponseCopyWith<$Res> {
  factory _$ApplicationListResponseCopyWith(_ApplicationListResponse value, $Res Function(_ApplicationListResponse) _then) = __$ApplicationListResponseCopyWithImpl;
@override @useResult
$Res call({
 int count, String? next, String? previous, List<Application> results
});




}
/// @nodoc
class __$ApplicationListResponseCopyWithImpl<$Res>
    implements _$ApplicationListResponseCopyWith<$Res> {
  __$ApplicationListResponseCopyWithImpl(this._self, this._then);

  final _ApplicationListResponse _self;
  final $Res Function(_ApplicationListResponse) _then;

/// Create a copy of ApplicationListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? count = null,Object? next = freezed,Object? previous = freezed,Object? results = null,}) {
  return _then(_ApplicationListResponse(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,next: freezed == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as String?,previous: freezed == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as String?,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<Application>,
  ));
}


}


/// @nodoc
mixin _$KanbanColumn {

 String get status; String get label; int get color; List<Application> get applications;
/// Create a copy of KanbanColumn
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KanbanColumnCopyWith<KanbanColumn> get copyWith => _$KanbanColumnCopyWithImpl<KanbanColumn>(this as KanbanColumn, _$identity);

  /// Serializes this KanbanColumn to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KanbanColumn&&(identical(other.status, status) || other.status == status)&&(identical(other.label, label) || other.label == label)&&(identical(other.color, color) || other.color == color)&&const DeepCollectionEquality().equals(other.applications, applications));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,label,color,const DeepCollectionEquality().hash(applications));

@override
String toString() {
  return 'KanbanColumn(status: $status, label: $label, color: $color, applications: $applications)';
}


}

/// @nodoc
abstract mixin class $KanbanColumnCopyWith<$Res>  {
  factory $KanbanColumnCopyWith(KanbanColumn value, $Res Function(KanbanColumn) _then) = _$KanbanColumnCopyWithImpl;
@useResult
$Res call({
 String status, String label, int color, List<Application> applications
});




}
/// @nodoc
class _$KanbanColumnCopyWithImpl<$Res>
    implements $KanbanColumnCopyWith<$Res> {
  _$KanbanColumnCopyWithImpl(this._self, this._then);

  final KanbanColumn _self;
  final $Res Function(KanbanColumn) _then;

/// Create a copy of KanbanColumn
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? label = null,Object? color = null,Object? applications = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as int,applications: null == applications ? _self.applications : applications // ignore: cast_nullable_to_non_nullable
as List<Application>,
  ));
}

}


/// Adds pattern-matching-related methods to [KanbanColumn].
extension KanbanColumnPatterns on KanbanColumn {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KanbanColumn value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KanbanColumn() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KanbanColumn value)  $default,){
final _that = this;
switch (_that) {
case _KanbanColumn():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KanbanColumn value)?  $default,){
final _that = this;
switch (_that) {
case _KanbanColumn() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String status,  String label,  int color,  List<Application> applications)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KanbanColumn() when $default != null:
return $default(_that.status,_that.label,_that.color,_that.applications);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String status,  String label,  int color,  List<Application> applications)  $default,) {final _that = this;
switch (_that) {
case _KanbanColumn():
return $default(_that.status,_that.label,_that.color,_that.applications);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String status,  String label,  int color,  List<Application> applications)?  $default,) {final _that = this;
switch (_that) {
case _KanbanColumn() when $default != null:
return $default(_that.status,_that.label,_that.color,_that.applications);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KanbanColumn implements KanbanColumn {
  const _KanbanColumn({required this.status, required this.label, required this.color, required final  List<Application> applications}): _applications = applications;
  factory _KanbanColumn.fromJson(Map<String, dynamic> json) => _$KanbanColumnFromJson(json);

@override final  String status;
@override final  String label;
@override final  int color;
 final  List<Application> _applications;
@override List<Application> get applications {
  if (_applications is EqualUnmodifiableListView) return _applications;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_applications);
}


/// Create a copy of KanbanColumn
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KanbanColumnCopyWith<_KanbanColumn> get copyWith => __$KanbanColumnCopyWithImpl<_KanbanColumn>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KanbanColumnToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KanbanColumn&&(identical(other.status, status) || other.status == status)&&(identical(other.label, label) || other.label == label)&&(identical(other.color, color) || other.color == color)&&const DeepCollectionEquality().equals(other._applications, _applications));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,label,color,const DeepCollectionEquality().hash(_applications));

@override
String toString() {
  return 'KanbanColumn(status: $status, label: $label, color: $color, applications: $applications)';
}


}

/// @nodoc
abstract mixin class _$KanbanColumnCopyWith<$Res> implements $KanbanColumnCopyWith<$Res> {
  factory _$KanbanColumnCopyWith(_KanbanColumn value, $Res Function(_KanbanColumn) _then) = __$KanbanColumnCopyWithImpl;
@override @useResult
$Res call({
 String status, String label, int color, List<Application> applications
});




}
/// @nodoc
class __$KanbanColumnCopyWithImpl<$Res>
    implements _$KanbanColumnCopyWith<$Res> {
  __$KanbanColumnCopyWithImpl(this._self, this._then);

  final _KanbanColumn _self;
  final $Res Function(_KanbanColumn) _then;

/// Create a copy of KanbanColumn
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? label = null,Object? color = null,Object? applications = null,}) {
  return _then(_KanbanColumn(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as int,applications: null == applications ? _self._applications : applications // ignore: cast_nullable_to_non_nullable
as List<Application>,
  ));
}


}

// dart format on
