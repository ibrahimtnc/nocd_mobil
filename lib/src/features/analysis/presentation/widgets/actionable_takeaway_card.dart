import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ocdcoach/src/core/constants/app_constants.dart';
import 'package:ocdcoach/src/core/theme/app_colors.dart';
import 'package:ocdcoach/src/core/theme/app_text_styles.dart';
import 'package:ocdcoach/src/core/widgets/bento_card.dart';
import 'package:ocdcoach/src/shared/providers/localization_provider.dart';

/// Actionable takeaway card widget
/// Provides a small, non-compulsive tip for the next hour
class ActionableTakeawayCard extends ConsumerWidget {
  final String actionableTakeaway;

  const ActionableTakeawayCard({
    super.key,
    required this.actionableTakeaway,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = ref.watch(localizationProvider);
    
    return localization.when(
      data: (loc) => BentoCard(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        backgroundColor: AppColors.accent.withOpacity(0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lightbulb_outline,
                    color: AppColors.accent,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    loc.getString('actionable_takeaway'),
                    style: AppTextStyles.h3(color: AppColors.textPrimary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              actionableTakeaway,
              style: AppTextStyles.bodyMedium(
                color: AppColors.textSecondary,
              ).copyWith(
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
      loading: () => BentoCard(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        backgroundColor: AppColors.accent.withOpacity(0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lightbulb_outline,
                    color: AppColors.accent,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text('Actionable Takeaway'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              actionableTakeaway,
              style: AppTextStyles.bodyMedium(
                color: AppColors.textSecondary,
              ).copyWith(
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
      error: (_, __) => BentoCard(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        backgroundColor: AppColors.accent.withOpacity(0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lightbulb_outline,
                    color: AppColors.accent,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text('Actionable Takeaway'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              actionableTakeaway,
              style: AppTextStyles.bodyMedium(
                color: AppColors.textSecondary,
              ).copyWith(
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


