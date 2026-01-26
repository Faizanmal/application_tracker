// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resume_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Resume _$ResumeFromJson(Map<String, dynamic> json) => _Resume(
  id: json['id'] as String,
  name: json['name'] as String,
  fileUrl: json['file_url'] as String,
  fileName: json['file_name'] as String,
  fileSize: (json['file_size'] as num?)?.toInt(),
  fileType: json['file_type'] as String?,
  isDefault: json['isDefault'] as bool? ?? false,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$ResumeToJson(_Resume instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'file_url': instance.fileUrl,
  'file_name': instance.fileName,
  'file_size': instance.fileSize,
  'file_type': instance.fileType,
  'isDefault': instance.isDefault,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};

_ResumeListResponse _$ResumeListResponseFromJson(Map<String, dynamic> json) =>
    _ResumeListResponse(
      count: (json['count'] as num).toInt(),
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List<dynamic>)
          .map((e) => Resume.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ResumeListResponseToJson(_ResumeListResponse instance) =>
    <String, dynamic>{
      'count': instance.count,
      'next': instance.next,
      'previous': instance.previous,
      'results': instance.results,
    };

_UpdateResumeRequest _$UpdateResumeRequestFromJson(Map<String, dynamic> json) =>
    _UpdateResumeRequest(
      name: json['name'] as String?,
      isDefault: json['is_default'] as bool?,
    );

Map<String, dynamic> _$UpdateResumeRequestToJson(
  _UpdateResumeRequest instance,
) => <String, dynamic>{'name': instance.name, 'is_default': instance.isDefault};
