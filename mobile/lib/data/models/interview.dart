import 'package:hive/hive.dart';

part 'interview.g.dart';

/// Interview type enum
@HiveType(typeId: 14)
enum InterviewType {
  @HiveField(0)
  phone,
  @HiveField(1)
  video,
  @HiveField(2)
  onsite,
  @HiveField(3)
  technical,
  @HiveField(4)
  behavioral,
  @HiveField(5)
  panel,
  @HiveField(6)
  final_round,
  @HiveField(7)
  other,
}

/// Interview status enum
@HiveType(typeId: 15)
enum InterviewStatus {
  @HiveField(0)
  scheduled,
  @HiveField(1)
  completed,
  @HiveField(2)
  cancelled,
  @HiveField(3)
  rescheduled,
  @HiveField(4)
  no_show,
}

/// Interview model
@HiveType(typeId: 1)
class Interview extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String applicationId;

  @HiveField(2)
  final InterviewType type;

  @HiveField(3)
  final InterviewStatus status;

  @HiveField(4)
  final DateTime scheduledAt;

  @HiveField(5)
  final int durationMinutes;

  @HiveField(6)
  final String? location;

  @HiveField(7)
  final String? meetingUrl;

  @HiveField(8)
  final String? meetingId;

  @HiveField(9)
  final String? meetingPassword;

  @HiveField(10)
  final String? interviewerName;

  @HiveField(11)
  final String? interviewerTitle;

  @HiveField(12)
  final String? interviewerEmail;

  @HiveField(13)
  final String? notes;

  @HiveField(14)
  final String? preparationNotes;

  @HiveField(15)
  final String? feedback;

  @HiveField(16)
  final int? rating;

  @HiveField(17)
  final List<String> topics;

  @HiveField(18)
  final String? companyName;

  @HiveField(19)
  final String? jobTitle;

  @HiveField(20)
  final bool reminderSent;

  @HiveField(21)
  final DateTime createdAt;

  @HiveField(22)
  final DateTime updatedAt;

  Interview({
    required this.id,
    required this.applicationId,
    required this.type,
    this.status = InterviewStatus.scheduled,
    required this.scheduledAt,
    this.durationMinutes = 60,
    this.location,
    this.meetingUrl,
    this.meetingId,
    this.meetingPassword,
    this.interviewerName,
    this.interviewerTitle,
    this.interviewerEmail,
    this.notes,
    this.preparationNotes,
    this.feedback,
    this.rating,
    this.topics = const [],
    this.companyName,
    this.jobTitle,
    this.reminderSent = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Interview copyWith({
    String? id,
    String? applicationId,
    InterviewType? type,
    InterviewStatus? status,
    DateTime? scheduledAt,
    int? durationMinutes,
    String? location,
    String? meetingUrl,
    String? meetingId,
    String? meetingPassword,
    String? interviewerName,
    String? interviewerTitle,
    String? interviewerEmail,
    String? notes,
    String? preparationNotes,
    String? feedback,
    int? rating,
    List<String>? topics,
    String? companyName,
    String? jobTitle,
    bool? reminderSent,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Interview(
      id: id ?? this.id,
      applicationId: applicationId ?? this.applicationId,
      type: type ?? this.type,
      status: status ?? this.status,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      location: location ?? this.location,
      meetingUrl: meetingUrl ?? this.meetingUrl,
      meetingId: meetingId ?? this.meetingId,
      meetingPassword: meetingPassword ?? this.meetingPassword,
      interviewerName: interviewerName ?? this.interviewerName,
      interviewerTitle: interviewerTitle ?? this.interviewerTitle,
      interviewerEmail: interviewerEmail ?? this.interviewerEmail,
      notes: notes ?? this.notes,
      preparationNotes: preparationNotes ?? this.preparationNotes,
      feedback: feedback ?? this.feedback,
      rating: rating ?? this.rating,
      topics: topics ?? this.topics,
      companyName: companyName ?? this.companyName,
      jobTitle: jobTitle ?? this.jobTitle,
      reminderSent: reminderSent ?? this.reminderSent,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  DateTime get endTime => scheduledAt.add(Duration(minutes: durationMinutes));

  bool get isUpcoming => scheduledAt.isAfter(DateTime.now());

  bool get isPast => scheduledAt.isBefore(DateTime.now());

  bool get isToday {
    final now = DateTime.now();
    return scheduledAt.year == now.year &&
        scheduledAt.month == now.month &&
        scheduledAt.day == now.day;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'application_id': applicationId,
      'type': type.name,
      'status': status.name,
      'scheduled_at': scheduledAt.toIso8601String(),
      'duration_minutes': durationMinutes,
      'location': location,
      'meeting_url': meetingUrl,
      'meeting_id': meetingId,
      'meeting_password': meetingPassword,
      'interviewer_name': interviewerName,
      'interviewer_title': interviewerTitle,
      'interviewer_email': interviewerEmail,
      'notes': notes,
      'preparation_notes': preparationNotes,
      'feedback': feedback,
      'rating': rating,
      'topics': topics,
      'company_name': companyName,
      'job_title': jobTitle,
      'reminder_sent': reminderSent,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Interview.fromJson(Map<String, dynamic> json) {
    return Interview(
      id: json['id'] as String,
      applicationId: json['application_id'] as String,
      type: InterviewType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => InterviewType.other,
      ),
      status: InterviewStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => InterviewStatus.scheduled,
      ),
      scheduledAt: DateTime.parse(json['scheduled_at'] as String),
      durationMinutes: json['duration_minutes'] as int? ?? 60,
      location: json['location'] as String?,
      meetingUrl: json['meeting_url'] as String?,
      meetingId: json['meeting_id'] as String?,
      meetingPassword: json['meeting_password'] as String?,
      interviewerName: json['interviewer_name'] as String?,
      interviewerTitle: json['interviewer_title'] as String?,
      interviewerEmail: json['interviewer_email'] as String?,
      notes: json['notes'] as String?,
      preparationNotes: json['preparation_notes'] as String?,
      feedback: json['feedback'] as String?,
      rating: json['rating'] as int?,
      topics: (json['topics'] as List<dynamic>?)?.cast<String>() ?? [],
      companyName: json['company_name'] as String?,
      jobTitle: json['job_title'] as String?,
      reminderSent: json['reminder_sent'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  @override
  String toString() {
    return 'Interview(id: $id, type: $type, status: $status, scheduledAt: $scheduledAt)';
  }
}

/// Hive adapter for Interview
class InterviewAdapter extends TypeAdapter<Interview> {
  @override
  final int typeId = 1;

  @override
  Interview read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Interview(
      id: fields[0] as String,
      applicationId: fields[1] as String,
      type: fields[2] as InterviewType,
      status: fields[3] as InterviewStatus,
      scheduledAt: fields[4] as DateTime,
      durationMinutes: fields[5] as int? ?? 60,
      location: fields[6] as String?,
      meetingUrl: fields[7] as String?,
      meetingId: fields[8] as String?,
      meetingPassword: fields[9] as String?,
      interviewerName: fields[10] as String?,
      interviewerTitle: fields[11] as String?,
      interviewerEmail: fields[12] as String?,
      notes: fields[13] as String?,
      preparationNotes: fields[14] as String?,
      feedback: fields[15] as String?,
      rating: fields[16] as int?,
      topics: (fields[17] as List?)?.cast<String>() ?? [],
      companyName: fields[18] as String?,
      jobTitle: fields[19] as String?,
      reminderSent: fields[20] as bool? ?? false,
      createdAt: fields[21] as DateTime?,
      updatedAt: fields[22] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Interview obj) {
    writer
      ..writeByte(23)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.applicationId)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.scheduledAt)
      ..writeByte(5)
      ..write(obj.durationMinutes)
      ..writeByte(6)
      ..write(obj.location)
      ..writeByte(7)
      ..write(obj.meetingUrl)
      ..writeByte(8)
      ..write(obj.meetingId)
      ..writeByte(9)
      ..write(obj.meetingPassword)
      ..writeByte(10)
      ..write(obj.interviewerName)
      ..writeByte(11)
      ..write(obj.interviewerTitle)
      ..writeByte(12)
      ..write(obj.interviewerEmail)
      ..writeByte(13)
      ..write(obj.notes)
      ..writeByte(14)
      ..write(obj.preparationNotes)
      ..writeByte(15)
      ..write(obj.feedback)
      ..writeByte(16)
      ..write(obj.rating)
      ..writeByte(17)
      ..write(obj.topics)
      ..writeByte(18)
      ..write(obj.companyName)
      ..writeByte(19)
      ..write(obj.jobTitle)
      ..writeByte(20)
      ..write(obj.reminderSent)
      ..writeByte(21)
      ..write(obj.createdAt)
      ..writeByte(22)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InterviewAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

/// Hive adapters for enums
class InterviewTypeAdapter extends TypeAdapter<InterviewType> {
  @override
  final int typeId = 14;

  @override
  InterviewType read(BinaryReader reader) {
    return InterviewType.values[reader.readByte()];
  }

  @override
  void write(BinaryWriter writer, InterviewType obj) {
    writer.writeByte(obj.index);
  }
}

class InterviewStatusAdapter extends TypeAdapter<InterviewStatus> {
  @override
  final int typeId = 15;

  @override
  InterviewStatus read(BinaryReader reader) {
    return InterviewStatus.values[reader.readByte()];
  }

  @override
  void write(BinaryWriter writer, InterviewStatus obj) {
    writer.writeByte(obj.index);
  }
}
