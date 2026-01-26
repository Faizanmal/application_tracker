import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/models.dart';
import '../network/api_service.dart';
import '../network/dio_client.dart';

/// Repository for authentication operations
class AuthRepository {
  final ApiService _api;
  final DioClient _dioClient;

  AuthRepository(this._api, this._dioClient);

  /// Login with email and password
  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await _api.login(LoginRequest(
        email: email,
        password: password,
      ));
      
      // Save tokens
      await _dioClient.saveTokens(
        response.tokens.access,
        response.tokens.refresh,
      );
      
      return response;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Register new user
  Future<AuthResponse> register({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    try {
      final response = await _api.register(RegisterRequest(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      ));
      
      // Save tokens
      await _dioClient.saveTokens(
        response.tokens.access,
        response.tokens.refresh,
      );
      
      return response;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Login with Google
  Future<AuthResponse> googleLogin(String idToken) async {
    try {
      final response = await _api.googleAuth({'id_token': idToken});
      
      // Save tokens
      await _dioClient.saveTokens(
        response.tokens.access,
        response.tokens.refresh,
      );
      
      return response;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      await _api.logout();
    } catch (_) {
      // Ignore errors, always clear tokens
    }
    await _dioClient.clearTokens();
  }

  /// Get current user
  Future<User> getCurrentUser() async {
    try {
      return await _api.getCurrentUser();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Update profile
  Future<User> updateProfile(UpdateProfileRequest request) async {
    try {
      return await _api.updateProfile(request);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Change password
  Future<void> changePassword(String currentPassword, String newPassword) async {
    try {
      await _api.changePassword(ChangePasswordRequest(
        currentPassword: currentPassword,
        newPassword: newPassword,
      ));
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await _dioClient.getAccessToken();
    return token != null;
  }
}

/// Provider for AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dioClient = DioClient.instance;
  final api = ApiService(dioClient.dio);
  return AuthRepository(api, dioClient);
});
