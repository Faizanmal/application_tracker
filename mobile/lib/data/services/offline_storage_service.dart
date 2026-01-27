import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/application.dart';
import '../models/interview.dart';
import '../models/sync_item.dart';

/// Offline storage service using Hive for local persistence
class OfflineStorageService {
  static const String _applicationsBox = 'applications';
  static const String _interviewsBox = 'interviews';
  static const String _templatesBox = 'templates';
  static const String _syncQueueBox = 'sync_queue';
  static const String _cachedDataBox = 'cached_data';
  static const String _userSettingsBox = 'user_settings';

  static final OfflineStorageService _instance = OfflineStorageService._internal();
  factory OfflineStorageService() => _instance;
  OfflineStorageService._internal();

  final _uuid = const Uuid();
  bool _initialized = false;

  /// Initialize Hive and open boxes
  Future<void> initialize() async {
    if (_initialized) return;

    await Hive.initFlutter();

    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ApplicationAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(InterviewAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(SyncItemAdapter());
    }

    // Open boxes
    await Hive.openBox<Application>(_applicationsBox);
    await Hive.openBox<Interview>(_interviewsBox);
    await Hive.openBox<dynamic>(_templatesBox);
    await Hive.openBox<SyncItem>(_syncQueueBox);
    await Hive.openBox<dynamic>(_cachedDataBox);
    await Hive.openBox<dynamic>(_userSettingsBox);

    _initialized = true;
  }

  // ==================== Applications ====================

  /// Get all applications from local storage
  Future<List<Application>> getApplications() async {
    final box = Hive.box<Application>(_applicationsBox);
    return box.values.toList();
  }

  /// Get application by ID
  Future<Application?> getApplication(String id) async {
    final box = Hive.box<Application>(_applicationsBox);
    return box.get(id);
  }

  /// Save application to local storage
  Future<void> saveApplication(Application application) async {
    final box = Hive.box<Application>(_applicationsBox);
    await box.put(application.id, application);
  }

  /// Save multiple applications
  Future<void> saveApplications(List<Application> applications) async {
    final box = Hive.box<Application>(_applicationsBox);
    final Map<String, Application> entries = {
      for (final app in applications) app.id: app
    };
    await box.putAll(entries);
  }

  /// Delete application from local storage
  Future<void> deleteApplication(String id) async {
    final box = Hive.box<Application>(_applicationsBox);
    await box.delete(id);
  }

  /// Clear all applications
  Future<void> clearApplications() async {
    final box = Hive.box<Application>(_applicationsBox);
    await box.clear();
  }

  /// Watch applications for changes
  Stream<List<Application>> watchApplications() {
    final box = Hive.box<Application>(_applicationsBox);
    return box.watch().map((_) => box.values.toList());
  }

  // ==================== Interviews ====================

  /// Get all interviews from local storage
  Future<List<Interview>> getInterviews() async {
    final box = Hive.box<Interview>(_interviewsBox);
    return box.values.toList();
  }

  /// Get interview by ID
  Future<Interview?> getInterview(String id) async {
    final box = Hive.box<Interview>(_interviewsBox);
    return box.get(id);
  }

  /// Save interview to local storage
  Future<void> saveInterview(Interview interview) async {
    final box = Hive.box<Interview>(_interviewsBox);
    await box.put(interview.id, interview);
  }

  /// Save multiple interviews
  Future<void> saveInterviews(List<Interview> interviews) async {
    final box = Hive.box<Interview>(_interviewsBox);
    final Map<String, Interview> entries = {
      for (final interview in interviews) interview.id: interview
    };
    await box.putAll(entries);
  }

  /// Delete interview from local storage
  Future<void> deleteInterview(String id) async {
    final box = Hive.box<Interview>(_interviewsBox);
    await box.delete(id);
  }

  // ==================== Sync Queue ====================

  /// Add item to sync queue
  Future<void> addToSyncQueue(SyncItem item) async {
    final box = Hive.box<SyncItem>(_syncQueueBox);
    await box.put(item.id, item);
  }

  /// Get all items in sync queue
  Future<List<SyncItem>> getSyncQueue() async {
    final box = Hive.box<SyncItem>(_syncQueueBox);
    final items = box.values.toList();
    items.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return items;
  }

  /// Remove item from sync queue
  Future<void> removeFromSyncQueue(String id) async {
    final box = Hive.box<SyncItem>(_syncQueueBox);
    await box.delete(id);
  }

  /// Clear sync queue
  Future<void> clearSyncQueue() async {
    final box = Hive.box<SyncItem>(_syncQueueBox);
    await box.clear();
  }

