// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AnalyticsOverview _$AnalyticsOverviewFromJson(Map<String, dynamic> json) =>
    _AnalyticsOverview(
      totalApplications: (json['total_applications'] as num?)?.toInt() ?? 0,
      activeApplications: (json['active_applications'] as num?)?.toInt() ?? 0,
      interviewsScheduled: (json['interviews_scheduled'] as num?)?.toInt() ?? 0,
      offersReceived: (json['offers_received'] as num?)?.toInt() ?? 0,
      responseRate: (json['response_rate'] as num?)?.toDouble() ?? 0.0,
      interviewRate: (json['interview_rate'] as num?)?.toDouble() ?? 0.0,
      offerRate: (json['offer_rate'] as num?)?.toDouble() ?? 0.0,
      avgResponseTimeDays: (json['avg_response_time_days'] as num?)?.toDouble(),
      weeklyGoal: (json['weekly_goal'] as num?)?.toInt() ?? 10,
      weeklyProgress: (json['weekly_progress'] as num?)?.toInt() ?? 0,
      statusBreakdown:
          (json['status_breakdown'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
      sourceBreakdown:
          (json['source_breakdown'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
      applicationsByWeek:
          (json['applications_by_week'] as List<dynamic>?)
              ?.map((e) => WeeklyData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      topCompanies:
          (json['top_companies'] as List<dynamic>?)
              ?.map((e) => CompanyStats.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$AnalyticsOverviewToJson(_AnalyticsOverview instance) =>
    <String, dynamic>{
      'total_applications': instance.totalApplications,
      'active_applications': instance.activeApplications,
      'interviews_scheduled': instance.interviewsScheduled,
      'offers_received': instance.offersReceived,
      'response_rate': instance.responseRate,
      'interview_rate': instance.interviewRate,
      'offer_rate': instance.offerRate,
      'avg_response_time_days': instance.avgResponseTimeDays,
      'weekly_goal': instance.weeklyGoal,
      'weekly_progress': instance.weeklyProgress,
      'status_breakdown': instance.statusBreakdown,
      'source_breakdown': instance.sourceBreakdown,
      'applications_by_week': instance.applicationsByWeek,
      'top_companies': instance.topCompanies,
    };

_WeeklyData _$WeeklyDataFromJson(Map<String, dynamic> json) => _WeeklyData(
  week: json['week'] as String,
  count: (json['count'] as num).toInt(),
);

Map<String, dynamic> _$WeeklyDataToJson(_WeeklyData instance) =>
    <String, dynamic>{'week': instance.week, 'count': instance.count};

_CompanyStats _$CompanyStatsFromJson(Map<String, dynamic> json) =>
    _CompanyStats(
      company: json['company'] as String,
      applications: (json['applications'] as num).toInt(),
      interviews: (json['interviews'] as num).toInt(),
      offers: (json['offers'] as num).toInt(),
    );

Map<String, dynamic> _$CompanyStatsToJson(_CompanyStats instance) =>
    <String, dynamic>{
      'company': instance.company,
      'applications': instance.applications,
      'interviews': instance.interviews,
      'offers': instance.offers,
    };

_FunnelStage _$FunnelStageFromJson(Map<String, dynamic> json) => _FunnelStage(
  stage: json['stage'] as String,
  count: (json['count'] as num).toInt(),
  percentage: (json['percentage'] as num).toDouble(),
);

Map<String, dynamic> _$FunnelStageToJson(_FunnelStage instance) =>
    <String, dynamic>{
      'stage': instance.stage,
      'count': instance.count,
      'percentage': instance.percentage,
    };
