import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_model.freezed.dart';
part 'analytics_model.g.dart';

/// Analytics overview response
@freezed
class AnalyticsOverview with _$AnalyticsOverview {
  const factory AnalyticsOverview({
    @JsonKey(name: 'total_applications') @Default(0) int totalApplications,
    @JsonKey(name: 'active_applications') @Default(0) int activeApplications,
    @JsonKey(name: 'interviews_scheduled') @Default(0) int interviewsScheduled,
    @JsonKey(name: 'offers_received') @Default(0) int offersReceived,
    @JsonKey(name: 'response_rate') @Default(0.0) double responseRate,
    @JsonKey(name: 'interview_rate') @Default(0.0) double interviewRate,
    @JsonKey(name: 'offer_rate') @Default(0.0) double offerRate,
    @JsonKey(name: 'avg_response_time_days') double? avgResponseTimeDays,
    @JsonKey(name: 'weekly_goal') @Default(10) int weeklyGoal,
    @JsonKey(name: 'weekly_progress') @Default(0) int weeklyProgress,
    @JsonKey(name: 'status_breakdown') @Default({}) Map<String, int> statusBreakdown,
    @JsonKey(name: 'source_breakdown') @Default({}) Map<String, int> sourceBreakdown,
    @JsonKey(name: 'applications_by_week') @Default([]) List<WeeklyData> applicationsByWeek,
    @JsonKey(name: 'top_companies') @Default([]) List<CompanyStats> topCompanies,
  }) = _AnalyticsOverview;

  factory AnalyticsOverview.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsOverviewFromJson(json);
}

/// Weekly data point
@freezed
class WeeklyData with _$WeeklyData {
  const factory WeeklyData({
    required String week,
    required int count,
  }) = _WeeklyData;

  factory WeeklyData.fromJson(Map<String, dynamic> json) =>
      _$WeeklyDataFromJson(json);
}

/// Company statistics
@freezed
class CompanyStats with _$CompanyStats {
  const factory CompanyStats({
    required String company,
    required int applications,
    required int interviews,
    required int offers,
  }) = _CompanyStats;

  factory CompanyStats.fromJson(Map<String, dynamic> json) =>
      _$CompanyStatsFromJson(json);
}

/// Funnel stage data
@freezed
class FunnelStage with _$FunnelStage {
  const factory FunnelStage({
    required String stage,
    required int count,
    required double percentage,
  }) = _FunnelStage;

  factory FunnelStage.fromJson(Map<String, dynamic> json) =>
      _$FunnelStageFromJson(json);
}
