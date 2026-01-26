// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interview_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Interview _$InterviewFromJson(Map<String, dynamic> json) => _Interview(
  id: json['id'] as String,
  applicationId: json['application_id'] as String,
  application: json['application'] == null
      ? null
      : ApplicationSummary.fromJson(
          json['application'] as Map<String, dynamic>,
        ),
  interviewType: json['interview_type'] as String,
  status: json['status'] as String,
  scheduledAt: DateTime.parse(json['scheduled_at'] as String),
  durationMinutes: (json['duration_minutes'] as num?)?.toInt(),
  location: json['location'] as String?,
  meetingLink: json['meeting_link'] as String?,
  interviewerNames: json['interviewer_names'] as String?,
  notes: json['notes'] as String?,
  preparationNotes: json['preparation_notes'] as String?,
  rating: (json['rating'] as num?)?.toInt(),
  feedback: json['feedback'] as String?,
  sendCalendarInvite: json['send_calendar_invite'] as bool? ?? false,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$InterviewToJson(_Interview instance) =>
    <String, dynamic>{
      'id': instance.id,
      'application_id': instance.applicationId,
      'application': instance.application,
      'interview_type': instance.interviewType,
      'status': instance.status,
      'scheduled_at': instance.scheduledAt.toIso8601String(),
      'duration_minutes': instance.durationMinutes,
      'location': instance.location,
      'meeting_link': instance.meetingLink,
      'interviewer_names': instance.interviewerNames,
      'notes': instance.notes,
      'preparation_notes': instance.preparationNotes,
      'rating': instance.rating,
      'feedback': instance.feedback,
      'send_calendar_invite': instance.sendCalendarInvite,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_ApplicationSummary _$ApplicationSummaryFromJson(Map<String, dynamic> json) =>
    _ApplicationSummary(
      id: json['id'] as String,
      companyName: json['company_name'] as String,
      jobTitle: json['job_title'] as String,
      companyLogo: json['company_logo'] as String?,
    );

Map<String, dynamic> _$ApplicationSummaryToJson(_ApplicationSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'company_name': instance.companyName,
      'job_title': instance.jobTitle,
      'company_logo': instance.companyLogo,
    };

_CreateInterviewRequest _$CreateInterviewRequestFromJson(
  Map<String, dynamic> json,
) => _CreateInterviewRequest(
  applicationId: json['application_id'] as String,
  interviewType: json['interview_type'] as String,
  scheduledAt: DateTime.parse(json['scheduled_at'] as String),
  durationMinutes: (json['duration_minutes'] as num?)?.toInt(),
  location: json['location'] as String?,
  meetingLink: json['meeting_link'] as String?,
  interviewerNames: json['interviewer_names'] as String?,
  notes: json['notes'] as String?,
  sendCalendarInvite: json['send_calendar_invite'] as bool? ?? false,
);

Map<String, dynamic> _$CreateInterviewRequestToJson(
  _CreateInterviewRequest instance,
) => <String, dynamic>{
  'application_id': instance.applicationId,
  'interview_type': instance.interviewType,
  'scheduled_at': instance.scheduledAt.toIso8601String(),
  'duration_minutes': instance.durationMinutes,
  'location': instance.location,
  'meeting_link': instance.meetingLink,
  'interviewer_names': instance.interviewerNames,
  'notes': instance.notes,
  'send_calendar_invite': instance.sendCalendarInvite,
};

_UpdateInterviewRequest _$UpdateInterviewRequestFromJson(
  Map<String, dynamic> json,
) => _UpdateInterviewRequest(
  interviewType: json['interview_type'] as String?,
  status: json['status'] as String?,
  scheduledAt: json['scheduled_at'] == null
      ? null
      : DateTime.parse(json['scheduled_at'] as String),
  durationMinutes: (json['duration_minutes'] as num?)?.toInt(),
  location: json['location'] as String?,
  meetingLink: json['meeting_link'] as String?,
  interviewerNames: json['interviewer_names'] as String?,
  notes: json['notes'] as String?,
  preparationNotes: json['preparation_notes'] as String?,
  rating: (json['rating'] as num?)?.toInt(),
  feedback: json['feedback'] as String?,
);

Map<String, dynamic> _$UpdateInterviewRequestToJson(
  _UpdateInterviewRequest instance,
) => <String, dynamic>{
  'interview_type': instance.interviewType,
  'status': instance.status,
  'scheduled_at': instance.scheduledAt?.toIso8601String(),
  'duration_minutes': instance.durationMinutes,
  'location': instance.location,
  'meeting_link': instance.meetingLink,
  'interviewer_names': instance.interviewerNames,
  'notes': instance.notes,
  'preparation_notes': instance.preparationNotes,
  'rating': instance.rating,
  'feedback': instance.feedback,
};

_CompleteInterviewRequest _$CompleteInterviewRequestFromJson(
  Map<String, dynamic> json,
) => _CompleteInterviewRequest(
  rating: (json['rating'] as num).toInt(),
  feedback: json['feedback'] as String?,
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$CompleteInterviewRequestToJson(
  _CompleteInterviewRequest instance,
) => <String, dynamic>{
  'rating': instance.rating,
  'feedback': instance.feedback,
  'notes': instance.notes,
};

_InterviewListResponse _$InterviewListResponseFromJson(
  Map<String, dynamic> json,
) => _InterviewListResponse(
  count: (json['count'] as num).toInt(),
  next: json['next'] as String?,
  previous: json['previous'] as String?,
  results: (json['results'] as List<dynamic>)
      .map((e) => Interview.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$InterviewListResponseToJson(
  _InterviewListResponse instance,
) => <String, dynamic>{
  'count': instance.count,
  'next': instance.next,
  'previous': instance.previous,
  'results': instance.results,
};

_StarResponse _$StarResponseFromJson(Map<String, dynamic> json) =>
    _StarResponse(
      id: json['id'] as String,
      question: json['question'] as String,
      situation: json['situation'] as String?,
      task: json['task'] as String?,
      action: json['action'] as String?,
      result: json['result'] as String?,
    );

Map<String, dynamic> _$StarResponseToJson(_StarResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'question': instance.question,
      'situation': instance.situation,
      'task': instance.task,
      'action': instance.action,
      'result': instance.result,
    };
