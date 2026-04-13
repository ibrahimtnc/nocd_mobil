import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:ocdcoach/src/core/constants/app_constants.dart';
import 'package:ocdcoach/src/core/theme/app_colors.dart';
import 'package:ocdcoach/src/core/storage/hive_service.dart';

/// Splash screen with gentle logo fade-in
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Check if user has completed onboarding
    final userBox = HiveService.userBox;
    final user = userBox.get('user');

    if (user?.hasCompletedOnboarding == true) {
      context.go('/home');
    } else {
      context.go('/privacy');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo/Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
              ),
              child: const Icon(
                Icons.anchor,
                size: 64,
                color: AppColors.white,
              ),
            )
                .animate()
                .fadeIn(duration: AppConstants.mediumAnimation)
                .scale(delay: AppConstants.shortAnimation),
            const SizedBox(height: 24),
            Text(
              'OCD Coach',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
            )
                .animate()
                .fadeIn(
                  delay: AppConstants.shortAnimation,
                  duration: AppConstants.mediumAnimation,
                ),
          ],
        ),
      ),
    );
  }
}

