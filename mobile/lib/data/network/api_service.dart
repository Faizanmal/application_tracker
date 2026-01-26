import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../core/constants/api_constants.dart';
import '../models/models.dart';

part 'api_service.g.dart';

/// Main API service interface using Retrofit
@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  // ========== Auth ==========

  @POST(ApiConstants.login)
  Future<AuthResponse> login(@Body() LoginRequest request);

  @POST(ApiConstants.register)
  Future<AuthResponse> register(@Body() RegisterRequest request);

  @POST(ApiConstants.logout)
  Future<void> logout();

  @GET(ApiConstants.me)
  Future<User> getCurrentUser();

  @PATCH(ApiConstants.me)
  Future<User> updateProfile(@Body() UpdateProfileRequest request);

  @POST(ApiConstants.changePassword)
  Future<void> changePassword(@Body() ChangePasswordRequest request);

  @POST(ApiConstants.googleAuth)
  Future<AuthResponse> googleAuth(@Body() Map<String, dynamic> request);

  // ========== Applications ==========

  @GET(ApiConstants.applications)
  Future<ApplicationListResponse> getApplications({
    @Query('page') int? page,
    @Query('status') String? status,
    @Query('search') String? search,
    @Query('ordering') String? ordering,
  });

  @GET('/applications/{id}/')
  Future<Application> getApplication(@Path('id') String id);

  @POST(ApiConstants.applications)
  Future<Application> createApplication(@Body() CreateApplicationRequest request);

  @PATCH('/applications/{id}/')
  Future<Application> updateApplication(
    @Path('id') String id,
    @Body() UpdateApplicationRequest request,
  );

  @DELETE('/applications/{id}/')
  Future<void> deleteApplication(@Path('id') String id);

  @PATCH('/applications/{id}/status/')
  Future<Application> updateApplicationStatus(
    @Path('id') String id,
    @Body() UpdateStatusRequest request,
  );

  // ========== Interviews ==========

  @GET(ApiConstants.interviews)
  Future<InterviewListResponse> getInterviews({
    @Query('page') int? page,
    @Query('status') String? status,
    @Query('application') String? applicationId,
  });

  @GET(ApiConstants.upcomingInterviews)
  Future<List<Interview>> getUpcomingInterviews();

  @GET('/interviews/{id}/')
  Future<Interview> getInterview(@Path('id') String id);

  @POST(ApiConstants.interviews)
  Future<Interview> createInterview(@Body() CreateInterviewRequest request);

  @PATCH('/interviews/{id}/')
  Future<Interview> updateInterview(
    @Path('id') String id,
    @Body() UpdateInterviewRequest request,
  );

  @DELETE('/interviews/{id}/')
  Future<void> deleteInterview(@Path('id') String id);

  @POST('/interviews/{id}/complete/')
  Future<Interview> completeInterview(
    @Path('id') String id,
    @Body() CompleteInterviewRequest request,
  );

  // ========== Reminders ==========

  @GET(ApiConstants.reminders)
  Future<ReminderListResponse> getReminders({
    @Query('page') int? page,
    @Query('status') String? status,
    @Query('application') String? applicationId,
  });

  @GET('/reminders/{id}/')
  Future<Reminder> getReminder(@Path('id') String id);

  @POST(ApiConstants.reminders)
  Future<Reminder> createReminder(@Body() CreateReminderRequest request);

  @PATCH('/reminders/{id}/')
  Future<Reminder> updateReminder(
    @Path('id') String id,
    @Body() UpdateReminderRequest request,
  );

  @DELETE('/reminders/{id}/')
  Future<void> deleteReminder(@Path('id') String id);

  @POST('/reminders/{id}/complete/')
  Future<Reminder> completeReminder(@Path('id') String id);

  @POST('/reminders/{id}/snooze/')
  Future<Reminder> snoozeReminder(
    @Path('id') String id,
    @Body() SnoozeReminderRequest request,
  );

  // ========== Resumes ==========

  @GET(ApiConstants.resumes)
  Future<ResumeListResponse> getResumes();

  @GET('/resumes/{id}/')
  Future<Resume> getResume(@Path('id') String id);

  @DELETE('/resumes/{id}/')
  Future<void> deleteResume(@Path('id') String id);

  @PATCH('/resumes/{id}/')
  Future<Resume> updateResume(
    @Path('id') String id,
    @Body() UpdateResumeRequest request,
  );

  // ========== Analytics ==========

  @GET(ApiConstants.analyticsOverview)
  Future<AnalyticsOverview> getAnalyticsOverview({
    @Query('start_date') String? startDate,
    @Query('end_date') String? endDate,
  });

  // ========== AI ==========

  @POST(ApiConstants.aiFollowUp)
  Future<Map<String, dynamic>> generateFollowUp(
    @Body() Map<String, dynamic> request,
  );

  @POST(ApiConstants.aiResumeMatch)
  Future<Map<String, dynamic>> matchResume(
    @Body() Map<String, dynamic> request,
  );

  @POST(ApiConstants.aiInterviewQuestions)
  Future<Map<String, dynamic>> generateInterviewQuestions(
    @Body() Map<String, dynamic> request,
  );

  // ========== Subscription ==========

  @GET(ApiConstants.subscription)
  Future<Map<String, dynamic>> getSubscription();

  @POST(ApiConstants.checkoutSession)
  Future<Map<String, dynamic>> createCheckoutSession(
    @Body() Map<String, dynamic> request,
  );
}
