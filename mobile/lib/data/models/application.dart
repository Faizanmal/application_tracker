import 'package:hive/hive.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'application.freezed.dart';
part 'application.g.dart';

/// Application status enum
@HiveType(typeId: 11)
enum ApplicationStatus {
  @HiveField(0)
  draft,
  @HiveField(1)
  applied,
  @HiveField(2)
  screening,
  @HiveField(3)
  interviewing,
  @HiveField(4)
  offered,
  @HiveField(5)
  accepted,
  @HiveField(6)
  rejected,
  @HiveField(7)
  withdrawn,
  @HiveField(8)
  archived,
}

/// Work location type
@HiveType(typeId: 12)
enum WorkLocationType {
  @HiveField(0)
  onsite,
  @HiveField(1)
  remote,
  @HiveField(2)
  hybrid,
}

/// Job type
@HiveType(typeId: 13)
enum JobType {
  @HiveField(0)
  fullTime,
  @HiveField(1)
  partTime,
  @HiveField(2)
  contract,
  @HiveField(3)
  internship,
  @HiveField(4)
  freelance,
}

/// Application model
@HiveType(typeId: 0)
class Application extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String companyName;

  @HiveField(2)
  final String jobTitle;

  @HiveField(3)
  final ApplicationStatus status;

  @HiveField(4)
  final String? jobUrl;

  @HiveField(5)
  final String? jobDescription;

  @HiveField(6)
  final String? location;

  @HiveField(7)
  final WorkLocationType? workLocationType;

  @HiveField(8)
  final JobType? jobType;

  @HiveField(9)
  final double? salaryMin;

  @HiveField(10)
  final double? salaryMax;

  @HiveField(11)
  final String? salaryCurrency;

  @HiveField(12)
  final DateTime? appliedDate;

  @HiveField(13)
  final DateTime? deadlineDate;

  @HiveField(14)
  final String? notes;

  @HiveField(15)
  final List<String> tags;

  @HiveField(16)
  final String? contactName;

  @HiveField(17)
  final String? contactEmail;

  @HiveField(18)
  final String? contactPhone;

  @HiveField(19)
  final int priority;

  @HiveField(20)
  final bool isFavorite;

  @HiveField(21)
  final bool isArchived;

  @HiveField(22)
  final DateTime createdAt;

  @HiveField(23)
  final DateTime updatedAt;

  @HiveField(24)
  final String? resumeVersion;

  @HiveField(25)
  final String? coverLetter;

  @HiveField(26)
  final String? source;

  Application({
    required this.id,
    required this.companyName,
    required this.jobTitle,
    this.status = ApplicationStatus.draft,
    this.jobUrl,
    this.jobDescription,
    this.location,
    this.workLocationType,
    this.jobType,
    this.salaryMin,
    this.salaryMax,
    this.salaryCurrency,
    this.appliedDate,
    this.deadlineDate,
    this.notes,
    this.tags = const [],
    this.contactName,
    this.contactEmail,
    this.contactPhone,
    this.priority = 0,
    this.isFavorite = false,
    this.isArchived = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.resumeVersion,
    this.coverLetter,
    this.source,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Application copyWith({
    String? id,
    String? companyName,
    String? jobTitle,
    ApplicationStatus? status,
    String? jobUrl,
    String? jobDescription,
    String? location,
    WorkLocationType? workLocationType,
    JobType? jobType,
    double? salaryMin,
    double? salaryMax,
    String? salaryCurrency,
    DateTime? appliedDate,
    DateTime? deadlineDate,
    String? notes,
    List<String>? tags,
    String? contactName,
    String? contactEmail,
    String? contactPhone,
    int? priority,
    bool? isFavorite,
    bool? isArchived,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? resumeVersion,
    String? coverLetter,
    String? source,
  }) {
    return Application(
      id: id ?? this.id,
      companyName: companyName ?? this.companyName,
      jobTitle: jobTitle ?? this.jobTitle,
      status: status ?? this.status,
      jobUrl: jobUrl ?? this.jobUrl,
      jobDescription: jobDescription ?? this.jobDescription,
      location: location ?? this.location,
      workLocationType: workLocationType ?? this.workLocationType,
      jobType: jobType ?? this.jobType,
      salaryMin: salaryMin ?? this.salaryMin,
      salaryMax: salaryMax ?? this.salaryMax,
      salaryCurrency: salaryCurrency ?? this.salaryCurrency,
      appliedDate: appliedDate ?? this.appliedDate,
      deadlineDate: deadlineDate ?? this.deadlineDate,
      notes: notes ?? this.notes,
      tags: tags ?? this.tags,
      contactName: contactName ?? this.contactName,
      contactEmail: contactEmail ?? this.contactEmail,
      contactPhone: contactPhone ?? this.contactPhone,
      priority: priority ?? this.priority,
      isFavorite: isFavorite ?? this.isFavorite,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      resumeVersion: resumeVersion ?? this.resumeVersion,
      coverLetter: coverLetter ?? this.coverLetter,
      source: source ?? this.source,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_name': companyName,
      'job_title': jobTitle,
      'status': status.name,
      'job_url': jobUrl,
      'job_description': jobDescription,
      'location': location,
      'work_location_type': workLocationType?.name,
      'job_type': jobType?.name,
      'salary_min': salaryMin,
      'salary_max': salaryMax,
      'salary_currency': salaryCurrency,
      'applied_date': appliedDate?.toIso8601String(),
      'deadline_date': deadlineDate?.toIso8601String(),
      'notes': notes,
      'tags': tags,
      'contact_name': contactName,
      'contact_email': contactEmail,
      'contact_phone': contactPhone,
      'priority': priority,
      'is_favorite': isFavorite,
      'is_archived': isArchived,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'resume_version': resumeVersion,
      'cover_letter': coverLetter,
      'source': source,
    };
  }

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      id: json['id'] as String,
      companyName: json['company_name'] as String,
      jobTitle: json['job_title'] as String,
      status: ApplicationStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ApplicationStatus.draft,
      ),
      jobUrl: json['job_url'] as String?,
      jobDescription: json['job_description'] as String?,
      location: json['location'] as String?,
      workLocationType: json['work_location_type'] != null
          ? WorkLocationType.values.firstWhere(
              (e) => e.name == json['work_location_type'],
              orElse: () => WorkLocationType.onsite,
            )
          : null,
      jobType: json['job_type'] != null
          ? JobType.values.firstWhere(
              (e) => e.name == json['job_type'],
              orElse: () => JobType.fullTime,
            )
          : null,
      salaryMin: (json['salary_min'] as num?)?.toDouble(),
      salaryMax: (json['salary_max'] as num?)?.toDouble(),
      salaryCurrency: json['salary_currency'] as String?,
      appliedDate: json['applied_date'] != null
          ? DateTime.parse(json['applied_date'] as String)
          : null,
      deadlineDate: json['deadline_date'] != null
          ? DateTime.parse(json['deadline_date'] as String)
          : null,
      notes: json['notes'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      contactName: json['contact_name'] as String?,
      contactEmail: json['contact_email'] as String?,
      contactPhone: json['contact_phone'] as String?,
      priority: json['priority'] as int? ?? 0,
      isFavorite: json['is_favorite'] as bool? ?? false,
      isArchived: json['is_archived'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      resumeVersion: json['resume_version'] as String?,
      coverLetter: json['cover_letter'] as String?,
      source: json['source'] as String?,
    );
  }

  @override
  String toString() {
    return 'Application(id: $id, companyName: $companyName, jobTitle: $jobTitle, status: $status)';
  }
}

