import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ocdcoach/src/core/constants/app_constants.dart';
import 'package:ocdcoach/src/core/theme/app_colors.dart';
import 'package:ocdcoach/src/core/theme/app_text_styles.dart';

/// Disclaimer screen
/// User must acknowledge this is a coaching tool, not a medical device
class DisclaimerScreen extends StatefulWidget {
  const DisclaimerScreen({super.key});

  @override
  State<DisclaimerScreen> createState() => _DisclaimerScreenState();
}

class _DisclaimerScreenState extends State<DisclaimerScreen> {
  bool _hasUnderstood = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.largePadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Medical Icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.medical_information,
                  size: 50,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Important Notice',
                style: AppTextStyles.h1(color: AppColors.textPrimary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.largePadding),
                  child: Column(
                    children: [
                      Text(
                        'This is a coaching tool, not a medical device.',
                        style: AppTextStyles.bodyLarge(
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'OCD Coach is designed to help you practice ERP techniques and build tolerance to uncertainty. It is not a substitute for professional medical advice.',
                        style: AppTextStyles.bodyMedium(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              CheckboxListTile(
                value: _hasUnderstood,
                onChanged: (value) {
                  setState(() {
                    _hasUnderstood = value ?? false;
                  });
                },
                title: Text(
                  'I Understand',
                  style: AppTextStyles.bodyMedium(),
                ),
                activeColor: AppColors.primary,
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _hasUnderstood
                    ? () => context.go('/setup')
                    : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                ),
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

