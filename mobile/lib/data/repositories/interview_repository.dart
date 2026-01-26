import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/models.dart';
import '../network/api_service.dart';
import '../network/dio_client.dart';

/// Repository for interview operations
class InterviewRepository {
  final ApiService _api;

  InterviewRepository(this._api);

  /// Get paginated list of interviews
  Future<InterviewListResponse> getInterviews({
    int? page,
    String? status,
    String? applicationId,
  }) async {
    try {
      return await _api.getInterviews(
        page: page,
        status: status,
        applicationId: applicationId,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Get upcoming interviews
  Future<List<Interview>> getUpcomingInterviews() async {
    try {
      return await _api.getUpcomingInterviews();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Get single interview by ID
  Future<Interview> getInterview(String id) async {
    try {
      return await _api.getInterview(id);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Create new interview
  Future<Interview> createInterview(CreateInterviewRequest request) async {
    try {
      return await _api.createInterview(request);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Update interview
  Future<Interview> updateInterview(
    String id,
    UpdateInterviewRequest request,
  ) async {
    try {
      return await _api.updateInterview(id, request);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Delete interview
  Future<void> deleteInterview(String id) async {
    try {
      await _api.deleteInterview(id);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Complete interview with rating
  Future<Interview> completeInterview(
    String id,
    int rating, {
    String? feedback,
    String? notes,
  }) async {
    try {
      return await _api.completeInterview(
        id,
        CompleteInterviewRequest(
          rating: rating,
          feedback: feedback,
          notes: notes,
        ),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}

/// Provider for InterviewRepository
final interviewRepositoryProvider = Provider<InterviewRepository>((ref) {
  final api = ApiService(DioClient.instance.dio);
  return InterviewRepository(api);
});
