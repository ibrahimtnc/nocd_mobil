import 'package:flutter/material.dart';
import 'package:ocdcoach/src/core/constants/app_constants.dart';
import 'package:ocdcoach/src/core/theme/app_colors.dart';
import 'package:ocdcoach/src/core/theme/app_text_styles.dart';

/// Cognitive reframing card
/// Comparison of "What you feel" vs "What is real"
class CognitiveReframeCard extends StatelessWidget {
  final String reframe;

  const CognitiveReframeCard({
    super.key,
    required this.reframe,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.anxietyLow.withOpacity(0.05),
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
                    color: AppColors.anxietyLow.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.psychology,
                    color: AppColors.anxietyLow,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Cognitive Reframing',
                  style: AppTextStyles.h3(color: AppColors.textPrimary),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              reframe,
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

