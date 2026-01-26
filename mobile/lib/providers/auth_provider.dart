import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';

import '../../data/models/models.dart';
import '../../data/repositories/repositories.dart';

/// Auth state
class AuthState {
  final User? user;
  final bool isLoading;
  final bool isAuthenticated;
  final String? error;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.isAuthenticated = false,
    this.error,
  });

  AuthState copyWith({
    User? user,
    bool? isLoading,
    bool? isAuthenticated,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      error: error,
    );
  }
}

/// Auth state notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AuthState());

  /// Initialize auth state by checking for existing token
  Future<void> initialize() async {
    state = state.copyWith(isLoading: true);
    
    try {
      final isAuthenticated = await _repository.isAuthenticated();
      
      if (isAuthenticated) {
        final user = await _repository.getCurrentUser();
        state = AuthState(
          user: user,
          isAuthenticated: true,
          isLoading: false,
        );
      } else {
        state = const AuthState(isLoading: false);
      }
    } catch (e) {
      state = const AuthState(isLoading: false);
    }
  }

  /// Login with email and password
  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final response = await _repository.login(email, password);
      state = AuthState(
        user: response.user,
        isAuthenticated: true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  /// Register new user
  Future<void> register({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final response = await _repository.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );
      state = AuthState(
        user: response.user,
        isAuthenticated: true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  /// Login with Google
  Future<void> googleLogin(String idToken) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final response = await _repository.googleLogin(idToken);
      state = AuthState(
        user: response.user,
        isAuthenticated: true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  /// Logout
  Future<void> logout() async {
    await _repository.logout();
    state = const AuthState();
  }

  /// Update profile
  Future<void> updateProfile(UpdateProfileRequest request) async {
    try {
      final user = await _repository.updateProfile(request);
      state = state.copyWith(user: user);
    } catch (e) {
      rethrow;
    }
  }

  /// Change password
  Future<void> changePassword(String currentPassword, String newPassword) async {
    await _repository.changePassword(currentPassword, newPassword);
  }

  /// Refresh user data
  Future<void> refreshUser() async {
    try {
      final user = await _repository.getCurrentUser();
      state = state.copyWith(user: user);
    } catch (e) {
      // Ignore errors
    }
  }
}

/// Provider for auth state
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});

/// Provider for checking authentication status
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});

/// Provider for current user
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authProvider).user;
});
