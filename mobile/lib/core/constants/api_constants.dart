/// API configuration constants
class ApiConstants {
  ApiConstants._();

  /// Base URL for the API
  /// Use 10.0.2.2 for Android emulator to access localhost
  /// Use localhost for iOS simulator
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  /// API version
  static const String apiVersion = 'v1';

  /// Full API URL
  static String get apiUrl => '$baseUrl/$apiVersion';

  /// Auth endpoints
  static const String login = '/auth/login/';
  static const String register = '/auth/register/';
  static const String logout = '/auth/logout/';
  static const String refreshToken = '/auth/token/refresh/';
  static const String me = '/auth/me/';
  static const String googleAuth = '/auth/google/';
  static const String changePassword = '/auth/change-password/';

  /// Applications endpoints
  static const String applications = '/applications/';
  static String applicationDetail(String id) => '/applications/$id/';
  static String applicationStatus(String id) => '/applications/$id/status/';

  /// Interviews endpoints
  static const String interviews = '/interviews/';
  static String interviewDetail(String id) => '/interviews/$id/';
  static const String upcomingInterviews = '/interviews/upcoming/';

  /// Reminders endpoints
  static const String reminders = '/reminders/';
  static String reminderDetail(String id) => '/reminders/$id/';
  static String reminderComplete(String id) => '/reminders/$id/complete/';
  static String reminderSnooze(String id) => '/reminders/$id/snooze/';

  /// Resumes endpoints
  static const String resumes = '/resumes/';
  static String resumeDetail(String id) => '/resumes/$id/';

  /// Analytics endpoints
  static const String analytics = '/analytics/';
  static const String analyticsOverview = '/analytics/overview/';

  /// AI endpoints
  static const String aiFollowUp = '/ai/follow-up/';
  static const String aiResumeMatch = '/ai/resume-match/';
  static const String aiInterviewQuestions = '/ai/interview-questions/';

  /// Subscription endpoints
  static const String subscription = '/subscriptions/';
  static const String checkoutSession = '/subscriptions/checkout/';

  /// Request timeout
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
