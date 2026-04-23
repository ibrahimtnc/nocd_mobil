import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ocdcoach/src/core/theme/app_theme.dart';
import 'package:ocdcoach/src/shared/providers/settings_provider.dart';
import 'package:ocdcoach/src/features/analysis/presentation/screens/analysis_screen.dart';
import 'package:ocdcoach/src/features/home/presentation/screens/home_screen.dart';
import 'package:ocdcoach/src/features/minigames/presentation/screens/minigame_screen.dart';
import 'package:ocdcoach/src/features/onboarding/presentation/screens/disclaimer_screen.dart';
import 'package:ocdcoach/src/features/onboarding/presentation/screens/privacy_screen.dart';
import 'package:ocdcoach/src/features/onboarding/presentation/screens/setup_screen.dart';
import 'package:ocdcoach/src/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:ocdcoach/src/features/history/presentation/screens/history_screen.dart';
import 'package:ocdcoach/src/features/settings/presentation/screens/settings_screen.dart';

/// App router configuration using GoRouter
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/privacy',
        builder: (context, state) => const PrivacyScreen(),
      ),
      GoRoute(
        path: '/disclaimer',
        builder: (context, state) => const DisclaimerScreen(),
      ),
      GoRoute(
        path: '/setup',
        builder: (context, state) => const SetupScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/history',
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/minigame',
        builder: (context, state) {
          final duration = state.uri.queryParameters['duration'] ?? '120';
          final thought = state.uri.queryParameters['thought'];
          final anxietyLevel = state.uri.queryParameters['anxietyLevel'];
          return MinigameScreen(
            durationSeconds: int.parse(duration),
            thought: thought,
            anxietyLevel: anxietyLevel != null ? int.parse(anxietyLevel) : null,
          );
        },
      ),
      GoRoute(
        path: '/analysis',
        builder: (context, state) {
          final thought = state.uri.queryParameters['thought'] ?? '';
          final anxietyLevel = state.uri.queryParameters['anxietyLevel'] ?? '5';
          final waitDuration = state.uri.queryParameters['waitDuration'] ?? '120';
          final entryId = state.uri.queryParameters['entryId'];
          return AnalysisScreen(
            thought: thought,
            anxietyLevel: int.parse(anxietyLevel),
            waitDurationSeconds: int.parse(waitDuration),
            entryId: entryId,
          );
        },
      ),
    ],
  );
});

/// Root app widget
class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final settings = ref.watch(settingsProvider);
    
    return MaterialApp.router(
      title: 'nOCD',
      theme: AppTheme.lightTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('tr', ''),
      ],
      locale: Locale(settings.language),
    );
  }
}