  /// Get sync queue count
  int getSyncQueueCount() {
    final box = Hive.box<SyncItem>(_syncQueueBox);
    return box.length;
  }

  /// Watch sync queue for changes
  Stream<int> watchSyncQueueCount() {
    final box = Hive.box<SyncItem>(_syncQueueBox);
    return box.watch().map((_) => box.length);
  }

  // ==================== Cached Data ====================

  /// Cache API response
  Future<void> cacheData(String key, dynamic data, {Duration? expiry}) async {
    final box = Hive.box<dynamic>(_cachedDataBox);
    final expiryTime = expiry != null
        ? DateTime.now().add(expiry).toIso8601String()
        : null;
    await box.put(key, {
      'data': jsonEncode(data),
      'expiry': expiryTime,
      'cachedAt': DateTime.now().toIso8601String(),
    });
  }

  /// Get cached data
  Future<T?> getCachedData<T>(String key, T Function(dynamic) fromJson) async {
    final box = Hive.box<dynamic>(_cachedDataBox);
    final cached = box.get(key);
    
    if (cached == null) return null;

    // Check expiry
    if (cached['expiry'] != null) {
      final expiry = DateTime.parse(cached['expiry'] as String);
      if (DateTime.now().isAfter(expiry)) {
        await box.delete(key);
        return null;
      }
    }

    try {
      final data = jsonDecode(cached['data'] as String);
      return fromJson(data);
    } catch (e) {
      return null;
    }
  }

  /// Clear expired cache
  Future<void> clearExpiredCache() async {
    final box = Hive.box<dynamic>(_cachedDataBox);
    final now = DateTime.now();
    final keysToDelete = <String>[];

    for (final key in box.keys) {
      final cached = box.get(key);
      if (cached != null && cached['expiry'] != null) {
        final expiry = DateTime.parse(cached['expiry'] as String);
        if (now.isAfter(expiry)) {
          keysToDelete.add(key as String);
        }
      }
    }

    for (final key in keysToDelete) {
      await box.delete(key);
    }
  }

  // ==================== User Settings ====================

  /// Get user setting
  T? getSetting<T>(String key, {T? defaultValue}) {
    final box = Hive.box<dynamic>(_userSettingsBox);
    return box.get(key, defaultValue: defaultValue) as T?;
  }

  /// Set user setting
  Future<void> setSetting<T>(String key, T value) async {
    final box = Hive.box<dynamic>(_userSettingsBox);
    await box.put(key, value);
  }

  /// Remove user setting
  Future<void> removeSetting(String key) async {
    final box = Hive.box<dynamic>(_userSettingsBox);
    await box.delete(key);
  }

  // ==================== Quick Add ====================

  /// Save quick add draft
  Future<void> saveQuickAddDraft(Map<String, dynamic> draft) async {
    final box = Hive.box<dynamic>(_cachedDataBox);
    await box.put('quick_add_draft', {
      'data': jsonEncode(draft),
      'savedAt': DateTime.now().toIso8601String(),
    });
  }

  /// Get quick add draft
  Future<Map<String, dynamic>?> getQuickAddDraft() async {
    final box = Hive.box<dynamic>(_cachedDataBox);
    final cached = box.get('quick_add_draft');
    
    if (cached == null) return null;

    try {
      return jsonDecode(cached['data'] as String) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// Clear quick add draft
  Future<void> clearQuickAddDraft() async {
    final box = Hive.box<dynamic>(_cachedDataBox);
    await box.delete('quick_add_draft');
  }

  // ==================== Storage Info ====================

  /// Get storage statistics
  Future<Map<String, int>> getStorageStats() async {
    return {
      'applications': Hive.box<Application>(_applicationsBox).length,
      'interviews': Hive.box<Interview>(_interviewsBox).length,
      'templates': Hive.box<dynamic>(_templatesBox).length,
      'syncQueue': Hive.box<SyncItem>(_syncQueueBox).length,
      'cachedData': Hive.box<dynamic>(_cachedDataBox).length,
    };
  }

  /// Clear all local data
  Future<void> clearAllData() async {
    await Hive.box<Application>(_applicationsBox).clear();
    await Hive.box<Interview>(_interviewsBox).clear();
    await Hive.box<dynamic>(_templatesBox).clear();
    await Hive.box<SyncItem>(_syncQueueBox).clear();
    await Hive.box<dynamic>(_cachedDataBox).clear();
    // Keep user settings
  }

  /// Generate unique ID for offline items
  String generateId() => _uuid.v4();
}
