import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/providers.dart';
import '../../ui/screens/auth/login_screen.dart';
import '../../ui/screens/auth/register_screen.dart';
import '../../ui/screens/auth/splash_screen.dart';
import '../../ui/screens/home/home_screen.dart';
import '../../ui/screens/applications/applications_screen.dart';
import '../../ui/screens/applications/application_detail_screen.dart';
import '../../ui/screens/applications/create_application_screen.dart';
import '../../ui/screens/interviews/interviews_screen.dart';
import '../../ui/screens/interviews/interview_detail_screen.dart';
import '../../ui/screens/interviews/create_interview_screen.dart';
import '../../ui/screens/reminders/reminders_screen.dart';
import '../../ui/screens/analytics/analytics_screen.dart';
import '../../ui/screens/settings/settings_screen.dart';
import '../../ui/screens/settings/profile_screen.dart';
import '../../ui/screens/networking/networking_screen.dart';
import '../../ui/screens/career/career_screen.dart';
import '../../ui/screens/gamification/gamification_screen.dart';
import '../../ui/screens/market_intel/market_intel_screen.dart';
import '../../ui/screens/privacy/privacy_screen.dart';
import '../../ui/screens/integrations/integrations_screen.dart';
import '../../ui/widgets/main_scaffold.dart';

/// Router configuration
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isAuth = authState.isAuthenticated;
      final isLoading = authState.isLoading;
      final isSplash = state.matchedLocation == '/splash';
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      // Still loading, stay on splash
      if (isLoading && isSplash) {
        return null;
      }

      // Not authenticated
      if (!isAuth) {
        if (isAuthRoute || isSplash) {
          return isAuthRoute ? null : '/login';
        }
        return '/login';
      }

      // Authenticated, redirect away from auth routes
      if (isAuth && (isAuthRoute || isSplash)) {
        return '/';
      }

      return null;
    },
    routes: [
      // Splash
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Auth routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // Main app with bottom navigation
      ShellRoute(
        builder: (context, state, child) {
          return MainScaffold(child: child);
        },
        routes: [
          // Home
          GoRoute(
            path: '/',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),

          // Applications
          GoRoute(
            path: '/applications',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ApplicationsScreen(),
            ),
          ),

          // Interviews
          GoRoute(
            path: '/interviews',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: InterviewsScreen(),
            ),
          ),

          // Reminders
          GoRoute(
            path: '/reminders',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: RemindersScreen(),
            ),
          ),

          // Settings
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SettingsScreen(),
            ),
          ),
        ],
      ),

      // Full-screen routes (without bottom nav)
      GoRoute(
        path: '/applications/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ApplicationDetailScreen(applicationId: id);
        },
      ),
      GoRoute(
        path: '/applications/new',
        builder: (context, state) => const CreateApplicationScreen(),
      ),
      GoRoute(
        path: '/interviews/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return InterviewDetailScreen(interviewId: id);
        },
      ),
      GoRoute(
        path: '/interviews/new',
        builder: (context, state) => const CreateInterviewScreen(),
      ),
      GoRoute(
        path: '/analytics',
        builder: (context, state) => const AnalyticsScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      // New Feature Routes
      GoRoute(
        path: '/networking',
        builder: (context, state) => const NetworkingScreen(),
      ),
      GoRoute(
        path: '/career',
        builder: (context, state) => const CareerScreen(),
      ),
      GoRoute(
        path: '/gamification',
        builder: (context, state) => const GamificationScreen(),
      ),
      GoRoute(
        path: '/market-intel',
        builder: (context, state) => const MarketIntelScreen(),
      ),
      GoRoute(
        path: '/privacy',
        builder: (context, state) => const PrivacyScreen(),
      ),
      GoRoute(
        path: '/integrations',
        builder: (context, state) => const IntegrationsScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Page not found: ${state.uri}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});
