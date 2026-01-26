// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analytics_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AnalyticsOverview {

@JsonKey(name: 'total_applications') int get totalApplications;@JsonKey(name: 'active_applications') int get activeApplications;@JsonKey(name: 'interviews_scheduled') int get interviewsScheduled;@JsonKey(name: 'offers_received') int get offersReceived;@JsonKey(name: 'response_rate') double get responseRate;@JsonKey(name: 'interview_rate') double get interviewRate;@JsonKey(name: 'offer_rate') double get offerRate;@JsonKey(name: 'avg_response_time_days') double? get avgResponseTimeDays;@JsonKey(name: 'weekly_goal') int get weeklyGoal;@JsonKey(name: 'weekly_progress') int get weeklyProgress;@JsonKey(name: 'status_breakdown') Map<String, int> get statusBreakdown;@JsonKey(name: 'source_breakdown') Map<String, int> get sourceBreakdown;@JsonKey(name: 'applications_by_week') List<WeeklyData> get applicationsByWeek;@JsonKey(name: 'top_companies') List<CompanyStats> get topCompanies;
/// Create a copy of AnalyticsOverview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalyticsOverviewCopyWith<AnalyticsOverview> get copyWith => _$AnalyticsOverviewCopyWithImpl<AnalyticsOverview>(this as AnalyticsOverview, _$identity);

  /// Serializes this AnalyticsOverview to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalyticsOverview&&(identical(other.totalApplications, totalApplications) || other.totalApplications == totalApplications)&&(identical(other.activeApplications, activeApplications) || other.activeApplications == activeApplications)&&(identical(other.interviewsScheduled, interviewsScheduled) || other.interviewsScheduled == interviewsScheduled)&&(identical(other.offersReceived, offersReceived) || other.offersReceived == offersReceived)&&(identical(other.responseRate, responseRate) || other.responseRate == responseRate)&&(identical(other.interviewRate, interviewRate) || other.interviewRate == interviewRate)&&(identical(other.offerRate, offerRate) || other.offerRate == offerRate)&&(identical(other.avgResponseTimeDays, avgResponseTimeDays) || other.avgResponseTimeDays == avgResponseTimeDays)&&(identical(other.weeklyGoal, weeklyGoal) || other.weeklyGoal == weeklyGoal)&&(identical(other.weeklyProgress, weeklyProgress) || other.weeklyProgress == weeklyProgress)&&const DeepCollectionEquality().equals(other.statusBreakdown, statusBreakdown)&&const DeepCollectionEquality().equals(other.sourceBreakdown, sourceBreakdown)&&const DeepCollectionEquality().equals(other.applicationsByWeek, applicationsByWeek)&&const DeepCollectionEquality().equals(other.topCompanies, topCompanies));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalApplications,activeApplications,interviewsScheduled,offersReceived,responseRate,interviewRate,offerRate,avgResponseTimeDays,weeklyGoal,weeklyProgress,const DeepCollectionEquality().hash(statusBreakdown),const DeepCollectionEquality().hash(sourceBreakdown),const DeepCollectionEquality().hash(applicationsByWeek),const DeepCollectionEquality().hash(topCompanies));

@override
String toString() {
  return 'AnalyticsOverview(totalApplications: $totalApplications, activeApplications: $activeApplications, interviewsScheduled: $interviewsScheduled, offersReceived: $offersReceived, responseRate: $responseRate, interviewRate: $interviewRate, offerRate: $offerRate, avgResponseTimeDays: $avgResponseTimeDays, weeklyGoal: $weeklyGoal, weeklyProgress: $weeklyProgress, statusBreakdown: $statusBreakdown, sourceBreakdown: $sourceBreakdown, applicationsByWeek: $applicationsByWeek, topCompanies: $topCompanies)';
}


}