/// Hive adapter for Application
class ApplicationAdapter extends TypeAdapter<Application> {
  @override
  final int typeId = 0;

  @override
  Application read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Application(
      id: fields[0] as String,
      companyName: fields[1] as String,
      jobTitle: fields[2] as String,
      status: fields[3] as ApplicationStatus,
      jobUrl: fields[4] as String?,
      jobDescription: fields[5] as String?,
      location: fields[6] as String?,
      workLocationType: fields[7] as WorkLocationType?,
      jobType: fields[8] as JobType?,
      salaryMin: fields[9] as double?,
      salaryMax: fields[10] as double?,
      salaryCurrency: fields[11] as String?,
      appliedDate: fields[12] as DateTime?,
      deadlineDate: fields[13] as DateTime?,
      notes: fields[14] as String?,
      tags: (fields[15] as List?)?.cast<String>() ?? [],
      contactName: fields[16] as String?,
      contactEmail: fields[17] as String?,
      contactPhone: fields[18] as String?,
      priority: fields[19] as int? ?? 0,
      isFavorite: fields[20] as bool? ?? false,
      isArchived: fields[21] as bool? ?? false,
      createdAt: fields[22] as DateTime?,
      updatedAt: fields[23] as DateTime?,
      resumeVersion: fields[24] as String?,
      coverLetter: fields[25] as String?,
      source: fields[26] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Application obj) {
    writer
      ..writeByte(27)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.companyName)
      ..writeByte(2)
      ..write(obj.jobTitle)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.jobUrl)
      ..writeByte(5)
      ..write(obj.jobDescription)
      ..writeByte(6)
      ..write(obj.location)
      ..writeByte(7)
      ..write(obj.workLocationType)
      ..writeByte(8)
      ..write(obj.jobType)
      ..writeByte(9)
      ..write(obj.salaryMin)
      ..writeByte(10)
      ..write(obj.salaryMax)
      ..writeByte(11)
      ..write(obj.salaryCurrency)
      ..writeByte(12)
      ..write(obj.appliedDate)
      ..writeByte(13)
      ..write(obj.deadlineDate)
      ..writeByte(14)
      ..write(obj.notes)
      ..writeByte(15)
      ..write(obj.tags)
      ..writeByte(16)
      ..write(obj.contactName)
      ..writeByte(17)
      ..write(obj.contactEmail)
      ..writeByte(18)
      ..write(obj.contactPhone)
      ..writeByte(19)
      ..write(obj.priority)
      ..writeByte(20)
      ..write(obj.isFavorite)
      ..writeByte(21)
      ..write(obj.isArchived)
      ..writeByte(22)
      ..write(obj.createdAt)
      ..writeByte(23)
      ..write(obj.updatedAt)
      ..writeByte(24)
      ..write(obj.resumeVersion)
      ..writeByte(25)
      ..write(obj.coverLetter)
      ..writeByte(26)
      ..write(obj.source);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApplicationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

/// Hive adapters for enums
class ApplicationStatusAdapter extends TypeAdapter<ApplicationStatus> {
  @override
  final int typeId = 11;

  @override
  ApplicationStatus read(BinaryReader reader) {
    return ApplicationStatus.values[reader.readByte()];
  }

  @override
  void write(BinaryWriter writer, ApplicationStatus obj) {
    writer.writeByte(obj.index);
  }
}

class WorkLocationTypeAdapter extends TypeAdapter<WorkLocationType> {
  @override
  final int typeId = 12;

  @override
  WorkLocationType read(BinaryReader reader) {
    return WorkLocationType.values[reader.readByte()];
  }

  @override
  void write(BinaryWriter writer, WorkLocationType obj) {
    writer.writeByte(obj.index);
  }
}

class JobTypeAdapter extends TypeAdapter<JobType> {
  @override
  final int typeId = 13;

  @override
  JobType read(BinaryReader reader) {
    return JobType.values[reader.readByte()];
  }

  @override
  void write(BinaryWriter writer, JobType obj) {
    writer.writeByte(obj.index);
  }
}
