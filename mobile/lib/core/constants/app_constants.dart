import 'package:flutter/material.dart';

/// Application-wide constants
class AppConstants {
  AppConstants._();

  /// App name
  static const String appName = 'JobScouter';

  /// App tagline
  static const String appTagline = 'Track Your Job Search. Land Your Dream Job.';

  /// Secure storage keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';

  /// SharedPreferences keys
  static const String themeKey = 'theme_mode';
  static const String onboardingCompleteKey = 'onboarding_complete';
  static const String notificationsEnabledKey = 'notifications_enabled';

  /// Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  /// Pagination
  static const int defaultPageSize = 20;

  /// File size limits (in bytes)
  static const int maxResumeSize = 5 * 1024 * 1024; // 5 MB

  /// Allowed resume file types
  static const List<String> allowedResumeTypes = ['pdf', 'doc', 'docx'];

  /// Free tier limits
  static const int freeApplicationLimit = 25;
  static const int freeResumeLimit = 3;
}

/// Application status options
enum ApplicationStatus {
  saved('saved', 'Saved', Color(0xFF6B7280)),
  applied('applied', 'Applied', Color(0xFF3B82F6)),
  phoneScreen('phone_screen', 'Phone Screen', Color(0xFF8B5CF6)),
  interview('interview', 'Interview', Color(0xFFF59E0B)),
  offer('offer', 'Offer', Color(0xFF10B981)),
  rejected('rejected', 'Rejected', Color(0xFFEF4444)),
  withdrawn('withdrawn', 'Withdrawn', Color(0xFF6B7280));

  const ApplicationStatus(this.value, this.label, this.color);

  final String value;
  final String label;
  final Color color;

  static ApplicationStatus fromValue(String value) {
    return ApplicationStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ApplicationStatus.saved,
    );
  }
}

/// Work mode options
enum WorkMode {
  onsite('onsite', 'On-site'),
  remote('remote', 'Remote'),
  hybrid('hybrid', 'Hybrid');

  const WorkMode(this.value, this.label);

  final String value;
  final String label;

  static WorkMode fromValue(String value) {
    return WorkMode.values.firstWhere(
      (e) => e.value == value,
      orElse: () => WorkMode.onsite,
    );
  }
}

/// Job type options
enum JobType {
  fullTime('full_time', 'Full-time'),
  partTime('part_time', 'Part-time'),
  contract('contract', 'Contract'),
  internship('internship', 'Internship'),
  freelance('freelance', 'Freelance');

  const JobType(this.value, this.label);

  final String value;
  final String label;

  static JobType fromValue(String value) {
    return JobType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => JobType.fullTime,
    );
  }
}

/// Interview type options
enum InterviewType {
  phone('phone', 'Phone Screen', Icons.phone),
  video('video', 'Video Call', Icons.videocam),
  onsite('onsite', 'On-site', Icons.business),
  technical('technical', 'Technical', Icons.code),
  behavioral('behavioral', 'Behavioral', Icons.psychology),
  panel('panel', 'Panel', Icons.groups),
  other('other', 'Other', Icons.event);

  const InterviewType(this.value, this.label, this.icon);

  final String value;
  final String label;
  final IconData icon;

  static InterviewType fromValue(String value) {
    return InterviewType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => InterviewType.phone,
    );
  }
}

/// Interview status options
enum InterviewStatus {
  scheduled('scheduled', 'Scheduled', Color(0xFF3B82F6)),
  completed('completed', 'Completed', Color(0xFF10B981)),
  cancelled('cancelled', 'Cancelled', Color(0xFFEF4444)),
  rescheduled('rescheduled', 'Rescheduled', Color(0xFFF59E0B));

  const InterviewStatus(this.value, this.label, this.color);

  final String value;
  final String label;
  final Color color;

  static InterviewStatus fromValue(String value) {
    return InterviewStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => InterviewStatus.scheduled,
    );
  }
}

/// Reminder type options
enum ReminderType {
  followUp('follow_up', 'Follow Up', Icons.email, Color(0xFF3B82F6)),
  interview('interview', 'Interview', Icons.event, Color(0xFFF59E0B)),
  deadline('deadline', 'Deadline', Icons.timer, Color(0xFFEF4444)),
  custom('custom', 'Custom', Icons.notifications, Color(0xFF6B7280));

  const ReminderType(this.value, this.label, this.icon, this.color);

  final String value;
  final String label;
  final IconData icon;
  final Color color;

  static ReminderType fromValue(String value) {
    return ReminderType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ReminderType.custom,
    );
  }
}

/// Reminder status options
enum ReminderStatus {
  pending('pending', 'Pending'),
  completed('completed', 'Completed'),
  snoozed('snoozed', 'Snoozed');

  const ReminderStatus(this.value, this.label);

  final String value;
  final String label;

  static ReminderStatus fromValue(String value) {
    return ReminderStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ReminderStatus.pending,
    );
  }
}