/// @nodoc
abstract mixin class $AnalyticsOverviewCopyWith<$Res>  {
  factory $AnalyticsOverviewCopyWith(AnalyticsOverview value, $Res Function(AnalyticsOverview) _then) = _$AnalyticsOverviewCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'total_applications') int totalApplications,@JsonKey(name: 'active_applications') int activeApplications,@JsonKey(name: 'interviews_scheduled') int interviewsScheduled,@JsonKey(name: 'offers_received') int offersReceived,@JsonKey(name: 'response_rate') double responseRate,@JsonKey(name: 'interview_rate') double interviewRate,@JsonKey(name: 'offer_rate') double offerRate,@JsonKey(name: 'avg_response_time_days') double? avgResponseTimeDays,@JsonKey(name: 'weekly_goal') int weeklyGoal,@JsonKey(name: 'weekly_progress') int weeklyProgress,@JsonKey(name: 'status_breakdown') Map<String, int> statusBreakdown,@JsonKey(name: 'source_breakdown') Map<String, int> sourceBreakdown,@JsonKey(name: 'applications_by_week') List<WeeklyData> applicationsByWeek,@JsonKey(name: 'top_companies') List<CompanyStats> topCompanies
});




}
/// @nodoc
class _$AnalyticsOverviewCopyWithImpl<$Res>
    implements $AnalyticsOverviewCopyWith<$Res> {
  _$AnalyticsOverviewCopyWithImpl(this._self, this._then);

  final AnalyticsOverview _self;
  final $Res Function(AnalyticsOverview) _then;

/// Create a copy of AnalyticsOverview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalApplications = null,Object? activeApplications = null,Object? interviewsScheduled = null,Object? offersReceived = null,Object? responseRate = null,Object? interviewRate = null,Object? offerRate = null,Object? avgResponseTimeDays = freezed,Object? weeklyGoal = null,Object? weeklyProgress = null,Object? statusBreakdown = null,Object? sourceBreakdown = null,Object? applicationsByWeek = null,Object? topCompanies = null,}) {
  return _then(_self.copyWith(
totalApplications: null == totalApplications ? _self.totalApplications : totalApplications // ignore: cast_nullable_to_non_nullable
as int,activeApplications: null == activeApplications ? _self.activeApplications : activeApplications // ignore: cast_nullable_to_non_nullable
as int,interviewsScheduled: null == interviewsScheduled ? _self.interviewsScheduled : interviewsScheduled // ignore: cast_nullable_to_non_nullable
as int,offersReceived: null == offersReceived ? _self.offersReceived : offersReceived // ignore: cast_nullable_to_non_nullable
as int,responseRate: null == responseRate ? _self.responseRate : responseRate // ignore: cast_nullable_to_non_nullable
as double,interviewRate: null == interviewRate ? _self.interviewRate : interviewRate // ignore: cast_nullable_to_non_nullable
as double,offerRate: null == offerRate ? _self.offerRate : offerRate // ignore: cast_nullable_to_non_nullable
as double,avgResponseTimeDays: freezed == avgResponseTimeDays ? _self.avgResponseTimeDays : avgResponseTimeDays // ignore: cast_nullable_to_non_nullable
as double?,weeklyGoal: null == weeklyGoal ? _self.weeklyGoal : weeklyGoal // ignore: cast_nullable_to_non_nullable
as int,weeklyProgress: null == weeklyProgress ? _self.weeklyProgress : weeklyProgress // ignore: cast_nullable_to_non_nullable
as int,statusBreakdown: null == statusBreakdown ? _self.statusBreakdown : statusBreakdown // ignore: cast_nullable_to_non_nullable
as Map<String, int>,sourceBreakdown: null == sourceBreakdown ? _self.sourceBreakdown : sourceBreakdown // ignore: cast_nullable_to_non_nullable
as Map<String, int>,applicationsByWeek: null == applicationsByWeek ? _self.applicationsByWeek : applicationsByWeek // ignore: cast_nullable_to_non_nullable
as List<WeeklyData>,topCompanies: null == topCompanies ? _self.topCompanies : topCompanies // ignore: cast_nullable_to_non_nullable
as List<CompanyStats>,
  ));
}

}


