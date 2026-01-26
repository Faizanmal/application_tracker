import 'package:freezed_annotation/freezed_annotation.dart';

part 'interview_model.freezed.dart';
part 'interview_model.g.dart';

/// Interview model
@freezed
class Interview with _$Interview {
  const factory Interview({
    required String id,
    @JsonKey(name: 'application_id') required String applicationId,
    @JsonKey(name: 'application') ApplicationSummary? application,
    @JsonKey(name: 'interview_type') required String interviewType,
    required String status,
    @JsonKey(name: 'scheduled_at') required DateTime scheduledAt,
    @JsonKey(name: 'duration_minutes') int? durationMinutes,
    String? location,
    @JsonKey(name: 'meeting_link') String? meetingLink,
    @JsonKey(name: 'interviewer_names') String? interviewerNames,
    String? notes,
    @JsonKey(name: 'preparation_notes') String? preparationNotes,
    int? rating,
    String? feedback,
    @JsonKey(name: 'send_calendar_invite') @Default(false) bool sendCalendarInvite,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _Interview;

  factory Interview.fromJson(Map<String, dynamic> json) =>
      _$InterviewFromJson(json);
}

/// Minimal application info for interview
@freezed
class ApplicationSummary with _$ApplicationSummary {
  const factory ApplicationSummary({
    required String id,
    @JsonKey(name: 'company_name') required String companyName,
    @JsonKey(name: 'job_title') required String jobTitle,
    @JsonKey(name: 'company_logo') String? companyLogo,
  }) = _ApplicationSummary;

  factory ApplicationSummary.fromJson(Map<String, dynamic> json) =>
      _$ApplicationSummaryFromJson(json);
}

/// Create interview request
@freezed
class CreateInterviewRequest with _$CreateInterviewRequest {
  const factory CreateInterviewRequest({
    @JsonKey(name: 'application_id') required String applicationId,
    @JsonKey(name: 'interview_type') required String interviewType,
    @JsonKey(name: 'scheduled_at') required DateTime scheduledAt,
    @JsonKey(name: 'duration_minutes') int? durationMinutes,
    String? location,
    @JsonKey(name: 'meeting_link') String? meetingLink,
    @JsonKey(name: 'interviewer_names') String? interviewerNames,
    String? notes,
    @JsonKey(name: 'send_calendar_invite') @Default(false) bool sendCalendarInvite,
  }) = _CreateInterviewRequest;

  factory CreateInterviewRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateInterviewRequestFromJson(json);
}

/// Update interview request
@freezed
class UpdateInterviewRequest with _$UpdateInterviewRequest {
  const factory UpdateInterviewRequest({
    @JsonKey(name: 'interview_type') String? interviewType,
    String? status,
    @JsonKey(name: 'scheduled_at') DateTime? scheduledAt,
    @JsonKey(name: 'duration_minutes') int? durationMinutes,
    String? location,
    @JsonKey(name: 'meeting_link') String? meetingLink,
    @JsonKey(name: 'interviewer_names') String? interviewerNames,
    String? notes,
    @JsonKey(name: 'preparation_notes') String? preparationNotes,
    int? rating,
    String? feedback,
  }) = _UpdateInterviewRequest;

  factory UpdateInterviewRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateInterviewRequestFromJson(json);
}

/// Complete interview request
@freezed
class CompleteInterviewRequest with _$CompleteInterviewRequest {
  const factory CompleteInterviewRequest({
    required int rating,
    String? feedback,
    String? notes,
  }) = _CompleteInterviewRequest;

  factory CompleteInterviewRequest.fromJson(Map<String, dynamic> json) =>
      _$CompleteInterviewRequestFromJson(json);
}

/// Interview list response with pagination
@freezed
class InterviewListResponse with _$InterviewListResponse {
  const factory InterviewListResponse({
    required int count,
    String? next,
    String? previous,
    required List<Interview> results,
  }) = _InterviewListResponse;

  factory InterviewListResponse.fromJson(Map<String, dynamic> json) =>
      _$InterviewListResponseFromJson(json);
}

/// STAR method response for interview prep
@freezed
class StarResponse with _$StarResponse {
  const factory StarResponse({
    required String id,
    required String question,
    String? situation,
    String? task,
    String? action,
    String? result,
  }) = _StarResponse;

  factory StarResponse.fromJson(Map<String, dynamic> json) =>
      _$StarResponseFromJson(json);
}
