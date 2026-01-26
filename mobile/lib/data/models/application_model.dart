import 'package:freezed_annotation/freezed_annotation.dart';

part 'application_model.freezed.dart';
part 'application_model.g.dart';

/// Job application model
@freezed
class Application with _$Application {
  const factory Application({
    required String id,
    @JsonKey(name: 'company_name') required String companyName,
    @JsonKey(name: 'job_title') required String jobTitle,
    required String status,
    @JsonKey(name: 'job_url') String? jobUrl,
    String? location,
    @JsonKey(name: 'work_mode') String? workMode,
    @JsonKey(name: 'job_type') String? jobType,
    @JsonKey(name: 'salary_min') int? salaryMin,
    @JsonKey(name: 'salary_max') int? salaryMax,
    @JsonKey(name: 'salary_currency') @Default('USD') String salaryCurrency,
    String? description,
    String? notes,
    @JsonKey(name: 'company_website') String? companyWebsite,
    @JsonKey(name: 'company_logo') String? companyLogo,
    @JsonKey(name: 'contact_name') String? contactName,
    @JsonKey(name: 'contact_email') String? contactEmail,
    @JsonKey(name: 'contact_phone') String? contactPhone,
    @JsonKey(name: 'applied_at') DateTime? appliedAt,
    @JsonKey(name: 'deadline') DateTime? deadline,
    @JsonKey(name: 'resume_id') String? resumeId,
    @JsonKey(name: 'source') String? source,
    @Default(0) int priority,
    @Default(false) bool starred,
    @JsonKey(name: 'interview_count') @Default(0) int interviewCount,
    @JsonKey(name: 'reminder_count') @Default(0) int reminderCount,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _Application;

  factory Application.fromJson(Map<String, dynamic> json) =>
      _$ApplicationFromJson(json);
}

/// Create application request
@freezed
class CreateApplicationRequest with _$CreateApplicationRequest {
  const factory CreateApplicationRequest({
    @JsonKey(name: 'company_name') required String companyName,
    @JsonKey(name: 'job_title') required String jobTitle,
    String? status,
    @JsonKey(name: 'job_url') String? jobUrl,
    String? location,
    @JsonKey(name: 'work_mode') String? workMode,
    @JsonKey(name: 'job_type') String? jobType,
    @JsonKey(name: 'salary_min') int? salaryMin,
    @JsonKey(name: 'salary_max') int? salaryMax,
    String? description,
    String? notes,
    @JsonKey(name: 'company_website') String? companyWebsite,
    @JsonKey(name: 'contact_name') String? contactName,
    @JsonKey(name: 'contact_email') String? contactEmail,
    @JsonKey(name: 'contact_phone') String? contactPhone,
    @JsonKey(name: 'applied_at') DateTime? appliedAt,
    @JsonKey(name: 'deadline') DateTime? deadline,
    @JsonKey(name: 'resume_id') String? resumeId,
    String? source,
    int? priority,
  }) = _CreateApplicationRequest;

  factory CreateApplicationRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateApplicationRequestFromJson(json);
}

/// Update application request
@freezed
class UpdateApplicationRequest with _$UpdateApplicationRequest {
  const factory UpdateApplicationRequest({
    @JsonKey(name: 'company_name') String? companyName,
    @JsonKey(name: 'job_title') String? jobTitle,
    String? status,
    @JsonKey(name: 'job_url') String? jobUrl,
    String? location,
    @JsonKey(name: 'work_mode') String? workMode,
    @JsonKey(name: 'job_type') String? jobType,
    @JsonKey(name: 'salary_min') int? salaryMin,
    @JsonKey(name: 'salary_max') int? salaryMax,
    String? description,
    String? notes,
    @JsonKey(name: 'company_website') String? companyWebsite,
    @JsonKey(name: 'contact_name') String? contactName,
    @JsonKey(name: 'contact_email') String? contactEmail,
    @JsonKey(name: 'contact_phone') String? contactPhone,
    @JsonKey(name: 'deadline') DateTime? deadline,
    @JsonKey(name: 'resume_id') String? resumeId,
    String? source,
    int? priority,
    bool? starred,
  }) = _UpdateApplicationRequest;

  factory UpdateApplicationRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateApplicationRequestFromJson(json);
}

/// Application status update request
@freezed
class UpdateStatusRequest with _$UpdateStatusRequest {
  const factory UpdateStatusRequest({
    required String status,
  }) = _UpdateStatusRequest;

  factory UpdateStatusRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateStatusRequestFromJson(json);
}

/// Application list response with pagination
@freezed
class ApplicationListResponse with _$ApplicationListResponse {
  const factory ApplicationListResponse({
    required int count,
    String? next,
    String? previous,
    required List<Application> results,
  }) = _ApplicationListResponse;

  factory ApplicationListResponse.fromJson(Map<String, dynamic> json) =>
      _$ApplicationListResponseFromJson(json);
}

/// Applications grouped by status for Kanban
@freezed
class KanbanColumn with _$KanbanColumn {
  const factory KanbanColumn({
    required String status,
    required String label,
    required int color,
    required List<Application> applications,
  }) = _KanbanColumn;

  factory KanbanColumn.fromJson(Map<String, dynamic> json) =>
      _$KanbanColumnFromJson(json);
}