/// Adds pattern-matching-related methods to [AnalyticsOverview].
extension AnalyticsOverviewPatterns on AnalyticsOverview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnalyticsOverview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnalyticsOverview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnalyticsOverview value)  $default,){
final _that = this;
switch (_that) {
case _AnalyticsOverview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnalyticsOverview value)?  $default,){
final _that = this;
switch (_that) {
case _AnalyticsOverview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_applications')  int totalApplications, @JsonKey(name: 'active_applications')  int activeApplications, @JsonKey(name: 'interviews_scheduled')  int interviewsScheduled, @JsonKey(name: 'offers_received')  int offersReceived, @JsonKey(name: 'response_rate')  double responseRate, @JsonKey(name: 'interview_rate')  double interviewRate, @JsonKey(name: 'offer_rate')  double offerRate, @JsonKey(name: 'avg_response_time_days')  double? avgResponseTimeDays, @JsonKey(name: 'weekly_goal')  int weeklyGoal, @JsonKey(name: 'weekly_progress')  int weeklyProgress, @JsonKey(name: 'status_breakdown')  Map<String, int> statusBreakdown, @JsonKey(name: 'source_breakdown')  Map<String, int> sourceBreakdown, @JsonKey(name: 'applications_by_week')  List<WeeklyData> applicationsByWeek, @JsonKey(name: 'top_companies')  List<CompanyStats> topCompanies)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnalyticsOverview() when $default != null:
return $default(_that.totalApplications,_that.activeApplications,_that.interviewsScheduled,_that.offersReceived,_that.responseRate,_that.interviewRate,_that.offerRate,_that.avgResponseTimeDays,_that.weeklyGoal,_that.weeklyProgress,_that.statusBreakdown,_that.sourceBreakdown,_that.applicationsByWeek,_that.topCompanies);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_applications')  int totalApplications, @JsonKey(name: 'active_applications')  int activeApplications, @JsonKey(name: 'interviews_scheduled')  int interviewsScheduled, @JsonKey(name: 'offers_received')  int offersReceived, @JsonKey(name: 'response_rate')  double responseRate, @JsonKey(name: 'interview_rate')  double interviewRate, @JsonKey(name: 'offer_rate')  double offerRate, @JsonKey(name: 'avg_response_time_days')  double? avgResponseTimeDays, @JsonKey(name: 'weekly_goal')  int weeklyGoal, @JsonKey(name: 'weekly_progress')  int weeklyProgress, @JsonKey(name: 'status_breakdown')  Map<String, int> statusBreakdown, @JsonKey(name: 'source_breakdown')  Map<String, int> sourceBreakdown, @JsonKey(name: 'applications_by_week')  List<WeeklyData> applicationsByWeek, @JsonKey(name: 'top_companies')  List<CompanyStats> topCompanies)  $default,) {final _that = this;
switch (_that) {
case _AnalyticsOverview():
return $default(_that.totalApplications,_that.activeApplications,_that.interviewsScheduled,_that.offersReceived,_that.responseRate,_that.interviewRate,_that.offerRate,_that.avgResponseTimeDays,_that.weeklyGoal,_that.weeklyProgress,_that.statusBreakdown,_that.sourceBreakdown,_that.applicationsByWeek,_that.topCompanies);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'total_applications')  int totalApplications, @JsonKey(name: 'active_applications')  int activeApplications, @JsonKey(name: 'interviews_scheduled')  int interviewsScheduled, @JsonKey(name: 'offers_received')  int offersReceived, @JsonKey(name: 'response_rate')  double responseRate, @JsonKey(name: 'interview_rate')  double interviewRate, @JsonKey(name: 'offer_rate')  double offerRate, @JsonKey(name: 'avg_response_time_days')  double? avgResponseTimeDays, @JsonKey(name: 'weekly_goal')  int weeklyGoal, @JsonKey(name: 'weekly_progress')  int weeklyProgress, @JsonKey(name: 'status_breakdown')  Map<String, int> statusBreakdown, @JsonKey(name: 'source_breakdown')  Map<String, int> sourceBreakdown, @JsonKey(name: 'applications_by_week')  List<WeeklyData> applicationsByWeek, @JsonKey(name: 'top_companies')  List<CompanyStats> topCompanies)?  $default,) {final _that = this;
switch (_that) {
case _AnalyticsOverview() when $default != null:
return $default(_that.totalApplications,_that.activeApplications,_that.interviewsScheduled,_that.offersReceived,_that.responseRate,_that.interviewRate,_that.offerRate,_that.avgResponseTimeDays,_that.weeklyGoal,_that.weeklyProgress,_that.statusBreakdown,_that.sourceBreakdown,_that.applicationsByWeek,_that.topCompanies);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnalyticsOverview implements AnalyticsOverview {
  const _AnalyticsOverview({@JsonKey(name: 'total_applications') this.totalApplications = 0, @JsonKey(name: 'active_applications') this.activeApplications = 0, @JsonKey(name: 'interviews_scheduled') this.interviewsScheduled = 0, @JsonKey(name: 'offers_received') this.offersReceived = 0, @JsonKey(name: 'response_rate') this.responseRate = 0.0, @JsonKey(name: 'interview_rate') this.interviewRate = 0.0, @JsonKey(name: 'offer_rate') this.offerRate = 0.0, @JsonKey(name: 'avg_response_time_days') this.avgResponseTimeDays, @JsonKey(name: 'weekly_goal') this.weeklyGoal = 10, @JsonKey(name: 'weekly_progress') this.weeklyProgress = 0, @JsonKey(name: 'status_breakdown') final  Map<String, int> statusBreakdown = const {}, @JsonKey(name: 'source_breakdown') final  Map<String, int> sourceBreakdown = const {}, @JsonKey(name: 'applications_by_week') final  List<WeeklyData> applicationsByWeek = const [], @JsonKey(name: 'top_companies') final  List<CompanyStats> topCompanies = const []}): _statusBreakdown = statusBreakdown,_sourceBreakdown = sourceBreakdown,_applicationsByWeek = applicationsByWeek,_topCompanies = topCompanies;
  factory _AnalyticsOverview.fromJson(Map<String, dynamic> json) => _$AnalyticsOverviewFromJson(json);

@override@JsonKey(name: 'total_applications') final  int totalApplications;
@override@JsonKey(name: 'active_applications') final  int activeApplications;
@override@JsonKey(name: 'interviews_scheduled') final  int interviewsScheduled;
@override@JsonKey(name: 'offers_received') final  int offersReceived;
@override@JsonKey(name: 'response_rate') final  double responseRate;
@override@JsonKey(name: 'interview_rate') final  double interviewRate;
@override@JsonKey(name: 'offer_rate') final  double offerRate;
@override@JsonKey(name: 'avg_response_time_days') final  double? avgResponseTimeDays;
@override@JsonKey(name: 'weekly_goal') final  int weeklyGoal;
@override@JsonKey(name: 'weekly_progress') final  int weeklyProgress;
 final  Map<String, int> _statusBreakdown;
@override@JsonKey(name: 'status_breakdown') Map<String, int> get statusBreakdown {
  if (_statusBreakdown is EqualUnmodifiableMapView) return _statusBreakdown;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_statusBreakdown);
}

 final  Map<String, int> _sourceBreakdown;
@override@JsonKey(name: 'source_breakdown') Map<String, int> get sourceBreakdown {
  if (_sourceBreakdown is EqualUnmodifiableMapView) return _sourceBreakdown;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_sourceBreakdown);
}

 final  List<WeeklyData> _applicationsByWeek;
@override@JsonKey(name: 'applications_by_week') List<WeeklyData> get applicationsByWeek {
  if (_applicationsByWeek is EqualUnmodifiableListView) return _applicationsByWeek;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_applicationsByWeek);
}

 final  List<CompanyStats> _topCompanies;
