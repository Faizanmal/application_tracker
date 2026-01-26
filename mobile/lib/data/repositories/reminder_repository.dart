import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/models.dart';
import '../network/api_service.dart';
import '../network/dio_client.dart';

/// Repository for reminder operations
class ReminderRepository {
  final ApiService _api;

  ReminderRepository(this._api);

  /// Get paginated list of reminders
  Future<ReminderListResponse> getReminders({
    int? page,
    String? status,
    String? applicationId,
  }) async {
    try {
      return await _api.getReminders(
        page: page,
        status: status,
        applicationId: applicationId,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Get single reminder by ID
  Future<Reminder> getReminder(String id) async {
    try {
      return await _api.getReminder(id);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Create new reminder
  Future<Reminder> createReminder(CreateReminderRequest request) async {
    try {
      return await _api.createReminder(request);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Update reminder
  Future<Reminder> updateReminder(
    String id,
    UpdateReminderRequest request,
  ) async {
    try {
      return await _api.updateReminder(id, request);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Delete reminder
  Future<void> deleteReminder(String id) async {
    try {
      await _api.deleteReminder(id);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Complete reminder
  Future<Reminder> completeReminder(String id) async {
    try {
      return await _api.completeReminder(id);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Snooze reminder
  Future<Reminder> snoozeReminder(String id, DateTime snoozeUntil) async {
    try {
      return await _api.snoozeReminder(
        id,
        SnoozeReminderRequest(snoozeUntil: snoozeUntil),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}

/// Provider for ReminderRepository
final reminderRepositoryProvider = Provider<ReminderRepository>((ref) {
  final api = ApiService(DioClient.instance.dio);
  return ReminderRepository(api);
});
