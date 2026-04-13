import 'package:flutter/material.dart';
import 'package:ocdcoach/src/core/constants/app_constants.dart';
import 'package:ocdcoach/src/core/theme/app_colors.dart';
import 'package:ocdcoach/src/core/theme/app_text_styles.dart';

/// Brain glitch card widget
/// Explains why the user had this thought (brain glitch explanation)
class BrainGlitchCard extends StatelessWidget {
  final String brainGlitch;

  const BrainGlitchCard({
    super.key,
    required this.brainGlitch,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.primary.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.psychology,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'The Brain Glitch',
                  style: AppTextStyles.h3(color: AppColors.textPrimary),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              brainGlitch,
              style: AppTextStyles.bodyMedium(
                color: AppColors.textSecondary,
              ).copyWith(
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}