@override@JsonKey(name: 'top_companies') List<CompanyStats> get topCompanies {
  if (_topCompanies is EqualUnmodifiableListView) return _topCompanies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_topCompanies);
}


/// Create a copy of AnalyticsOverview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnalyticsOverviewCopyWith<_AnalyticsOverview> get copyWith => __$AnalyticsOverviewCopyWithImpl<_AnalyticsOverview>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnalyticsOverviewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalyticsOverview&&(identical(other.totalApplications, totalApplications) || other.totalApplications == totalApplications)&&(identical(other.activeApplications, activeApplications) || other.activeApplications == activeApplications)&&(identical(other.interviewsScheduled, interviewsScheduled) || other.interviewsScheduled == interviewsScheduled)&&(identical(other.offersReceived, offersReceived) || other.offersReceived == offersReceived)&&(identical(other.responseRate, responseRate) || other.responseRate == responseRate)&&(identical(other.interviewRate, interviewRate) || other.interviewRate == interviewRate)&&(identical(other.offerRate, offerRate) || other.offerRate == offerRate)&&(identical(other.avgResponseTimeDays, avgResponseTimeDays) || other.avgResponseTimeDays == avgResponseTimeDays)&&(identical(other.weeklyGoal, weeklyGoal) || other.weeklyGoal == weeklyGoal)&&(identical(other.weeklyProgress, weeklyProgress) || other.weeklyProgress == weeklyProgress)&&const DeepCollectionEquality().equals(other._statusBreakdown, _statusBreakdown)&&const DeepCollectionEquality().equals(other._sourceBreakdown, _sourceBreakdown)&&const DeepCollectionEquality().equals(other._applicationsByWeek, _applicationsByWeek)&&const DeepCollectionEquality().equals(other._topCompanies, _topCompanies));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalApplications,activeApplications,interviewsScheduled,offersReceived,responseRate,interviewRate,offerRate,avgResponseTimeDays,weeklyGoal,weeklyProgress,const DeepCollectionEquality().hash(_statusBreakdown),const DeepCollectionEquality().hash(_sourceBreakdown),const DeepCollectionEquality().hash(_applicationsByWeek),const DeepCollectionEquality().hash(_topCompanies));

