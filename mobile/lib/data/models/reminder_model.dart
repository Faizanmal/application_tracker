import 'package:freezed_annotation/freezed_annotation.dart';

part 'reminder_model.freezed.dart';
part 'reminder_model.g.dart';

/// Reminder model
@freezed
class Reminder with _$Reminder {
  const factory Reminder({
    required String id,
    @JsonKey(name: 'application_id') String? applicationId,
    @JsonKey(name: 'application') ReminderApplicationSummary? application,
    required String title,
    String? description,
    @JsonKey(name: 'reminder_type') required String reminderType,
    required String status,
    @JsonKey(name: 'due_at') required DateTime dueAt,
    @JsonKey(name: 'snoozed_until') DateTime? snoozedUntil,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _Reminder;

  factory Reminder.fromJson(Map<String, dynamic> json) =>
      _$ReminderFromJson(json);
}

/// Minimal application info for reminder
@freezed
class ReminderApplicationSummary with _$ReminderApplicationSummary {
  const factory ReminderApplicationSummary({
    required String id,
    @JsonKey(name: 'company_name') required String companyName,
    @JsonKey(name: 'job_title') required String jobTitle,
  }) = _ReminderApplicationSummary;

  factory ReminderApplicationSummary.fromJson(Map<String, dynamic> json) =>
      _$ReminderApplicationSummaryFromJson(json);
}

/// Create reminder request
@freezed
class CreateReminderRequest with _$CreateReminderRequest {
  const factory CreateReminderRequest({
    @JsonKey(name: 'application_id') String? applicationId,
    required String title,
    String? description,
    @JsonKey(name: 'reminder_type') required String reminderType,
    @JsonKey(name: 'due_at') required DateTime dueAt,
  }) = _CreateReminderRequest;

  factory CreateReminderRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateReminderRequestFromJson(json);
}

/// Update reminder request
@freezed
class UpdateReminderRequest with _$UpdateReminderRequest {
  const factory UpdateReminderRequest({
    String? title,
    String? description,
    @JsonKey(name: 'reminder_type') String? reminderType,
    @JsonKey(name: 'due_at') DateTime? dueAt,
    String? status,
  }) = _UpdateReminderRequest;

  factory UpdateReminderRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateReminderRequestFromJson(json);
}

/// Snooze reminder request
@freezed
class SnoozeReminderRequest with _$SnoozeReminderRequest {
  const factory SnoozeReminderRequest({
    @JsonKey(name: 'snooze_until') required DateTime snoozeUntil,
  }) = _SnoozeReminderRequest;

  factory SnoozeReminderRequest.fromJson(Map<String, dynamic> json) =>
      _$SnoozeReminderRequestFromJson(json);
}

/// Reminder list response with pagination
@freezed
class ReminderListResponse with _$ReminderListResponse {
  const factory ReminderListResponse({
    required int count,
    String? next,
    String? previous,
    required List<Reminder> results,
  }) = _ReminderListResponse;

  factory ReminderListResponse.fromJson(Map<String, dynamic> json) =>
      _$ReminderListResponseFromJson(json);
}
