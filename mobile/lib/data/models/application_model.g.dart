// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Application _$ApplicationFromJson(Map<String, dynamic> json) => _Application(
  id: json['id'] as String,
  companyName: json['company_name'] as String,
  jobTitle: json['job_title'] as String,
  status: json['status'] as String,
  jobUrl: json['job_url'] as String?,
  location: json['location'] as String?,
  workMode: json['work_mode'] as String?,
  jobType: json['job_type'] as String?,
  salaryMin: (json['salary_min'] as num?)?.toInt(),
  salaryMax: (json['salary_max'] as num?)?.toInt(),
  salaryCurrency: json['salary_currency'] as String? ?? 'USD',
  description: json['description'] as String?,
  notes: json['notes'] as String?,
  companyWebsite: json['company_website'] as String?,
  companyLogo: json['company_logo'] as String?,
  contactName: json['contact_name'] as String?,
  contactEmail: json['contact_email'] as String?,
  contactPhone: json['contact_phone'] as String?,
  appliedAt: json['applied_at'] == null
      ? null
      : DateTime.parse(json['applied_at'] as String),
  deadline: json['deadline'] == null
      ? null
      : DateTime.parse(json['deadline'] as String),
  resumeId: json['resume_id'] as String?,
  source: json['source'] as String?,
  priority: (json['priority'] as num?)?.toInt() ?? 0,
  starred: json['starred'] as bool? ?? false,
  interviewCount: (json['interview_count'] as num?)?.toInt() ?? 0,
  reminderCount: (json['reminder_count'] as num?)?.toInt() ?? 0,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$ApplicationToJson(_Application instance) =>
    <String, dynamic>{
      'id': instance.id,
      'company_name': instance.companyName,
      'job_title': instance.jobTitle,
      'status': instance.status,
      'job_url': instance.jobUrl,
      'location': instance.location,
      'work_mode': instance.workMode,
      'job_type': instance.jobType,
      'salary_min': instance.salaryMin,
      'salary_max': instance.salaryMax,
      'salary_currency': instance.salaryCurrency,
      'description': instance.description,
      'notes': instance.notes,
      'company_website': instance.companyWebsite,
      'company_logo': instance.companyLogo,
      'contact_name': instance.contactName,
      'contact_email': instance.contactEmail,
      'contact_phone': instance.contactPhone,
      'applied_at': instance.appliedAt?.toIso8601String(),
      'deadline': instance.deadline?.toIso8601String(),
      'resume_id': instance.resumeId,
      'source': instance.source,
      'priority': instance.priority,
      'starred': instance.starred,
      'interview_count': instance.interviewCount,
      'reminder_count': instance.reminderCount,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_CreateApplicationRequest _$CreateApplicationRequestFromJson(
  Map<String, dynamic> json,
) => _CreateApplicationRequest(
  companyName: json['company_name'] as String,
  jobTitle: json['job_title'] as String,
  status: json['status'] as String?,
  jobUrl: json['job_url'] as String?,
  location: json['location'] as String?,
  workMode: json['work_mode'] as String?,
  jobType: json['job_type'] as String?,
  salaryMin: (json['salary_min'] as num?)?.toInt(),
  salaryMax: (json['salary_max'] as num?)?.toInt(),
  description: json['description'] as String?,
  notes: json['notes'] as String?,
  companyWebsite: json['company_website'] as String?,
  contactName: json['contact_name'] as String?,
  contactEmail: json['contact_email'] as String?,
  contactPhone: json['contact_phone'] as String?,
  appliedAt: json['applied_at'] == null
      ? null
      : DateTime.parse(json['applied_at'] as String),
  deadline: json['deadline'] == null
      ? null
      : DateTime.parse(json['deadline'] as String),
  resumeId: json['resume_id'] as String?,
  source: json['source'] as String?,
  priority: (json['priority'] as num?)?.toInt(),
);

Map<String, dynamic> _$CreateApplicationRequestToJson(
  _CreateApplicationRequest instance,
) => <String, dynamic>{
  'company_name': instance.companyName,
  'job_title': instance.jobTitle,
  'status': instance.status,
  'job_url': instance.jobUrl,
  'location': instance.location,
  'work_mode': instance.workMode,
  'job_type': instance.jobType,
  'salary_min': instance.salaryMin,
  'salary_max': instance.salaryMax,
  'description': instance.description,
  'notes': instance.notes,
  'company_website': instance.companyWebsite,
  'contact_name': instance.contactName,
  'contact_email': instance.contactEmail,
  'contact_phone': instance.contactPhone,
  'applied_at': instance.appliedAt?.toIso8601String(),
  'deadline': instance.deadline?.toIso8601String(),
  'resume_id': instance.resumeId,
  'source': instance.source,
  'priority': instance.priority,
};

_UpdateApplicationRequest _$UpdateApplicationRequestFromJson(
  Map<String, dynamic> json,
) => _UpdateApplicationRequest(
  companyName: json['company_name'] as String?,
  jobTitle: json['job_title'] as String?,
  status: json['status'] as String?,
  jobUrl: json['job_url'] as String?,
  location: json['location'] as String?,
  workMode: json['work_mode'] as String?,
  jobType: json['job_type'] as String?,
  salaryMin: (json['salary_min'] as num?)?.toInt(),
  salaryMax: (json['salary_max'] as num?)?.toInt(),
  description: json['description'] as String?,
  notes: json['notes'] as String?,
  companyWebsite: json['company_website'] as String?,
  contactName: json['contact_name'] as String?,
  contactEmail: json['contact_email'] as String?,
  contactPhone: json['contact_phone'] as String?,
  deadline: json['deadline'] == null
      ? null
      : DateTime.parse(json['deadline'] as String),
  resumeId: json['resume_id'] as String?,
  source: json['source'] as String?,
  priority: (json['priority'] as num?)?.toInt(),
  starred: json['starred'] as bool?,
);

Map<String, dynamic> _$UpdateApplicationRequestToJson(
  _UpdateApplicationRequest instance,
) => <String, dynamic>{
  'company_name': instance.companyName,
  'job_title': instance.jobTitle,
  'status': instance.status,
  'job_url': instance.jobUrl,
  'location': instance.location,
  'work_mode': instance.workMode,
  'job_type': instance.jobType,
  'salary_min': instance.salaryMin,
  'salary_max': instance.salaryMax,
  'description': instance.description,
  'notes': instance.notes,
  'company_website': instance.companyWebsite,
  'contact_name': instance.contactName,
  'contact_email': instance.contactEmail,
  'contact_phone': instance.contactPhone,
  'deadline': instance.deadline?.toIso8601String(),
  'resume_id': instance.resumeId,
  'source': instance.source,
  'priority': instance.priority,
  'starred': instance.starred,
};

_UpdateStatusRequest _$UpdateStatusRequestFromJson(Map<String, dynamic> json) =>
    _UpdateStatusRequest(status: json['status'] as String);

Map<String, dynamic> _$UpdateStatusRequestToJson(
  _UpdateStatusRequest instance,
) => <String, dynamic>{'status': instance.status};

_ApplicationListResponse _$ApplicationListResponseFromJson(
  Map<String, dynamic> json,
) => _ApplicationListResponse(
  count: (json['count'] as num).toInt(),
  next: json['next'] as String?,
  previous: json['previous'] as String?,
  results: (json['results'] as List<dynamic>)
      .map((e) => Application.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ApplicationListResponseToJson(
  _ApplicationListResponse instance,
) => <String, dynamic>{
  'count': instance.count,
  'next': instance.next,
  'previous': instance.previous,
  'results': instance.results,
};

_KanbanColumn _$KanbanColumnFromJson(Map<String, dynamic> json) =>
    _KanbanColumn(
      status: json['status'] as String,
      label: json['label'] as String,
      color: (json['color'] as num).toInt(),
      applications: (json['applications'] as List<dynamic>)
          .map((e) => Application.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$KanbanColumnToJson(_KanbanColumn instance) =>
    <String, dynamic>{
      'status': instance.status,
      'label': instance.label,
      'color': instance.color,
      'applications': instance.applications,
    };