@override
String toString() {
  return 'AnalyticsOverview(totalApplications: $totalApplications, activeApplications: $activeApplications, interviewsScheduled: $interviewsScheduled, offersReceived: $offersReceived, responseRate: $responseRate, interviewRate: $interviewRate, offerRate: $offerRate, avgResponseTimeDays: $avgResponseTimeDays, weeklyGoal: $weeklyGoal, weeklyProgress: $weeklyProgress, statusBreakdown: $statusBreakdown, sourceBreakdown: $sourceBreakdown, applicationsByWeek: $applicationsByWeek, topCompanies: $topCompanies)';
}


}

/// @nodoc
abstract mixin class _$AnalyticsOverviewCopyWith<$Res> implements $AnalyticsOverviewCopyWith<$Res> {
  factory _$AnalyticsOverviewCopyWith(_AnalyticsOverview value, $Res Function(_AnalyticsOverview) _then) = __$AnalyticsOverviewCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'total_applications') int totalApplications,@JsonKey(name: 'active_applications') int activeApplications,@JsonKey(name: 'interviews_scheduled') int interviewsScheduled,@JsonKey(name: 'offers_received') int offersReceived,@JsonKey(name: 'response_rate') double responseRate,@JsonKey(name: 'interview_rate') double interviewRate,@JsonKey(name: 'offer_rate') double offerRate,@JsonKey(name: 'avg_response_time_days') double? avgResponseTimeDays,@JsonKey(name: 'weekly_goal') int weeklyGoal,@JsonKey(name: 'weekly_progress') int weeklyProgress,@JsonKey(name: 'status_breakdown') Map<String, int> statusBreakdown,@JsonKey(name: 'source_breakdown') Map<String, int> sourceBreakdown,@JsonKey(name: 'applications_by_week') List<WeeklyData> applicationsByWeek,@JsonKey(name: 'top_companies') List<CompanyStats> topCompanies
});




}
/// @nodoc
class __$AnalyticsOverviewCopyWithImpl<$Res>
    implements _$AnalyticsOverviewCopyWith<$Res> {
  __$AnalyticsOverviewCopyWithImpl(this._self, this._then);

  final _AnalyticsOverview _self;
  final $Res Function(_AnalyticsOverview) _then;

/// Create a copy of AnalyticsOverview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalApplications = null,Object? activeApplications = null,Object? interviewsScheduled = null,Object? offersReceived = null,Object? responseRate = null,Object? interviewRate = null,Object? offerRate = null,Object? avgResponseTimeDays = freezed,Object? weeklyGoal = null,Object? weeklyProgress = null,Object? statusBreakdown = null,Object? sourceBreakdown = null,Object? applicationsByWeek = null,Object? topCompanies = null,}) {
  return _then(_AnalyticsOverview(
totalApplications: null == totalApplications ? _self.totalApplications : totalApplications // ignore: cast_nullable_to_non_nullable
as int,activeApplications: null == activeApplications ? _self.activeApplications : activeApplications // ignore: cast_nullable_to_non_nullable
as int,interviewsScheduled: null == interviewsScheduled ? _self.interviewsScheduled : interviewsScheduled // ignore: cast_nullable_to_non_nullable
as int,offersReceived: null == offersReceived ? _self.offersReceived : offersReceived // ignore: cast_nullable_to_non_nullable
as int,responseRate: null == responseRate ? _self.responseRate : responseRate // ignore: cast_nullable_to_non_nullable
as double,interviewRate: null == interviewRate ? _self.interviewRate : interviewRate // ignore: cast_nullable_to_non_nullable
as double,offerRate: null == offerRate ? _self.offerRate : offerRate // ignore: cast_nullable_to_non_nullable
as double,avgResponseTimeDays: freezed == avgResponseTimeDays ? _self.avgResponseTimeDays : avgResponseTimeDays // ignore: cast_nullable_to_non_nullable
as double?,weeklyGoal: null == weeklyGoal ? _self.weeklyGoal : weeklyGoal // ignore: cast_nullable_to_non_nullable
as int,weeklyProgress: null == weeklyProgress ? _self.weeklyProgress : weeklyProgress // ignore: cast_nullable_to_non_nullable
as int,statusBreakdown: null == statusBreakdown ? _self._statusBreakdown : statusBreakdown // ignore: cast_nullable_to_non_nullable
as Map<String, int>,sourceBreakdown: null == sourceBreakdown ? _self._sourceBreakdown : sourceBreakdown // ignore: cast_nullable_to_non_nullable
as Map<String, int>,applicationsByWeek: null == applicationsByWeek ? _self._applicationsByWeek : applicationsByWeek // ignore: cast_nullable_to_non_nullable
as List<WeeklyData>,topCompanies: null == topCompanies ? _self._topCompanies : topCompanies // ignore: cast_nullable_to_non_nullable
as List<CompanyStats>,
  ));
}


}


