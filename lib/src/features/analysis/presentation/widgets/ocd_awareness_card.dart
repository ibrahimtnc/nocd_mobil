import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ocdcoach/src/core/constants/app_constants.dart';
import 'package:ocdcoach/src/core/theme/app_colors.dart';
import 'package:ocdcoach/src/core/theme/app_text_styles.dart';
import 'package:ocdcoach/src/core/widgets/bento_card.dart';
import 'package:ocdcoach/src/shared/providers/localization_provider.dart';

/// OCD Awareness Card
/// Emphasizes that OCD is not the user's fault
class OCDAwarenessCard extends ConsumerWidget {
  const OCDAwarenessCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = ref.watch(localizationProvider);
    
    return localization.when(
      data: (loc) => BentoCard(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        backgroundColor: AppColors.primary.withOpacity(0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.psychology,
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    loc.getString('this_is_ocd_not_you'),
                    style: AppTextStyles.h2(color: AppColors.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              loc.getString('ocd_alarm_system'),
              style: AppTextStyles.bodyLarge(
                color: AppColors.textPrimary,
              ).copyWith(
                height: 1.6,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              loc.getString('ocd_neurological'),
              style: AppTextStyles.bodyMedium(
                color: AppColors.textSecondary,
              ).copyWith(
                height: 1.6,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      loc.getString('fear_feels_real'),
                      style: AppTextStyles.bodySmall(
                        color: AppColors.textPrimary,
                      ).copyWith(
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      loading: () => BentoCard(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        backgroundColor: AppColors.primary.withOpacity(0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.psychology,
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'This is OCD, Not You',
                    style: AppTextStyles.h2(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      error: (_, __) => BentoCard(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        backgroundColor: AppColors.primary.withOpacity(0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.psychology,
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'This is OCD, Not You',
                    style: AppTextStyles.h2(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

