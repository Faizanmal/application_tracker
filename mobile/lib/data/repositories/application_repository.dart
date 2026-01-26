import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/models.dart';
import '../network/api_service.dart';
import '../network/dio_client.dart';

/// Repository for application operations
class ApplicationRepository {
  final ApiService _api;

  ApplicationRepository(this._api);

  /// Get paginated list of applications
  Future<ApplicationListResponse> getApplications({
    int? page,
    String? status,
    String? search,
    String? ordering,
  }) async {
    try {
      return await _api.getApplications(
        page: page,
        status: status,
        search: search,
        ordering: ordering,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Get single application by ID
  Future<Application> getApplication(String id) async {
    try {
      return await _api.getApplication(id);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Create new application
  Future<Application> createApplication(CreateApplicationRequest request) async {
    try {
      return await _api.createApplication(request);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Update application
  Future<Application> updateApplication(
    String id,
    UpdateApplicationRequest request,
  ) async {
    try {
      return await _api.updateApplication(id, request);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Delete application
  Future<void> deleteApplication(String id) async {
    try {
      await _api.deleteApplication(id);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Update application status
  Future<Application> updateStatus(String id, String status) async {
    try {
      return await _api.updateApplicationStatus(
        id,
        UpdateStatusRequest(status: status),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Toggle starred status
  Future<Application> toggleStarred(String id, bool starred) async {
    try {
      return await _api.updateApplication(
        id,
        UpdateApplicationRequest(starred: starred),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}

/// Provider for ApplicationRepository
final applicationRepositoryProvider = Provider<ApplicationRepository>((ref) {
  final api = ApiService(DioClient.instance.dio);
  return ApplicationRepository(api);
});