/// @nodoc
mixin _$WeeklyData {

 String get week; int get count;
/// Create a copy of WeeklyData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeeklyDataCopyWith<WeeklyData> get copyWith => _$WeeklyDataCopyWithImpl<WeeklyData>(this as WeeklyData, _$identity);

  /// Serializes this WeeklyData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeeklyData&&(identical(other.week, week) || other.week == week)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,week,count);

@override
String toString() {
  return 'WeeklyData(week: $week, count: $count)';
}


}

/// @nodoc
abstract mixin class $WeeklyDataCopyWith<$Res>  {
  factory $WeeklyDataCopyWith(WeeklyData value, $Res Function(WeeklyData) _then) = _$WeeklyDataCopyWithImpl;
@useResult
$Res call({
 String week, int count
});




}
/// @nodoc
class _$WeeklyDataCopyWithImpl<$Res>
    implements $WeeklyDataCopyWith<$Res> {
  _$WeeklyDataCopyWithImpl(this._self, this._then);

  final WeeklyData _self;
  final $Res Function(WeeklyData) _then;

/// Create a copy of WeeklyData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? week = null,Object? count = null,}) {
  return _then(_self.copyWith(
week: null == week ? _self.week : week // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [WeeklyData].
extension WeeklyDataPatterns on WeeklyData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeeklyData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeeklyData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeeklyData value)  $default,){
final _that = this;
switch (_that) {
case _WeeklyData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeeklyData value)?  $default,){
final _that = this;
switch (_that) {
case _WeeklyData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String week,  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeeklyData() when $default != null:
return $default(_that.week,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String week,  int count)  $default,) {final _that = this;
switch (_that) {
case _WeeklyData():
return $default(_that.week,_that.count);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String week,  int count)?  $default,) {final _that = this;
switch (_that) {
case _WeeklyData() when $default != null:
return $default(_that.week,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WeeklyData implements WeeklyData {
  const _WeeklyData({required this.week, required this.count});
  factory _WeeklyData.fromJson(Map<String, dynamic> json) => _$WeeklyDataFromJson(json);

@override final  String week;
@override final  int count;

/// Create a copy of WeeklyData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeeklyDataCopyWith<_WeeklyData> get copyWith => __$WeeklyDataCopyWithImpl<_WeeklyData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeeklyDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeeklyData&&(identical(other.week, week) || other.week == week)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,week,count);

@override
String toString() {
  return 'WeeklyData(week: $week, count: $count)';
}


}

/// @nodoc
abstract mixin class _$WeeklyDataCopyWith<$Res> implements $WeeklyDataCopyWith<$Res> {
  factory _$WeeklyDataCopyWith(_WeeklyData value, $Res Function(_WeeklyData) _then) = __$WeeklyDataCopyWithImpl;
@override @useResult
$Res call({
 String week, int count
});




}
/// @nodoc
class __$WeeklyDataCopyWithImpl<$Res>
    implements _$WeeklyDataCopyWith<$Res> {
  __$WeeklyDataCopyWithImpl(this._self, this._then);

  final _WeeklyData _self;
  final $Res Function(_WeeklyData) _then;

/// Create a copy of WeeklyData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? week = null,Object? count = null,}) {
  return _then(_WeeklyData(
week: null == week ? _self.week : week // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$CompanyStats {

 String get company; int get applications; int get interviews; int get offers;
/// Create a copy of CompanyStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CompanyStatsCopyWith<CompanyStats> get copyWith => _$CompanyStatsCopyWithImpl<CompanyStats>(this as CompanyStats, _$identity);

  /// Serializes this CompanyStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CompanyStats&&(identical(other.company, company) || other.company == company)&&(identical(other.applications, applications) || other.applications == applications)&&(identical(other.interviews, interviews) || other.interviews == interviews)&&(identical(other.offers, offers) || other.offers == offers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,company,applications,interviews,offers);

@override
String toString() {
  return 'CompanyStats(company: $company, applications: $applications, interviews: $interviews, offers: $offers)';
}


}

/// @nodoc
abstract mixin class $CompanyStatsCopyWith<$Res>  {
  factory $CompanyStatsCopyWith(CompanyStats value, $Res Function(CompanyStats) _then) = _$CompanyStatsCopyWithImpl;
@useResult
$Res call({
 String company, int applications, int interviews, int offers
});




}
/// @nodoc
class _$CompanyStatsCopyWithImpl<$Res>
    implements $CompanyStatsCopyWith<$Res> {
  _$CompanyStatsCopyWithImpl(this._self, this._then);

  final CompanyStats _self;
  final $Res Function(CompanyStats) _then;

/// Create a copy of CompanyStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? company = null,Object? applications = null,Object? interviews = null,Object? offers = null,}) {
  return _then(_self.copyWith(
company: null == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as String,applications: null == applications ? _self.applications : applications // ignore: cast_nullable_to_non_nullable
as int,interviews: null == interviews ? _self.interviews : interviews // ignore: cast_nullable_to_non_nullable
as int,offers: null == offers ? _self.offers : offers // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CompanyStats].
extension CompanyStatsPatterns on CompanyStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CompanyStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CompanyStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CompanyStats value)  $default,){
final _that = this;
switch (_that) {
case _CompanyStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CompanyStats value)?  $default,){
final _that = this;
switch (_that) {
case _CompanyStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String company,  int applications,  int interviews,  int offers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CompanyStats() when $default != null:
return $default(_that.company,_that.applications,_that.interviews,_that.offers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String company,  int applications,  int interviews,  int offers)  $default,) {final _that = this;
switch (_that) {
case _CompanyStats():
return $default(_that.company,_that.applications,_that.interviews,_that.offers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String company,  int applications,  int interviews,  int offers)?  $default,) {final _that = this;
switch (_that) {
case _CompanyStats() when $default != null:
return $default(_that.company,_that.applications,_that.interviews,_that.offers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CompanyStats implements CompanyStats {
  const _CompanyStats({required this.company, required this.applications, required this.interviews, required this.offers});
  factory _CompanyStats.fromJson(Map<String, dynamic> json) => _$CompanyStatsFromJson(json);

@override final  String company;
@override final  int applications;
@override final  int interviews;
@override final  int offers;

/// Create a copy of CompanyStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CompanyStatsCopyWith<_CompanyStats> get copyWith => __$CompanyStatsCopyWithImpl<_CompanyStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CompanyStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CompanyStats&&(identical(other.company, company) || other.company == company)&&(identical(other.applications, applications) || other.applications == applications)&&(identical(other.interviews, interviews) || other.interviews == interviews)&&(identical(other.offers, offers) || other.offers == offers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,company,applications,interviews,offers);

@override
String toString() {
  return 'CompanyStats(company: $company, applications: $applications, interviews: $interviews, offers: $offers)';
}


}

/// @nodoc
abstract mixin class _$CompanyStatsCopyWith<$Res> implements $CompanyStatsCopyWith<$Res> {
  factory _$CompanyStatsCopyWith(_CompanyStats value, $Res Function(_CompanyStats) _then) = __$CompanyStatsCopyWithImpl;
@override @useResult
$Res call({
 String company, int applications, int interviews, int offers
});




}
/// @nodoc
class __$CompanyStatsCopyWithImpl<$Res>
    implements _$CompanyStatsCopyWith<$Res> {
  __$CompanyStatsCopyWithImpl(this._self, this._then);

  final _CompanyStats _self;
  final $Res Function(_CompanyStats) _then;

/// Create a copy of CompanyStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? company = null,Object? applications = null,Object? interviews = null,Object? offers = null,}) {
  return _then(_CompanyStats(
company: null == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as String,applications: null == applications ? _self.applications : applications // ignore: cast_nullable_to_non_nullable
as int,interviews: null == interviews ? _self.interviews : interviews // ignore: cast_nullable_to_non_nullable
as int,offers: null == offers ? _self.offers : offers // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$FunnelStage {

 String get stage; int get count; double get percentage;
/// Create a copy of FunnelStage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FunnelStageCopyWith<FunnelStage> get copyWith => _$FunnelStageCopyWithImpl<FunnelStage>(this as FunnelStage, _$identity);

  /// Serializes this FunnelStage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FunnelStage&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.count, count) || other.count == count)&&(identical(other.percentage, percentage) || other.percentage == percentage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stage,count,percentage);

@override
String toString() {
  return 'FunnelStage(stage: $stage, count: $count, percentage: $percentage)';
}


}

/// @nodoc
abstract mixin class $FunnelStageCopyWith<$Res>  {
  factory $FunnelStageCopyWith(FunnelStage value, $Res Function(FunnelStage) _then) = _$FunnelStageCopyWithImpl;
@useResult
$Res call({
 String stage, int count, double percentage
});




}
/// @nodoc
class _$FunnelStageCopyWithImpl<$Res>
    implements $FunnelStageCopyWith<$Res> {
  _$FunnelStageCopyWithImpl(this._self, this._then);

  final FunnelStage _self;
  final $Res Function(FunnelStage) _then;

/// Create a copy of FunnelStage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stage = null,Object? count = null,Object? percentage = null,}) {
  return _then(_self.copyWith(
stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [FunnelStage].
extension FunnelStagePatterns on FunnelStage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FunnelStage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FunnelStage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FunnelStage value)  $default,){
final _that = this;
switch (_that) {
case _FunnelStage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FunnelStage value)?  $default,){
final _that = this;
switch (_that) {
case _FunnelStage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String stage,  int count,  double percentage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FunnelStage() when $default != null:
return $default(_that.stage,_that.count,_that.percentage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String stage,  int count,  double percentage)  $default,) {final _that = this;
switch (_that) {
case _FunnelStage():
return $default(_that.stage,_that.count,_that.percentage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String stage,  int count,  double percentage)?  $default,) {final _that = this;
switch (_that) {
case _FunnelStage() when $default != null:
return $default(_that.stage,_that.count,_that.percentage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FunnelStage implements FunnelStage {
  const _FunnelStage({required this.stage, required this.count, required this.percentage});
  factory _FunnelStage.fromJson(Map<String, dynamic> json) => _$FunnelStageFromJson(json);

@override final  String stage;
@override final  int count;
@override final  double percentage;

/// Create a copy of FunnelStage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FunnelStageCopyWith<_FunnelStage> get copyWith => __$FunnelStageCopyWithImpl<_FunnelStage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FunnelStageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FunnelStage&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.count, count) || other.count == count)&&(identical(other.percentage, percentage) || other.percentage == percentage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stage,count,percentage);

@override
String toString() {
  return 'FunnelStage(stage: $stage, count: $count, percentage: $percentage)';
}


}

/// @nodoc
abstract mixin class _$FunnelStageCopyWith<$Res> implements $FunnelStageCopyWith<$Res> {
  factory _$FunnelStageCopyWith(_FunnelStage value, $Res Function(_FunnelStage) _then) = __$FunnelStageCopyWithImpl;
@override @useResult
$Res call({
 String stage, int count, double percentage
});




}
/// @nodoc
class __$FunnelStageCopyWithImpl<$Res>
    implements _$FunnelStageCopyWith<$Res> {
  __$FunnelStageCopyWithImpl(this._self, this._then);

  final _FunnelStage _self;
  final $Res Function(_FunnelStage) _then;

/// Create a copy of FunnelStage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stage = null,Object? count = null,Object? percentage = null,}) {
  return _then(_FunnelStage(
stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
