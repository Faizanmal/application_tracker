import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/sync_item.dart';
import '../models/application.dart';
import '../models/interview.dart';
import 'offline_storage_service.dart';
import 'api_service.dart';

/// Sync status enum
enum SyncStatus {
  idle,
  syncing,
  completed,
  failed,
  offline,
}

/// Sync result class
class SyncResult {
  final int successful;
  final int failed;
  final List<String> errors;
  final DateTime timestamp;

  SyncResult({
    required this.successful,
    required this.failed,
    required this.errors,
    required this.timestamp,
  });
}

/// Sync state class
class SyncState {
  final SyncStatus status;
  final int pendingCount;
  final SyncResult? lastResult;
  final bool isOnline;
  final DateTime? lastSyncTime;

  const SyncState({
    this.status = SyncStatus.idle,
    this.pendingCount = 0,
    this.lastResult,
    this.isOnline = true,
    this.lastSyncTime,
  });

  SyncState copyWith({
    SyncStatus? status,
    int? pendingCount,
    SyncResult? lastResult,
    bool? isOnline,
    DateTime? lastSyncTime,
  }) {
    return SyncState(
      status: status ?? this.status,
      pendingCount: pendingCount ?? this.pendingCount,
      lastResult: lastResult ?? this.lastResult,
      isOnline: isOnline ?? this.isOnline,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
    );
  }
}

/// Sync service for handling offline/online data synchronization
class SyncService extends StateNotifier<SyncState> {
  final OfflineStorageService _storage;
  final ApiService _apiService;
  final Connectivity _connectivity;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  Timer? _syncTimer;
  bool _isSyncing = false;

  SyncService({
    required OfflineStorageService storage,
    required ApiService apiService,
    Connectivity? connectivity,
  })  : _storage = storage,
        _apiService = apiService,
        _connectivity = connectivity ?? Connectivity(),
        super(const SyncState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    // Check initial connectivity
    final result = await _connectivity.checkConnectivity();
    final isOnline = !result.contains(ConnectivityResult.none);
    
    // Get pending count
    final pendingCount = _storage.getSyncQueueCount();
    
    state = state.copyWith(
      isOnline: isOnline,
      pendingCount: pendingCount,
      status: isOnline ? SyncStatus.idle : SyncStatus.offline,
    );

    // Listen to connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _onConnectivityChanged,
    );

    // Start periodic sync check
    _syncTimer = Timer.periodic(
      const Duration(minutes: 5),
      (_) => _checkAndSync(),
    );

