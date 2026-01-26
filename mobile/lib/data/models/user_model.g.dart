// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: json['id'] as String,
  email: json['email'] as String,
  firstName: json['first_name'] as String?,
  lastName: json['last_name'] as String?,
  avatar: json['avatar'] as String?,
  phone: json['phone'] as String?,
  location: json['location'] as String?,
  jobTitle: json['job_title'] as String?,
  bio: json['bio'] as String?,
  linkedinUrl: json['linkedin_url'] as String?,
  portfolioUrl: json['portfolio_url'] as String?,
  preferredJobType: json['preferred_job_type'] as String?,
  preferredWorkMode: json['preferred_work_mode'] as String?,
  weeklyApplicationGoal: (json['weekly_application_goal'] as num?)?.toInt(),
  isPremium: json['is_premium'] as bool? ?? false,
  subscriptionStatus: json['subscription_status'] as String?,
  subscriptionEndsAt: json['subscription_ends_at'] == null
      ? null
      : DateTime.parse(json['subscription_ends_at'] as String),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'avatar': instance.avatar,
  'phone': instance.phone,
  'location': instance.location,
  'job_title': instance.jobTitle,
  'bio': instance.bio,
  'linkedin_url': instance.linkedinUrl,
  'portfolio_url': instance.portfolioUrl,
  'preferred_job_type': instance.preferredJobType,
  'preferred_work_mode': instance.preferredWorkMode,
  'weekly_application_goal': instance.weeklyApplicationGoal,
  'is_premium': instance.isPremium,
  'subscription_status': instance.subscriptionStatus,
  'subscription_ends_at': instance.subscriptionEndsAt?.toIso8601String(),
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};

_AuthTokens _$AuthTokensFromJson(Map<String, dynamic> json) => _AuthTokens(
  access: json['access'] as String,
  refresh: json['refresh'] as String,
);

Map<String, dynamic> _$AuthTokensToJson(_AuthTokens instance) =>
    <String, dynamic>{'access': instance.access, 'refresh': instance.refresh};

_LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) =>
    _LoginRequest(
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$LoginRequestToJson(_LoginRequest instance) =>
    <String, dynamic>{'email': instance.email, 'password': instance.password};

_RegisterRequest _$RegisterRequestFromJson(Map<String, dynamic> json) =>
    _RegisterRequest(
      email: json['email'] as String,
      password: json['password'] as String,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
    );

Map<String, dynamic> _$RegisterRequestToJson(_RegisterRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
    };

_AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) =>
    _AuthResponse(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      tokens: AuthTokens.fromJson(json['tokens'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuthResponseToJson(_AuthResponse instance) =>
    <String, dynamic>{'user': instance.user, 'tokens': instance.tokens};

_ChangePasswordRequest _$ChangePasswordRequestFromJson(
  Map<String, dynamic> json,
) => _ChangePasswordRequest(
  currentPassword: json['current_password'] as String,
  newPassword: json['new_password'] as String,
);

Map<String, dynamic> _$ChangePasswordRequestToJson(
  _ChangePasswordRequest instance,
) => <String, dynamic>{
  'current_password': instance.currentPassword,
  'new_password': instance.newPassword,
};

_UpdateProfileRequest _$UpdateProfileRequestFromJson(
  Map<String, dynamic> json,
) => _UpdateProfileRequest(
  firstName: json['first_name'] as String?,
  lastName: json['last_name'] as String?,
  phone: json['phone'] as String?,
  location: json['location'] as String?,
  jobTitle: json['job_title'] as String?,
  bio: json['bio'] as String?,
  linkedinUrl: json['linkedin_url'] as String?,
  portfolioUrl: json['portfolio_url'] as String?,
  preferredJobType: json['preferred_job_type'] as String?,
  preferredWorkMode: json['preferred_work_mode'] as String?,
  weeklyApplicationGoal: (json['weekly_application_goal'] as num?)?.toInt(),
);

Map<String, dynamic> _$UpdateProfileRequestToJson(
  _UpdateProfileRequest instance,
) => <String, dynamic>{
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'phone': instance.phone,
  'location': instance.location,
  'job_title': instance.jobTitle,
  'bio': instance.bio,
  'linkedin_url': instance.linkedinUrl,
  'portfolio_url': instance.portfolioUrl,
  'preferred_job_type': instance.preferredJobType,
  'preferred_work_mode': instance.preferredWorkMode,
  'weekly_application_goal': instance.weeklyApplicationGoal,
};
