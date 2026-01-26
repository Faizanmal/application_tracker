// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Reminder _$ReminderFromJson(Map<String, dynamic> json) => _Reminder(
  id: json['id'] as String,
  applicationId: json['application_id'] as String?,
  application: json['application'] == null
      ? null
      : ReminderApplicationSummary.fromJson(
          json['application'] as Map<String, dynamic>,
        ),
  title: json['title'] as String,
  description: json['description'] as String?,
  reminderType: json['reminder_type'] as String,
  status: json['status'] as String,
  dueAt: DateTime.parse(json['due_at'] as String),
  snoozedUntil: json['snoozed_until'] == null
      ? null
      : DateTime.parse(json['snoozed_until'] as String),
  completedAt: json['completed_at'] == null
      ? null
      : DateTime.parse(json['completed_at'] as String),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$ReminderToJson(_Reminder instance) => <String, dynamic>{
  'id': instance.id,
  'application_id': instance.applicationId,
  'application': instance.application,
  'title': instance.title,
  'description': instance.description,
  'reminder_type': instance.reminderType,
  'status': instance.status,
  'due_at': instance.dueAt.toIso8601String(),
  'snoozed_until': instance.snoozedUntil?.toIso8601String(),
  'completed_at': instance.completedAt?.toIso8601String(),
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};

_ReminderApplicationSummary _$ReminderApplicationSummaryFromJson(
  Map<String, dynamic> json,
) => _ReminderApplicationSummary(
  id: json['id'] as String,
  companyName: json['company_name'] as String,
  jobTitle: json['job_title'] as String,
);

Map<String, dynamic> _$ReminderApplicationSummaryToJson(
  _ReminderApplicationSummary instance,
) => <String, dynamic>{
  'id': instance.id,
  'company_name': instance.companyName,
  'job_title': instance.jobTitle,
};

_CreateReminderRequest _$CreateReminderRequestFromJson(
  Map<String, dynamic> json,
) => _CreateReminderRequest(
  applicationId: json['application_id'] as String?,
  title: json['title'] as String,
  description: json['description'] as String?,
  reminderType: json['reminder_type'] as String,
  dueAt: DateTime.parse(json['due_at'] as String),
);

Map<String, dynamic> _$CreateReminderRequestToJson(
  _CreateReminderRequest instance,
) => <String, dynamic>{
  'application_id': instance.applicationId,
  'title': instance.title,
  'description': instance.description,
  'reminder_type': instance.reminderType,
  'due_at': instance.dueAt.toIso8601String(),
};

_UpdateReminderRequest _$UpdateReminderRequestFromJson(
  Map<String, dynamic> json,
) => _UpdateReminderRequest(
  title: json['title'] as String?,
  description: json['description'] as String?,
  reminderType: json['reminder_type'] as String?,
  dueAt: json['due_at'] == null
      ? null
      : DateTime.parse(json['due_at'] as String),
  status: json['status'] as String?,
);

Map<String, dynamic> _$UpdateReminderRequestToJson(
  _UpdateReminderRequest instance,
) => <String, dynamic>{
  'title': instance.title,
  'description': instance.description,
  'reminder_type': instance.reminderType,
  'due_at': instance.dueAt?.toIso8601String(),
  'status': instance.status,
};

_SnoozeReminderRequest _$SnoozeReminderRequestFromJson(
  Map<String, dynamic> json,
) => _SnoozeReminderRequest(
  snoozeUntil: DateTime.parse(json['snooze_until'] as String),
);

Map<String, dynamic> _$SnoozeReminderRequestToJson(
  _SnoozeReminderRequest instance,
) => <String, dynamic>{'snooze_until': instance.snoozeUntil.toIso8601String()};

_ReminderListResponse _$ReminderListResponseFromJson(
  Map<String, dynamic> json,
) => _ReminderListResponse(
  count: (json['count'] as num).toInt(),
  next: json['next'] as String?,
  previous: json['previous'] as String?,
  results: (json['results'] as List<dynamic>)
      .map((e) => Reminder.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ReminderListResponseToJson(
  _ReminderListResponse instance,
) => <String, dynamic>{
  'count': instance.count,
  'next': instance.next,
  'previous': instance.previous,
  'results': instance.results,
};
