import 'package:flutter/material.dart';
import 'package:ocdcoach/src/core/constants/app_constants.dart';
import 'package:ocdcoach/src/core/theme/app_colors.dart';
import 'package:ocdcoach/src/core/theme/app_text_styles.dart';

/// Science explanation card
/// Explains why the fear is likely a false alarm
class ScienceExplanationCard extends StatelessWidget {
  final String explanation;

  const ScienceExplanationCard({
    super.key,
    required this.explanation,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.accent.withOpacity(0.05),
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
                    color: AppColors.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.science,
                    color: AppColors.accent,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'The Mechanics',
                  style: AppTextStyles.h3(color: AppColors.textPrimary),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              explanation,
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