    // Initial sync if online
    if (isOnline && pendingCount > 0) {
      await sync();
    }
  }

  void _onConnectivityChanged(List<ConnectivityResult> result) async {
    final isOnline = !result.contains(ConnectivityResult.none);
    
    state = state.copyWith(
      isOnline: isOnline,
      status: isOnline ? SyncStatus.idle : SyncStatus.offline,
    );

    // Auto-sync when coming back online
    if (isOnline && state.pendingCount > 0) {
      await sync();
    }
  }

  Future<void> _checkAndSync() async {
    if (state.isOnline && state.pendingCount > 0 && !_isSyncing) {
      await sync();
    }
  }

  /// Queue an operation for sync
  Future<void> queueOperation({
    required SyncOperation operation,
    required String entityType,
    required String entityId,
    required Map<String, dynamic> data,
  }) async {
    final item = SyncItem(
      id: _storage.generateId(),
      operation: operation,
      entityType: entityType,
      entityId: entityId,
      data: data,
      timestamp: DateTime.now(),
      attempts: 0,
    );

    await _storage.addToSyncQueue(item);
    state = state.copyWith(pendingCount: state.pendingCount + 1);

    // Try to sync immediately if online
    if (state.isOnline) {
      await sync();
    }
  }

  /// Perform synchronization
  Future<SyncResult> sync() async {
    if (_isSyncing) {
      return SyncResult(
        successful: 0,
        failed: 0,
        errors: ['Sync already in progress'],
        timestamp: DateTime.now(),
      );
    }

    if (!state.isOnline) {
      return SyncResult(
        successful: 0,
        failed: 0,
        errors: ['Device is offline'],
        timestamp: DateTime.now(),
      );
    }

    _isSyncing = true;
    state = state.copyWith(status: SyncStatus.syncing);

    int successful = 0;
    int failed = 0;
    final errors = <String>[];

    try {
      final queue = await _storage.getSyncQueue();

      for (final item in queue) {
        try {
          await _processItem(item);
          await _storage.removeFromSyncQueue(item.id);
          successful++;
        } catch (e) {
          failed++;
          errors.add('${item.entityType}/${item.entityId}: $e');

          // Update attempt count
          if (item.attempts < 3) {
            final updatedItem = item.copyWith(attempts: item.attempts + 1);
            await _storage.addToSyncQueue(updatedItem);
          } else {
            // Remove after 3 failed attempts
            await _storage.removeFromSyncQueue(item.id);
            errors.add('${item.entityType}/${item.entityId}: Removed after 3 failed attempts');
          }
        }
      }
    } finally {
      _isSyncing = false;
    }

    final pendingCount = _storage.getSyncQueueCount();
    final result = SyncResult(
      successful: successful,
      failed: failed,
      errors: errors,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      status: failed > 0 ? SyncStatus.failed : SyncStatus.completed,
      pendingCount: pendingCount,
      lastResult: result,
      lastSyncTime: DateTime.now(),
    );

    // Reset status after delay
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        state = state.copyWith(
          status: state.isOnline ? SyncStatus.idle : SyncStatus.offline,
        );
      }
    });

    return result;
  }

  Future<void> _processItem(SyncItem item) async {
    switch (item.entityType) {
      case 'application':
        await _syncApplication(item);
        break;
      case 'interview':
        await _syncInterview(item);
        break;
      default:
        throw Exception('Unknown entity type: ${item.entityType}');
    }
  }

  Future<void> _syncApplication(SyncItem item) async {
    switch (item.operation) {
      case SyncOperation.create:
        await _apiService.createApplication(item.data);
        break;
      case SyncOperation.update:
        await _apiService.updateApplication(item.entityId, item.data);
        break;
      case SyncOperation.delete:
        await _apiService.deleteApplication(item.entityId);
        break;
    }
  }

  Future<void> _syncInterview(SyncItem item) async {
    switch (item.operation) {
      case SyncOperation.create:
        await _apiService.createInterview(item.data);
        break;
      case SyncOperation.update:
        await _apiService.updateInterview(item.entityId, item.data);
        break;
      case SyncOperation.delete:
        await _apiService.deleteInterview(item.entityId);
        break;
    }
  }

  /// Fetch and cache data from server
  Future<void> fetchAndCacheApplications() async {
    if (!state.isOnline) return;

    try {
      final applications = await _apiService.getApplications();
      await _storage.saveApplications(applications);
    } catch (e) {
      // Silently fail, use cached data
    }
  }

  /// Fetch and cache interviews
  Future<void> fetchAndCacheInterviews() async {
    if (!state.isOnline) return;

    try {
      final interviews = await _apiService.getInterviews();
      await _storage.saveInterviews(interviews);
    } catch (e) {
      // Silently fail, use cached data
    }
  }

  /// Force refresh all data
  Future<void> forceRefresh() async {
    if (!state.isOnline) {
      throw Exception('Cannot refresh while offline');
    }

    await Future.wait([
      fetchAndCacheApplications(),
      fetchAndCacheInterviews(),
    ]);
  }

  /// Clear sync queue
  Future<void> clearQueue() async {
    await _storage.clearSyncQueue();
    state = state.copyWith(pendingCount: 0);
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    _syncTimer?.cancel();
    super.dispose();
  }
}

/// Provider for sync service
final syncServiceProvider = StateNotifierProvider<SyncService, SyncState>((ref) {
  return SyncService(
    storage: OfflineStorageService(),
    apiService: ref.read(apiServiceProvider),
  );
});

/// Provider for API service (placeholder)
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

/// API Service placeholder
class ApiService {
  Future<List<Application>> getApplications() async {
    // Implementation would make actual API calls
    throw UnimplementedError();
  }

  Future<Application> createApplication(Map<String, dynamic> data) async {
    throw UnimplementedError();
  }

  Future<Application> updateApplication(String id, Map<String, dynamic> data) async {
    throw UnimplementedError();
  }

  Future<void> deleteApplication(String id) async {
    throw UnimplementedError();
  }

  Future<List<Interview>> getInterviews() async {
    throw UnimplementedError();
  }

  Future<Interview> createInterview(Map<String, dynamic> data) async {
    throw UnimplementedError();
  }

  Future<Interview> updateInterview(String id, Map<String, dynamic> data) async {
    throw UnimplementedError();
  }

  Future<void> deleteInterview(String id) async {
    throw UnimplementedError();
  }
}
