import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../core/constants/api_constants.dart';
import '../../core/constants/app_constants.dart';

/// Dio client singleton with interceptors for auth and logging
class DioClient {
  static DioClient? _instance;
  late final Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  DioClient._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.apiUrl,
        connectTimeout: ApiConstants.connectionTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.addAll([
      _AuthInterceptor(_storage, _dio),
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ),
    ]);
  }

  static DioClient get instance {
    _instance ??= DioClient._();
    return _instance!;
  }

  Dio get dio => _dio;

  /// Clear tokens on logout
  Future<void> clearTokens() async {
    await _storage.delete(key: AppConstants.accessTokenKey);
    await _storage.delete(key: AppConstants.refreshTokenKey);
  }

  /// Save tokens
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await _storage.write(key: AppConstants.accessTokenKey, value: accessToken);
    await _storage.write(key: AppConstants.refreshTokenKey, value: refreshToken);
  }

  /// Get access token
  Future<String?> getAccessToken() async {
    return await _storage.read(key: AppConstants.accessTokenKey);
  }
}

/// Auth interceptor for adding tokens and handling refresh
class _AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _storage;
  final Dio _dio;
  bool _isRefreshing = false;

  _AuthInterceptor(this._storage, this._dio);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip auth for login/register endpoints
    if (options.path.contains('/auth/login') ||
        options.path.contains('/auth/register') ||
        options.path.contains('/auth/token/refresh')) {
      return handler.next(options);
    }

    final accessToken = await _storage.read(key: AppConstants.accessTokenKey);
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;

      try {
        final refreshToken =
            await _storage.read(key: AppConstants.refreshTokenKey);

        if (refreshToken != null) {
          // Try to refresh the token
          final response = await _dio.post(
            ApiConstants.refreshToken,
            data: {'refresh': refreshToken},
          );

          if (response.statusCode == 200) {
            final newAccessToken = response.data['access'];
            await _storage.write(
              key: AppConstants.accessTokenKey,
              value: newAccessToken,
            );

            // Retry the original request
            err.requestOptions.headers['Authorization'] =
                'Bearer $newAccessToken';

            final retryResponse = await _dio.fetch(err.requestOptions);
            _isRefreshing = false;
            return handler.resolve(retryResponse);
          }
        }

        // Refresh failed, clear tokens
        await _storage.delete(key: AppConstants.accessTokenKey);
        await _storage.delete(key: AppConstants.refreshTokenKey);
        _isRefreshing = false;
      } catch (_) {
        // Refresh failed, clear tokens
        await _storage.delete(key: AppConstants.accessTokenKey);
        await _storage.delete(key: AppConstants.refreshTokenKey);
        _isRefreshing = false;
      }
    }

    return handler.next(err);
  }
}

/// API exception for handling errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException({
    required this.message,
    this.statusCode,
    this.data,
  });

  factory ApiException.fromDioException(DioException e) {
    String message = 'An unexpected error occurred';

    if (e.response != null) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        if (data.containsKey('detail')) {
          message = data['detail'].toString();
        } else if (data.containsKey('message')) {
          message = data['message'].toString();
        } else if (data.containsKey('error')) {
          message = data['error'].toString();
        } else {
          // Try to get first error from any field
          for (final value in data.values) {
            if (value is List && value.isNotEmpty) {
              message = value.first.toString();
              break;
            } else if (value is String) {
              message = value;
              break;
            }
          }
        }
      }
    } else if (e.type == DioExceptionType.connectionTimeout) {
      message = 'Connection timeout. Please check your internet connection.';
    } else if (e.type == DioExceptionType.receiveTimeout) {
      message = 'Server is taking too long to respond.';
    } else if (e.type == DioExceptionType.connectionError) {
      message = 'Unable to connect to server. Please check your internet.';
    }

    return ApiException(
      message: message,
      statusCode: e.response?.statusCode,
      data: e.response?.data,
    );
  }

  @override
  String toString() => message;
}
