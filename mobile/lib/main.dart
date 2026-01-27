import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/models/application.dart';
import 'data/models/interview.dart';
import 'data/models/sync_item.dart';
import 'data/services/offline_storage_service.dart';
import 'ui/widgets/accessibility_widgets.dart';
import 'ui/widgets/offline_widgets.dart';

/// Global secure storage instance
final secureStorage = FlutterSecureStorage(
  aOptions: const AndroidOptions(
    encryptedSharedPreferences: true,
  ),
  iOptions: const IOSOptions(
    accessibility: KeychainAccessibility.first_unlock,
  ),
);

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for offline storage
  await Hive.initFlutter();
  
  // Register Hive adapters
  Hive.registerAdapter(ApplicationAdapter());
  Hive.registerAdapter(ApplicationStatusAdapter());
  Hive.registerAdapter(WorkLocationTypeAdapter());
  Hive.registerAdapter(JobTypeAdapter());
  Hive.registerAdapter(InterviewAdapter());
  Hive.registerAdapter(InterviewTypeAdapter());
  Hive.registerAdapter(InterviewStatusAdapter());
  Hive.registerAdapter(SyncItemAdapter());
  Hive.registerAdapter(SyncOperationAdapter());
  
  // Initialize offline storage
  await OfflineStorageService.instance.init();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Run the app
  runApp(
    const ProviderScope(
      child: JobScouterApp(),
    ),
  );
}

/// Main application widget
class JobScouterApp extends ConsumerWidget {
  const JobScouterApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final accessibilitySettings = ref.watch(accessibilityProvider);

    return MaterialApp.router(
      title: 'JobScouter',
      debugShowCheckedModeBanner: false,
      
      // Theme configuration
      theme: accessibilitySettings.highContrast 
          ? AppTheme.highContrastLightTheme 
          : AppTheme.lightTheme,
      darkTheme: accessibilitySettings.highContrast 
          ? AppTheme.highContrastDarkTheme 
          : AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      
      // Router configuration
      routerConfig: router,
      
      // Builder for global overlays/error handling
      builder: (context, child) {
        // Calculate text scale based on accessibility settings
        double textScale = accessibilitySettings.textScale;
        if (accessibilitySettings.largeText) {
          textScale = textScale * 1.3;
        }
        
        return Stack(
          children: [
            MediaQuery(
              // Apply accessibility text scaling
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(
                  textScale.clamp(0.8, 2.0),
                ),
                boldText: accessibilitySettings.boldText,
                disableAnimations: accessibilitySettings.reduceMotion,
              ),
              child: child ?? const SizedBox(),
            ),
            // Global offline indicator
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: OfflineIndicator(),
              ),
            ),
          ],
        );
      },
    );
  }
}
