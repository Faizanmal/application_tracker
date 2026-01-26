import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// User model
@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    String? avatar,
    String? phone,
    String? location,
    @JsonKey(name: 'job_title') String? jobTitle,
    String? bio,
    @JsonKey(name: 'linkedin_url') String? linkedinUrl,
    @JsonKey(name: 'portfolio_url') String? portfolioUrl,
    @JsonKey(name: 'preferred_job_type') String? preferredJobType,
    @JsonKey(name: 'preferred_work_mode') String? preferredWorkMode,
    @JsonKey(name: 'weekly_application_goal') int? weeklyApplicationGoal,
    @JsonKey(name: 'is_premium') @Default(false) bool isPremium,
    @JsonKey(name: 'subscription_status') String? subscriptionStatus,
    @JsonKey(name: 'subscription_ends_at') DateTime? subscriptionEndsAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

/// Auth tokens
@freezed
class AuthTokens with _$AuthTokens {
  const factory AuthTokens({
    required String access,
    required String refresh,
  }) = _AuthTokens;

  factory AuthTokens.fromJson(Map<String, dynamic> json) =>
      _$AuthTokensFromJson(json);
}

/// Login request
@freezed
class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    required String email,
    required String password,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
}

/// Register request
@freezed
class RegisterRequest with _$RegisterRequest {
  const factory RegisterRequest({
    required String email,
    required String password,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
  }) = _RegisterRequest;

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);
}

/// Auth response
@freezed
class AuthResponse with _$AuthResponse {
  const factory AuthResponse({
    required User user,
    required AuthTokens tokens,
  }) = _AuthResponse;

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
}

/// Change password request
@freezed
class ChangePasswordRequest with _$ChangePasswordRequest {
  const factory ChangePasswordRequest({
    @JsonKey(name: 'current_password') required String currentPassword,
    @JsonKey(name: 'new_password') required String newPassword,
  }) = _ChangePasswordRequest;

  factory ChangePasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordRequestFromJson(json);
}

/// Update profile request
@freezed
class UpdateProfileRequest with _$UpdateProfileRequest {
  const factory UpdateProfileRequest({
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    String? phone,
    String? location,
    @JsonKey(name: 'job_title') String? jobTitle,
    String? bio,
    @JsonKey(name: 'linkedin_url') String? linkedinUrl,
    @JsonKey(name: 'portfolio_url') String? portfolioUrl,
    @JsonKey(name: 'preferred_job_type') String? preferredJobType,
    @JsonKey(name: 'preferred_work_mode') String? preferredWorkMode,
    @JsonKey(name: 'weekly_application_goal') int? weeklyApplicationGoal,
  }) = _UpdateProfileRequest;

  factory UpdateProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileRequestFromJson(json);
}
