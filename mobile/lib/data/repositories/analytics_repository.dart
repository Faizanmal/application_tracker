import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/models.dart';
import '../network/api_service.dart';
import '../network/dio_client.dart';

/// Repository for analytics operations
class AnalyticsRepository {
  final ApiService _api;

  AnalyticsRepository(this._api);

  /// Get analytics overview
  Future<AnalyticsOverview> getOverview({
    String? startDate,
    String? endDate,
  }) async {
    try {
      return await _api.getAnalyticsOverview(
        startDate: startDate,
        endDate: endDate,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}

/// Provider for AnalyticsRepository
final analyticsRepositoryProvider = Provider<AnalyticsRepository>((ref) {
  final api = ApiService(DioClient.instance.dio);
  return AnalyticsRepository(api);
});
