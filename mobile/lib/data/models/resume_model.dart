import 'package:freezed_annotation/freezed_annotation.dart';

part 'resume_model.freezed.dart';
part 'resume_model.g.dart';

/// Resume model
@freezed
class Resume with _$Resume {
  const factory Resume({
    required String id,
    required String name,
    @JsonKey(name: 'file_url') required String fileUrl,
    @JsonKey(name: 'file_name') required String fileName,
    @JsonKey(name: 'file_size') int? fileSize,
    @JsonKey(name: 'file_type') String? fileType,
    @Default(false) bool isDefault,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _Resume;

  factory Resume.fromJson(Map<String, dynamic> json) => _$ResumeFromJson(json);
}

/// Resume list response
@freezed
class ResumeListResponse with _$ResumeListResponse {
  const factory ResumeListResponse({
    required int count,
    String? next,
    String? previous,
    required List<Resume> results,
  }) = _ResumeListResponse;

  factory ResumeListResponse.fromJson(Map<String, dynamic> json) =>
      _$ResumeListResponseFromJson(json);
}

/// Update resume request
@freezed
class UpdateResumeRequest with _$UpdateResumeRequest {
  const factory UpdateResumeRequest({
    String? name,
    @JsonKey(name: 'is_default') bool? isDefault,
  }) = _UpdateResumeRequest;

  factory UpdateResumeRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateResumeRequestFromJson(json);
}
