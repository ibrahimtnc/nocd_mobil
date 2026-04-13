import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ocdcoach/src/core/constants/app_constants.dart';
import 'package:ocdcoach/src/core/theme/app_colors.dart';
import 'package:ocdcoach/src/core/theme/app_text_styles.dart';
import 'package:ocdcoach/src/core/widgets/bento_card.dart';
import 'package:ocdcoach/src/shared/providers/localization_provider.dart';

/// Disclaimer card widget
/// Shows important notice about analysis results
class DisclaimerCard extends ConsumerWidget {
  const DisclaimerCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = ref.watch(localizationProvider);
    
    return localization.when(
      data: (loc) => BentoCard(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        backgroundColor: AppColors.anxietyHigh.withOpacity(0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.anxietyHigh.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.info_outline,
                    color: AppColors.anxietyHigh,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    loc.getString('disclaimer_title'),
                    style: AppTextStyles.h3(
                      color: AppColors.anxietyHigh,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              loc.getString('disclaimer_message'),
              style: AppTextStyles.bodyMedium(
                color: AppColors.textPrimary,
              ).copyWith(
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

